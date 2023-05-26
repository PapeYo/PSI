----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.05.2023 13:30:25
-- Design Name: 
-- Module Name: MemDataTest - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemDataTest is
end MemDataTest;

architecture Behavioral of MemDataTest is

COMPONENT MemoireDonnees
    Port ( addr : in std_logic_vector (7 downto 0);
           input : in std_logic_vector (7 downto 0);
           RW : in std_logic; --read/write
           RST : in std_logic; --reset
           CLK : in std_logic; --clock
           output : out std_logic_vector(7 downto 0)
           );
end COMPONENT;

-- input
signal test_addr : std_logic_vector(7 downto 0);
signal test_input : std_logic_vector(7 downto 0) := "00000000" ;
signal test_RW : std_logic := '0';
signal test_RST : std_logic := '0';
signal test_clock : std_logic := '0';

-- output
signal test_output : std_logic_vector(7 downto 0) := "00000000";

-- clock
constant Clock_period : time := 10 ns;

begin

Label_MD : MemoireDonnees PORT MAP (
    addr => test_addr,
    input => test_input,
    RW => test_RW,
    RST => test_RST,
    CLK => test_clock,
    output => test_output
);

Clock_process : process
begin
    test_clock <= not(test_clock);
    wait for Clock_period/2;
end process;

process
begin
    wait until rising_edge(test_clock);
    test_RW <= '0';
    test_addr  <= "00000001";
    test_input <= test_input + '1';
    
    wait until rising_edge(test_clock);  
    test_addr  <= "00000010";
    test_input <= test_input + '1';
    
    wait until rising_edge(test_clock);
    test_RW <= '1';
    test_addr <= "00000001";
    test_input <= test_input + '1';
    
    wait until rising_edge(test_clock);
    test_addr <= "00000010";
    test_input <= test_input + '1';
end process;

end Behavioral;
