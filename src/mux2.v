module mux2 #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] mux_d0,
    input  wire [WIDTH-1:0] mux_d1,
    input  wire             mux_sel,
    output wire [WIDTH-1:0] mux_y
);

    assign mux_y = mux_sel ? mux_d1 : mux_d0;

endmodule
