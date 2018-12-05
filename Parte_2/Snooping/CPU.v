module CPU(clock, clear, habilita, controleP, shared_in, instr, bus_in, shared_out, bus_out);
	input clock, clear, controleP, shared_in, habilita;
	input [7:0] instr;
	input [9:0] bus_in;
	output reg [9:0] bus_out;
	output reg shared_out;
	//2 posicoes de memoria na cache, com oito bits. Sendo eles divididos: XXYYYWWW - XX: estado; YYY: tag; WWW: dado.
	reg [7:0] cache [3:0]; 
	//Contador de passos. No primeiro passo da maq de escrita, identifica um hit ou miss de acordo com a instr.
	//No segundo passo, modifica o estado e manda mensagens para o bus.
	reg [1:0] passo;
	reg [1:0] pos;
	reg [1:0] acao; //Acao que sera indicada para a maquina de estados.
	
	wire Bus_out;
	wire Mem_out;
	wire est_fut;
	
	initial begin
		cache[0] <= 8'b10_100_001;
	end
	
	always @ (posedge clear, posedge clock) begin
		if(clear) begin
			shared_out <= 1'b0;
			passo <= 2'b00;
			pos <= 2'b00;
			bus_out <= 2'b00;
		end
		else if(clock & habilita) begin
//			if(controleP) begin //Se estiver em modo de escrita.
//				case (passo)
//					2'b00: begin
//						passo <= 2'b01; // Incrementando o passo.
//						pos <= instr[5:3] mod 4;
//					end
//					2'b01: begin
//						//No if abaixo verificaremos se a tag da instr passada existe na cache, e se nao esta invalida.
//						if(cache[pos][5:3] == instr[5:3] & cache[pos][7:6] != 2'b00) begin
//							if(instr[7:6] == 2'b01) begin //Se for um read, neste ponto já sabemos que foi um read hit.
//								acao <= 2'b01;
//								passo <= 2'b10;
//								//Futuramente, retornar o valor lido, ou um sinal de que foi read hit.
//							end
//							else if(instr[7:6] == 2'b10) begin //Se for um write, neste ponto já sabemos que foi um write hit.
//								acao <= 2'b11;
//								passo <= 2'b10;
//								//No proximo passo, iremos fazer a escrita.
//							end
//						end
//						//No if abaixo verificaremos se a tag da instr passada nao existe na cache, ou se esta invalida.
//						else if(cache[pos][5:3] != instr[5:3] | cache[pos][7:6] == 2'b00)begin
//							if(instr[7:6] == 2'b01) begin //Se for um read, neste ponto já sabemos que foi um read miss.
//								acao <= 2'b00;
//								passo <= 2'b10;
//							end
//							else if(instr[7:6] == 2'b10) begin //Se for um write, neste ponto já sabemos que foi um write miss.
//								acao <= 2'b10;
//								passo <= 2'b10;
//							end
//							//No proximo passo, temos que informar ao bus qual eh a tag que deu hit ou miss.
//						end
//					end
//					2'b10: begin
//						case (acao)
//							//Se a acao for um read miss.
//							2'b00: begin
//								bus_out <= Bus_out;
//								mem_out <= Mem_out;
//								cache[pos][7:6] <= est_fut;
//							end
//							//Se a acao for um read hit.
//							2'b01: begin
//								bus_out <= Bus_out;
//								mem_out <= Mem_out;
//								cache[pos][7:6] <= est_fut;
//								
//							end
//							//Se a acao for um write miss.
//							2'b10: begin
//							
//							end
//							//Se a acao for um write hit.
//							2'b11: begin
//							
//							end
//					end
//				endcase			
//			end
			if(~controleP) begin //Se estiver em modo de leitura.
				case(passo)
					3'b000:begin
						if(bus_in[3:0] == 4'b0011)begin
							pos <= bus_in[5:3] % 4;
						end
						passo <= passo+1;
					end
					3'b001:begin
						// No if abaixo, verificamos se a tag na posicao mapeada bate com aquela passada por parametro no bus, e se o estado
						// dela eh valido. Se for, informamos que a tag buscada esta compartilhada.
						if(cache[pos][5:3] == bus_in[5:3] & cache[pos][7:6] != 2'b00)begin
							shared_out <=1'b1;
						end
						else begin
							shared_out <=1'b0;
						end
					end
				endcase
			end
		end
	end
	/*O ultimo bit da concatenacao indica se o bloco eh shared ou nao. Tem que ser modificidao*/
	Mesi m_e(clear, clock, {controleP,acao,1'b0}, bus_in[4:3], cache[pos][7:6], Bus_out, Mem_out, est_fut);
	
endmodule
