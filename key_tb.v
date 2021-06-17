`timescale 1ns/1ps

module key_tb;

	reg clk;
	reg rst;
	reg key;
	wire led;
	wire [9:0] count;
	key key0(
		.rst(rst),
		.clk(clk),
		.key(key),
		.led(led),
		.count(count)
	);
	
	initial clk = 1;
	initial key=1;
	initial rst =1;
	always#10 clk=~clk;
	
	initial begin
		#1700;
		repeat(3)begin
			repeat(20) begin
				key=~key;
				#1;
			end
			key = 0;
			#600;
			repeat(20) begin
				key=~key;
				#1;
			end
			key = 1;
			#600;
		end	
			$stop;
	end

endmodule



