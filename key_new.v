module key_new(key_in,clk,n_rst,out);
  
  localparam idle       = 4'b0001,
             press_down = 4'b0010,
             press_keep = 4'b0100,
             press_up   = 4'b1000;
         
  reg[3:0] state;
  reg[3:0] next_state;
  
  // capture rising edge
  reg t1,t2,n_key;
  assign  n_key = (!t1)||t2;
  always@(posedge clk or negedge n_rst)
    begin
      if(!n_rst)begin
        t1 <= 1'b1;
        t2 <= 1'b1;
      end
      else begin
        t1 <= key_in;
        t2 <= t1;
      end
    end
  
  // count time: press down
  reg start_count;
  reg[19:0] time_count;
  always@(posedge clk or negedge n_rst)
    begin
      if(!n_rst)begin
        start_count <= 0;
        time_count  <= 0;
      end
      else begin
        if(start_count)begin
          time_count <= time_count + 1'd1;
        end
        else time_count <= 0;
      end
    end
  
  /**********************     1     *************************/
  always@(posedge clk or negedge n_rst)
    begin
      if(!n_rst)begin
        state <= idle;
        next_state <=idle;
      end
      else begin
        state <= next_state;
      end
    end
  
  /*********************    2     ************************/
  always@(*)
    begin
      case(state):
        idle:
              begin
                if(n_key == 1)
                  next_state = press_down;
                  start_count = 1'b1; // start count when press down
                else begin 
                  next_state = idle;
                  start_count = 1'b0; // stop and clear count when idle
                end
              end
        press_down:
              begin
                if(key_in == 1'b1 || time_count < count_keep) next_state = idle;
                else if(key_in == 1'b0 || time_count >= count_keep) begin
                  next_state = press_keep;
                  start_count = 1'b0;
                end
                else next_state = press_down;
              end
        press_keep:
              begin
                if(key_in == 1'b0) next_state = press_up;
                else next_state = press_keep;
              end
        press_up:
              begin
                
              end
        default: 
              begin
                  next_state = state;
                  start_count = 1'b0;
              end
      end
              
  /**********************     3     ****************************/
  always@(posedge clk or negedge n_rst)
    begin
      out <= press_up;
    end
                
  
endmodule
