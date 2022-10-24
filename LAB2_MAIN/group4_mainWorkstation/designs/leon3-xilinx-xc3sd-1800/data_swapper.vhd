----------------------------------------------------------------------
--- Group Num: 4 
--- Author: QINGYU ZHANG, SHURAN YANG, HAIBO LIAN
--- Date: 22/10/2022 
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.misc.all;
library UNISIM;
use UNISIM.VComponents.all;


-- The data_wapper
entity data_swapper is
  port(
    HRDATA : out std_logic_vector (31 downto 0);
    dmao_rdata : in std_logic_vector (31 downto 0)
  );
end;
----------------------------------------------------------------------
architecture structural of data_swapper is

begin
  swapper:
  process(dmao_rdata)
  begin
    HRDATA (31 downto 24) <= dmao_rdata (7 downto 0);
    HRDATA (23 downto 16) <= dmao_rdata (15 downto 8);
    HRDATA (15 downto 8) <= dmao_rdata (23 downto 16);
    HRDATA (7 downto 0) <= dmao_rdata (31 downto 24);
  end process;
 
  
end structural;

