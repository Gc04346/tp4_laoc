module FilaInstr(reset, clock, modo_cpu1, modo_cpu2, modo_cpu3, instr);
	input reset, clock;
	// Não podemos conter dois blocos com o modo de emissão ativos.
	output modo_cpu1, modo_cpu2, modo_cpu3; // Modo de emissão ou escuta para cada bloco.
	output [7:0] instr; // Intrucao enviada para o processador.
	
	// Buffer que armazena as instrucoes que serao executadas.
	reg [7:0] Queue [9:0]; 
	// Registrador que armazena a temporizacao ate a proxima instrucao poder ser enviada.
	reg temp;
	// inicializacao para simulacao.
	initial begin
		Queue[0] <= 10'b00_00_000_000; 
		Queue[1] <= 10'b00_00_000_000;
		Queue[2] <= 10'b00_00_000_000;
		Queue[3] <= 10'b00_00_000_000;
		Queue[4] <= 10'b00_00_000_000;
		Queue[5] <= 10'b00_00_000_000;
		Queue[6] <= 10'b00_00_000_000;
		Queue[7] <= 10'b00_00_000_000;
	end
	
	
endmodule
