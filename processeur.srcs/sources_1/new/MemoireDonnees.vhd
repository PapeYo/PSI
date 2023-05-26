----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 10:23:25
-- Design Name: 
-- Module Name: MemoireDonnees - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemoireDonnees is
    Port ( addr : in std_logic_vector (7 downto 0);
           input : in std_logic_vector (7 downto 0);
           RW : in std_logic; --read/write
           RST : in std_logic; --reset
           CLK : in std_logic; --clock
           output : out std_logic_vector(7 downto 0)
           );
end MemoireDonnees;

architecture Behavioral of MemoireDonnees is

-- 256*8 = 2048
-- Max address : 255 (11111111)
signal memory : std_logic_vector(2047 downto 0) := (others => '0');

begin
    
    process
    begin
        wait until falling_edge(CLK);
        
        --reset = 1 -> init memory at 0 
        if (RST = '1') then 
            memory <= (others => '0');
        
        --case read -> read data in memory at address addr
        elsif (RW = '1') then        
            output <= memory((to_integer(unsigned(addr))*8+7) downto (to_integer(unsigned(addr))*8));
        
        -- case write -> writing input data in memory at address addr
        else        
            memory((to_integer(unsigned(addr))*8+7) downto (to_integer(unsigned(addr))*8)) <= input;
            output <= "00000000";
        end if;
    end process;
    
end Behavioral;
