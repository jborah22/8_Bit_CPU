module reg_tb;

  reg        clk_sig;
  reg        rst_sig;
  reg        out_en_sig;
  reg        ld_sig;
  reg  [7:0] input_sig;
  wire [7:0] output_sig;
  wire [7:0] output_alu_sig;

  localparam integer clk_period = 10;

  \reg  reg1 (
    .clk         (clk_sig),
    .rst         (rst_sig),
    .out_en      (out_en_sig),
    .load        (ld_sig),
    .\input      (input_sig),
    .\output     (output_sig),
    .\output_alu (output_alu_sig)
  );

  initial begin
    clk_sig = 1'b0;
    forever #(clk_period/2) clk_sig = ~clk_sig;
  end

  initial begin
    rst_sig     = 1'b0;
    out_en_sig  = 1'b0;
    ld_sig      = 1'b0;

    #(clk_period*5);
    input_sig   = 8'b00100010;
    ld_sig      = 1'b1;

    #(clk_period);
    ld_sig      = 1'b0;

    #(clk_period);
    out_en_sig  = 1'b1;

    #(clk_period);
    out_en_sig  = 1'b0;

    forever #(clk_period);
  end

endmodule
