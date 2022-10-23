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

entity cm0_wrapper is
  port (  clkm : in std_logic;
          rstn : in std_logic;

          ahbmi : in ahb_mst_in_type;
          ahbmo : out ahb_mst_out_type;
          cm0_led : out std_logic);
end;

architecture structure of cm0_wrapper is
  component CORTEXM0DS is
  port (
    HCLK : in std_logic;
    HRESETn : in std_logic;
    HADDR : out std_logic_vector (31 downto 0); 
    HBURST : out std_logic_vector (2 downto 0);
    HMASTLOCK : out std_logic;
    HPROT : out std_logic_vector (3 downto 0);
    HSIZE : out std_logic_vector (2 downto 0);
    HTRANS : out std_logic_vector (1 downto 0);
    HWDATA : out std_logic_vector (31 downto 0);
    HWRITE : out std_logic;
    HRDATA : in std_logic_vector (31 downto 0);
    HREADY : in std_logic;
    HRESP : in std_logic;
    
    NMI : in std_logic;
    IRQ : in std_logic_vector (15 downto 0);
    TXEV : out std_logic;
    RXEV : in std_logic;
    LOCKUP : out std_logic;
    SYSRESETREQ : out std_logic;
    
    SLEEPING : out std_logic
  );
end component;

  component ahb_bridge is
     port(

          clkm : in std_logic;
          rstn : in std_logic;

          ahbi : in ahb_mst_in_type;
          ahbo : out ahb_mst_out_type;

          HADDR : in std_logic_vector (31 downto 0); 
          HSIZE : in std_logic_vector (2 downto 0); 
          HTRANS : in std_logic_vector (1 downto 0); 
          HWDATA : in std_logic_vector (31 downto 0); 
          HWRITE : in std_logic; -- AHB write control
          HRDATA : out std_logic_vector (31 downto 0); 
          HREADY : out std_logic -- AHB stall signal
 );
 end component;
 
  component  detectorbus is
        Port ( clkm : in  STD_LOGIC;
           HRDATA : in  STD_LOGIC_VECTOR (31 downto 0);
           cm0_led : out  STD_LOGIC);
  end component;
    
 

 signal HADDR :  std_logic_vector (31 downto 0); 
 signal HSIZE :  std_logic_vector (2 downto 0); 
 signal HTRANS : std_logic_vector (1 downto 0); 
 signal HWDATA : std_logic_vector (31 downto 0); 
 signal HWRITE : std_logic; -- AHB write control
 signal HRDATA : std_logic_vector (31 downto 0); 
 signal HREADY : std_logic ;-- AHB stall signal 

 ------five port----------------------------------
 --signal HBURST : std_logic_vector (2 downto 0) := open;

 --signal HMASTLOCK : std_logic;
 
-- signal HPROT : std_logic_vector (3 downto 0);
 
 --signal HRESP : std_logic;

    
 --signal NMI : std_logic;

 --signal IRQ : std_logic_vector (15 downto 0);
 
 --signal TXEV : std_logic;
 
 --signal RXEV : std_logic;

 --signal LOCKUP : std_logic;
 
 --signal SYSRESETREQ : std_logic;
 
    
 --signal SLEEPING :  std_logic;
 
 
 
begin


 CM0: CORTEXM0DS
 port map (
   HCLK =>clkm,
   HRESETn => rstn,
   HADDR => HADDR,
   HSIZE => HSIZE,
   HTRANS => HTRANS,
   HWDATA => HWDATA,
   HWRITE => HWRITE,
   HRDATA  => HRDATA,
   HREADY => HREADY,

  HBURST => open ,
  HMASTLOCK => open,
  HPROT => open,
  HRESP => '0',
  NMI => '0' ,
  IRQ => "0000000000000000" ,
  TXEV => open,
  RXEV => '0',
  LOCKUP => open,
  SYSRESETREQ => open,
  SLEEPING => open
 );
  bridge : ahb_bridge 
  port map ( 
    clkm => clkm,
    rstn => rstn,
    
    ahbi => ahbmi,
    ahbo => ahbmo,
    
    HADDR => HADDR,
    HSIZE => HSIZE,
    HTRANS => HTRANS,
    HWDATA => HWDATA,
    HWRITE => HWRITE,
    HRDATA => HRDATA,
    HREADY => HREADY
  );
  leddetector : detectorbus
  port map (
    clkm =>clkm,
    HRDATA=>HRDATA,
    cm0_led => cm0_led);
  
end structure; 
