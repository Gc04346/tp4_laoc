module display7seg (in, out);
	input [3:0] in;
	output reg [6:0] out;

	always @ (in) //switch case da entrada in para definir quais segmentos estarao acesos (em 0) no display hex0
		begin
			case (in)
				4'b0000: out = 7'b0000001;
				4'b0001: out = 7'b1001111;
				4'b0010: out = 7'b0010010;
				4'b0011: out = 7'b0000110;
				4'b0100: out = 7'b1001100;
				4'b0101: out = 7'b0100100;
				4'b0110: out = 7'b0100000;
				4'b0111: out = 7'b0001111;
				4'b1000: out = 7'b0000000;
				4'b1001: out = 7'b0000100;
				4'b1010: out = 7'b0001000;
				4'b1011: out = 7'b1100000;
				4'b1100: out = 7'b1110010;
				4'b1101: out = 7'b1000010;
				4'b1110: out = 7'b0110000;
				4'b1111: out = 7'b0111000;
			endcase
		end
endmodule

module SeteSeg(SW,HEX0);
	input [17:0] SW;
	output [0:6] HEX0;
	
	display7seg visor (SW,HEX0);
endmodule
