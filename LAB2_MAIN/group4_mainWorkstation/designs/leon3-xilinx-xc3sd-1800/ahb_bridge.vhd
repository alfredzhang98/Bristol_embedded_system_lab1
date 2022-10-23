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

-- The second interface for the AHB bridge
entity ahb_bridge is
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

----------------------------------------------------------------------
architecture structural of ahb_bridge is
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
    clkm : in std_logic;
    rstn : in std_logic;
    HADDR : in std_logic_vector (31 downto 0);
    HSIZE : in std_logic_vector (2 downto 0);
    HTRANS : in std_logic_vector (1 downto 0);
    HWDATA : in std_logic_vector (31 downto 0);
    HWRITE : in std_logic;
    HREADY : out std_logic;
		dmai : out ahb_dma_in_type;
		dmao : in ahb_dma_out_type
	);
end component;

--declare a component for ahbmst
component ahbmst is
  generic (
    hindex  : integer := 0;
    hirq    : integer := 0;
    venid   : integer := VENDOR_GAISLER;
    devid   : integer := 0;
    version : integer := 0;
    chprot  : integer := 3;
    incaddr : integer := 0); 
  port(
    rst  : in  std_ulogic;
    clk  : in  std_ulogic;
    dmai : in ahb_dma_in_type;
    dmao : out ahb_dma_out_type;
    ahbi : in  ahb_mst_in_type;
    ahbo : out ahb_mst_out_type 
	);
end component;

--declare a component for data_swapper
component data_swapper is
  port(
    HRDATA : out std_logic_vector (31 downto 0);
    dmao : in ahb_dma_out_type
	);
end component;

----------------------------
-- the define of signal
signal dmai : ahb_dma_in_type;
signal dmao : ahb_dma_out_type;


----------------------------
-- the begin of action
begin

--instantiate state_machine component and make the connections
  u_state_machine : state_machine
  port map(
    clkm => clkm,
    rstn => rstn,
    HADDR => HADDR,
    HSIZE => HSIZE,
    HTRANS => HTRANS,
    HWDATA => HWDATA,
    HWRITE => HWRITE,
    HREADY => HREADY,
		dmai => dmai,
		dmao => dmao
  );

--instantiate the ahbmst component and make the connections
  u_ahbmst : ahbmst
  port map(
    clk => clkm,
    rst => rstn,
  		dmai => dmai,
		dmao => dmao,
		ahbi => ahbmi,
		ahbo => ahbmo
  );

--instantiate the data_swapper component and make the connections
  u_data_swapper : data_swapper
  port map(
    HRDATA => HRDATA,
    dmao => dmao
  );

end structural;