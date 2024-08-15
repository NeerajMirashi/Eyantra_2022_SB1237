module SB_1237_uart(
	input clk,
	input transmit,
	input [7:0] str_len,  //length of string 
	input [127:0]str,  //string
	output tx,		//UART transmit output,
	output reg done
);

integer n;
parameter idle = 0;
parameter start =1;
parameter data = 2;
parameter stop =3;
integer ct =0;
integer state = idle;
integer j =0;
integer i;
reg in_flag=1;
reg flag=0;
reg temp_clk=1;
reg x = 1;
reg flag_recived=0;
assign tx = x;



always @(posedge clk)
begin
	n = str_len;               // length of string to be transmitted
	if(flag_recived==1)        /// when flag is recived in temp_clk block it become 0 to avoid multiple transmissions of the same message.
		flag=0;
	if(transmit ==1)          ///when transmit signal is recived flag reg becomes 1.
		flag=1;
	if(ct==217)
	begin
		temp_clk = temp_clk?0:1; //temp_clk frequency scale down to baud-rate.
		ct = 0;
	end
	ct = ct + 1;
end


always @(posedge temp_clk)
begin
	case(state)
		idle:
		begin
			x = 1;
			if(in_flag)
			begin
				if(flag==1)
				begin
					flag_recived<=1;
					done=0;
					i=0;
					in_flag=0;
				end
				else
					flag_recived<=0;
				state = idle;
			end
			else
			begin
				state = start;
			end
		end
		start:
		begin
			x = 0;
			state = data;
		end
		data:
		begin
			x = str[((n-1-i)*8)+j];
			j = j+1;
			if(j==8)
			begin
				j=0;
				state = stop;
				i = i+1;
			end
		end
		stop:
		begin
			if(i==n)
			begin
				in_flag=1;
			end
			x = 1;
			state = idle;
		end
	endcase
end



endmodule