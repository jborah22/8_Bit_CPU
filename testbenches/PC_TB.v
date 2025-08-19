module pc_tb;

  reg        clk_sig;
  reg        rst_sig;
  reg        en_sig;
  reg        oe_sig;
  reg        ld_sig;
  reg  [3:0] input_sig;
  wire [3:0] output_sig;

  localparam integer clk_period = 10;

  pc pc1 (
    .clk     (clk_sig),
    .rst     (rst_sig),
    .en      (en_sig),
    .oe      (oe_sig),
    .ld      (ld_sig),
    .\input  (input_sig),
    .\output (output_sig)
  );

  initial begin
    clk_sig = 1'b0;
    forever #(clk_period/2) clk_sig = ~clk_sig;
  end

  initial begin
    rst_sig   = 1'b0;
    en_sig    = 1'b0;
    ld_sig    = 1'b0;

    #(clk_period*5);
    en_sig = 1'b1;

    #(clk_period*5);
    en_sig = 1'b0;
    oe_sig = 1'b1;

    #(clk_period);
    oe_sig = 1'b0;
    rst_sig = 1'b1;

    #(clk_period);
    en_sig = 1'b1;
    rst_sig = 1'b0;

    #(clk_period);
    oe_sig = 1'b1;

    forever #(clk_period);
  end

endmodule
