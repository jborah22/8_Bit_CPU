module mar_mem_tb;

  localparam integer clk_period = 10;

  reg         clk_sig;
  reg         rst_sig;
  reg         load_mar;
  reg  [3:0]  mar_input;
  wire [3:0]  mar_out;

  reg         mem_en_sig;      
  reg         mem_ld_sig;      
  reg  [7:0]  mem_input_sig;   
  wire [7:0]  mem_output_sig;

  mar mar1 (
    .clk     (clk_sig),
    .rst     (rst_sig),
    .load    (load_mar),
    .\input  (mar_input),     
    .\output (mar_out)
  );

  mem mem1 (
    .clk      (clk_sig),
    .load     (mem_ld_sig),
    .oe       (mem_en_sig),
    .data_in  (mem_input_sig),
    .addr_in  (mar_out),
    .data_out (mem_output_sig)
  );

  initial begin
    clk_sig = 1'b0;
    forever #(clk_period/2) clk_sig = ~clk_sig;
  end

  task load_addr(input [3:0] a);
  begin
    mar_input = a;
    load_mar  = 1'b1;  @(posedge clk_sig);
    load_mar  = 1'b0;
  end
  endtask

  task read_on_next_clock;
  begin
    mem_en_sig = 1'b1; @(posedge clk_sig);
    mem_en_sig = 1'b0;
  end
  endtask

  initial begin
    rst_sig       = 1'b0;
    load_mar      = 1'b0;
    mar_input     = 4'b0000;

    mem_en_sig    = 1'b0;
    mem_ld_sig    = 1'b0;
    mem_input_sig = 8'h00;

    @(posedge clk_sig);

    load_addr(4'b0000);
    read_on_next_clock;

    load_addr(4'b0001);
    read_on_next_clock;

    load_addr(4'b0010);
    read_on_next_clock;

    forever @(posedge clk_sig);
  end

  initial begin
    $display(" time   mar_out  mem_output_sig");
    forever begin
      @(posedge clk_sig);
      if (mem_en_sig)
        $display("%6t   %b      %b", $time, mar_out, mem_output_sig);
    end
  end

endmodule
