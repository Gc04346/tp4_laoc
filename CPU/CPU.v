module CPU(clock, clear, modo, instr, bus_in, bus_out);

	input clock, clear, modo;
	input [7:0] instr;
	input [4:0] bus_in;
	output reg [4:0] bus_out;
	//2 posicoes de memoria na cache, com oito bits. Sendo eles divididos: XXYYYWWW - XX: estado; YYY: tag; WWW: dado.
	reg [1:0] cache [7:0]; 
	//Registrador para conter a instrucao.
	reg instrucao [7:0];
	//Contador de passos. No primeiro passo da maq de escrita, identifica um hit ou miss de acordo com a instrucao.
	//No segundo passo, modifica o estado e manda mensagens para o bus.
	reg [1:0] passo;
	reg [1:0] pos;
	reg [1:0] acao; //Acao que sera indicada para a maquina de estados.
	
	wire Bus_out;
	wire Mem_out;
	wire est_fut;
	
	always @ (posedge clear, posedge clock) begin
		if(clear) begin // Reiniciar todos os regs que são necessários.
			cache[0][7:6] <= 2'b00;
			cache[1][7:6] <= 2'b00;
			passo <= 2'b00;
			instrucao <= 8'b0;
			pos <= 2'b00;
			bus_out <= 2'b00;
		end
		else if(clock) begin
			if(modo) begin //Se estiver em modo de escrita.
				case (passo)
					2'b00: begin
						instrucao <= instr;
						passo <= 2'b01; // Incrementando o passo.
						pos <= instr[5:3] mod 2
					end
					2'b01: begin
						//No if abaixo verificaremos se a tag da instrucao passada existe na cache, e se nao esta invalida.
						if(cache[pos][5:3] == instrucao[5:3] & cache[pos][7:6] != 2'b00) begin
							if(instrucao[7:6] == 2'b01) begin //Se for um read, neste ponto já sabemos que foi um read hit.
								acao <= 2'b01;
								passo <= 2'b10;
								//Futuramente, retornar o valor lido, ou um sinal de que foi read hit.
							end
							else if(instrucao[7:6] == 2'b10) begin //Se for um write, neste ponto já sabemos que foi um write hit.
								acao <= 2'b11;
								passo <= 2'b10;
								//No proximo passo, iremos fazer a escrita.
							end
						end
						//No if abaixo verificaremos se a tag da instrucao passada nao existe na cache, ou se esta invalida.
						else if(cache[pos][5:3] != instrucao[5:3] | cache[pos][7:6] == 2'b00)begin
							if(instrucao[7:6] == 2'b01) begin //Se for um read, neste ponto já sabemos que foi um read miss.
								acao <= 2'b00;
								passo <= 2'b10;
							end
							else if(instrucao[7:6] == 2'b10) begin //Se for um write, neste ponto já sabemos que foi um write miss.
								acao <= 2'b10;
								passo <= 2'b10;
							end
							//No proximo passo, temos que informar ao bus qual eh a tag que deu hit ou miss.
						end
					end
					2'b10: begin
						case (acao) // Enviamos as mensagens para o bus e executamos as ações necessárias.
							//Se a acao for um read miss.
							2'b00: begin
								
							end
							//Se a acao for um read hit.
							2'b01: begin
							
							end
							//Se a acao for um write miss.
							2'b10: begin
							
							end
							//Se a acao for um write hit.
							2'b11: begin
							
							end
					end
				endcase			
			end
			else if(~modo) begin //Se estiver em modo de leitura.
			
			end
		end
	end
	/*O ultimo bit da concatenacao indica se o bloco eh shared ou nao. Tem que ser modificidao*/
	Mesi m_e(clear, clock, {modo,acao,0}, bus_in[4:3], cache[pos][7:6], Bus_out, Mem_out, est_fut);
	
endmodule