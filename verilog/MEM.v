module mem (
    input  wire        clk,
    input  wire        load,
    input  wire        oe,
    input  wire [7:0]  data_in,
    input  wire [3:0]  addr_in,
    output wire [7:0]  data_out
);
  reg [7:0] mem_obj [0:15];              
  reg [7:0] data_out_reg = 8'bzzzzzzzz;  

  initial begin
    $readmemb("init_mem.txt", mem_obj);
  end

  always @(posedge clk) begin
    if (load) begin
      mem_obj[addr_in] <= data_in;
    end
    if (oe) begin
      data_out_reg <= mem_obj[addr_in];   
    end else begin
      data_out_reg <= 8'bzzzzzzzz;
    end
  end

  assign data_out = data_out_reg;
endmodule
