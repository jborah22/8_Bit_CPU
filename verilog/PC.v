module pc (
    input  wire        clk,
    input  wire        rst,
    input  wire        en,
    input  wire        oe,
    input  wire        ld,
    input  wire [3:0]  \input ,   
    output wire [3:0]  \output    
);

    reg [3:0] count = 4'b0000;   

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end else begin
            if (ld) begin
                count <= \input ;
            end else if (en) begin
                count <= count + 4'b0001; // 4-bit wraps naturally
            end
        end
    end

    assign \output = oe ? count : 4'bzzzz;

endmodule
