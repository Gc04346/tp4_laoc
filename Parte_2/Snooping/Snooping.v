module Snooping(clock, clear);
	input clock, clear;
	
	reg [4:0] pc; // Contador de instrucoes.
	reg [9:0] inst; // Armazena a instr atual.
	reg [2:0]passo; // Reg que armazena os passos.
	
	reg hab_cpu1, hab_cpu2, hab_cpu3; // Sinais que habilitam a operacao da cpu.
	reg controleP1, controleP2, controleP3; // Define se cada processador esta agindo ou ouvindo.
	reg hab_bus; // Habilita a escrita no bus.
	reg [9:0] bus_in; // Mensagem que vai para o bus.
	reg shared; // Indica se o bloco em questao esta compartilhado entre outras caches.
	
	wire [9:0] bus; // Barramento de informacoes.
	wire cpu1_shared, cpu2_shared, cpu3_shared; // Fios que informam se a tag atual estah presente no demais procs.
	wire [9:0] bus_out_cpu1, bus_out_cpu2, bus_out_cpu3; // Saidas para o bus de cada cpu.
	wire [2:0] out_cpu1, out_cpu2, out_cpu3; // Saida de cada proc no final do processo.
	
	// Definindo a memoria de instrucoes
	reg [9:0] instrucao [31:0];

	always @ (posedge clock, posedge clear) begin
		// Carregando a memoria de instrucoes
		if(clear)begin
			hab_cpu1 <= 1'b0;
			hab_cpu2 <= 1'b0;
			hab_cpu3 <= 1'b0;
			pc <= 5'b0;
			passo <= 3'b0;
			hab_bus <= 1'b0;
			shared <= 2'b0;
			controleP1 <= 1'b0;
			controleP2 <= 1'b0;
			controleP3 <= 1'b0;
			instrucao[0] <= 10'b0000100000;
			instrucao[1] <= 10'b01;
			instrucao[2] <= 10'b10;
			instrucao[3] <= 10'b011;
			instrucao[4] <= 10'b100;
			instrucao[5] <= 10'b101;
			instrucao[6] <= 10'b110;
			instrucao[7] <= 10'b111;
			instrucao[8] <= 10'b1000;
			instrucao[9] <= 10'b1001;
		end
		else if (clock) begin
			case (passo)
				3'b000: begin
					// Reiniciar os sinais de operacao da cpu se necessario.
					pc <= pc+1; // Incrementa pc.
					passo <= 3'b001;
					inst <= instrucao[pc]; // Le a instrucao vinda da memoria.
				end
				3'b001: begin
					if(inst[9:8] == 2'b00) begin
						controleP1 <= 1'b1; // Processador 1 agindo.
						controleP2 <= 1'b0;
						controleP3 <= 1'b0;
					end
					else if(inst[9:8] == 2'b01) begin
						controleP1 <= 1'b0; 
						controleP2 <= 1'b1; // Processador 2 agindo.
						controleP3 <= 1'b0;
					end
					else if(inst[9:8] == 2'b10) begin
						controleP1 <= 1'b0; 
						controleP2 <= 1'b0;
						controleP3 <= 1'b1; // Processador 3 agindo.
					end
					hab_bus <= 1'b1; // Escrita no bus habilitada.
					bus_in <= {4'b0011,inst[5:3],3'b000}; // Valor a ser escrito no bus.
					passo <= 3'b010;
					
				end
				3'b010: begin
					hab_bus <= 1'b0;
					passo <= 3'b011;
					// Habilita a execucao das cpus para ouvir.
					if(controleP1) begin 
						hab_cpu1 <= 1'b0;
						hab_cpu2 <= 1'b1;
						hab_cpu3 <= 1'b1;
					end
					else if(controleP2) begin
						hab_cpu1 <= 1'b1;
						hab_cpu2 <= 1'b0;
						hab_cpu3 <= 1'b1;
					end
					else if(controleP3) begin
						hab_cpu1 <= 1'b1;
						hab_cpu2 <= 1'b1;
						hab_cpu3 <= 1'b0;
					end
				end
				3'b011: begin
					passo <= 3'b100;
				end
				3'b100: begin
					// Se algum ControlePx estiver em 1, significa que o processador x esta em modo de emissao, e portanto, necessita saber se a tag estah compartilhada.
					// Agora habilitamos a operacao na cpu que tem emissao e desabilitamos as demais.
					// Aqui definimos tambem se o bloco esta compartilhado em outra cache.
					if(controleP1) begin 
						shared <= cpu2_shared | cpu3_shared;
						hab_cpu1 <= 1'b1;
						hab_cpu2 <= 1'b0;
						hab_cpu3 <= 1'b0;
					end
					else if(controleP2) begin
						shared <= cpu1_shared | cpu3_shared;
						hab_cpu1 <= 1'b0;
						hab_cpu2 <= 1'b1;
						hab_cpu3 <= 1'b0;
					end
					else if(controleP3) begin
						shared <= cpu1_shared | cpu2_shared;
						hab_cpu1 <= 1'b0;
						hab_cpu2 <= 1'b0;
						hab_cpu3 <= 1'b1;
					end
					passo <= 3'b101;
				end
				3'b101: begin
					
				end
			endcase
		end
	
	end
	
	// Modulos a parte.
	Bus_arbiter juiz (clock, clear, bus_in, hab_bus, bus);
	CPU cpu1(clock, clear, hab_cpu1, controleP1, shared, inst, bus, cpu1_shared, bus_out_cpu1, out_cpu1);
	CPU cpu2(clock, clear, hab_cpu2, controleP2, shared, inst, bus, cpu2_shared, bus_out_cpu2, out_cpu2);
	CPU cpu3(clock, clear, hab_cpu3, controleP3, shared, inst, bus, cpu3_shared, bus_out_cpu3, out_cpu3);
endmodule
