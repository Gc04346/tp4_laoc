library verilog;
use verilog.vl_types.all;
entity Snooping is
    port(
        clock           : in     vl_logic;
        clear           : in     vl_logic
    );
end Snooping;
