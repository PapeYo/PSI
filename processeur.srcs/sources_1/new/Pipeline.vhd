----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 10:43:27
-- Design Name: 
-- Module Name: Pipeline - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pipeline is
    Port ( inA : in std_logic_vector (7 downto 0);
           inB : in std_logic_vector (7 downto 0);
           inC : in std_logic_vector (7 downto 0);
           inOp : in std_logic_vector (3 downto 0);
           CLK : in std_logic;
           outA : out std_logic_vector (7 downto 0);
           outB : out std_logic_vector (7 downto 0);
           outC : out std_logic_vector (7 downto 0);
           outOp : out std_logic_vector (3 downto 0));
end Pipeline;

architecture Behavioral of Pipeline is

begin
    process
    begin
        wait until rising_edge(CLK);
        outA <= inA;
        outB <= inB;
        outC <= inC;
        outOp <= inOp;

    end process;

end Behavioral;
