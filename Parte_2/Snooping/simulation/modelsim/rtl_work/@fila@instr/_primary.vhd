library verilog;
use verilog.vl_types.all;
entity FilaInstr is
    port(
        reset           : in     vl_logic;
        clock           : in     vl_logic;
        modo_cpu1       : out    vl_logic;
        modo_cpu2       : out    vl_logic;
        modo_cpu3       : out    vl_logic;
        instr           : out    vl_logic_vector(7 downto 0)
    );
end FilaInstr;
