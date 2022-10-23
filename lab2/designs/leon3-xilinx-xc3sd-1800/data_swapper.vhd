library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library gaisler;
use gaisler.misc.all;

entity data_swapper is
port (dmao_rdata : in std_logic_vector (31 downto 0);
		HRDATA : out std_logic_vector (31 downto 0));
end data_swapper;

architecture structure of data_swapper is
begin

HRDATA (31 downto 24) <= dmao_rdata (7 downto 0);
HRDATA (23 downto 16) <= dmao_rdata (15 downto 8);
HRDATA (15 downto 8) <= dmao_rdata (23 downto 16);
HRDATA (7 downto 0) <= dmao_rdata (31 downto 24);

end structure;