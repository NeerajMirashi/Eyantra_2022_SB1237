module test(input clk, output [1:0]led_r);



//////////////////////////////////////////////
reg p_start;
reg [4:0]s_node=0;
reg [4:0]e_node=3;
wire p_done;
wire [10*2-1:0] dir;
path_planner(.clk(clk),
				 .start(p_start),
				 .s_node(s_node),
				 .e_node(e_node),
				 .done(p_done),
				 .final_path(dir));
////////////////////////////////////////////	

reg [10*2-1:0] dire='b0;
reg [32:0] s3=0;

integer state;
integer i=0;
integer ct;
reg lsb;
reg msb;

initial 
begin
p_start =0;
state=0;
end

always @(posedge clk)
begin

case(state)
0:
begin
ct=ct+1;
if(ct==100)
p_start=1;
if(ct==300)
begin
p_start=0;
ct=0;
state=1;
end
end

1:
begin
if(p_done==0)
state =1;
else
begin
dire='b0;
state =2;
end
end

2:
begin
dire = dir;
$display(dire);
state =3;
end

3:
begin
s3=s3+1;
if(s3 =='d50000000)
begin
i = i+2;
s3=0;
end
lsb = dire[i];
msb = dire[i+1];
if(dire[i]==0 && dire[i+1]==0)
begin
state =0;
s_node = (s_node+1) %25;
e_node = (e_node+1) % 25;
end
end



endcase
end
assign led_r[0] = ~lsb;
assign led_r[1] = ~msb;
endmodule



// SB : Task 1 D PWM Generator
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will scale down the 50Mhz Clock Frequency to 1Mhz and perform Pulse Width Modulation on it.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//PWM Generator
//Inputs : Clk, DUTY_CYCLE
//Output : PWM_OUT

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
//
//module test(
// 
//	input clk,             // Clock input
//	output [1:0]PWM_OUT         // Output PWM
//);
// 
//////////////////////////WRITE YOUR CODE FROM HERE////////////////////
//
//reg [1:0]y ;
//assign PWM_OUT = y; 
//reg [32:0] a = 0;
//reg [7:0]DUTY_CYCLE = 4;
//
//always @(posedge clk)
//begin
//	if(a < 2000000000)
//	begin
//		if(a < DUTY_CYCLE /2)
//		begin
//			y = 'b10;
//		end
//		else
//			begin
//			if(a == 0)
//			begin
//				y = 'b10;
//			end 
//			else
//			y = 0;
//			
//			end
//		a =a+1;
//	end
//	else
//	begin
//		a = 0;
//		y=0;
//	end
//end
//
//
//
//////////////////////////YOUR CODE ENDS HERE//////////////////////////
//endmodule
/////////////////////////////////MODULE ENDS///////////////////////////
