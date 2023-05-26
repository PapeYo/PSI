----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2023 12:08:39
-- Design Name: 
-- Module Name: CheminDonnees - Behavioral
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

entity CheminDonnees is
end CheminDonnees;

architecture Behavioral of CheminDonnees is

COMPONENT MemoireInstructions
Port (
    CLK : in std_logic;
    addr : in std_logic_vector (7 downto 0);
    instruction : out std_logic_vector (31 downto 0)
);
END COMPONENT;

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

COMPONENT MemoireDonnees
Port ( addr : in std_logic_vector (7 downto 0);
       input : in std_logic_vector (7 downto 0);
       RW : in std_logic; --read/write
       RST : in std_logic; --reset
       CLK : in std_logic; --clock
       output : out std_logic_vector(7 downto 0)
       );
end COMPONENT;

COMPONENT Pipeline
Port ( inA : in std_logic_vector (7 downto 0);
       inB : in std_logic_vector (7 downto 0);
       inC : in std_logic_vector (7 downto 0);
       inOp : in std_logic_vector (3 downto 0);
       CLK : in std_logic;
       outA : out std_logic_vector (7 downto 0);
       outB : out std_logic_vector (7 downto 0);
       outC : out std_logic_vector (7 downto 0);
       outOp : out std_logic_vector (3 downto 0));
END COMPONENT;

    -- clock
signal test_CLK : std_logic := '0';
constant CLK_period : time := 10ns;

    -- signaux mémoire instruction
-- input
signal instr_addr : std_logic_vector(7 downto 0) := "11111111";
-- output
                -- format reminder
                -- 31 -> 24 : operation code
                -- 23 -> 16 : result address
                -- 15 -> 8  : first number
                -- 7  -> 0  : second number 
signal instr_out : std_logic_vector(31 downto 0) := (others => '0');

    -- signaux pipeline li/di
signal lidi_out_a : std_logic_vector(7 downto 0) := (others => '0');
signal lidi_out_b : std_logic_vector(7 downto 0) := (others => '0');
signal lidi_out_c : std_logic_vector(7 downto 0) := (others => '0');
signal lidi_out_op : std_logic_vector(3 downto 0) := (others => '0');

    -- signaux banc registres
signal br_qa : std_logic_vector(7 downto 0) := (others => '0');
signal br_qb : std_logic_vector(7 downto 0) := (others => '0');
signal br_rst : std_logic := '1';

    -- signaux pipeline di/ex
signal diex_out_a : std_logic_vector(7 downto 0) := (others => '0');
signal diex_out_b : std_logic_vector(7 downto 0) := (others => '0');
signal diex_out_c : std_logic_vector(7 downto 0) := (others => '0');
signal diex_out_op : std_logic_vector(3 downto 0) := (others => '0');

    -- signaux ual
signal ual_s : std_logic_vector(7 downto 0) := (others => '0');
signal ual_n : std_logic := '0';
signal ual_o : std_logic := '0';
signal ual_z : std_logic := '0';
signal ual_c : std_logic := '0';

    -- signaux pipeline ex/mem
signal exmem_out_a : std_logic_vector(7 downto 0) := (others => '0');
signal exmem_out_b : std_logic_vector(7 downto 0) := (others => '0');
signal exmem_out_c : std_logic_vector(7 downto 0) := (others => '0'); -- not used
signal exmem_out_op : std_logic_vector(3 downto 0) := (others => '0');

    -- signaux mémoire données
signal md_rst : std_logic := '1';
signal md_output : std_logic_vector(7 downto 0) := (others => '0');

    -- signaux pipeline mem/re
signal memre_out_a : std_logic_vector(7 downto 0) := (others => '0');
signal memre_out_b : std_logic_vector(7 downto 0) := (others => '0');
signal memre_out_c : std_logic_vector(7 downto 0) := (others => '0'); -- not used
signal memre_out_op : std_logic_vector(3 downto 0) := (others => '0');

    -- signal lc post mem/re
signal lc_w : std_logic := '0';
    -- signal lc ual
signal lc_opcode : std_logic_vector(2 downto 0) := (others => '0');
    -- signal lc mémoire données
signal lc_rw : std_logic := '1';

    -- signaux mux
signal mux_br : std_logic_vector(7 downto 0) := (others => '0');
signal mux_ual : std_logic_vector(7 downto 0) := (others => '0');
signal mux_md_out : std_logic_vector(7 downto 0) := (others => '0');
signal mux_md_in : std_logic_vector(7 downto 0) := (others => '0');

    -- détecteur d'aléa entre li/di et di/ex
signal alea_lidi_diex : std_logic := '0';

    -- détecteur d'aléa entre lid_di et ex/mem
signal alea_lidi_exmem : std_logic := '0';

    -- calcul en cours
signal calcul : std_logic := '0';

begin

Label_mi : MemoireInstructions PORT MAP (
    CLK => test_CLK,
    addr => instr_addr,
    instruction => instr_out
);

Label_lidi : Pipeline PORT MAP (
    inA => instr_out(23 downto 16),
    inB => instr_out(15 downto 8),
    inC => instr_out(7 downto 0),
    inOp => instr_out(27 downto 24),
    CLK => test_CLK,
    outA => lidi_out_a,
    outB => lidi_out_b,
    outC => lidi_out_c,
    outOp => lidi_out_op
);

Label_br : BancRegistres PORT MAP (
    addrA => lidi_out_b(3 downto 0),
    addrB => lidi_out_c(3 downto 0),
    addrW => memre_out_a(3 downto 0),
    W => lc_w,
    DATA => memre_out_b,
    RST => br_rst,
    CLK => test_CLK,
    QA => br_qa,
    QB => br_qb
);

Label_diex : Pipeline PORT MAP (
    inA => lidi_out_a,
    inB => mux_br,
    inC => br_qb,
    inOp => lidi_out_op,
    CLK => test_CLK,
    outA => diex_out_a,
    outB => diex_out_b,
    outC => diex_out_c,
    outOp => diex_out_op
);

Label_ual : UAL PORT MAP (
    A => diex_out_b,
    B => diex_out_c,
    opcode => lc_opcode,
    S => ual_s,
    N => ual_n,
    O => ual_o,
    Z => ual_z,
    C => ual_c
);

Label_exmem : Pipeline PORT MAP (
    inA => diex_out_a,
    inB => mux_ual,
    inC => diex_out_c, -- not used
    inOp => diex_out_op,
    CLK => test_CLK,
    outA => exmem_out_a,
    outB => exmem_out_b,
    outC => exmem_out_c, -- not used
    outOp => exmem_out_op
);

Label_md: MemoireDonnees PORT MAP (
    addr => mux_md_in,
    input => exmem_out_b,
    RW => lc_rw,
    RST => md_rst,
    output => md_output,
    CLK => test_CLK
);

Label_memre : Pipeline PORT MAP (
    inA => exmem_out_a,
    inB => mux_md_out,
    inC => exmem_out_c, -- not used
    inOp => exmem_out_op,
    CLK => test_CLK,
    outA => memre_out_a,
    outB => memre_out_b,
    outC => memre_out_c, -- not used
    outOp => memre_out_op
);

br_rst <= '0' after 0ns;
md_rst <= '0' after 0ns;

-- LC APRES MEMRE
-- Verifie que le code op soit valide pour écrire dans le banc de registres
lc_w <= '0' when (memre_out_op="1000" or memre_out_op="0000") else '1';

-- LC UAL
-- convertit l'opcode de l'instruction en opcode connu par l'ALU
lc_opcode <=    "001" when (diex_out_op = "0001") else  -- +
                "010" when (diex_out_op = "0010") else  -- *
                "011" when (diex_out_op = "0011") else  -- -
                "100" when (diex_out_op = "0100") else  -- /
                "101" when (diex_out_op = "1001") else  -- or
                "110" when (diex_out_op = "1010") else  -- and
                "111" when (diex_out_op = "1011");      -- not                

-- LC Mémoire de données
-- écriture si STORE
lc_rw <= '0' when exmem_out_op="1000" else '1';

-- MUX banc registre
mux_br <= lidi_out_b when (lidi_out_op = "0110") else br_qa; -- when AFC

-- MUX UAL
mux_ual <= ual_s when   (diex_out_op="0001" or      -- addition
                         diex_out_op="0010" or      -- multiplication
                         diex_out_op="0011" or      -- soustraction
                         diex_out_op="0100" or      -- division
                         diex_out_op="1001" or      -- or
                         diex_out_op="1010" or      -- and
                         diex_out_op="1011") else   -- not
            diex_out_b;

-- MUX mémoire données : load
mux_md_out <= md_output when exmem_out_op="0111" else exmem_out_b;

-- MUX mémoire données : store
mux_md_in <= exmem_out_a when exmem_out_op="1000" else exmem_out_b;

calcul <= '1' when (    lidi_out_op="0001" or
                        lidi_out_op="0010" or
                        lidi_out_op="0011" or
                        lidi_out_op="0100" or
                        lidi_out_op="1001" or
                        lidi_out_op="1010" or
                        lidi_out_op="1011") else '0';

-- alea detection
alea_lidi_diex <= '1' 
    when 
    -- AFC puis COP avec utilisation d'un même registre
    ((lidi_out_op="0110" and instr_out(27 downto 24)="0101" and lidi_out_a=instr_out(15 downto 8)) 
    or
    -- AFC puis calcul utilisant le même registre
    (lidi_out_op="0110" and (instr_out(27 downto 24)="0001" or instr_out(27 downto 24)="0010" or instr_out(27 downto 24)="0011" 
    or instr_out(27 downto 24)="0100" or instr_out(27 downto 24)="1001" or instr_out(27 downto 24)="1010" or instr_out(27 downto 24)="1011") and
    (lidi_out_a=instr_out(15 downto 8) or lidi_out_a=instr_out(7 downto 0)))
    or
    -- COP puis calcul utilisant le même registre
    (lidi_out_op="0101" and (instr_out(27 downto 24)="0001" or instr_out(27 downto 24)="0010" or instr_out(27 downto 24)="0011" 
    or instr_out(27 downto 24)="0100" or instr_out(27 downto 24)="1001" or instr_out(27 downto 24)="1010" or instr_out(27 downto 24)="1011") and
    (lidi_out_a=instr_out(15 downto 8)))
    or
    -- Calcul en cours mettant à jour un registre utilisé pour le calcul suivant
    (calcul='1' and (lidi_out_a=instr_out(15 downto 8) or lidi_out_a=instr_out(7 downto 0))))
    else '0';

Clock_process : 
process
begin
    test_CLK <= not(test_CLK);
    wait for CLK_period/2;
end process;

instr_addr_process : process
begin
    wait until rising_edge(test_CLK);
    if alea_lidi_diex = '0' then
        instr_addr <= instr_addr + '1';
    else
        wait until rising_edge(test_CLK);
        wait until rising_edge(test_CLK);
        wait until rising_edge(test_CLK);
        instr_addr <= instr_addr + '1';
    end if;
end process;

end Behavioral;