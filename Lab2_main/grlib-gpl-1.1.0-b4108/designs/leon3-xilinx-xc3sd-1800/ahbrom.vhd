
----------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2010 Aeroflex Gaisler
----------------------------------------------------------------------------
-- Entity: 	ahbrom
-- File:	ahbrom.vhd
-- Author:	Jiri Gaisler - Gaisler Research
-- Description:	AHB rom. 0/1-waitstate read
----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;

entity ahbrom is
  generic (
    hindex  : integer := 0;
    haddr   : integer := 0;
    hmask   : integer := 16#fff#;
    pipe    : integer := 0;
    tech    : integer := 0;
    kbytes  : integer := 1);
  port (
    rst     : in  std_ulogic;
    clk     : in  std_ulogic;
    ahbsi   : in  ahb_slv_in_type;
    ahbso   : out ahb_slv_out_type
  );
end;

architecture rtl of ahbrom is
constant abits : integer := 9;
constant bytes : integer := 376;

constant hconfig : ahb_config_type := (
  0 => ahb_device_reg ( VENDOR_GAISLER, GAISLER_AHBROM, 0, 0, 0),
  4 => ahb_membar(haddr, '1', '1', hmask), others => zero32);

signal romdata : std_logic_vector(31 downto 0);
signal addr : std_logic_vector(abits-1 downto 2);
signal hsel, hready : std_ulogic;

begin

  ahbso.hresp   <= "00"; 
  ahbso.hsplit  <= (others => '0'); 
  ahbso.hirq    <= (others => '0');
  ahbso.hcache  <= '1';
  ahbso.hconfig <= hconfig;
  ahbso.hindex  <= hindex;

  reg : process (clk)
  begin
    if rising_edge(clk) then 
      addr <= ahbsi.haddr(abits-1 downto 2);
    end if;
  end process;

  p0 : if pipe = 0 generate
    ahbso.hrdata  <= ahbdrivedata(romdata);
    ahbso.hready  <= '1';
  end generate;

  p1 : if pipe = 1 generate
    reg2 : process (clk)
    begin
      if rising_edge(clk) then
	hsel <= ahbsi.hsel(hindex) and ahbsi.htrans(1);
	hready <= ahbsi.hready;
	ahbso.hready <=  (not rst) or (hsel and hready) or
	  (ahbsi.hsel(hindex) and not ahbsi.htrans(1) and ahbsi.hready);
	ahbso.hrdata  <= ahbdrivedata(romdata);
      end if;
    end process;
  end generate;

  comb : process (addr)
  begin
    case conv_integer(addr) is
    when 16#00000# => romdata <= X"00040000";
    when 16#00001# => romdata <= X"A1000000";
    when 16#00002# => romdata <= X"00000000";
    when 16#00003# => romdata <= X"00000000";
    when 16#00004# => romdata <= X"00000000";
    when 16#00005# => romdata <= X"00F002F8";
    when 16#00006# => romdata <= X"00F032F8";
    when 16#00007# => romdata <= X"0CA030C8";
    when 16#00008# => romdata <= X"08382418";
    when 16#00009# => romdata <= X"2D18A246";
    when 16#0000A# => romdata <= X"671EAB46";
    when 16#0000B# => romdata <= X"54465D46";
    when 16#0000C# => romdata <= X"AC4201D1";
    when 16#0000D# => romdata <= X"00F024F8";
    when 16#0000E# => romdata <= X"7E460F3E";
    when 16#0000F# => romdata <= X"0FCCB646";
    when 16#00010# => romdata <= X"01263342";
    when 16#00011# => romdata <= X"00D0FB1A";
    when 16#00012# => romdata <= X"A246AB46";
    when 16#00013# => romdata <= X"33431847";
    when 16#00014# => romdata <= X"18010000";
    when 16#00015# => romdata <= X"28010000";
    when 16#00016# => romdata <= X"00230024";
    when 16#00017# => romdata <= X"00250026";
    when 16#00018# => romdata <= X"103A01D3";
    when 16#00019# => romdata <= X"78C1FBD8";
    when 16#0001A# => romdata <= X"520700D3";
    when 16#0001B# => romdata <= X"30C100D5";
    when 16#0001C# => romdata <= X"0B607047";
    when 16#0001D# => romdata <= X"1FB5C046";
    when 16#0001E# => romdata <= X"C0461FBD";
    when 16#0001F# => romdata <= X"10B510BD";
    when 16#00020# => romdata <= X"00F026F8";
    when 16#00021# => romdata <= X"1146FFF7";
    when 16#00022# => romdata <= X"F5FF00F0";
    when 16#00023# => romdata <= X"09F800F0";
    when 16#00024# => romdata <= X"3EF803B4";
    when 16#00025# => romdata <= X"FFF7F2FF";
    when 16#00026# => romdata <= X"03BC00F0";
    when 16#00027# => romdata <= X"5FF80000";
    when 16#00028# => romdata <= X"C8220FE0";
    when 16#00029# => romdata <= X"00210020";
    when 16#0002A# => romdata <= X"01E0491C";
    when 16#0002B# => romdata <= X"401C9042";
    when 16#0002C# => romdata <= X"FBD3054B";
    when 16#0002D# => romdata <= X"002001E0";
    when 16#0002E# => romdata <= X"491C401C";
    when 16#0002F# => romdata <= X"9042FBD3";
    when 16#00030# => romdata <= X"024B5B1C";
    when 16#00031# => romdata <= X"EEE70000";
    when 16#00032# => romdata <= X"5555AAAA";
    when 16#00033# => romdata <= X"F0F0F0F0";
    when 16#00034# => romdata <= X"754600F0";
    when 16#00035# => romdata <= X"23F8AE46";
    when 16#00036# => romdata <= X"05006946";
    when 16#00037# => romdata <= X"5346C008";
    when 16#00038# => romdata <= X"C0008546";
    when 16#00039# => romdata <= X"18B020B5";
    when 16#0003A# => romdata <= X"00F01CF8";
    when 16#0003B# => romdata <= X"60BC0027";
    when 16#0003C# => romdata <= X"4908B646";
    when 16#0003D# => romdata <= X"0026C0C5";
    when 16#0003E# => romdata <= X"C0C5C0C5";
    when 16#0003F# => romdata <= X"C0C5C0C5";
    when 16#00040# => romdata <= X"C0C5C0C5";
    when 16#00041# => romdata <= X"C0C5403D";
    when 16#00042# => romdata <= X"49008D46";
    when 16#00043# => romdata <= X"70470446";
    when 16#00044# => romdata <= X"C046C046";
    when 16#00045# => romdata <= X"2046FFF7";
    when 16#00046# => romdata <= X"BCFF0000";
    when 16#00047# => romdata <= X"00487047";
    when 16#00048# => romdata <= X"00040000";
    when 16#00049# => romdata <= X"00B585B0";
    when 16#0004A# => romdata <= X"694601AA";
    when 16#0004B# => romdata <= X"09480A60";
    when 16#0004C# => romdata <= X"ABBE0198";
    when 16#0004D# => romdata <= X"002803D1";
    when 16#0004E# => romdata <= X"05480721";
    when 16#0004F# => romdata <= X"40188843";
    when 16#00050# => romdata <= X"0399029A";
    when 16#00051# => romdata <= X"049B05B0";
    when 16#00052# => romdata <= X"00BD00BF";
    when 16#00053# => romdata <= X"0D000000";
    when 16#00054# => romdata <= X"60040000";
    when 16#00055# => romdata <= X"16000000";
    when 16#00056# => romdata <= X"70470000";
    when 16#00057# => romdata <= X"01491820";
    when 16#00058# => romdata <= X"ABBEFEE7";
    when 16#00059# => romdata <= X"26000200";
    when 16#0005A# => romdata <= X"78010000";
    when 16#0005B# => romdata <= X"00040000";
    when 16#0005C# => romdata <= X"60000000";
    when 16#0005D# => romdata <= X"58000000";
    when 16#0005E# => romdata <= X"58000000";
    when others => romdata <= (others => '-');
    end case;
  end process;
  -- pragma translate_off
  bootmsg : report_version 
  generic map ("ahbrom" & tost(hindex) &
  ": 32-bit AHB ROM Module,  " & tost(bytes/4) & " words, " & tost(abits-2) & " address bits" );
  -- pragma translate_on
  end;
