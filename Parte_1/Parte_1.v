module Parte_1(SW, KEY, HEX0, HEX1, HEX2);

	input [17:0] SW;
	input [0:0] KEY;
	output [0:6] HEX0, HEX1, HEX2;

	// Fios necessarios.
	wire [1:0] bus_out, mem_out, estado; 
	
	Mesi maqEst(SW[17:17], KEY[0:0], SW[3:0], SW[6:5], bus_out, mem_out, estado);
	
	// Displays de SeteSegmentos
	SeteSeg visorBus({2'b0, bus_out}, HEX0); // Visor do Bus.
	SeteSeg visorMem({2'b0, mem_out}, HEX1); // Visor da mensagem para a memoria.
	SeteSeg visorMaqEst({2'b0, estado}, HEX2); // Estado final.
	
	
endmodule
