----------------------------------------------------------------------
--- Group Num: 4 
--- Author: QINGYU ZHANG, SHURAN YANG, HAIBO LIAN
--- Date: 22/10/2022 
----------------------------------------------------------------------

--  type ahb_dma_in_type is record
--    address         : std_logic_vector(31 downto 0);
--    wdata           : std_logic_vector(AHBDW-1 downto 0);
--    start           : std_ulogic;
--    burst           : std_ulogic;
--    write           : std_ulogic;
--    busy            : std_ulogic;
--    irq             : std_ulogic;
--    size            : std_logic_vector(2 downto 0);
--  end record;
--
--  type ahb_dma_out_type is record
--    start           : std_ulogic;
--    active          : std_ulogic;
--    ready           : std_ulogic;
--    retry           : std_ulogic;
--    mexc            : std_ulogic;
--    haddr           : std_logic_vector(9 downto 0);
--    rdata           : std_logic_vector(AHBDW-1 downto 0);
--  end record;

---- AHB master inputs
--  type ahb_mst_in_type is record
--    hgrant	: std_logic_vector(0 to NAHBMST-1);     -- bus grant
--    hready	: std_ulogic;                         	-- transfer done
--    hresp	: std_logic_vector(1 downto 0); 	-- response type
--    hrdata	: std_logic_vector(AHBDW-1 downto 0); 	-- read data bus
--    hcache	: std_ulogic;                         	-- cacheable
--    hirq  	: std_logic_vector(NAHBIRQ-1 downto 0);	-- interrupt result bus
--    testen	: std_ulogic;                         	-- scan test enable
--    testrst	: std_ulogic;                         	-- scan test reset
--    scanen 	: std_ulogic;                         	-- scan enable
--    testoen 	: std_ulogic;                         	-- test output enable 
--  end record;
--
---- AHB master outputs
--  type ahb_mst_out_type is record
--    hbusreq	: std_ulogic;                         	-- bus request
--    hlock	: std_ulogic;                         	-- lock request
--    htrans	: std_logic_vector(1 downto 0); 	-- transfer type
--    haddr	: std_logic_vector(31 downto 0); 	-- address bus (byte)
--    hwrite	: std_ulogic;                         	-- read/write
--    hsize	: std_logic_vector(2 downto 0); 	-- transfer size
--    hburst	: std_logic_vector(2 downto 0); 	-- burst type
--    hprot	: std_logic_vector(3 downto 0); 	-- protection control
--    hwdata	: std_logic_vector(AHBDW-1 downto 0); 	-- write data bus
--    hirq   	: std_logic_vector(NAHBIRQ-1 downto 0);	-- interrupt bus
--    hconfig 	: ahb_config_type;	 		-- memory access reg.
--    hindex  	: integer range 0 to NAHBMST-1;	 	-- diagnostic use only
--  end record;


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
    dmao : in ahb_dma_out_type
  );
end;
----------------------------------------------------------------------
architecture structural of data_swapper is

signal get_rdata : std_logic_vector (31 downto 0);

begin
  swapper:
  process(dmao)
  begin
    get_rdata <= dmao.rdata;
    HRDATA (31 downto 24) <= get_rdata (7 downto 0);
    HRDATA (23 downto 16) <= get_rdata (15 downto 8);
    HRDATA (15 downto 8) <= get_rdata (23 downto 16);
    HRDATA (7 downto 0) <= get_rdata (31 downto 24);
  end process;

--  process(get_rdata)
--  begin
--    HRDATA (31 downto 24) <= get_rdata (7 downto 0);
--    HRDATA (23 downto 16) <= get_rdata (15 downto 8);
--    HRDATA (15 downto 8) <= get_rdata (23 downto 16);
--    HRDATA (7 downto 0) <= get_rdata (31 downto 24);
--  end process;
 
  
end structural;

