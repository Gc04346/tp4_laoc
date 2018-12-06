library verilog;
use verilog.vl_types.all;
entity CPU is
    port(
        clock           : in     vl_logic;
        clear           : in     vl_logic;
        habilita        : in     vl_logic;
        controleP       : in     vl_logic;
        shared_in       : in     vl_logic;
        instr           : in     vl_logic_vector(7 downto 0);
        bus_in          : in     vl_logic_vector(9 downto 0);
        shared_out      : out    vl_logic;
        bus_out         : out    vl_logic_vector(9 downto 0);
        \out\           : out    vl_logic_vector(2 downto 0)
    );
end CPU;
