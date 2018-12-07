module Snooping(clock, clear);
	input clock, clear;
	
	reg [4:0] pc; // Contador de instrucoes.
	reg [9:0] inst; // Armazena a instr atual.
	reg [4:0] passo; // Reg que armazena os passos.
	
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
	
	//Instanciando nossa memoria de dados
	reg [5:0] Mem [7:0];

	always @ (posedge clock, posedge clear) begin
		// Carregando a memoria de instrucoes
		if(clear)begin
			hab_cpu1 <= 1'b0;
			hab_cpu2 <= 1'b0;
			hab_cpu3 <= 1'b0;
			pc <= 5'b0;
			passo <= 5'b0;
			hab_bus <= 1'b0;
			shared <= 2'b0;
			controleP1 <= 1'b0;
			controleP2 <= 1'b0;
			controleP3 <= 1'b0;
			
			//Nas proximas linhas, carregaremos nossa memoria de dados segundo a figura do PDF disponibilizado pela profa. Daniela Cascini,
			//com o codigo de testes referente a esta atividade.
			//Pos mem  -    tag | dado
			Mem[0][5:0] <= 6'b000_000; //Na imagem temos o valor 1 aqui. Colocaremos o valor 0 para fins de teste.
			Mem[1][5:0] <= 6'b001_010;
			Mem[2][5:0] <= 6'b010_001;
			Mem[3][5:0] <= 6'b011_101;
			Mem[4][5:0] <= 6'b100_000;
			Mem[5][5:0] <= 6'b101_111; // Na imagem temos aqui o valor 28. Por questao de praticidade, colocaremos este valor como 7.
			Mem[6][5:0] <= 6'b110_011;
			Mem[7][5:0] <= 6'b000000; // Posicao invalida de memoria.
			
			//Nas proximas linhas, carregaremos a memoria com as instrucoes passadas no PDF disponibilizado pela profa. Daniela Cascini,
			//com o codigo de testes referente a esta atividade.
			
			//P0:read 100 -   cpu|inst|tag|dado
			instrucao[0] <= 10'b00_01_000_000;
			//P1:read 100 -   cpu|inst|tag|dado
			instrucao[1] <= 10'b01_01_000_000;
			//P1:write 100<-03-cpu|inst|tag|dado
			instrucao[2] <= 10'b01_10_000_011;
			//P0:write 100<-06-cpu|inst|tag|dado
			instrucao[3] <= 10'b00_10_000_110;
			//P1:read 100 -   cpu|inst|tag|dado
			instrucao[4] <= 10'b01_01_000_000;
			//P1:read 110 -   cpu|inst|tag|dado
			instrucao[5] <= 10'b01_01_010_000;
			//P3:write 110<-07-cpu|inst|tag|dado
			instrucao[6] <= 10'b10_10_010_111;
			//P1:read 130 -   cpu|inst|tag|dado
			instrucao[7] <= 10'b01_01_110_000;
			//P1:write 130<-06-cpu|inst|tag|dado
			instrucao[8] <= 10'b01_10_110_110;
		end
		else if (clock) begin
			case (passo)
				5'b00000: begin
					// Reiniciar os sinais de operacao da cpu se necessario.
					pc <= pc+1; // Incrementa pc.
					passo <= 5'b00001;
					inst <= instrucao[pc]; // Le a instrucao vinda da memoria.
				end
				5'b00001: begin
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
					passo <= 5'b00010;
				end
				5'b00010: begin
					hab_bus <= 1'b0;
					passo <= 5'b00011;
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
				// Stall necessario para recebimento do sinal shared.
				5'b00011: begin
					passo <= 5'b00100;
				end
				5'b00100: begin
					passo <= 5'b00101; // Mais um stall para receber o sinal de shared.
				end
				5'b00101: begin
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
					passo <= 5'b0110;
				end
				5'b00110: begin
					// Stall para execucao do proc.
					passo <= 5'b00111; // Passo 7.
				end
				5'b00111: begin
					// Segundo passo de stall.
					passo <= 5'b01000; // Passo 8.
				end
				5'b01000: begin
					// Terceiro stall.
					passo <= 5'b01001; // Passo 9.
				end
				5'b01001: begin
					// Quarto stall.
					passo <= 5'b01010; // Passo 10.
				end
				5'b01010: begin
					// Voltamos a executar a instrucao.
					// Desabilitamos a Cpu de escrita e habilitamos as de escuta.
					if(controleP1) begin 
						hab_cpu1 <= 1'b0;
						hab_cpu2 <= 1'b1;
						hab_cpu3 <= 1'b1;
						hab_bus <= 1'b1;
						bus_in <= bus_out_cpu1;
					end
					else if(controleP2) begin
						hab_cpu1 <= 1'b1;
						hab_cpu2 <= 1'b0;
						hab_cpu3 <= 1'b1;
						hab_bus <= 1'b1;
						bus_in <= bus_out_cpu2;
					end
					else if(controleP3) begin
						hab_cpu1 <= 1'b1;
						hab_cpu2 <= 1'b1;
						hab_cpu3 <= 1'b0;
						hab_bus <= 1'b1;
						bus_in <= bus_out_cpu3;
					end
					passo <= 5'b01011; // Passo 11.
				end
				5'b01011:begin
					//Desabilitamos o bus para que, nesse meio tempo, nao haja escrita.
					hab_bus <=1'b0;
					passo <= 5'b01100;
				end
				5'b01100:begin
					//Nesse passo reabilitamos o hab_bus para escrever nele, caso ele tenha mandado mensagem de abort mem access+wb.
					if(controleP1) begin 
						hab_cpu2 <= 1'b0;
						hab_cpu3 <= 1'b0;
						hab_bus <= 1'b1;
						if(bus_out_cpu2[7:6] == 2'b01) begin
							bus_in <= bus_out_cpu2;
						end
						else if(bus_out_cpu3[7:6] == 2'b01) begin
							bus_in <= bus_out_cpu3;
						end
						// Se nenhum processador enviou mensagem de abort mem access+wb, o bus recebera um nada.
						else begin
							bus_in <= bus_out_cpu3;
						end
					end
					else if(controleP2) begin
						hab_cpu1 <= 1'b0;
						hab_cpu3 <= 1'b0;
						hab_bus <= 1'b1;
						if(bus_out_cpu1[7:6] == 2'b01) begin
							bus_in <= bus_out_cpu1;
						end
						else if(bus_out_cpu3[7:6] == 2'b01) begin
							bus_in <= bus_out_cpu3;
						end
						// Se nenhum processador enviou mensagem de abort mem access+wb, o bus recebera um nada.
						else begin
							bus_in <= bus_out_cpu3;
						end
					end
					else if(controleP3) begin
						hab_cpu1 <= 1'b0;
						hab_cpu2 <= 1'b0;
						hab_bus <= 1'b1;
						if(bus_out_cpu2[7:6] == 2'b01) begin
							bus_in <= bus_out_cpu2;
						end
						else if(bus_out_cpu1[7:6] == 2'b01) begin
							bus_in <= bus_out_cpu1;
						end
						// Se nenhum processador enviou mensagem de abort mem access+wb, o bus recebera um nada.
						else begin
							bus_in <= bus_out_cpu1;
						end
					end
					passo <= 5'b01101;
				end
				5'b1101: begin 
					if(bus[7:6] == 2'b01) begin // Operacao de write-back.
						Mem[bus[5:3]][2:0] <= bus[2:0];
					end
					bus_in <= {4'b0000,Mem[inst[5:3]][5:0]};
					passo <= 5'b01110;
				end
				5'b01110: begin
					if(controleP1) begin
						hab_cpu1 <= 1'b1;
					end
					else if(controleP2) begin
						hab_cpu2 <= 1'b1;
					end
					else if(controleP3) begin
						hab_cpu3 <= 1'b1;
					end
					passo <= 5'b01111;
				end	
				5'b01111: begin
					// Stall de execucao da Cpu. 
					passo <= 5'b10000;
				end
				5'b10000: begin
					if(controleP1) begin
						hab_cpu1 <= 1'b0;
					end
					else if(controleP2) begin
						hab_cpu2 <= 1'b0;
					end
					else if(controleP3) begin
						hab_cpu3 <= 1'b0;
					end
					passo <= 5'b0;
				end
			endcase
		end
	
	end
	
	// Modulos a parte.
	Bus_arbiter juiz (clock, clear, bus_in, hab_bus, bus);
	Cpu1 cpu1(clock, clear, hab_cpu1, controleP1, shared, inst, bus, cpu1_shared, bus_out_cpu1, out_cpu1);
	Cpu2 cpu2(clock, clear, hab_cpu2, controleP2, shared, inst, bus, cpu2_shared, bus_out_cpu2, out_cpu2);
	Cpu3 cpu3(clock, clear, hab_cpu3, controleP3, shared, inst, bus, cpu3_shared, bus_out_cpu3, out_cpu3);
endmodule
