library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sharp_slice is
  port (
    clk     : in std_logic;
    reset   : in std_logic;
    de_in   : in std_logic;
    data_in : in integer range 0 to 255;
    data_out: out integer range 0 to 255
  );
end entity sharp_slice;

architecture behavioral of sharp_slice is
    component sharp_linemem is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            write_en    : in std_logic;
            data_in     : in integer range 0 to 255;
            data_out    : out integer range 0 to 255
    );
    end component;

    component sharp_arith is
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
    end component;
        
    type filter_array is array (0 to 6) of integer range 0 to 255;
    signal v_tap    : filter_array;
    signal h_tap    : filter_array;
    signal v_out    : integer range 0 to 255;

begin
    v_tap(0) <= data_in;

    g: for i in 0 to 5 generate
        mem: sharp_linemem
            port map (
                clk => clk,
                reset => reset,
                write_en => de_in,
                data_in => v_tap(i),
                data_out => v_tap(i+1)
            );
        end generate;
    
    vertical_filter: sharp_arith
        port map (
            clk => clk,
            reset => reset,
            tap_m3 => v_tap(0),
            tap_m2 => v_tap(1),
            tap_m1 => v_tap(2),
            tap_00 => v_tap(3),
            tap_p1 => v_tap(4),
            tap_p2 => v_tap(5),
            tap_p3 => v_tap(6)
        );

    process
    begin
        wait until rising_edge(clk);

        h_tap(0) <= v_out;
        for i in 0 to 5 loop
            h_tap(i+1) <= h_tap(i);
        end loop;
    end process;

    horizontal_filter: sharp_arith
            port map(
                clk => clk,
                reset => reset,
                tap_m3 => h_tap(0),
                tap_m2 => h_tap(1),
                tap_m1 => h_tap(2),
                tap_00 => h_tap(3),
                tap_p1 => h_tap(4),
                tap_p2 => h_tap(5),
                tap_p3 => h_tap(6),
                data_out => data_out
            );

end behavioral ; -- behavioral