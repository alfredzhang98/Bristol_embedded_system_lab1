-- Copyright (c) 2020, Jose Nunez
-- All rights reserved.
--  
-- Redistribution and use in source and binary forms, with or without modification, are permitted provided that
-- the following conditions are met:
-- 
--     * Redistributions of source code must retain the above copyright notice, this list of conditions and the 
--       following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and 
--       the following disclaimer in the documentation and/or other materials provided with the distribution.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity DetectorBus is
    Port ( Clock : in  STD_LOGIC;
           DataBus : in  STD_LOGIC_VECTOR (31 downto 0);
           Detector : out  STD_LOGIC);
end DetectorBus;

architecture Behavioral of DetectorBus is
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

	if (DataBus(31 downto 0)="11110000111100001111000011110000" or 
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

