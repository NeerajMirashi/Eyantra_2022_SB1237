module SB_1237_freq_counter(
	 input clk,
	 input ip_signal,
	 output reg[13:0]  count
    );



reg [13:0] temp = 0;
reg f=0;
integer ct=0;
// frequency counter which will measure frequency of input signal in kHz.

always @(posedge clk)
begin
	ct = ct+1;
	if(ct==2)
	begin
		f = ~f;
		ct=0;
	end
end

//scale down frequency

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
