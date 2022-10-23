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

-- The state machine
entity state_machine is
  port(
    -- Reset and clock
    clkm : in std_logic;
    rstn : in std_logic;
    -- State machine (M0)
    HADDR : in std_logic_vector (31 downto 0);
    HSIZE : in std_logic_vector (2 downto 0);
    HTRANS : in std_logic_vector (1 downto 0);
    HWDATA : in std_logic_vector (31 downto 0);
    HWRITE : in std_logic;
    HREADY : out std_logic;
    -- State machine (Internal)
		dmai : out ahb_dma_in_type;
		dmao : in ahb_dma_out_type
  );
end;



----------------------------------------------------------------------
architecture structural of state_machine is

  type state_ahb_bridge is (idle, instr_fetch);
    signal u_state : state_ahb_bridge;
    begin
    
  -- init the dmai info (The out info)
  dmai.address <= HADDR;
  dmai.wdata <= HWDATA;
--  dmai.start <= '0';
  dmai.burst <= '0';
  dmai.write <= HWRITE;
  dmai.busy <= '0';
  dmai.irq <= '0';
  dmai.size <= HSIZE; 
  
  change_state:
  process (rstn, clkm)
  begin
    -- reset to low level come to the idle state
    -- normal work status is high level
    if rstn = '0' then
      u_state <= idle;
      HREADY <= '1';
      dmai.start <= '0';
    elsif rising_edge(clkm) then
      case u_state is
        -- idle state
        when idle =>
        		HREADY <= '1';
		      dmai.start <= '0';
		      -- the reason to change
       		 if HTRANS = "10" then
		        dmai.start <= '1';
		        u_state <= instr_fetch;
		      end if;
        -- instr_fetch state
        when instr_fetch =>
		      HREADY <= '0';
		      dmai.start <= '0';
		      -- the reason to change
       		 if dmao.ready = '1' then
		        dmai.start <= '1';
		        u_state <= instr_fetch;
		      end if;
		  end case;
		end if;
  end process;
end structural;
		     
  
  
  
  
  
  
  
  
  