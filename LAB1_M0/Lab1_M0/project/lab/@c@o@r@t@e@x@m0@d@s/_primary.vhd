library verilog;
use verilog.vl_types.all;
entity CORTEXM0DS is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HADDR           : out    vl_logic_vector(31 downto 0);
        HBURST          : out    vl_logic_vector(2 downto 0);
        HMASTLOCK       : out    vl_logic;
        HPROT           : out    vl_logic_vector(3 downto 0);
        HSIZE           : out    vl_logic_vector(2 downto 0);
        HTRANS          : out    vl_logic_vector(1 downto 0);
        HWDATA          : out    vl_logic_vector(31 downto 0);
        HWRITE          : out    vl_logic;
        HRDATA          : in     vl_logic_vector(31 downto 0);
        HREADY          : in     vl_logic;
        HRESP           : in     vl_logic;
        NMI             : in     vl_logic;
        IRQ             : in     vl_logic_vector(15 downto 0);
        TXEV            : out    vl_logic;
        RXEV            : in     vl_logic;
        LOCKUP          : out    vl_logic;
        SYSRESETREQ     : out    vl_logic;
        SLEEPING        : out    vl_logic
    );
end CORTEXM0DS;
