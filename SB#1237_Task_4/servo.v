module servo(
    input clk,
    output servo,
	 input [1:0] cmd
	 
    );
reg servo_reg;
reg [19:0] counter;
reg [15:0] control= 'd50000;
integer st=0;
always @(posedge clk)
begin
	counter <= counter + 1;
	if(counter == 'd999999)
			counter <= 0;

	if(counter < ('d50000 + control))
			servo_reg <= 1;
	else
			servo_reg <= 0;

case(st)
0:
begin
	if(cmd=='b10)
	st=3;
	if(cmd=='b01)
st=1;
end
1:
begin
	
//	control <=control - 500;
	control=0;
	if(control =='d0)
		st=0;
end

3:
begin
//	control <=control + 500;
	control ='d50000;
	if(control =='d50000)
	st=0;
end
endcase
end

assign servo	= servo_reg;

endmodule