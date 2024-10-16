module what_while(
 input [15:0] in,
 output reg [4:0] out);
 integer i;
 always @(*) begin: count
     out = 0;
     i = 15;
     while (i >= 0 && ~in[i]) begin
         out = out + 1;
         i = i - 1;
     end
  end
endmodule 