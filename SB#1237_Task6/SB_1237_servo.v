module SB_1237_servo(
    input clk,
    output servo,
	 input [1:0] cmd
	 
    );
reg servo_reg;
reg [19:0] ct;
reg [15:0] angle= 'd50000;
integer st=0;
always @(posedge clk)
begin
	ct <= ct + 1;
	if(ct == 'd999999)   // clock cycle of 20 mili seconds
			ct <= 0;

	if(ct < ('d50000 + angle)) //when duty cycle is 1 mili second angle become 0 degree and for duty cycle of 2 mili second angle become 180 dgeree
			servo_reg <= 1;
	else
			servo_reg <= 0;

case(st)
0:
begin
	if(cmd=='b10)   // when cmd is 'b10 servo will set to 90 degree
	st=3;
	if(cmd=='b01)   // when cmd is 'b01 servo will set to 0 degree
st=1;
end
1:
begin
	
	angle=0;
	if(angle =='d0)
		st=0;
end

3:
begin
	angle ='d50000;
	if(angle =='d50000)
	st=0;
end
endcase
end

assign servo	= servo_reg;

endmodule