module xor_n2t_tb();
    reg  a;
    reg  b;
    reg  expected;

    wire out;

    xor_n2t xor_n2t(out, a, b);

    function void assert_else_error;
        assert (a ^ b == out) else $error("xor time: %d, a: %b,  b: %b, out: %b,  expected: %b", $time, a, b, c, expected);
    endfunction
    
    initial begin
        a = 0;
        b = 0;
        expected = 0;
        #1 assert_else_error();

        #1 a = 0;
        b = 1;
        expected = 1;
        #1 assert_else_error();

        #1 a = 1;
        b = 0;
        expected = 1;
        #1 assert_else_error();

        #1 a = 1;
        b = 1;
        expected = 0;
        #1 assert_else_error();
    end

endmodule
