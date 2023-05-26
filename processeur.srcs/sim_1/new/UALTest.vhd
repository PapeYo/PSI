----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 17:39:31
-- Design Name: 
-- Module Name: UALTest - Behavioral
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

entity UALTest is
end UALTest;

architecture Behavioral of UALTest is

COMPONENT UAL
    PORT (
        A : in std_logic_vector (7 downto 0);
        B : in std_logic_vector (7 downto 0);
        opcode : in std_logic_vector (2 downto 0);
        N : out std_logic ; -- negative value
        O : out std_logic ; -- overflow
        Z : out std_logic ; -- zero value
        C : out std_logic ; -- carry
        S : out std_logic_vector (7 downto 0)
    );
end COMPONENT;

-- input
signal test_A : std_logic_vector(7 downto 0) := "00000100";
signal test_B : std_logic_vector(7 downto 0) := "00010000";
signal test_opcode : std_logic_vector(2 downto 0) := "000";

-- output
signal test_N : std_logic := '0';
signal test_O : std_logic := '0';
signal test_Z : std_logic := '1';
signal test_C : std_logic := '0' ;
signal test_S : std_logic_vector(7 downto 0) := (others => '0');


begin

Label_UAL : UAL PORT MAP (
    A => test_A,
    B => test_B,
    opcode => test_opcode,
    N => test_N,
    O => test_O,
    Z => test_Z,
    C => test_C,
    S => test_S
);

ctrl_process : process
begin
    wait for 10ns;
    test_opcode <= test_opcode + '1';
end process;

end Behavioral;
