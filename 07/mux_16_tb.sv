module mux_16_tb();
    reg [15:0]  a;
    reg [15:0]  b;
    reg         select;

    wire [15:0] out;

    mux_16 u1(a, b, select, out);

    function void assert_else_error(reg[15:0] expected);
        assert (out == expected) else begin
            $error("mux_16 a: %b b: %b select: %b out: %b  expected: %b", a, b, select, out, expected);
        end
    endfunction

    initial
        begin
            a = 16'b0101010101010101;
            b = 16'b1010101010101010;
            select = 0;
            #1 assert_else_error(16'b0101010101010101);
            #1 select = 1;
            #1 assert_else_error(16'b1010101010101010);
        end
endmodule
