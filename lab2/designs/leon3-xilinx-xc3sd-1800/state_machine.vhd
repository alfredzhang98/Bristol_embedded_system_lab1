-----------------------------
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



entity state_machine is
port (  
    HADDR : in std_logic_vector(31 downto 0);
		HWDATA : in std_logic_vector(31 downto 0);
    HSIZE : in std_logic_vector(2 downto 0);
    HTRANS :in std_logic_vector (1 downto 0);
    HWRITE: in std_logic;
		dmao : in ahb_dma_out_type ;
		dmai : out ahb_dma_in_type ; 
    clkm,rstn : in std_logic;
    HREADY: out std_logic);
end state_machine;

architecture structure of state_machine is


type state_type is (idle,instr_fetch);  
	signal state : state_type;  
	begin    

dmai.busy <='0';
dmai.irq <= '0';
dmai.burst<= '0';     
dmai.address <= HADDR;
dmai.wdata <= HWDATA;
dmai.size <= HSIZE;
dmai.write<= HWRITE;

FSM : process (clkm)
begin

if (rstn='0')then
	state<= idle;
	HREADY<='1';
	dmai.start<='0';
elsif (rising_edge(clkm)) then

  case state is
   when idle=>
  		HREADY<='1';
		dmai.start<='0';
		if (HTRANS="10") then
		  dmai.start<='1';
		  state<=instr_fetch;
		end if;
   when instr_fetch=>
		HREADY <='0';
		dmai.start <='0';

		if (dmao.ready='1') then
		  HREADY<='1';
		  state<=idle;
		end if;
  end case;
end if;
end process;
end structure;