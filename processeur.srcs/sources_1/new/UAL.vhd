----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 10:23:25
-- Design Name: 
-- Module Name: UAL - Behavioral
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

entity UAL is 
    port (A : in std_logic_vector (7 downto 0);
          B : in std_logic_vector (7 downto 0);
          opcode : in std_logic_vector (2 downto 0);
          N : out std_logic ; -- negative value
          O : out std_logic ; -- overflow
          Z : out std_logic ; -- zero value
          C : out std_logic ; -- carry
          S : out std_logic_vector (7 downto 0)
          );
end UAL;

architecture Behavioral of UAL is

-- addition
signal add : std_logic_vector(7 downto 0) := (others => '0');
signal addCarry : std_logic_vector(8 downto 0) := (others => '0');

-- substraction
signal sub : std_logic_vector(7 downto 0) := (others => '0');

-- multiplication
signal mul : std_logic_vector(7 downto 0) := (others => '0');
signal mulCarry : std_logic_vector(15 downto 0) := (others => '0');

-- division
signal div : std_logic_vector(7 downto 0) := (others => '0');

-- logic operation
signal orS : std_logic_vector(7 downto 0) := (others => '0');
signal andS : std_logic_vector(7 downto 0) := (others => '0');
signal notS : std_logic_vector(7 downto 0) := (others => '0');

-- temporary result
signal aux : std_logic_vector(7 downto 0) := (others => '0');

begin
    
    process(A,B,opcode)
    begin
        -- addition
        addCarry <= ("0" & A) + ("0" & B);
        add <= addCarry(7 downto 0);
        
        -- substraction
        sub <= std_logic_vector(abs(signed(A) - signed(B)));
        
        -- multiplication
        mulCarry <= std_logic_vector(signed(A) * signed(B));
        mul <= mulCarry(7 downto 0);
        if opcode = "010" then
            report "A = " & integer'image(to_integer(signed(A)));
            report "B = " & integer'image(to_integer(signed(B)));
            report "Mul16 = " & integer'image(to_integer(signed(mulCarry)));
            report "Mul8 = " & integer'image(to_integer(signed(mul)));
        end if;
        
        -- division
        if B /= "00000000" then div <= std_logic_vector(signed(A) / signed(B));
        else div <= "00000000";
        end if;
        
        -- logic operation
        orS <= A OR B;
        andS <= A AND B;
        notS <= NOT A;
        
        -- overflow handler
        if ((mulCarry (15 downto 8) /= "00000000") and opcode = "010") then O <= '1';
        elsif (addCarry(8) /= '0' and opcode = "001") then O <='1';
        else O <= '0';
        end if;
        
        -- negative value handler
        if A < B and opcode = "011" then N <= '1';
        else N <= '0';
        end if;
        
        -- addition carry handler
        if opcode = "001" then C <= addCarry(8);
        else C <= '0';
        end if;
        
        -- zero value handler
        if aux = "00000000" then Z <= '1';
        else Z <= '0';
        end if;
        
        -- temporary result
        if opcode = "001" then aux <= add;
        elsif opcode = "010" then aux <= mul;
        elsif opcode = "011" then aux <= sub;
        elsif opcode = "100" then aux <= div;
        elsif opcode = "101" then aux <= orS;
        elsif opcode = "110" then aux <= andS;
        elsif opcode = "111" then aux <= notS;
        else aux <= "00000000";
        end if;
        
    end process;
    
    S <= aux;
    
end Behavioral;
