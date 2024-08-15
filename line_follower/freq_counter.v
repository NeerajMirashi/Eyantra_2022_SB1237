module freq_counter(
	 input clk,
	 input ip_signal,
	 output reg[7:0]  count
    );



reg [7:0] temp = 0;
reg f=0;
integer ct=0;

always @(posedge clk)
begin
	ct = ct+1;
	if(ct==250)
	begin
		f = ~f;
		ct=0;
	end
end
always @(posedge f)
	begin
		if(ip_signal ==1)
			begin
				if(f == 1)
				temp = temp + 1;
			end
		else
			begin
				if(temp != 0)
				begin
				count =  temp;
				end
				temp = 0;
			end
	end
	
	

endmodule
