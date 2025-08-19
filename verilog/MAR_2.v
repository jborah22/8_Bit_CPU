module MAR_2 (
    input  wire       clk,
    input  wire       rst,
    input  wire       load,
    input  wire [3:0] \input ,
    output wire [3:0] \output
);

  reg [3:0] reg_q = 4'b0000;

  assign \output = reg_q;

  always @(posedge clk) begin
    if (rst) begin
      reg_q <= 4'b0000;
    end else if (load) begin
      reg_q <= \input ;
    end
  end

endmodule
