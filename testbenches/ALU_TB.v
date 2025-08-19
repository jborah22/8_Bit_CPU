module alu_tb;

  reg        clk_sig;
  reg        en_sig;
  reg        op_sig;
  reg  [7:0] reg_a_sig;
  reg  [7:0] reg_b_sig;
  wire [7:0] res_out_sig;
  wire       carry_sig;

  localparam integer clk_period = 10;

  alu alu1 (
    .en        (en_sig),
    .op        (op_sig),
    .reg_a_in  (reg_a_sig),
    .reg_b_in  (reg_b_sig),
    .carry_out (carry_sig),
    .res_out   (res_out_sig)
  );

  initial begin
    clk_sig = 1'b0;
    forever #(clk_period/2) clk_sig = ~clk_sig;
  end

  initial begin
    reg_a_sig = 8'b11111111;
    reg_b_sig = 8'b00000001;

    en_sig    = 1'b0;
    op_sig    = 1'b1;
    #(clk_period*5);
    en_sig    = 1'b1;
    #(clk_period*5);
    op_sig    = 1'b0;

    forever #(clk_period);
  end

endmodule
