module Cpu3(clock, clear, habilita, controleP, shared_in, instr, bus_in, shared_out, bus_out, out);
	input clock, clear, controleP, shared_in, habilita;
	input [7:0] instr;
	input [9:0] bus_in;
	
	output reg [9:0] bus_out;
	output reg shared_out;
	output reg [2:0] out; // Saida no momento da acao. Se for leitura o valor lido na posicao e se for escrita o valor escrito na posicao.
	
	//2 posicoes de memoria na cache, com oito bits. Sendo eles divididos: XXYYYWWW - XX: estado; YYY: tag; WWW: dado.
	reg [7:0] cache [3:0]; 
	//Contador de passos. No primeiro passo da maq de escrita, identifica um hit ou miss de acordo com a instr.
	//No segundo passo, modifica o estado e manda mensagens para o bus.
	reg [2:0] passo;
	reg [1:0] pos;
	reg [1:0] acao; //Acao que sera indicada para a maquina de estados.
	
	wire [1:0] Bus_out;
	wire [1:0] Mem_out;
	wire [1:0] est_fut;
	
	// Carregando a cache do processador.
	initial begin
		// Pos  |  Estado|Tag|Dado 
		cache[0] <= 8'b01_100_000;
		cache[1] <= 8'b01_001_010;
		cache[2] <= 8'b00_010_001;
		cache[3] <= 8'b00_011_001;
	end
	
	always @ (posedge clear, posedge clock) begin
		if(clear) begin
			shared_out <= 1'b0;
			passo <= 3'b00;
			pos <= 2'b00;
			bus_out <= 2'b00;
			out <= 3'b00;
		end
		else if(clock & habilita) begin
			if(controleP) begin // Se estiver em modo de escrita.
				case (passo)
					3'b000: begin
						passo <= 3'b001; // Incrementando o passo.
						pos <= instr[5:3] % 4;
						out <= 3'b000;
					end
					3'b001: begin
						//No if abaixo verificaremos se a tag da instr passada existe na cache, e se nao esta invalida.
						if(cache[pos][5:3] == instr[5:3] & cache[pos][7:6] != 2'b00) begin
							if(instr[7:6] == 2'b01) begin // Se for um read, neste ponto já sabemos que foi um read hit.
								acao <= 2'b01; // Read hit.
								passo <= 3'b010; // Avancamos o passo.
							end
							else if(instr[7:6] == 2'b10) begin //Se for um write, neste ponto já sabemos que foi um write hit.
								acao <= 2'b11; // Write hit.
								passo <= 3'b010;
							end
						end
						// No if abaixo verificaremos se a tag da instr passada nao existe na cache, ou se estah invalida.
						else if(cache[pos][5:3] != instr[5:3] | cache[pos][7:6] == 2'b00)begin
							if(instr[7:6] == 2'b01) begin // Se for um read, neste ponto já sabemos que foi um read miss.
								acao <= 2'b00; // Read miss.
								passo <= 3'b010;
							end
							else if(instr[7:6] == 2'b10) begin // Se for um write, neste ponto já sabemos que foi um write miss.
								acao <= 2'b10; // write miss.
								passo <= 3'b010;
							end
						end
					end
					3'b010: begin
						// Stall para operacao da maquina de estados.
						passo <= 2'b011;
					end
					3'b011: begin
						case (acao)
							// Se a acao for um read miss.
							2'b00: begin
								// Avisamos a falha na leitura.
								bus_out <= {Bus_out, Mem_out, instr[5:0]};
								cache[pos][7:6] <= est_fut; // A cache passa para o estado futuro.
								cache[pos][5:3] <= instr[5:3]; // Recebemos a nova tag da posicao em questao.
								passo <= 3'b100; // Vamos para o proximo passo.
							end
							// Se a acao for um read hit.
							2'b01: begin
								// Avisamos com as devidas mensagens.
								bus_out <= {Bus_out, Mem_out, instr[5:0]};
								cache[pos][7:6] <= est_fut; // Atribuimos o estado futuro.
								out <= cache[pos][2:0]; // Lemos o valor da posicao.
								passo <= 3'b100; // Vamos para o proximo passo.
							end
							// Se a acao for um write miss.
							2'b10: begin
								bus_out <= {Bus_out, Mem_out, instr[5:0]}; // Avisamos com as devidas mensagens.
								cache[pos][7:6] <= est_fut; // Recebemos o estado futuro.
								cache[pos][5:0] <= instr[5:0]; // Recebemos a nova tag e o novo valor.
								out <= instr[2:0]; // out recebe o valor atribuido a posicao.
								passo <= 3'b100; // Vamos para o proximo passo.
							end
							// Se a acao for um write hit.
							2'b11: begin
								bus_out <= {Bus_out, Mem_out, instr[5:0]}; // Avisamos as devidas mensagens.
								cache[pos][7:6] <= est_fut; // Recebemos o estado futuro.
								cache[pos][2:0] <= instr[2:0]; // Recebemos o novo valor.
								out <= instr[2:0]; // Out recebe o valor que foi colocado na posicao.
								passo <= 3'b100; // Vamos para o proximo passo.
							end
						endcase
					end
					// As demais operacoes jah foram terminadas. Agora devemos terminar a operacao do processador de emissao.
					3'b100: begin
						passo <= 3'b101;
					end
					3'b101: begin
						if(acao == 2'b00 & bus_in[7:6] == 2'b01) begin
							cache[pos][5:0] <= bus_in[5:0];
							out <= bus_in[5:0];
						end
						passo <= 3'b110;
					end
					3'b110: begin
						if(acao == 2'b00) begin
							cache[pos][5:0] <= bus_in[5:0];
							out <= bus_in[5:0];
						end
						passo <= 4'b0;
					end
				endcase			
			end
			else if(~controleP) begin //Se estiver em modo de leitura.
				case(passo)
					3'b000:begin
						// Sinal para verificacao do sinal de shared.
						if(bus_in[3:0] == 4'b0011)begin
							pos <= bus_in[5:3] % 4;
						end
						passo <= 3'b001;
						// Resetando os sinais.
					end
					3'b001: begin
						// No if abaixo, verificamos se a tag na posicao mapeada bate com aquela passada por parametro no bus, e se o estado
						// dela eh valido. Se for, informamos que a tag buscada esta compartilhada.
						if(cache[pos][5:3] == bus_in[5:3] & cache[pos][7:6] != 2'b00) begin
							shared_out <=1'b1;
						end
						else begin
							shared_out <=1'b0;
						end
						passo <= 3'b010;
					end
					3'b010: begin
						//Stall para a acao da maquina de estados.
						passo <= 3'b011;
					end
					3'b011: begin
						if(cache[pos][5:3] == bus_in[5:3] & cache[pos][7:6] != 2'b00) begin
							bus_out <= {Bus_out, Mem_out, cache[pos][5:0]}; // Avisamos com as devidas mensagens.
							out <= cache[pos][5:0];
							cache[pos][7:6] <= est_fut; // Recebemos o estado futuro.
						end
						passo <= 3'b000;
					end	
				endcase
			end
		end
	end
	Mesi m_e(clear, clock, {controleP,acao,shared_in}, bus_in[9:8], cache[pos][7:6], Bus_out, Mem_out, est_fut);
	
endmodule