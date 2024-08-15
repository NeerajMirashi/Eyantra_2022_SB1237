module SB_1237_Task4(input clk,
	input  dout,			
	output adc_cs_n,			
	output din,					
	output adc_sck,
	output [3:0]dc,
	output l_w,
	output r_w,
	output c_w,
	output tx,
	output [8:0] rgb_w,
	input freq_color,
	output s2,
	output s3,
	output reg [1:0]turn_w,
	output wire servo1,
	output servo2
	);
	
reg [32:0] ct_pwm_turn=0;
reg [32:0] ct_pwm = 0;
wire l;
wire r;
wire c;
reg [2:0] rgb_w1[3];
reg [3:0]dc_r ='b0000;
reg [32:0] turn_pwm='d779900;
//////////////////////////////////////////////
SB_1237_adc_control(.clk_50(clk),
					.dout(dout),
					.adc_cs_n(adc_cs_n),
					.din(din),
					.adc_sck(adc_sck),
					.l(l),
					.r(r),
					.c(c));

//////////////////////////////////////////////

////////////////////////////////////////////////
wire[2:0] rgb;
SB_1237_top_color(.clk(clk),
				.s2(s2),
				.s3(s3),
				.ip_signal(freq_color),
				.color(rgb));


///////////////////////////////////////////////

//uart
////////////////////////////////////////////	
integer msg_index=0;
reg transmit =0;
reg [1:0] node_t = 'b01;
wire uart_done;
reg [7:0] str;
integer msg_jndex =0;
reg [127:0]tstr;
reg [7:0]n =0;
reg [7:0]sl=0;
SB_1237_uart(.clk(clk),
		.transmit(transmit),
		.str(tstr),
		.str_len(sl),
		.tx(tx),
		.done(uart_done));
		
//uart initial//		

initial
begin
str = 8'd48;
end	



////////////////////////////////////////////////

reg [1:0]cmd_servo1;
reg [1:0]cmd_servo2;
servo(.clk(clk),
			.cmd(cmd_servo1),
			.servo(servo1));
servo(.clk(clk),
			.cmd(cmd_servo2),
			.servo(servo2));

integer st_servo=1;
integer next_st_servo=2;
reg [31:0]ct_servo=0;

//////////////////////////////////////////////
reg p_start=0;
reg [4:0]s_node;
reg [4:0]e_node;
wire p_done;
wire [10*2-1:0] final_path;
wire [7:0] curr;
SB_1237_path_planner(.clk(clk),
				 .start(p_start),
				 .s_node(s_node),
				 .e_node(e_node),
				 .done(p_done),
				 .final_path(final_path),
				 .current_city_block(curr));
initial
begin
s_node = 0;
e_node = 8;
end
////////////////////////////////////////////
//reg [7:0] d=0;
//reg [7:0]d1=0;
//reg s=0;
//reg s1=0;
//dc_motor_control(.clk(clk),
//	.pwm(dc[1:0]),
//	.speed(d),
//	.dir(s));
//dc_motor_control(.clk(clk),
//	.pwm(dc[3:2]),
//	.speed(d1),
//	.dir(s1));




//////////////////////////////////////////////
	
integer ct =0;
integer state=1;
reg [19:0] temp_path;
reg [32:0]delay = 0;
integer i =0;
integer nn = 0;
integer line_follow_state; 
integer turn =0;
integer st = 1;
reg [1:0]ledi=0;
reg end_of_run = 0;
////////////////////////////////////////////
	
//s =>1 means back
//s1=>1 means back	
//0 black
//1 white

always @(posedge clk)
begin
if(transmit ==1)
transmit=0;
case(st)
5:
begin
dc_r = 4'b0;
case(state)
1:
begin
if(ct<100)
p_start=1;
else
begin
ct=0;
p_start =0;
state=2;
end
ct = ct+1;
end
2:
begin
if(p_done ==1)
begin
temp_path <= final_path;
state = 3;
end
end
3:
begin
delay = delay +1;
if(delay == 'd50000000)
begin
delay = 0;
turn_w[0] = temp_path[i];
turn_w[1] = temp_path[i+1];
i=i+2;
if(turn_w[0]==1 && turn_w[1]==0)
turn = 6;
if(turn_w[0]==0 && turn_w[1]==1)
turn =7;
if(turn_w[0]==1 && turn_w[1]==1)
turn =8;
if(turn_w[0] ==0 && turn_w[1]==0)
begin
st=4;
turn = 4;
if(e_node ==7 || e_node==11 || e_node==17)
begin
end_of_run =1;
st =7;                  ////////////////end of run//////////////////
state = 4;
end
else
begin
i=0;
state =1;
s_node = e_node;
nn = nn+1;
end
end
if(st !=4 && st!=7)
st = 3;
end
end
endcase
end


3:                                               ///turn decision
begin
ct_pwm_turn = ct_pwm_turn +1;
//if(turn == 8)
//begin
//turn_pwm = 'd459900;
//end
//else
//begin
//turn_pwm = 'd779900;
//end
if(ct_pwm_turn == 'd999999)
ct_pwm_turn = 0;
if(ct_pwm_turn < turn_pwm)
begin
case(turn)
0:
begin
dc_r[3:0]=4'b0;
//dc0=0;
//dc1=0;
//dc2=0;
//dc3=0;
end

4:                      //u-turn
begin
dc_r[1:0] = 'b01;
dc_r[3:2] = 'b01;

//dc0=50;
//dc1=0;
//dc2=50;
//dc3=0;


end
5:                      //back
begin
dc_r[1:0] = 'b01;
dc_r[3:2] = 'b10;
//dc0=50;
//dc1=0;
//dc2=0;
//dc3=50;
end
6:
begin
dc_r[1:0] = 'b00;         //00
dc_r[3:2] = 'b01;
//dc0=30;
//dc1=0;
//dc2=60;
//dc3=0;
end
7:
begin
dc_r[1:0] = 'b10;
dc_r[3:2] = 'b00;        //00
//dc0=0;
//dc1=60;
//dc2=0;
//dc3=30;
end


8:
begin
dc_r[1:0]='b10;
dc_r[3:2]='b01;
//dc0=0;
//dc1=60;
//dc2=60;
//dc3=0;
end
endcase
end
else
dc_r='b0000;
//dc0=0;
//dc1=0;
//dc2=0;
//dc3=0;
if(turn==8)
begin
if(l==1 || c==1 || r==1)
begin
st=1;
line_follow_state=1;
turn=0;
end
end
else if(l==1 && c==0 && r==1)
begin
st = 1;        ///follow line
line_follow_state =1;
turn =0;       ///dead state of turn
end
end

4:
begin
sl ='d8;
rgb_w1[ledi] = rgb;
if(rgb_w1[ledi] == 'b001)
begin
tstr = {"GBI",str+curr,"-W-#"};
e_node=11;
end
if(rgb_w1[ledi] == 'b100)
begin
tstr = {"GBI",str+curr,"-M-#"};
e_node=7;
end
if(rgb_w1[ledi] == 'b010)
begin
e_node=17;
tstr = {"GBI",str+curr,"-D-#"};
end
ledi = ledi+'d1;
transmit = 1;
st=7;
if(end_of_run==1)
st=6;
end

7:                                 //block pick next state =3; servo1 up-down servo2 gripper
begin
case(st_servo)
1:
begin
ct_servo = ct_servo+1;
if(ct_servo=='d40000000)
begin
ct_servo=0;
st_servo = next_st_servo;
end

end

2:                         //close gripper
begin
cmd_servo2 = 'b01;
st_servo=1;
next_st_servo=3;
end

3:                         //up the arm
begin
sl ='d13;
cmd_servo1 = 'b01;
st_servo=1;
next_st_servo=4;
tstr="GBI2-W-PICK-#";
transmit=1;
st=3;
end
4:
begin
cmd_servo1 = 'b10;
st_servo=1;
next_st_servo=5;
end
5:
begin
sl = 'd16;
cmd_servo2='b10;
st_servo=1;
next_st_servo=6;
tstr="GBI2-W-GDZC-DUMP";
transmit=1;
end
6:
begin
rgb_w1[0] = 'b000;
st_servo=1;
next_st_servo=7;
end
7:
begin
rgb_w1[0]='b111;
rgb_w1[1]='b111;
rgb_w1[2]='b111;
next_st_servo=1;
st_servo=1;
end
endcase
end


1:                   ////////////////simple line following case///////////////////
begin
st = 1;

if(l==0 && r==1)
begin
line_follow_state=2;
end

else if(l==1 && r==0)
begin
line_follow_state=3;
end
else if(l==1 && r==1 && c==0)
begin
line_follow_state =1;
end
else if(l==0 && r==0 && c==0)
begin
line_follow_state =0;
st =5;            ///on node go to delay line_follow_state.
end

ct_pwm = ct_pwm+1;
if(ct_pwm == 'd999999) ct_pwm=0;
if(ct_pwm < 'd689900)
begin
case (line_follow_state)
0:                      //stop
begin
dc_r[3:0] = 'b0;
//dc0=0;
//dc1=0;
//dc2=0;
//dc3=0;
end
1:                               //follow line
begin
dc_r[1:0] = 'b10;
dc_r[3:2] = 'b01;
//dc0=0;
//dc1='d60;
//dc2='d60;
//dc3=0;
end
2:                               //left turn
begin
dc_r[1:0] = 'b10;
dc_r[3:2] = 'b00;                //00
//dc0=0;
//dc1=60;
//dc2=0;
//dc3=38;
end
3:                      //right turn
begin
dc_r[1:0] = 'b00;                 //00
dc_r[3:2] = 'b01;
//dc0=38;
//dc1=0;
//dc2=60;
//dc3=0;
end
endcase              ///////////////////line followning case ends here.../////////////
end
else
begin
dc_r = 'b0000;
//dc0=0;
//dc1=0;
//dc2=0;
//dc3=0;
end
end
endcase
end

assign dc=dc_r;

	
assign l_w = l;
assign r_w = r;
assign c_w  =c;
assign rgb_w[2:0] = rgb_w1[0];
assign rgb_w[5:3] = rgb_w1[1];
assign rgb_w[8:6] = rgb_w1[2];

endmodule
