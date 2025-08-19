module MEM_2 #(
    parameter integer ADDR_WIDTH = 4,  
    parameter integer DATA_WIDTH = 8
)(
    input  wire                          clk,

    // Port A
    input  wire                          load_A,
    input  wire                          oe_A,
    input  wire [DATA_WIDTH-1:0]         data_in_A,
    input  wire [ADDR_WIDTH-1:0]         addr_in_A,
    output reg  [DATA_WIDTH-1:0]         data_out_A,

    // Port B
    input  wire                          load_B,
    input  wire                          oe_B,
    input  wire [DATA_WIDTH-1:0]         data_in_B,
    input  wire [ADDR_WIDTH-1:0]         addr_in_B,
    output reg  [DATA_WIDTH-1:0]         data_out_B
);

  reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1];

  integer i;
  initial begin
    for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
      ram[i] = {DATA_WIDTH{1'b0}};
    end
    data_out_A = {DATA_WIDTH{1'bz}};
    data_out_B = {DATA_WIDTH{1'bz}};
  end

  always @(posedge clk) begin
    if (load_A) ram[addr_in_A] <= data_in_A;
    if (load_B) ram[addr_in_B] <= data_in_B; 

    if (oe_A)  data_out_A <= ram[addr_in_A];
    else       data_out_A <= {DATA_WIDTH{1'bz}};

    if (oe_B)  data_out_B <= ram[addr_in_B];
    else       data_out_B <= {DATA_WIDTH{1'bz}};
  end

endmodule
