module SB_1237_servo(
    input clk,
    output servo,
	 input [1:0] cmd
	 
    );
reg servo_reg;
reg [19:0] ct;
reg [19:0] angle= 0;
integer st=0;
always @(posedge clk)
begin
	ct <= ct + 1;
	if(ct == 'd999999)   // clock cycle of 20 mili seconds
			ct <= 0;

	if(ct < ('d25000 + angle)) //when duty cycle is 1 mili second angle become 0 degree and for duty cycle of 2 mili second angle become 180 dgeree
			servo_reg <= 1;
	else
			servo_reg <= 0;

	if(cmd=='b11)   // 180 degree
	angle ='d100000;
	if(cmd=='b10)   // when cmd is 'b10 servo will set to 90 degree
	angle='d50000;
	if(cmd=='b01)   // when cmd is 'b01 servo will set to 0 degree
	angle=0;
	
	st=0;
end

assign servo	= servo_reg;

endmodule