module mem_tb_2;

  localparam integer clk_period = 20;

  reg clk_sig  = 1'b0;
  reg rst_sig  = 1'b0;

  reg        load_mar_a  = 1'b0;
  reg        load_mar_b  = 1'b0;
  reg  [3:0] mar_input_a = 4'b0000;
  reg  [3:0] mar_input_b = 4'b0000;
  wire [3:0] mar_out_a;
  wire [3:0] mar_out_b;

  wire mar_bank_a = mar_out_a[3];
  wire mar_bank_b = mar_out_b[3];


  reg        mem_ld_sig   = 1'b0;         
  reg        mem_oe_a     = 1'b0;
  reg        mem_oe_b     = 1'b0;
  reg  [7:0] mem_data_in  = 8'h00;
  wire [7:0] mem_dout_a;
  wire [7:0] mem_dout_b;


  always #(clk_period/2) clk_sig = ~clk_sig;

  MAR_2 mar_a (
    .clk     (clk_sig),
    .rst     (rst_sig),
    .load    (load_mar_a),
    .\input  (mar_input_a),
    .\output (mar_out_a)
  );

  MAR_2 mar_b (
    .clk     (clk_sig),
    .rst     (rst_sig),
    .load    (load_mar_b),
    .\input  (mar_input_b),
    .\output (mar_out_b)
  );


  MEM_2 #(
    .ADDR_WIDTH(4),
    .DATA_WIDTH(8)
  ) mem1 (
    .clk        (clk_sig),

    // Port A
    .load_A     (mem_ld_sig),
    .oe_A       (mem_oe_a),
    .data_in_A  (mem_data_in),
    .addr_in_A  (mar_out_a),
    .data_out_A (mem_dout_a),

    // Port B
    .load_B     (1'b0),
    .oe_B       (mem_oe_b),
    .data_in_B  ({8{1'b0}}),
    .addr_in_B  (mar_out_b),
    .data_out_B (mem_dout_b)
  );

  initial begin
    rst_sig     = 1'b1;
    load_mar_a  = 1'b0;
    load_mar_b  = 1'b0;
    mem_ld_sig  = 1'b0;
    mem_oe_a    = 1'b0;
    mem_oe_b    = 1'b0;
    #(clk_period*3);
    rst_sig = 1'b0;
    #(clk_period);

    mar_input_a = 4'b0010;     // addr 2
    load_mar_a  = 1'b1;  #(clk_period);  load_mar_a  = 1'b0;
    mem_data_in = 8'hAA;
    mem_ld_sig  = 1'b1;  #(clk_period);  mem_ld_sig  = 1'b0;
    #(clk_period);


    mar_input_a = 4'b0011;     
    load_mar_a  = 1'b1;  #(clk_period);  load_mar_a  = 1'b0;
    mem_data_in = 8'h55;
    mem_ld_sig  = 1'b1;  #(clk_period);  mem_ld_sig  = 1'b0;
    #(clk_period);


    mar_input_a = 4'b0010;
    mar_input_b = 4'b0011;
    load_mar_a  = 1'b1;
    load_mar_b  = 1'b1;
    #(clk_period);
    load_mar_a  = 1'b0;
    load_mar_b  = 1'b0;

    mem_oe_a = 1'b1;
    mem_oe_b = 1'b1;
    #(clk_period/2);

    if (mem_dout_a !== 8'hAA) begin
      $error("Port A read mismatch (addr 2): got %02h, expected AA", mem_dout_a);
    end
    if (mem_dout_b !== 8'h55) begin
      $error("Port B read mismatch (addr 3): got %02h, expected 55", mem_dout_b);
    end

    $display("Parallel fetch OK: A=%02h (addr 2, bank=%0d),  B=%02h (addr 3, bank=%0d)",
             mem_dout_a, mar_bank_a, mem_dout_b, mar_bank_b);

    $finish;
  end

endmodule
