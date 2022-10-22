----------------------------------------------------------------------
--- Group Num: 4 
--- Author: QINGYU ZHANG
--- Date: 17/10/2022 
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
entity AHB_bridge is
  port(
    -- Clock and Reset 
    clkm : in std_logic;
    rstn : in std_logic;
    -- AHB Master records 
    ahbmi : in ahb_mst_in_type;
    ahbmo : out ahb_mst_out_type;
    -- ARM Cortex-M0 AHB-Lite signals 
    HADDR : in std_logic_vector (31 downto 0);    -- AHB transaction address
    HSIZE : in std_logic_vector (2 downto 0);     -- AHB size: byte, half-word or word
    HTRANS : in std_logic_vector (1 downto 0);    -- AHB transfer: non-sequential only
    HWDATA : in std_logic_vector (31 downto 0);   -- AHB write-data
    HWRITE : in std_logic; -- AHB write control
    HRDATA : out std_logic_vector (31 downto 0);  -- AHB read-data
    HREADY : out std_logic -- AHB stall signal
  );
end;

-- Refer the The type definitions for ahb_mst_in_type and ahb_mst_out_type are available in the file amba.vhd that can be found at "...\lib\grlib\amba
-- AHB master inputs
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

-- AHB master outputs
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


----------------------------------------------------------------------
architecture structural of AHB_bridge is
----------------------------
--declare a component

--declare a component for state_machine
-- Two state
-- idle state
-- HREADY <= '1' idle state AHB-Lite bus is ready to accept an address-phase
-- If we forget to do this then the processor will not do anything
-- instr_fetch state
-- HREADY <= '0' instr_fetch

component state_machine is
  port(


--declare a component for ahbmst
component ahbmst is
  port(
    

--declare a component for data_swapper
component data_swapper is
  port(
    

----------------------------
-- the define of signal
signal dmai : ahb_dma_in_type;
signal dmao : ahb_dma_out_type;


----------------------------
-- the begin of action
begin

--instantiate state_machine component and make the connections

--instantiate the ahbmst component and make the connections

--instantiate the data_swapper component and make the connections

end structural;