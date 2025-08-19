module control_unit (
    input  wire        clk,
    input  wire        rst,
    input  wire [3:0]  inst,
    output reg  [16:0] do
);

  reg [3:0] counter = 4'b0000;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= 4'b0000;
    end else if (counter == 4'b0110) begin
      counter <= 4'b0000;
    end else begin
      counter <= counter + 4'b0001; 
    end
  end

  always @* begin
    do = do;

    // Fetch 
    if      (counter == 4'b0000) do = 17'b00000001100000000;
    else if (counter == 4'b0001) do = 17'b00000100001000010;

    // LDA 
    else if (counter == 4'b0010 && inst == 4'b0000) do = 17'b00000000000000001;
    else if (counter == 4'b0011 && inst == 4'b0000) do = 17'b00000000100000001;
    else if (counter == 4'b0100 && inst == 4'b0000) do = 17'b00000000001100000;
    else if (counter == 4'b0101 && inst == 4'b0000) do = 17'b00000000000000000;
    else if (counter == 4'b0110 && inst == 4'b0000) do = 17'b00000000000000000;

    // (inst = 0001)
    else if (counter == 4'b0010 && inst == 4'b0001) do = 17'b00000000000000001;
    else if (counter == 4'b0011 && inst == 4'b0001) do = 17'b00000000100000001;
    else if (counter == 4'b0100 && inst == 4'b0001) do = 17'b00000000010010000;
    else if (counter == 4'b0101 && inst == 4'b0001) do = 17'b00000000000000000;
    else if (counter == 4'b0110 && inst == 4'b0001) do = 17'b00000000000000000;

    // ADD (inst = 0010)
    else if (counter == 4'b0010 && inst == 4'b0010) do = 17'b00000000000000001;
    else if (counter == 4'b0011 && inst == 4'b0010) do = 17'b00000000100000001;
    else if (counter == 4'b0100 && inst == 4'b0010) do = 17'b00000000001001000;
    else if (counter == 4'b0101 && inst == 4'b0010) do = 17'b00001000000000000;
    else if (counter == 4'b0110 && inst == 4'b0010) do = 17'b00001000000100000;

    // SUB (inst = 0011)
    else if (counter == 4'b0010 && inst == 4'b0011) do = 17'b00000000000000001;
    else if (counter == 4'b0011 && inst == 4'b0011) do = 17'b00000000100000001;
    else if (counter == 4'b0100 && inst == 4'b0011) do = 17'b00000000001001000;
    else if (counter == 4'b0101 && inst == 4'b0011) do = 17'b00010000000000000;
    else if (counter == 4'b0110 && inst == 4'b0011) do = 17'b00011000000100000;

    // JMP (inst = 0100)
    else if (counter == 4'b0010 && inst == 4'b0100) do = 17'b00000000000000001;
    else if (counter == 4'b0011 && inst == 4'b0100) do = 17'b00000010000000001;
    else if (counter == 4'b0100 && inst == 4'b0100) do = 17'b00000000000000000;
    else if (counter == 4'b0101 && inst == 4'b0100) do = 17'b00000000000000000;
    else if (counter == 4'b0110 && inst == 4'b0100) do = 17'b00000000000000000;

    // OUT (inst = 0101)
    else if (counter == 4'b0010 && inst == 4'b0101) do = 17'b00000000000000001;
    else if (counter == 4'b0011 && inst == 4'b0101) do = 17'b00000000100000001;
    else if (counter == 4'b0100 && inst == 4'b0101) do = 17'b00000000001000000;
    else if (counter == 4'b0101 && inst == 4'b0101) do = 17'b01000000001000000;
    else if (counter == 4'b0110 && inst == 4'b0101) do = 17'b00100000000000000;

    // HLT (inst = 0110)
    else if (counter == 4'b0010 && inst == 4'b0110) do = 17'b10000000000000000;
    else if (counter == 4'b0011 && inst == 4'b0110) do = 17'b10000010000000000;
    else if (counter == 4'b0100 && inst == 4'b0110) do = 17'b00000000000000000;
    else if (counter == 4'b0101 && inst == 4'b0110) do = 17'b00000000000000000;
    else if (counter == 4'b0110 && inst == 4'b0110) do = 17'b00000000000000000;
  end

endmodule
