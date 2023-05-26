----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 12:00:33
-- Design Name: 
-- Module Name: BRTest - Behavioral
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BRTest is
end BRTest;

architecture Behavioral of BRTest is

COMPONENT BancRegistres
Port ( addrA : in std_logic_vector (3 downto 0);
       addrB : in std_logic_vector (3 downto 0);
       addrW : in std_logic_vector (3 downto 0);
       W : in std_logic;
       DATA : in std_logic_vector (7 downto 0);
       RST : in std_logic;
       CLK : in std_logic;
       QA : out std_logic_vector (7 downto 0);
       QB : out std_logic_vector (7 downto 0)
       );
END COMPONENT;

-- input
signal test_addrA : std_logic_vector (3 downto 0) := "0000";
signal test_addrB : std_logic_vector (3 downto 0) := "0001";
signal test_addrW : std_logic_vector (3 downto 0) := "0000";
signal test_DATA : std_logic_vector (7 downto 0) := "00000110";
signal test_W : std_logic := '1'; -- writing mode
signal test_RST : std_logic := '1';
signal test_clock : std_logic := '0';

-- ouput
signal test_QA : std_logic_vector(7 downto 0);
signal test_QB : std_logic_vector(7 downto 0);

-- clock
constant Clock_period : time := 10 ns;

begin

Label_BR : BancRegistres PORT MAP (
    addrA => test_addrA,
    addrB => test_addrB,
    addrW => test_addrW,
    W => test_W,
    DATA => test_DATA,
    RST => test_RST,
    CLK => test_clock,
    QA => test_QA,
    QB => test_QB
);

Clock_process : process
begin
    test_clock <= not(test_clock);
    wait for Clock_period/2;
end process;

test_RST <= '0' after 0ns;

process
begin
    wait until rising_edge(test_clock);
    wait until rising_edge(test_clock);
    test_addrA <= "0110";
    test_addrB <= "0000";
    test_addrW <= "0000";
    test_DATA <= "10101010";
    test_W <= '0';
    wait until rising_edge(test_clock);
    test_addrA <= "0010";
    test_addrB <= "0100";  
    test_addrW <= "0110";
    test_DATA <= "01010101";
    test_W <= '1';
end process;

end Behavioral;
