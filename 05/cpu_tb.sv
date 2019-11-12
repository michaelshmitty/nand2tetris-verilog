`include "cpu.sv"

module cpu_tb();
    reg  [15:0] inM;
    reg  [15:0] instruction;
    reg         reset;
    reg         clock;
    wire [15:0] outM;
    wire        writeM;
    wire [15:0] addressM;
    wire [15:0] pc;

    cpu u1(inM, instruction, reset, clock, outM, writeM, addressM, pc);

    task assert_else_error(
            reg [15:0] exp_outM, 
            reg exp_writeM, 
            reg[14:0] exp_addressM, 
            reg[14:0] exp_pc,
            reg[15:0] exp_d_register_out
        );
        assert (outM ==? exp_outM &&
          writeM ==? exp_writeM &&
          addressM ==? exp_addressM &&
          pc ==? exp_pc &&
          u1.d_register_out == exp_d_register_out) else begin
            $error("clock %b, inM %b instruction %b reset %b (real exp, outM %b %b, writeM %b %b, addressM %b %b, pc %b %b, d_register_out %b %b, should_load_d_register %b, second_alu_input_value %b)",
                clock,
                inM, 
                instruction, 
                reset, 
                outM,
                exp_outM,
                writeM,
                exp_writeM,
                addressM,
                exp_addressM,
                pc,
                exp_pc,
                u1.d_register_out,
                exp_d_register_out,
                u1.should_load_d_register,
                u1.second_alu_input_value,
             );
        end
    endtask

    initial
        begin
            // 0+
            #1 instruction = 16'b0011000000111001; 
            #1 clock = 1;
            inM = 0; 
            reset = 0;
            #1 assert_else_error(
                16'bx,//outM
                1'bx, //writeM
                16'bx, //addressM
                0, //pc
                0 // d_register
            );

            #1 clock = 0;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                12345, //addressM
                1, //pc
                0 // d_register
            );       

            // 1+
            #1 instruction = 16'b1110110000010000; 
            #1 clock = 1;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                12345, //addressM
                1, //pc
                12345 // d_register
            ); 

            // 2
            #1 clock = 0;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                12345, //addressM
                2, //pc
                12345 // d_register
            ); 
                        
            // 2+
            #1 instruction = 16'b0101101110100000;
            #1 clock = 1;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                16'b0101101110100000, //addressM
                2, //pc
                12345 // d_register
            ); 

            // 3
            #1 clock = 0;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                23456, //addressM
                3, //pc
                12345 // d_register
            ); 

            // 3+
            #1 instruction = 16'b1110000111010000;
            #1 clock = 1;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                23456, //addressM
                3, //pc
                11111 // d_register
            ); 

            // 4
            #1 clock = 0;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                23456, //addressM
                4, //pc
                11111 // d_register
            ); 

            // 4+
            #1 instruction = 16'b0000001111101000;
            #1 clock = 1;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                1000, //addressM
                4, //pc
                11111 // d_register
            ); 
            
            // 5
            #1 clock = 0;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                1000, //addressM
                5, //pc
                11111 // d_register
            );  

            // 5+
            #1 instruction = 16'b1110001100001000;
            #1 clock = 1;
            #1 assert_else_error(
                11111,//outM
                1, //writeM
                1000, //addressM
                5, //pc
                11111 // d_register
            ); 

            // 6
            #1 clock = 0;
            #1 assert_else_error(
                11111,//outM
                1, //writeM
                1000, //addressM
                6, //pc
                11111 // d_register
            ); 

            // 6+
            #1 instruction = 16'b0000001111101001;
            #1 clock = 1;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                1001, //addressM
                6, //pc
                11111 // d_register
            ); 

            // 7
            #1 clock = 0;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                1001, //addressM
                7, //pc
                11111 // d_register
            ); 

            // 7+
            #1 instruction = 16'b1110001110011000;
            #1 clock = 1;
            #1 assert_else_error(
                11109,//outM
                1, //writeM
                1001, //addressM
                7, //pc
                11110 // d_register
            ); 

            // 8
            #1 clock = 0;
            #1 assert_else_error(
                11109,//outM
                1, //writeM
                1001, //addressM
                8, //pc
                11110 // d_register
            ); 

            // 8+
            #1 instruction = 16'b0000001111101000;
            #1 clock = 1;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                1000, //addressM
                8, //pc
                11110 // d_register
            ); 

            // 9
            #1 clock = 0;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                1000, //addressM
                9, //pc
                11110 // d_register
            ); 

            // 9+
            #1 instruction = 16'b1111010011010000;
            inM = 11111;
            #1 clock = 1;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                1000, //addressM
                9, //pc
                -1 // d_register
            ); 

            // 10
            #1 clock = 0;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                1000, //addressM
                10, //pc
                -1 // d_register
            );

            // 10+
            #1 instruction = 16'b0000000000001110;
            #1 clock = 1;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                14, //addressM
                10, //pc
                -1 // d_register
            ); 

            // 11
            #1 clock = 0;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                14, //addressM
                11, //pc
                -1 // d_register
            ); 

            // 11+
            #1 instruction = 16'b1110001100000100;
            #1 clock = 1;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                14, //addressM
                11, //pc
                -1 // d_register
            ); 

            // 12
            #1 clock = 0;
            #1 assert_else_error(
                16'bx,//outM
                0, //writeM
                14, //addressM
                14, //pc
                -1 // d_register
            ); 
            
        end
endmodule