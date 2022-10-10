library ieee;
use ieee.std_logic_1164.all;

entity tb_cortexm0 is
end tb_cortexm0;  

architecture tb of tb_cortexm0 is


component CM0_DSSystem is
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
end component;


signal reset,clk,led0,led1,led2,led3,led4,led5,led6,led7: std_logic;
constant clock_period: time := 100 ns;
constant half_period : time := clock_period / 2;

begin


DUT : CM0_DSSystem 
    port map( Led0 =>led0, -- dcm
           Led1 =>led1, -- sleep
           Led2 =>led2, -- lock
           Led3 =>led3, -- detector
           Led4 =>led4, -- reset
           Led5 =>led5,
           Led6 =>led6,
           Led7 =>led7,
           reset => reset,
           Clock_In => clk
           );



clock_process : process

begin

  clk <= '1';

  wait for half_period;

  clk <= '0';

  wait for half_period;

end process clock_process;



reset_process : process

begin

  reset <= '0';

  wait for clock_period;

  reset <= '1';

  wait for 4000000 us;

end process reset_process;


end tb;
  