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

  type state_ahb_bridge is (idle, wait_htrans, instr_fetch);
  signal present_state : state_ahb_bridge;
  signal next_state : state_ahb_bridge;  
  begin
    
  -- init the dmai info (The out info)
  dmai.address <= HADDR;
  dmai.wdata <= HWDATA;
  -- dmai.start <= '0';
  dmai.burst <= '0';
  dmai.write <= HWRITE;
  dmai.busy <= '0';
  dmai.irq <= '0';
  dmai.size <= HSIZE; 
  
  
  -- reg_sate change
  reg_sate:
  process (rstn, clkm)
  begin
    if rstn = '0' then
      present_state <= idle;
    elsif rising_edge(clkm) then
      present_state <= next_state;
    end if;
  end process;
  
  -- com_state change
  com_state:
  process (present_state, HTRANS, dmao.ready)
  begin
    case present_state is
      -- idle state
      when idle =>
        next_state <= wait_htrans;
      -- wait_htrans state
      when wait_htrans =>
    		  if HTRANS = "10" then
		      next_state <= instr_fetch;
		    else
		      next_state <= wait_htrans;
		    end if;
      -- instr_fetch state
      when instr_fetch =>
        if dmao.ready = '1' then
          next_state <= idle;
        else 
		      next_state <= instr_fetch;
		    end if;
      -- other state
      when others => 
        next_state <= idle;
		end case;
	end process;

	-- output_state change
  output_state:
	process (rstn, clkm)
  begin
    if rstn = '0' then
      HREADY <= '1';
      dmai.start <= '0';
    elsif rising_edge(clkm) then
  		  case present_state is
  		    -- idle state output 
		    when idle =>
		      HREADY <= '1';
		      dmai.start <= '0';
		    -- wait_htrans state output 
		    when wait_htrans =>
		      if HTRANS = "10" then
		        dmai.start <= '1';
		      end if;
		    -- instr_fetch state output 
		    when instr_fetch =>
		      HREADY <= '0';
		      dmai.start <= '0';
		      if dmao.ready = '1' then
		        HREADY <= '1';
		      end if;
		    -- others state output
		    when others => 
		      HREADY <= '1';
		      dmai.start <= '0';
		   end case;
    end if;
  end process;
  
end structural;
		     
  
  
  
  
  
  
  
  
  