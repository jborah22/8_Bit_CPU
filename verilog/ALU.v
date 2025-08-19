module alu (
    input  wire        en,
    input  wire        op,
    input  wire [7:0]  reg_a_in,
    input  wire [7:0]  reg_b_in,
    output wire        carry_out,
    output wire        zero_flag,
    output wire [7:0]  res_out
);

    reg [8:0] result;

    always @* begin
        if (op == 1'b1) begin
            result = {1'b0, reg_a_in} + {1'b0, reg_b_in};
        end else if (op == 1'b0) begin
            result = {1'b0, reg_a_in} - {1'b0, reg_b_in};
        end
    end

    assign carry_out = result[8];
    assign zero_flag = (result[7:0] == 8'b00000000) ? 1'b1 : 1'b0;
    assign res_out   = (en == 1'b1) ? result[7:0] : 8'bzzzzzzzz;

endmodule
