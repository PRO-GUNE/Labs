/**
Modified by: Chathura Gunasekara
Date: 2024/10/09


Author: Ramesh Fernando
Date: 2024/09/23
**/

module ALU_tb;
  // input and output signals for the DUT

  // 8-bit input A and B (renamed M to B for consistency)
  reg [7:0] A, B;
  // 3-bit input ALU_OP to select the operation       
  reg [2:0] ALU_OP;
  // 8-bit output result     
  wire [7:0] C;         

  // instantiate the DUT
  ALU DUT (
    .A(A), 
    .B(B), 
    .ALU_OP(ALU_OP), 
    .C(C)
  );

  // Assertions
  initial begin
    // A+M operation
    @(posedge ALU_OP == 3'b001);
    assert(C == (A + B)) else $error("Assertion failed: A+M is incorrect");

    // A-M operation
    @(posedge ALU_OP == 3'b010);
    assert(C == (A - B)) else $error("Assertion failed: A-M is incorrect");

    // M-A operation
    @(posedge ALU_OP == 3'b011);
    assert(C == (B - A)) else $error("Assertion failed: M-A is incorrect");

    // -(A+M) operation
    @(posedge ALU_OP == 3'b100);
    assert(C == ~(A + B)) else $error("Assertion failed: -(A+M) is incorrect");

    // A and M operation
    @(posedge ALU_OP == 3'b101);
    assert(C == (A & B)) else $error("Assertion failed: A and M is incorrect");

    // A or M operation
    @(posedge ALU_OP == 3'b110);
    assert(C == (A | B)) else $error("Assertion failed: A or M is incorrect");

    // A xor M operation
    @(posedge ALU_OP == 3'b111);
    assert(C == (A ^ B)) else $error("Assertion failed: A xor M is incorrect");
  end

  // Covergroup for functional coverage
  covergroup ALU_Coverage @(posedge ALU_OP);
    coverpoint A;
    coverpoint B;
    coverpoint ALU_OP;

    // Cross coverage to ensure all operations are tested with different inputs
    cross A, B, ALU_OP;
  endgroup

  ALU_Coverage ALU_coverage;

  // Generate stimulus and sample coverage using random values
  initial begin

    ALU_coverage = new();
    // Stimulate the inputs with a random range of values
    // conducted 100 times
    for (int i = 0; i < 100; i++) begin
      // Random 8-bit value
      A = $random % 256;

      // Random 8-bit value
      B = $random % 256;

      // Random 3-bit ALU operation
      ALU_OP = $random % 8;

      // Wait for 10 time units
      #10;  
      ALU_coverage.sample();  // Sample the coverage after each test
    end
    // Stop simulation after tests
    #10 $finish;
  end

  // Monitor output changes
  initial begin
    $monitor("At time %0t, A=%b, B=%b, ALU_OP=%b, C=%b", $time, A, B, ALU_OP, C);
  end
endmodule
