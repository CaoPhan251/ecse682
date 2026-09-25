module UpDwnCount #(
    parameter  int WIDTH = 20
)(
    input logic     clk,
    input logic     rst_n,  // asynchronous, active-low
    input logic     load,   // synchronous parallel load
    input logic [WIDTH-1:0] data_in, // pre-load value
    input logic     en,
    input logic     up_dn,  // 1 = up, 0 down
    output logic [WIDTH-1:0] count,
    output logic    overflow, // up-wrap pulse (all-ones -> 0)
    output logic    underflow // down-wrap pulse (0 -> all-ones)
);
    logic ovr_flag, ovr_flag_d;
    logic udr_flag, udr_flag_d;

    always_comb begin : overflow_flag
        if (en & ~load & up_dn & (&count)) begin
            ovr_flag = 1'b1;
        end else begin
            ovr_flag = 1'b0;
        end
    end

    always_comb begin: underflow_flag
        if (en & ~load & ~up_dn & (~|count)) begin
            udr_flag = 1'b1;
        end else begin 
            udr_flag = 1'b0;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 'h0;
            ovr_flag_d <= 1'b0;
            udr_flag_d <= 1'b0;
        end
        else begin
            ovr_flag_d <= ovr_flag;
            udr_flag_d <= udr_flag;
            if (load == 1) begin
                count <= data_in;
            end
            else if (en & ~load & up_dn & (&count)) begin
                count <= 'h00000; 
            end
            else if  (en & ~load & ~up_dn & (~|count)) begin
                count <= 'hFFFFF;
            end
            else if (en && up_dn) begin
                count = count + 1;
            end
            else if (en == 1 && up_dn == 0) begin
                count = count - 1;
            end
        end
        

    end
    assign overflow = !ovr_flag && ovr_flag_d;
    assign underflow = !udr_flag && udr_flag_d;

endmodule
