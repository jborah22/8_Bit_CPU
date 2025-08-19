module Control_unit_CU_2 (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] inst,

    // MAR A
    output wire       mar_load_a,
    output wire [3:0] mar_in_a,

    // MAR B
    output wire       mar_load_b,
    output wire [3:0] mar_in_b,

    output wire       mem_oe_a,
    output wire       mem_ld_a,   
    output wire       mem_oe_b,
    output wire       mem_ld_b,   

    output wire       stall
);

  // Registered outputs
  reg       r_mar_load_a = 1'b0;
  reg [3:0] r_mar_in_a   = 4'b0000;
  reg       r_mar_load_b = 1'b0;
  reg [3:0] r_mar_in_b   = 4'b0000;
  reg       r_mem_oe_a   = 1'b0;
  reg       r_mem_oe_b   = 1'b0;
  reg       r_stall      = 1'b0;

  reg [3:0] base_a = 4'b0000;
  reg [3:0] base_b = 4'b0000;

  reg serial = 1'b0;  
  reg phase  = 1'b0;  

  assign mem_ld_a = 1'b0;
  assign mem_ld_b = 1'b0;

  // Drive outs
  assign mar_load_a = r_mar_load_a;
  assign mar_in_a   = r_mar_in_a;
  assign mar_load_b = r_mar_load_b;
  assign mar_in_b   = r_mar_in_b;
  assign mem_oe_a   = r_mem_oe_a;
  assign mem_oe_b   = r_mem_oe_b;
  assign stall      = r_stall;

  wire [3:0] next_a = inst;             // operand A
  wire [3:0] next_b = inst + 4'd1;      // operand B 
  wire       bank_a_lsb = next_a[0];
  wire       bank_b_lsb = next_b[0];

  always @(posedge clk) begin
    r_mar_load_a <= 1'b0;
    r_mar_load_b <= 1'b0;
    r_mem_oe_a   <= 1'b0;
    r_mem_oe_b   <= 1'b0;
    r_stall      <= 1'b0;

    if (rst) begin
      serial      <= 1'b0;
      phase       <= 1'b0;
      base_a      <= 4'b0000;
      base_b      <= 4'b0000;
      r_mar_in_a  <= 4'b0000;
      r_mar_in_b  <= 4'b0000;

    end else begin
      if (!serial) begin
        base_a <= next_a;
        base_b <= next_b;

        if (bank_a_lsb != bank_b_lsb) begin
          if (bank_a_lsb == 1'b0) begin
            r_mar_in_a  <= next_a; r_mar_load_a <= 1'b1; r_mem_oe_a <= 1'b1;
            r_mar_in_b  <= next_b; r_mar_load_b <= 1'b1; r_mem_oe_b <= 1'b1;
          end else begin
            r_mar_in_a  <= next_b; r_mar_load_a <= 1'b1; r_mem_oe_a <= 1'b1;
            r_mar_in_b  <= next_a; r_mar_load_b <= 1'b1; r_mem_oe_b <= 1'b1;
          end

        end else begin
          serial  <= 1'b1;
          phase   <= 1'b0;
          r_stall <= 1'b1;
          if (bank_a_lsb == 1'b0) begin
            r_mar_in_a  <= next_a; r_mar_load_a <= 1'b1; r_mem_oe_a <= 1'b1;
          end else begin
            r_mar_in_b  <= next_a; r_mar_load_b <= 1'b1; r_mem_oe_b <= 1'b1;
          end
        end

      end else begin
        r_stall <= 1'b1;
        if (phase == 1'b0) begin
          if (base_a[0] == 1'b0) begin
            r_mar_in_a  <= base_b; r_mar_load_a <= 1'b1; r_mem_oe_a <= 1'b1;
          end else begin
            r_mar_in_b  <= base_b; r_mar_load_b <= 1'b1; r_mem_oe_b <= 1'b1;
          end
          phase <= 1'b1;
        end else begin
          serial <= 1'b0;
          phase  <= 1'b0;
          r_stall <= 1'b0;
        end
      end
    end
  end

endmodule
