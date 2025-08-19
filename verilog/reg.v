module \reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        out_en,
    input  wire        load,
    input  wire [7:0]  \input ,
    output wire [7:0]  \output ,
    output wire [7:0]  \output_alu
);

    reg [7:0] stored_value = 8'bzzzzzzzz;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stored_value <= 8'bzzzzzzzz;
        end else begin
            if (load) begin
                stored_value <= \input ;
            end
        end
    end

    assign \output     = out_en ? stored_value : 8'bzzzzzzzz;
    assign \output_alu = stored_value;

endmodule
