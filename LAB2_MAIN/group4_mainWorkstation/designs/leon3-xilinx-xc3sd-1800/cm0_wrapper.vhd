----------------------------------------------------------------------
--- Group Num: 4 
--- Author: QINGYU ZHANG
--- Date: 17/10/2022 
----------------------------------------------------------------------

----------------------------------------------------------------------
-- what is the difference of the AHB and AHB-Lite:
-- AHB can use multiply master
-- AHB-Lite can only have one master, multiply slave
-- The main difference is arbitration section:
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

-- The top interface for the AHB bridge
entity cm0_wrapper is
  
port (
-- Reset and clock 
rstn : in std_logic;
clkm : in std_logic;
-----------------
-- AHB bus signals for master
ahbmi : in ahb_mst_in_type;
ahbmo : out ahb_mst_out_type;
-----------------
);
end;

architecture structural of cm0_wrapper is
-----------------
-- component detectorbus can be used to test your implementation
-- signal connections
-- your state machine
-----------------
end structural;