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
end;
architecture structural of AHB_bridge is
	component state_machine
	port (  HADDR : in std_logic_vector(31 downto 0);
		  HWDATA : in std_logic_vector(31 downto 0);
        HSIZE : in std_logic_vector(2 downto 0);
        HTRANS :in std_logic_vector (1 downto 0);
        HWRITE: in std_logic;
		  dmao : in ahb_dma_out_type ;
		  dmai : out ahb_dma_in_type ; 
        clkm,rstn : in std_logic;
        HREADY: out std_logic);
	end component;
	
	component data_swapper is
	port (dmao_rdata : in std_logic_vector (31 downto 0);
		  HRDATA : out std_logic_vector (31 downto 0));
   end component;
	
	component ahbmst is
  generic (
    hindex  : integer := 0;
    hirq    : integer := 0;
    venid   : integer := VENDOR_GAISLER;
    devid   : integer := 0;
    version : integer := 0;
    chprot  : integer := 3;
    incaddr : integer := 0); 
   port (
      rst  : in  std_logic;
      clk  : in  std_logic;
      dmai : in ahb_dma_in_type;
      dmao : out ahb_dma_out_type;
      ahbi : in  ahb_mst_in_type;
      ahbo : out ahb_mst_out_type 
      );

  end component;

	
signal dmai : ahb_dma_in_type;
signal dmao : ahb_dma_out_type;

begin
        part_1 : state_machine
		 port map(
						clkm => clkm,
						rstn => rstn,
						HADDR => HADDR,
						HWDATA => HWDATA,
						HSIZE => HSIZE,
						HTRANS => HTRANS,
						HWRITE => HWRITE,
						HREADY => HREADY,
						dmao => dmao,
						dmai => dmai
						);
		
		Part_2: data_swapper
		port map(
						dmao_rdata => dmao.rdata,
						HRDATA => HRDATA
					);

		
		Part_3 : ahbmst
		port map(
					   clk => clkm,
						rst => rstn,
						dmao => dmao,
						dmai => dmai,
						ahbo => ahbo,
						ahbi => ahbi
					);
					
						

end structural;
