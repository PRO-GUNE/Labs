library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity sharp_arith is
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        tap_m3      : in integer range 0 to 255;
        tap_m2      : in integer range 0 to 255;
        tap_m1      : in integer range 0 to 255;
        tap_00      : in integer range 0 to 255;
        tap_p1      : in integer range 0 to 255;
        tap_p2      : in integer range 0 to 255;
        tap_p3      : in integer range 0 to 255;
        data_out    : out integer range 0 to 255 
    );
end entity sharp_arith;

architecture behavioral of sharp_arith is
 
begin
    -- filter coefficients [1; 0; -9; 48; -9; 0; 1]/32

    process
        variable sum    : integer range -512 to 511
    begin
        wait until rising_edge(clk);

        sum := ( tap_m3 - (9*tap_m1) + (48*tap_00) - (9*tap_p1) + tap_p3 ) / 32;

        if ( sum > 255 ) then
            data_out <= 255;
        elsif ( sum < 0 ) then
            data_out <= 0;
        else
            data_out <= sum;
        end if;

    end process;

end behavioral ; -- behavioral