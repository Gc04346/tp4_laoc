module Mesi(Reset, clock, CPU, Bus_in, Bus_out, Mem_out, estado_atual);
	// Entradas e saidas.
	input Reset, clock; 
	input [3:0] CPU; // Entrada enviada pela CPU para definicao do estado de leitura ou escrita. 
						  // O LSB indica se o bloco em questao esta compartilhado ou nao. So sera verificado em caso de ocorrencia de read miss.
	input [1:0] Bus_in; // Entrada padrao para escuta do bus.
	output reg [1:0] Bus_out, Mem_out; 
	output [1:0] estado_atual;
	// Registrador para a maquina de estados.
	reg [1:0] maquina_estados;
	
	// Para fins de simulacao, iniciaremos as saidas com valores 00 (invalid).
	initial begin
		Bus_out <= 2'b00;
		Mem_out <= 2'b00;
	end
	
	assign estado_atual = maquina_estados; // A saida para verificar a maquina de estados.
	// Logica principal do modulo.
	always @ (posedge clock, posedge Reset) begin
		if (Reset) begin // Se o reset estiver em nivel alto, a maquina eh resetada.
			maquina_estados <= 2'b00;
		end
		else if (clock) begin // Se o reset nao estiver ativo, eh hora do show.
			if(CPU[3:3])begin // Verificando se eh modo de escrita.
				if(maquina_estados == 2'b00 & CPU[2:0] == 3'b001) begin // Verificando se o estado eh invalido, e se a acao executada foi um CPU read com bloco compartilhado.
					maquina_estados <= 2'b01; // Maquina de estados vai para shared.
					Bus_out <= 2'b01; // Envia read miss para o bus.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b00 & CPU[2:0] == 3'b000)begin // Verificando se o estado eh invalido, e se a acao executada foi um CPU read com bloco nao compartilhado.
					maquina_estados <= 2'b10; // Maquina de estados vai para exclusive.
					Bus_out <= 2'b01; // Envia read miss para o bus.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b00 & CPU[2:1] == 2'b10)begin // Verificando se o estado eh invalido, e se a acao executada foi um CPU write miss.
					maquina_estados <= 2'b10; // Maquina de estados vai para exclusive.
					Bus_out <= 2'b10; // Envia write miss para o bus.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b01 & CPU[2:1] == 2'b01)begin // Verificando se o estado eh shared, e se a acao executada foi um CPU read hit.
					maquina_estados <= 2'b01; // Estado futuro continua em shared. 
					Bus_out <= 2'b00; //Bus esta vazio.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b01 & CPU[2:1] == 2'b00)begin // Verificando se o estado eh shared, e se a acao executada foi um CPU read miss.
					maquina_estados <= 2'b01; // Estado futuro continua em shared. 
					Bus_out <= 2'b01; //Bus recebe o sinal read miss.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b01 & CPU[2:1] == 2'b11)begin // Verificando se o estado eh shared, e se a acao executada foi um CPU write hit.
					maquina_estados <= 2'b10; // Estado futuro eh exclusive. 
					Bus_out <= 2'b11; //Bus recebe o sinal invalidate.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b01 & CPU[2:1] == 2'b10)begin // Verificando se o estado eh shared, e se a acao executada foi um CPU write miss.
					maquina_estados <= 2'b10; // Estado futuro eh exclusive. 
					Bus_out <= 2'b10; //Bus recebe o sinal write miss.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b10 & CPU[2:1] == 2'b01)begin // Verificando se o estado eh exclusive, e se a acao executada foi um CPU read hit.
					maquina_estados <= 2'b10; // Estado futuro continua em exclusive. 
					Bus_out <= 2'b00; //Bus esta vazio.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b10 & CPU[2:1] == 2'b11)begin // Verificando se o estado eh exclusive, e se a acao executada foi um CPU write hit.
					maquina_estados <= 2'b11; // Estado futuro eh modified. 
					Bus_out <= 2'b00; //Bus esta vazio.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b10 & CPU[2:1] == 2'b10)begin // Verificando se o estado eh exclusive, e se a acao executada foi um CPU write miss.
					maquina_estados <= 2'b11; // Estado futuro eh modified. 
					Bus_out <= 2'b10; //Bus recebe o sinal write miss.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b10 & CPU[2:1] == 2'b00)begin // Verificando se o estado eh exclusive, e se a acao executada foi um CPU read miss.
					maquina_estados <= 2'b01; // Estado futuro eh shared. 
					Bus_out <= 2'b01; //Bus recebe o sinal read miss.
					Mem_out <= 2'b10; // Memoria recebe um write-back block.
				end
			end	
			else if (~CPU[3:3]) begin // Verificando se eh modo de leitura.
				if(maquina_estados == 2'b01 & (Bus_in[1:0] == 2'b10 | Bus_in[1:0] == 2'b11)) begin // Verificando se o estado eh shared, e se açao no bus foi um write miss or ivalidate.
					maquina_estados <= 2'b00; // Estado futuro eh invalid.
					Bus_out <= 2'b00; //Bus esta vazio.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b01 & Bus_in[1:0] == 2'b01) begin // Verificando se o estado atual eh shared e se a acao no bus eh um read miss.
					maquina_estados <= 2'b01; // Estado futuro inalterado.
					Bus_out <= 2'b00; //Bus esta vazio.
					Mem_out <= 2'b00; // Nao altera a memoria.
				end
				else if(maquina_estados == 2'b10 & (Bus_in[1:0] == 2'b01 | Bus_in[1:0] == 2'b11)) begin // Verificando se o estado atual eh exclusive e se a acao no bus eh um read miss ou invalidate.
					maquina_estados <= 2'b01; // Estado futuro eh shared.
					Bus_out <= 2'b00; //Bus esta vazio.
					// TODO: Adicionar o abort mem access e o write-back. Verificar com a professora.
					Mem_out <= 2'b10; // Write-back.
				end
				else if(maquina_estados == 2'b10 & (Bus_in[1:0] == 2'b10 | Bus_in[1:0] == 2'b11)) begin // Verificando se o estado atual eh exclusive e se a acao no bus eh um write miss ou invalidate.
					maquina_estados <= 2'b00; // Estado futuro eh invalid.
					Bus_out <= 2'b00; //Bus esta vazio.
					// TODO: Adicionar o abort mem access e o write-back. Verificar com a professora.
					Mem_out <= 2'b10; // Write-back.
				end
			end
		end
	end
	
endmodule
