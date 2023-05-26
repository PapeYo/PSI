----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 10:23:25
-- Design Name: 
-- Module Name: BancRegistres - Behavioral
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

entity BancRegistres is
    Port ( addrA : in std_logic_vector (3 downto 0);
           addrB : in std_logic_vector (3 downto 0);
           addrW : in std_logic_vector (3 downto 0);
           W : in std_logic;
           DATA : in std_logic_vector (7 downto 0);
           RST : in std_logic;
           CLK : in std_logic;
           QA : out std_logic_vector (7 downto 0);
           QB : out std_logic_vector (7 downto 0));
end BancRegistres;

architecture Behavioral of BancRegistres is

-- 16 registers of 8 bits -> 16 * 8 - 1 = 128 - 1 = 127
signal registres : std_logic_vector(127 downto 0) := (others=> '0');

begin

    process
    begin
        wait until falling_edge(CLK);

        -- reset actif
        if (RST = '1') then 
            registres <= (others => '0');

        -- W=1 -> writing / W=0 -> reading
        elsif (W = '1') then 
            registres(to_integer(unsigned(addrW))*8+7 downto to_integer(unsigned(addrW))*8) <= DATA;
        
        end if;
    end process;
    
        QA <= registres(to_integer(unsigned(addrA))*8+7 downto to_integer(unsigned(addrA))*8);
        
        QB <= registres(to_integer(unsigned(addrB))*8+7 downto to_integer(unsigned(addrB))*8);

end Behavioral;
