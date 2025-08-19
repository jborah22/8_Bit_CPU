module CU_2_TB;

  reg clk = 1'b0;
  reg rst = 1'b1;       

  always #5 clk = ~clk;

  initial begin
    rst = 1'b1;
    #30;
    rst = 1'b0;
  end

  reg  [3:0] inst = 4'b0000;

  wire       mar_load_a;
  wire [3:0] mar_in_a;
  wire       mar_load_b;
  wire [3:0] mar_in_b;

  wire       mem_oe_a;
  wire       mem_ld_a;
  wire       mem_oe_b;
  wire       mem_ld_b;
  wire       stall;

  wire [3:0] mar_out_a;
  wire [3:0] mar_out_b;

  reg  [7:0] mem_din_a  = 8'h00;
  reg  [7:0] mem_din_b  = 8'h00;
  wire [7:0] mem_dout_a;
  wire [7:0] mem_dout_b;

  // Metrics
  integer cycles  = 0;      
  integer pairs   = 0;      
  integer dual_ok = 0;      
  reg     done    = 1'b0;

  localparam integer N_PAIRS = 32;


  Control_unit_CU_2 U_CU (
    .clk        (clk),
    .rst        (rst),
    .inst       (inst),

    .mar_load_a (mar_load_a),
    .mar_in_a   (mar_in_a),
    .mar_load_b (mar_load_b),
    .mar_in_b   (mar_in_b),

    .mem_oe_a   (mem_oe_a),
    .mem_ld_a   (mem_ld_a),
    .mem_oe_b   (mem_oe_b),
    .mem_ld_b   (mem_ld_b),

    .stall      (stall)
  );

  MAR_2 U_MAR_A (
    .clk     (clk),
    .rst     (rst),
    .load    (mar_load_a),
    .\input  (mar_in_a),
    .\output (mar_out_a)
  );

  MAR_2 U_MAR_B (
    .clk     (clk),
    .rst     (rst),
    .load    (mar_load_b),
    .\input  (mar_in_b),
    .\output (mar_out_b)
  );

  MEM_2 U_MEM (
    .clk        (clk),

    .load_A     (mem_ld_a),
    .oe_A       (mem_oe_a),
    .data_in_A  (mem_din_a),
    .addr_in_A  (mar_out_a),
    .data_out_A (mem_dout_a),

    .load_B     (mem_ld_b),
    .oe_B       (mem_oe_b),
    .data_in_B  (mem_din_b),
    .addr_in_B  (mar_out_b),
    .data_out_B (mem_dout_b)
  );

  always @(posedge clk) begin
    if (!rst && !done) begin
      cycles <= cycles + 1;
      if (mem_oe_a && mem_oe_b) begin
        dual_ok <= dual_ok + 1;
      end
    end
  end


  initial begin : stim
    integer H_pct;
    integer cpp_x100;
    integer cpi_proxy_x100;
    reg [3:0] v_inst;

    @(negedge rst);
    @(posedge clk);

    v_inst = 4'b0000;
    while (pairs < N_PAIRS) begin
      if (!stall) begin
        inst  <= v_inst;
        pairs <= pairs + 1;
        v_inst = v_inst + 4'd1;   
      end
      @(posedge clk);
    end

    repeat (4) @(posedge clk);

    done <= 1'b1;

    if (pairs > 0) begin
      H_pct          = (100 * dual_ok) / pairs;
      cpp_x100       = (100 * cycles) / pairs;
      cpi_proxy_x100 = 100 + cpp_x100; // 1 cycles
    end else begin
      H_pct = 0; cpp_x100 = 0; cpi_proxy_x100 = 0;
    end

    $display("==== Dual-Bank CU Metrics ====");
    $display("pairs                 = %0d", pairs);
    $display("cycles                = %0d", cycles);
    $display("dual_ok (parallel)    = %0d", dual_ok);
    $display("H (parallel, %%)       = %0d%%", H_pct);
    $display("cycles_per_pair x100  = %0d", cpp_x100);
    $display("CPI_proxy (1+cpp) x100= %0d", cpi_proxy_x100);
    $display("================================");

    $finish; 
  end

endmodule
