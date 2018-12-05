library verilog;
use verilog.vl_types.all;
entity mem_instr is
    port(
        clock           : in     vl_logic;
        clear           : in     vl_logic;
        pc              : in     vl_logic_vector(4 downto 0);
        instr_out       : out    vl_logic_vector(9 downto 0);
        hab_escr        : in     vl_logic;
        dado            : in     vl_logic_vector(9 downto 0)
    );
end mem_instr;
