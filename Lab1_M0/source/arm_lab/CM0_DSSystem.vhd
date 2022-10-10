-- Copyright (c) 2011, Pedro Ignacio Martos <pmartos@fi.uba.ar / pimartos@gmail.com> & Fabricio Baglivo <baglivofabricio@gmail.com>
-- All rights reserved.
--  
-- Redistribution and use in source and binary forms, with or without modification, are permitted provided that
-- the following conditions are met:
-- 
--     * Redistributions of source code must retain the above copyright notice, this list of conditions and the 
--       following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and 
--       the following disclaimer in the documentation and/or other materials provided with the distribution.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity CM0_DSSystem is
    Port ( Led0 : out  STD_LOGIC; -- dcm
           Led1 : out  STD_LOGIC; -- sleep
           Led2 : out  STD_LOGIC; -- lock
           Led3 : out  STD_LOGIC; -- detector
           Led4 : out  STD_LOGIC; -- reset
           Led5 : out  STD_LOGIC;
           Led6 : out  STD_LOGIC;
           Led7 : out  STD_LOGIC;
           reset : in STD_LOGIC;
           Clock_In : in  STD_LOGIC);
end CM0_DSSystem;

architecture Behavioral of CM0_DSSystem is

component cortexm0_memory
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;


component DetectorBus is
    Port ( Clock : in  STD_LOGIC;
           DataBus : in  STD_LOGIC_VECTOR (31 downto 0);
           Detector : out  STD_LOGIC);
end component;

	
	
COMPONENT CORTEXM0DS 
	PORT(
  -- CLOCK AND RESETS ------------------
  --input  wire        HCLK,              -- Clock
  --input  wire        HRESETn,           -- Asynchronous reset
  HCLK : IN std_logic;              -- Clock
  HRESETn : IN std_logic;           -- Asynchronous reset

  -- AHB-LITE MASTER PORT --------------
  --output wire [31:0] HADDR,             -- AHB transaction address
  --output wire [ 2:0] HBURST,            -- AHB burst: tied to single
  --output wire        HMASTLOCK,         -- AHB locked transfer (always zero)
  --output wire [ 3:0] HPROT,             -- AHB protection: priv; data or inst
  --output wire [ 2:0] HSIZE,             -- AHB size: byte, half-word or word
  --output wire [ 1:0] HTRANS,            -- AHB transfer: non-sequential only
  --output wire [31:0] HWDATA,            -- AHB write-data
  --output wire        HWRITE,            -- AHB write control
  --input  wire [31:0] HRDATA,            -- AHB read-data
  --input  wire        HREADY,            -- AHB stall signal
  --input  wire        HRESP,             -- AHB error response
  HADDR : OUT std_logic_vector (31 downto 0);             -- AHB transaction address
  HBURST : OUT std_logic_vector (2 downto 0);            -- AHB burst: tied to single
  HMASTLOCK : OUT std_logic;         -- AHB locked transfer (always zero)
  HPROT : OUT std_logic_vector (3 downto 0);              -- AHB protection: priv; data or inst
  HSIZE : OUT std_logic_vector (2 downto 0);             -- AHB size: byte, half-word or word
  HTRANS : OUT std_logic_vector (1 downto 0);            -- AHB transfer: non-sequential only
  HWDATA : OUT std_logic_vector (31 downto 0);             -- AHB write-data
  HWRITE : OUT std_logic;            -- AHB write control
  HRDATA : IN std_logic_vector (31 downto 0);            -- AHB read-data
  HREADY : IN std_logic;            -- AHB stall signal
  HRESP : IN std_logic;             -- AHB error response

  -- MISCELLANEOUS ---------------------
  --input  wire        NMI,               -- Non-maskable interrupt input
  --input  wire [15:0] IRQ,               -- Interrupt request inputs
  --output wire        TXEV,              -- Event output (SEV executed)
  --input  wire        RXEV,              -- Event input
  --output wire        LOCKUP,            -- Core is locked-up
  --output wire        SYSRESETREQ,       -- System reset request
  NMI : IN std_logic;               -- Non-maskable interrupt input
  IRQ : IN std_logic_vector (15 downto 0);               -- Interrupt request inputs
  TXEV : OUT std_logic;              -- Event output (SEV executed)
  RXEV : IN std_logic;              -- Event input
  LOCKUP : OUT std_logic;            -- Core is locked-up
  SYSRESETREQ : OUT std_logic;       -- System reset request

  -- POWER MANAGEMENT ------------------
  --output wire        SLEEPING           -- Core and NVIC sleeping
  SLEEPING : OUT std_logic          -- Core and NVIC sleeping
);
END COMPONENT;


signal dummy : STD_LOGIC_VECTOR (2 downto 0);
signal HRData : std_logic_vector (31 downto 0);
signal HWData : std_logic_vector (31 downto 0);
signal HADDR : std_logic_vector (31 downto 0);
signal HBurst : std_logic_vector (2 downto 0);
signal HProt : std_logic_vector (3 downto 0);
signal HSize : std_logic_vector (2 downto 0);
signal HTrans : std_logic_vector (1 downto 0);
signal HWrite : std_logic_vector (0 downto 0);
signal Clock : std_logic;
signal none : std_logic_vector (1 downto 0);
signal led_value:std_logic;
signal reset_rom: std_logic;
signal SyncResetPulse : std_logic;

begin
Led3 <= led_value;
Led4 <= SyncResetPulse;
Led5 <= '1';
Led6 <= '0';
Led7 <= '1';
reset_rom <= not SyncResetPulse;

Inst_Detector: DetectorBus 
    Port map ( Clock => Clock,
           DataBus => HRData,
           Detector => led_value);

Clock <= Clock_In;

Led0 <= '1';

--Inst_SystemClock: SystemClock PORT MAP(
--		CLKIN_IN => Clock_In,
--		CLKFX_OUT => Clock,
--		CLKIN_IBUFG_OUT => none(0),
--		CLK0_OUT => none(1),
--		LOCKED_OUT => Led0
--	);


SyncResetPulse <= reset;



Inst_Memory : cortexm0_memory
		port map (
			clka => Clock,
			ena => HTrans(1),
			wea => HWrite (0 downto 0),
			addra => HADDR(10 downto 2),
			dina => HWData(31 downto 0),
			douta => HRData(31 downto 0));
		
	
Processor : CORTEXM0DS	port map (
	-- CLOCK AND RESETS ------------------
  HCLK => Clock,              -- Clock
  HRESETn => SyncResetPulse,           -- Asynchronous reset

  -- AHB-LITE MASTER PORT --------------
  HADDR => HADDR(31 downto 0),             -- AHB transaction address
  HBURST => HBurst(2 downto 0),            -- AHB burst: tied to single
  HMASTLOCK => dummy(0),         -- AHB locked transfer (always zero)
  HPROT => HProt (3 downto 0),             -- AHB protection: priv; data or inst
  HSIZE => HSize(2 downto 0),             -- AHB size: byte, half-word or word
  HTRANS => HTrans (1 downto 0),            -- AHB transfer: non-sequential only
  HWDATA => HWData(31 downto 0),            -- AHB write-data
  HWRITE => HWrite(0),            -- AHB write control
  HRDATA => HRData(31 downto 0),            -- AHB read-data
  HREADY => '1',            -- AHB stall signal
  HRESP => '0',             -- AHB error response

  -- MISCELLANEOUS ---------------------
  NMI => '0',               -- Non-maskable interrupt input
  IRQ => "0000000000000000", --Interrupciones(15 downto 0),               -- Interrupt request inputs
  TXEV => dummy(1),              -- Event output (SEV executed)
  RXEV => '0',              -- Event input
  LOCKUP => Led2,            -- Core is locked-up
  SYSRESETREQ => dummy(2),       -- System reset request

  -- POWER MANAGEMENT ------------------
  SLEEPING => Led1           -- Core and NVIC sleeping
	);

end Behavioral; 
