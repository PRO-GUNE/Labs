library IEEE
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL

-- input / output are 8 bit RGB
entity sharp_linemem is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        write_en    : in std_logic;
        data_in     : in integer range 0 to 255;
        data_out    : out integer range 0 to 255
    );
end entity sharp_linemem;

architecture behavioral of sharp_linemem is
    -- input image is of 1280x720 pixel count
    type ram_array is array (0 to 1279) of integer range 0 to 255;
    signal ram : ram_array;

begin
    process
        variable wr_address : integer range 0 to 1279;
        variable rd_address : integer range 0 to 1279;
    begin
        wait until rising_edge(clk)

        if (write_en = '1') then
            data_out <= ram(rd_address);
              ram(wr_address) <= data_in;
            end if;
                
        if (reset = '1') then
            wr_address := 0;
            rd_address := 1;
        elsif (write_en = '1') then
            wr_address := rd_address;
            if (rd_address = 1279) then
            rd_address := 0;
            else
            rd_address := rd_address + 1;
            end if;
        end if;

    end process;	 
            
end behavioral;

-- Note: wait until rising_edge(clk) - This is used in a process to pause execution until a rising edge of the clock signal is detected. This form is less commonly used in synchronous designs but can be useful in testbenches or asynchronous processes.