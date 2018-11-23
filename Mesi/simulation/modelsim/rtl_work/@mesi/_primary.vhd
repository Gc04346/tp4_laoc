library verilog;
use verilog.vl_types.all;
entity Mesi is
    port(
        Reset           : in     vl_logic;
        clock           : in     vl_logic;
        CPU             : in     vl_logic_vector(3 downto 0);
        Bus_in          : in     vl_logic_vector(1 downto 0);
        est_at          : in     vl_logic_vector(1 downto 0);
        Bus_out         : out    vl_logic_vector(1 downto 0);
        Mem_out         : out    vl_logic_vector(1 downto 0);
        est_fut         : out    vl_logic_vector(1 downto 0)
    );
end Mesi;
