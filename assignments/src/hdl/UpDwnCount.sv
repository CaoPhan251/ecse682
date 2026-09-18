module UpDwnCount #(
    parameter  int WIDTH = 20;
)(
    input logic     clk,
    input logic     rst_n,  // asynchronous, active-low
    input logic     load,   // synchronous parallel load
    input logic [WIDTH-1:0] data_in, // pre-load value
    input logic     en,
    input logic     up_dn,  // 1 = up, 0 down
    output logic [WIDTH-1:0] count,
    output logic    overflow, // up-wrap pulse (all-ones -> 0)
    output logic    underflow, // down-wrap pulse (0 -> all-ones)
);

endmodule
