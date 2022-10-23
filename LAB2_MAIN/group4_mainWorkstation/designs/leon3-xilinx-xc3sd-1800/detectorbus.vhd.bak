----------------------------------------------------------------------
--- Group Num: 4 
--- Author: QINGYU ZHANG
--- Date: 17/10/2022 
----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity detectorbus is
    Port (Clock : in  STD_LOGIC;
           DataBus : in  STD_LOGIC_VECTOR (31 downto 0);
           Detector : out  STD_LOGIC);
end detectorbus;

architecture Behavioral of detectorbus is
  
signal trigger:std_logic;
signal outputff:std_logic;
signal inputff:std_logic;
signal rst_ff:std_logic;

begin

process (Clock,DataBus)
begin
	if (falling_edge(Clock)) then
		if (DataBus(31 downto 0)="10101010101010100101010101010101" or
              DataBus(31 downto 0)="10101010101010100110011001100110") then
			trigger<='1';
			rst_ff<='0';
		else
			trigger<='0';
		end if;

-- Group4: HEX:04040404 BIT:00000100000001000000010000000100
--  if (DataBus(31 downto 0)="11110000111100001111000011110000" or 
	if (DataBus(31 downto 0)="00000100000001000000010000000100" or 
          DataBus(31 downto 0)="11110010111100101111001011110010") then
		
		rst_ff<='1';
		trigger<='0';
		
	
	end if;
	
	
	end if;	
end process;

instFF : FDCE 
		generic map (
			INIT => '0') -- Initial value of register ('0' or '1')
		port map (
		Q => outputff, -- Data output
		C => Clock, -- Clock input
		CE => '1', -- Clock enable input
		CLR => rst_ff, -- Asynchronous clear input
		D => inputff -- Data input
		);

inputff <= trigger or outputff;		
Detector <= outputff;


end Behavioral;