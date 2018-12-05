library verilog;
use verilog.vl_types.all;
entity CPU is
    port(
        clock           : in     vl_logic;
        clear           : in     vl_logic;
        modo            : in     vl_logic;
        \shared\        : in     vl_logic;
        instr           : in     vl_logic_vector(7 downto 0);
        bus_in          : in     vl_logic_vector(4 downto 0);
        bus_out         : out    vl_logic_vector(4 downto 0);
        mem_out         : out    vl_logic_vector(1 downto 0)
    );
end CPU;
