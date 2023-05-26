----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 10:23:25
-- Design Name: 
-- Module Name: MemoireInstructions - Behavioral
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

entity MemoireInstructions is
    Port ( CLK : in std_logic;
           addr : in std_logic_vector (7 downto 0);
           -- instruction format
           -- 31 -> 24 : operation code
           -- 23 -> 16 : result address
           -- 15 -> 8  : first number
           -- 7  -> 0  : second number 
           instruction : out std_logic_vector (31 downto 0)
           );
end MemoireInstructions;

architecture Behavioral of MemoireInstructions is

-- 256 instructions, each encoded on 32 bits -> 256 * 32 = 8192
signal instructions : std_logic_vector(8191 downto 0) := (others=>'0'); 

-- Code operations
-- Addition         : 0x01 = 00000001 -> Test ok
-- Multiplication   : 0x02 = 00000010 -> Test ok
-- Soustraction     : 0x03 = 00000011 -> Test ok
-- Division         : 0x04 = 00000100 -> Test ok
-- Copie            : 0x05 = 00000101 -> Test ok
-- Affectation      : 0x06 = 00000110 -> Test ok
-- Chargement       : 0x07 = 00000111
-- Sauvegarde       : 0x08 = 00001000
-- And              : 0x09 = 00010001
-- Or               : 0x10 = 00010010
-- Not              : 0x11 = 00010011

begin

    process(addr)
    begin
        instruction <= instructions(to_integer(unsigned(addr))*32+31 downto to_integer(unsigned(addr))*32);
    end process;
    
    -- TESTS
    -- AFC 0 3 _
    instructions(31 downto 0) <= x"06000300";
    -- AFC 1 9 _
    instructions(63 downto 32) <= x"06010900";
    -- COP 2 1 _
    instructions(95 downto 64) <= x"05020100";
    -- ADD 3 0 1
    instructions(127 downto 96) <= x"01030001";
    -- SOU 4 0 1
    instructions(159 downto 128) <= x"03040001";
    -- SOU 4 1 0
    instructions(191 downto 160) <= x"03040100";
    -- MUL 5 1 3
    instructions(223 downto 192) <= x"02050103";
    -- DIV 5 5 0
    instructions(255 downto 224) <= x"04050500";
    -- OR  6 0 1
    instructions(287 downto 256) <= x"0A060001";
    -- AND 7 1 0
    instructions(319 downto 288) <= x"09070100";
    -- NOT 7 0 _
    instructions(351 downto 320) <= x"0B070000";
    -- STORE 0 6 _
    instructions(383 downto 352) <= x"08000600";
    -- LOAD  8 0 _
    instructions(415 downto 384) <= x"07080000";
    
end Behavioral;
