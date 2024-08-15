module SB_1237_top_color(input clk, output reg s2,output reg s3,output reg[2:0]color, input ip_signal);
wire [13:0]count;
reg [2:0]color_temp;

//frequency counter module which will count the frequency of input signal.
SB_1237_freq_counter(.clk(clk),
				.ip_signal(ip_signal),
				.count(count));
				
reg [13:0]r_freq;    //frequency of red filter 
reg [13:0]g_freq;		//frequency of green filter 
reg [13:0]b_freq;		//frequency of blue filter 
reg [13:0]c_freq;
reg [32:0]delay=0;
integer state=1;
integer next_state=0;
initial 
begin
//initially select lines are set to (1,0) which turn on clear filter
s2=1;
s3=0;
end

always @(posedge clk)
begin

	case(state)
		1:                      ////delay for 1 mili sec.
		begin
			delay = delay+1;
			if(delay=='d5000000)
			begin
				delay=0;
				state = next_state;
			end
		end
		0:
		begin
			c_freq[13:0] <=count[13:0];          //as the frequency of white light for clear filter is very high its frequency count is very low and in our case if frequency count is below 300 it's white light.
			if(c_freq < 'd300)
			begin
				color = 'b111;
				state = 1;
				next_state=0;				//if it detects the color as white it will not check for other filters.
			end
			else
			begin
				s2=0;   //red filter
				s3=0;
				state =1;
				next_state=2;
			end
			
		end
		2:
		begin
			r_freq[13:0] <= count[13:0];   // measured frequency is stored into reg.
			//select line config. are changed to blue
			s2=0;
			s3=1;
			next_state=3;
			state=1;      //delay
		end

		3:
		begin
			b_freq[13:0] <= count[13:0];   // measured frequency is stored into reg.
			//select line config. are changed to green
			s2=1;
			s3=1;
			next_state=4;
			state=1;    //delay
		end

		4:
		begin
			g_freq[13:0] <= count[13:0];	 // measured frequency is stored into reg.
			//select line config. are changed to red 
			s2=0;
			s3=0;
			next_state=5;
			state = 1;    //delay
		end

		5:
		begin
			// colors are calculated on the basis of minimum frequency count among filters.
			 if(r_freq < g_freq)
			begin
				if(r_freq < b_freq)
					color_temp = 'b100;
				else
					color_temp = 'b001;
			end
			else
			begin
				if(g_freq < b_freq)
					color_temp = 'b010;
				else
					color_temp = 'b001;
			end
			state = 1;
			next_state=6;
		end
		6:
		begin
			color = color_temp;
			//again the state machine goes to initial state to recalculate the color for next time.
			state = 1;
			next_state =0;
		end
	endcase

end
endmodule

