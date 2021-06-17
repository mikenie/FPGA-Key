module key(rst,clk,key,led,count);
	
	localparam
		STATE0 = 3'b001,
		STATE1 = 3'b010,
		STATE2 = 3'b011,
		STATE3 = 3'b100;
		
	input rst;
	input clk;
	input key;
	output reg led=0;
	reg [2:0] state = STATE0; //状态
	output reg [9:0] count=0; //计数值
	
	reg k_s1;
	reg k_s2;	
	reg m_posedge;
	
	//下降沿检测
	always@(posedge clk)
	if(!rst)begin
		k_s1 = 0;
		k_s2 = 0;
	end
	else begin
		k_s1 <= key;
		k_s2 <= k_s1;
	end
	
	assign m_negedge = !k_s1 & k_s2; //下降沿：   k_s1:—— ----> k_s2__ ,
	
	always@(posedge clk)
	begin
	
		if(!rst)begin //RESET
			state = STATE0;
			count = 0;
		end
		
		//一段式状态机
		case(state)
			STATE0:
				if(m_negedge) //检测到下降沿
					state=STATE1;
			
			STATE1:
				begin
					count = count+1; //计数值+1
					if(count>=10)	//计满改变状态
						begin
							count = 0;
							state = STATE2;
						end
				end
			
			STATE2:
				if(key==0)
					state=STATE3;
				else state=STATE0;
			
			STATE3:
				begin
					led = ~led;
					state = STATE0;
				end
		endcase
	end

endmodule
