module cu_test;

  reg         clk_sig;
  reg  [3:0]  inst_sig;
  reg         rst_sig;
  wire [16:0] control_op;

  wire pc_out;
  wire mar_in;

  localparam integer clk_period = 10;

  initial begin
    clk_sig = 1'b0;
    forever #(clk_period/2) clk_sig = ~clk_sig;
  end

  control_unit cu_inst (
    .clk (clk_sig),
    .rst (rst_sig),
    .inst(inst_sig),
    .do  (control_op)
  );

  assign pc_out = control_op[9];
  assign mar_in = control_op[8];

  initial begin
    inst_sig = 4'b0000;  
    rst_sig  = 1'b1;
    #(clk_period*5);
    rst_sig  = 1'b0;
    forever #(clk_period);
  end

endmodule
