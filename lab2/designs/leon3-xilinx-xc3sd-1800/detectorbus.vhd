library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity DetectorBus is
    Port ( clkm : in  STD_LOGIC;
           HRDATA : in  STD_LOGIC_VECTOR (31 downto 0);
           cm0_led : out  STD_LOGIC);
end DetectorBus;

architecture Behavioral of DetectorBus is

begin

process (clkm,HRDATA)
begin
	if (falling_edge(clkm)) then
		if (HRDATA(31 downto 0)="00001100000011000000110000001100") then
			cm0_led<='1';
		else
			cm0_led<='0';
		end if;
end if;

end process;




end Behavioral;

