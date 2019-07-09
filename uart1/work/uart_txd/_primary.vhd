library verilog;
use verilog.vl_types.all;
entity uart_txd is
    generic(
        bps_9600        : vl_logic_vector(15 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0);
        bps_14400       : vl_logic_vector(15 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        bps_19200       : vl_logic_vector(15 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0);
        bps_38400       : vl_logic_vector(15 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0);
        bps_56000       : vl_logic_vector(15 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi1);
        bps_115200      : vl_logic_vector(15 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0);
        bit_width       : vl_logic_vector(15 downto 0);
        bit0            : vl_logic_vector(15 downto 0);
        bit1            : vl_logic_vector(15 downto 0);
        bit2            : vl_logic_vector(15 downto 0);
        bit3            : vl_logic_vector(15 downto 0);
        bit4            : vl_logic_vector(15 downto 0);
        bit5            : vl_logic_vector(15 downto 0);
        bit6            : vl_logic_vector(15 downto 0);
        bit7            : vl_logic_vector(15 downto 0);
        bit_stop        : vl_logic_vector(15 downto 0);
        bit_stop_end    : vl_logic_vector(15 downto 0);
        IDLE            : vl_logic_vector(2 downto 0) := (Hi0, Hi0, Hi0);
        SEND            : vl_logic_vector(2 downto 0) := (Hi0, Hi0, Hi1)
    );
    port(
        clk50M          : in     vl_logic;
        rst_n           : in     vl_logic;
        txd_cmd         : in     vl_logic;
        txd_data        : in     vl_logic_vector(7 downto 0);
        txd_flag        : out    vl_logic;
        txd_pin         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of bps_9600 : constant is 2;
    attribute mti_svvh_generic_type of bps_14400 : constant is 2;
    attribute mti_svvh_generic_type of bps_19200 : constant is 2;
    attribute mti_svvh_generic_type of bps_38400 : constant is 2;
    attribute mti_svvh_generic_type of bps_56000 : constant is 2;
    attribute mti_svvh_generic_type of bps_115200 : constant is 2;
    attribute mti_svvh_generic_type of bit_width : constant is 4;
    attribute mti_svvh_generic_type of bit0 : constant is 4;
    attribute mti_svvh_generic_type of bit1 : constant is 4;
    attribute mti_svvh_generic_type of bit2 : constant is 4;
    attribute mti_svvh_generic_type of bit3 : constant is 4;
    attribute mti_svvh_generic_type of bit4 : constant is 4;
    attribute mti_svvh_generic_type of bit5 : constant is 4;
    attribute mti_svvh_generic_type of bit6 : constant is 4;
    attribute mti_svvh_generic_type of bit7 : constant is 4;
    attribute mti_svvh_generic_type of bit_stop : constant is 4;
    attribute mti_svvh_generic_type of bit_stop_end : constant is 4;
    attribute mti_svvh_generic_type of IDLE : constant is 2;
    attribute mti_svvh_generic_type of SEND : constant is 2;
end uart_txd;
