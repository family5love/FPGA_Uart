library verilog;
use verilog.vl_types.all;
entity timer_1s is
    port(
        s_rst_n         : in     vl_logic;
        sclk            : in     vl_logic;
        io_pin          : out    vl_logic
    );
end timer_1s;
