/**
Author: Ramesh Fernando
Date: 2024/09/23

ALU_OP | Operation
000 | A
001 | A+M
010 | A-M
011 | M-A
100 | -(A+M)
101 | A and M
110 | A or M
111 | A xor M
**/

module ALU(input [7:0] A, input [7:0] B, input [2:0] ALU_OP, output reg [7:0] C);
  // Temporary register to store the result of the operation
  reg [7:0] temp;
  // always block to perform the operation based on the ALU_OP input
  always @(A, B, ALU_OP) begin
    // case statement to select the operation
    case(ALU_OP)
      3'b000: temp = A;              // A
      3'b001: temp = A + B;          // A+M
      3'b010: temp = A - B;          // A-M
      3'b011: temp = B - A;          // M-A
      3'b100: temp = ~(A + B);       // -(A+M)
      3'b101: temp = A & B;          // A and M
      3'b110: temp = A | B;          // A or M
      3'b111: temp = A ^ B;          // A xor M
      default: temp = 8'b0;         // default case
    endcase
    // assign the value of temp to the output result
  end

  assign C = temp;
endmodule