----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 10:47:46
-- Design Name: 
-- Module Name: MemInstrTest - Behavioral
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

entity MemInstrTest is
end MemInstrTest;

architecture Behavioral of MemInstrTest is

COMPONENT MemoireInstructions
Port (
    CLK : in std_logic;
    addr : in std_logic_vector (7 downto 0);
    instruction : out std_logic_vector (31 downto 0)
);
END COMPONENT;

-- input
signal test_addr : std_logic_vector(7 downto 0) := "00000000";
signal test_clock : std_logic := '0';

-- output
signal test_output : std_logic_vector(31 downto 0);

-- clock
constant Clock_period : time := 10 ns;

begin

Label_MI : MemoireInstructions PORT MAP (
    CLK => test_clock,
    addr => test_addr,
    instruction => test_output
);

Clock_process : process
begin
    test_clock <= not(test_clock);
    wait for Clock_period/2;
end process;

addr_process : process
begin
    wait until rising_edge(test_clock);
    test_addr <= test_addr + '1';
end process;

end Behavioral;