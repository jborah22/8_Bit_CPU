module mar (
    input  wire       clk,
    input  wire       rst,
    input  wire       load,
    input  wire [3:0] \input ,
    output wire [3:0] \output
);
  reg [3:0] stored_value = 4'bzzzz;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      stored_value <= 4'bzzzz;
    end else if (load) begin
      stored_value <= \input ;
    end
  end

  assign \output = stored_value;
endmodule
