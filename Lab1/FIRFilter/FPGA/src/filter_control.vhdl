-- filter_control.vhd
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter_control is
  generic ( delay : integer := 7 );
  port ( clk       : in  std_logic;
         reset     : in  std_logic;
         ds_in     : in  std_logic;      -- data sync input
         de_in     : in  std_logic;      -- enable sync input
         ds_out    : out std_logic;      -- data sync output
         de_out    : out std_logic);     -- enable sync output
end filter_control;

architecture behave of filter_control is


  type delay_array is array (1 to delay) of std_logic;
  signal ds_delay : delay_array;
  signal de_delay : delay_array;

begin

  process
  begin
    wait until rising_edge(clk);

     -- first value of array is current input
     ds_delay(1) <= ds_in;
     de_delay(1) <= de_in;

    -- delay according to generic
    for i in 2 to delay loop
      ds_delay(i) <= ds_delay(i-1);
      de_delay(i) <= de_delay(i-1);
    end loop;

  end process;

  -- last value of array is output
  ds_out <= ds_delay(delay);
  de_out <= de_delay(delay);

end behave;