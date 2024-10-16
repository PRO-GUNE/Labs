module what_for(
 input [15:0] in,
 output reg [4:0] out
 );
 integer i;
 always @(*) begin: count
 out = 0;
     for (i = 15; i >= 0; i = i - 1) begin
         if (~in[i]) disable count;
         out = out + 1;
     end
 end
endmodule