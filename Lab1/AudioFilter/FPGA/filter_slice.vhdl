library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter_slice is
  port (
    clk     : in std_logic;
    reset   : in std_logic;
    de_in   : in std_logic;
    data_in : in integer range 0 to 65535;
    data_out: out integer range 0 to 65535
  );
end entity filter_slice;

architecture behavioral of filter_slice is
    component filter_arith is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            tap_m12     : in integer range 0 to 65535;
            tap_m11     : in integer range 0 to 65535;
            tap_m10     : in integer range 0 to 65535;
            tap_m9      : in integer range 0 to 65535;
            tap_m8      : in integer range 0 to 65535;
            tap_m7      : in integer range 0 to 65535;
            tap_m6      : in integer range 0 to 65535;
            tap_m5      : in integer range 0 to 65535;
            tap_m4      : in integer range 0 to 65535;
            tap_m3      : in integer range 0 to 65535;
            tap_m2      : in integer range 0 to 65535;
            tap_m1      : in integer range 0 to 65535;
            tap_00      : in integer range 0 to 65535;
            tap_p1      : in integer range 0 to 65535;
            tap_p2      : in integer range 0 to 65535;
            tap_p3      : in integer range 0 to 65535;
            tap_p4      : in integer range 0 to 65535;
            tap_p5      : in integer range 0 to 65535;
            tap_p6      : in integer range 0 to 65535;
            tap_p7      : in integer range 0 to 65535;
            tap_p8      : in integer range 0 to 65535;
            tap_p9      : in integer range 0 to 65535;
            tap_p10     : in integer range 0 to 65535;
            tap_p11     : in integer range 0 to 65535;
            tap_p12     : in integer range 0 to 65535;
            data_out    : out integer range 0 to 65535 
        );
    end component;

    type filter_array is array (0 to 24) of integer range 0 to 65535;
    signal h_tap    : filter_array;
    signal v_out    : integer range 0 to 65535;

begin
    process
    begin
        wait until rising_edge(clk);

        h_tap(0) <= data_in;
        for i in 0 to 24 loop
            h_tap(i+1) <= h_tap(i);
        end loop;
    end process;

    filter: filter_arith
        port map(
            clk => clk,
            reset => reset,
            tap_m12 => h_tap(0)
            tap_m11 => h_tap(1)
            tap_m10 => h_tap(2)
            tap_m9  => h_tap(3)
            tap_m8  => h_tap(4)
            tap_m7  => h_tap(5)
            tap_m6  => h_tap(6)
            tap_m5  => h_tap(7)
            tap_m4  => h_tap(8)
            tap_m3  => h_tap(9)
            tap_m2  => h_tap(10)
            tap_m1  => h_tap(11)
            tap_00  => h_tap(12)
            tap_p1  => h_tap(13)
            tap_p2  => h_tap(14)
            tap_p3  => h_tap(15)
            tap_p4  => h_tap(16)
            tap_p5  => h_tap(17)
            tap_p6  => h_tap(18)
            tap_p7  => h_tap(19)
            tap_p8  => h_tap(20)
            tap_p9  => h_tap(21)
            tap_p10 => h_tap(22)
            tap_p11 => h_tap(23)
            tap_p12 => h_tap(24)
            data_out => data_out 
        );
    
end behavioral

    