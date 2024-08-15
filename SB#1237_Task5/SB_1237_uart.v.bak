// SB : Task 2 B : UART
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design UART Transmitter.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//UART Transmitter design
//Input   : clk_50M : 50 MHz clock
//Output  : tx : UART transmit output

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module SB_1237_uart(
	input clk,
	input transmit,
	input [7:0] str_len,
	input [127:0]str,//50 MHz clock
	output tx,		//UART transmit output,
	output reg done
);
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

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
n = str_len;
if(flag_recived==1)
flag=0;
if(transmit ==1)
flag=1;
if(ct==217)
begin
temp_clk = temp_clk?0:1;
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



////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////