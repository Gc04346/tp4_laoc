// Modulo responsavel por comandar a escrita do bus. O top level decide a entrada e coloca na saida o valor necessario.
// Funciona como um registrador maior.
module Bus_arbiter(clock, clear, bus_in, hab_bus, bus);
	input clock, clear, hab_bus;
	input [9:0] bus_in;
	output reg [9:0] bus;
	
	always @ (posedge clear, posedge clock) begin
		if(clear)begin
			bus <= 10'b0;
		end
		else if(clock)begin
			if(hab_bus)begin
				bus <= bus_in;
			end
		end
	end
	
endmodule
