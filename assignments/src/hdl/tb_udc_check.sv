// UpDwnCount testbench
module tb_udc;
    parameter WIDTH = 20;
    parameter CLK_PERIOD = 10;

    logic clk;
    logic rst;
    logic load;
    logic en;
    logic up_dn;
    logic overflow;
    logic underflow;
    logic [WIDTH-1:0] data_in;
    logic [WIDTH-1:0] count;

UpDwnCount dut (
    .clk (clk),
    .rst_n (rst),
    .load (load),
    .data_in (data_in),
    .en (en),
    .up_dn(up_dn),
    .count (count),
    .overflow (overflow),
    .underflow (underflow)
);

always #(CLK_PERIOD/2) clk = ~clk;

initial begin
    $dumpfile("udc.vcd");
    $dumpvars(0, tb_udc);
    clk = 0;
    rst = 0;
    load = 0;

    // up counter - 5 times
    #10 rst = 1;
    #10 en = 1;
    up_dn = 1;
    #50;
    // down counter - 6 times
    // last one checks for underflow
    up_dn = 0;
    #70;
    // asynchronous reset
    rst = 0;
    #10;
    // load data
    data_in = 'hFFFFA;
    load = 1;
    rst = 1;
    up_dn = 1;
    // test both load && up_dn asserted at the same time
    // output should not change
    #10;
    // up counter, test for overflow
    load = 0;
    #100;
    $finish;

end

endmodule