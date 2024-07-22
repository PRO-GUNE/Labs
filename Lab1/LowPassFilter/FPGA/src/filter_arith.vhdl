-- filter_arith.vhd
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity filter_arith is
    port(
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
end entity filter_arith;

architecture behavioral of filter_arith is
 
begin
    -- filter coefficients [621;1252;955;-464;-1427;-442;1279;815;-2028;-2978;1849;9985;14052;
    --                      9985;1849;-2978;-2028;815;1279;-442;-1427;-464;955;1252;621]

    process
        variable sum    : integer range -131072 to 131071;
    begin
        wait until rising_edge(clk);
        -- Bit-true implementation of the filter
        sum := ( 621*tap_m12 + (1252*tap_m11) + (955*tap_m10) - (464*tap_m9) - (1427*tap_m8) - (442*tap_m7) + (1279*tap_m6) + (815*tap_m5) - (2028*tap_m4) - (2978*tap_m3) + (1849*tap_m2) + (9985*tap_m1) + (14052*tap_00) + (9985*tap_p1) - (1849*tap_p2) - (2978*tap_p3) - (2028*tap_p4) + (815*tap_p5) + (1279*tap_p6) - (442*tap_p7) - (1427*tap_p8) - (464*tap_p9) + (955*tap_p10) + (1252*tap_p11) + (621*tap_p12) ) / 32768;

        if ( sum > 255 ) then
            data_out <= 255;
        elsif ( sum < 0 ) then
            data_out <= 0;
        else
            data_out <= sum;
        end if;

    end process;

end behavioral ; -- behavioral