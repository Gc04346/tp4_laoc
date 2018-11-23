module Parte_1(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);

	input [17:0] SW;
	input [0:0] KEY;
	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

	// Fios necessarios.
	wire [1:0] bus_out, mem_out, estado; 
	
	Mesi maqEst(SW[17:17], ~KEY[0:0], SW[3:0], SW[6:5], bus_out, mem_out, estado);
	
	// Displays de SeteSegmentos
	SeteSeg visorBus({2'b0, bus_out}, HEX4); // Visor do Bus.
	SeteSeg visorMem({2'b0, mem_out}, HEX6); // Visor da mensagem para a memoria.
	SeteSeg visorMaqEst({2'b0, estado}, HEX0); // Estado final.
	
	// Travando os displays.
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	assign HEX7 = 7'b1111111;
	
endmodule
