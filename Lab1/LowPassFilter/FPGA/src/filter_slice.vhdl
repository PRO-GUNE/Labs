-- filter_slice.vhd
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter_slice is
  port (
    clk     : in std_logic;
    reset   : in std_logic;
    de_in   : in std_logic;
    data_in : in integer range 0 to 255;
    data_out: out integer range 0 to 255
  );
end entity filter_slice;

architecture behavioral of filter_slice is
    component filter_arith is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            tap_m12     : in integer range 0 to 255;
            tap_m11     : in integer range 0 to 255;
            tap_m10     : in integer range 0 to 255;
            tap_m9      : in integer range 0 to 255;
            tap_m8      : in integer range 0 to 255;
            tap_m7      : in integer range 0 to 255;
            tap_m6      : in integer range 0 to 255;
            tap_m5      : in integer range 0 to 255;
            tap_m4      : in integer range 0 to 255;
            tap_m3      : in integer range 0 to 255;
            tap_m2      : in integer range 0 to 255;
            tap_m1      : in integer range 0 to 255;
            tap_00      : in integer range 0 to 255;
            tap_p1      : in integer range 0 to 255;
            tap_p2      : in integer range 0 to 255;
            tap_p3      : in integer range 0 to 255;
            tap_p4      : in integer range 0 to 255;
            tap_p5      : in integer range 0 to 255;
            tap_p6      : in integer range 0 to 255;
            tap_p7      : in integer range 0 to 255;
            tap_p8      : in integer range 0 to 255;
            tap_p9      : in integer range 0 to 255;
            tap_p10     : in integer range 0 to 255;
            tap_p11     : in integer range 0 to 255;
            tap_p12     : in integer range 0 to 255;
            data_out    : out integer range 0 to 255 
        );
    end component;

    type filter_array is array (0 to 24) of integer range 0 to 255;
    signal d_tap    : filter_array;

begin
    process
    begin
        wait until rising_edge(clk);

        d_tap(0) <= data_in;
        for i in 0 to 23 loop
            d_tap(i+1) <= d_tap(i);
        end loop;
    end process;

    filter: filter_arith
        port map(
            clk => clk,
            reset => reset,
            tap_m12 => d_tap(0),
            tap_m11 => d_tap(1),
            tap_m10 => d_tap(2),
            tap_m9  => d_tap(3),
            tap_m8  => d_tap(4),
            tap_m7  => d_tap(5),
            tap_m6  => d_tap(6),
            tap_m5  => d_tap(7),
            tap_m4  => d_tap(8),
            tap_m3  => d_tap(9),
            tap_m2  => d_tap(10),
            tap_m1  => d_tap(11),
            tap_00  => d_tap(12),
            tap_p1  => d_tap(13),
            tap_p2  => d_tap(14),
            tap_p3  => d_tap(15),
            tap_p4  => d_tap(16),
            tap_p5  => d_tap(17),
            tap_p6  => d_tap(18),
            tap_p7  => d_tap(19),
            tap_p8  => d_tap(20),
            tap_p9  => d_tap(21),
            tap_p10 => d_tap(22),
            tap_p11 => d_tap(23),
            tap_p12 => d_tap(24),
            data_out => data_out 
        );
    
end behavioral;

    