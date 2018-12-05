module mem_instr (clock, clear, pc, instr_out, hab_escr, dado);
	input clock, hab_escr, clear;
	input [4:0] pc;
	output reg [9:0] instr_out;
	input [9:0] dado;
	
	reg [9:0] instrucao [31:0];
	
	always @ (posedge clock, posedge clear) begin
		if(clear)begin
			//Carregando a memoria
			instrucao[0] <= 10'b0;
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
		else if (hab_escr) begin
			instrucao[pc] <= dado;
		end
		else 
			instr_out <= instrucao[pc];
	end
	
endmodule
