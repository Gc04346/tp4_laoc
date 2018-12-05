library verilog;
use verilog.vl_types.all;
entity Bus_arbiter is
    port(
        clock           : in     vl_logic;
        clear           : in     vl_logic;
        bus_in          : in     vl_logic_vector(9 downto 0);
        hab_bus         : in     vl_logic;
        \bus\           : out    vl_logic_vector(9 downto 0)
    );
end Bus_arbiter;
