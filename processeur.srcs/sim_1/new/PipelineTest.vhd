----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2023 11:51:01
-- Design Name: 
-- Module Name: PipelineTest - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PipelineTest is
end PipelineTest;

architecture Behavioral of PipelineTest is

COMPONENT Pipeline
Port ( inA : in std_logic_vector (7 downto 0);
       inB : in std_logic_vector (7 downto 0);
       inC : in std_logic_vector (7 downto 0);
       inOp : in std_logic_vector (3 downto 0);
       clock : in std_logic;
       outA : out std_logic_vector (7 downto 0);
       outB : out std_logic_vector (7 downto 0);
       outC : out std_logic_vector (7 downto 0);
       outOp : out std_logic_vector (3 downto 0));
END COMPONENT;


-- input
signal test_inA : std_logic_vector (7 downto 0) := "00000101";
signal test_inB : std_logic_vector (7 downto 0) := "00001010";
signal test_inC : std_logic_vector (7 downto 0) := "00000101";
signal test_inOp : std_logic_vector (3 downto 0) := "0001";
signal test_clock : std_logic := '0';

-- output
signal test_outA : std_logic_vector (7 downto 0);
signal test_outB : std_logic_vector (7 downto 0);
signal test_outC : std_logic_vector (7 downto 0);
signal test_outOp : std_logic_vector (3 downto 0);

-- clock
constant Clock_period : time := 10 ns;

begin

Label_Pipeline : Pipeline PORT MAP (
    inA => test_inA,
    inB => test_inB,
    inC => test_inC,
    inOp => test_inOp,
    clock => test_clock,
    outA => test_outA,
    outB => test_outB,
    outC => test_outC,
    outOp => test_outOp
);

Clock_process : process
begin
    test_clock <= not(test_clock);
    wait for Clock_period/2;
end process;

test_inA <= not(test_inA) after Clock_period;
test_inB <= not(test_inB) after Clock_period;
test_inC <= not(test_inC) after Clock_period;
test_inOp <= not(test_inOp) after Clock_period;

end Behavioral;
