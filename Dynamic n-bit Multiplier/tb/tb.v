 `define D_WIDTH 8
`timescale 1ns/1ps
`include "bonus.v"

module tb_N_bit_mul;
    reg[`D_WIDTH-1:0] op1,op2;
    wire[2*`D_WIDTH-1:0] res;



    integer i,j,errors=0;

    N_bit_mul #(`D_WIDTH) dut (op1,op2,res);

    initial begin
        $dumpfile("N_bit_mul.vcd");
        $dumpvars(0, tb_N_bit_mul);
    end

    initial begin
       for ( i=0 ; i < (1<<`D_WIDTH) ; i=i+1 ) begin
            op1 = i;
           for ( j=0 ; j < (1<<`D_WIDTH) ; j=j+1 ) begin
               op2 = j; #10

               if(res != (op1*op2)) begin
                    $display("Test case failed !!!");
                    errors = errors + 1;
                    // $display("--------------------------- Test case failed !!! ---------------------------");
                    // $display("Operand-1: %d; Operand-2: %d; \nExpected Output: %d \nReceived Output: %d",op1,op2,op1*op2,res);
               end
           end
       end

        $display("\n----------------------------- DATA WIDTH = %d -------------------------------\n",`D_WIDTH);
        $display("Number of Test cases passed: ( %d / %d )",((1 << 2*`D_WIDTH) - errors),(1 << 2*`D_WIDTH));
        $display("\n--------------------------- Simulation Done !!! ---------------------------\n");
        $finish;
    end

endmodule
