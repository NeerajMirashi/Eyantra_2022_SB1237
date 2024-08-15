module adc_control(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
//	output [11:0]d_out_ch5,	//12-bit output of ch. 5 (parallel)
//	output [11:0]d_out_ch6,	//12-bit output of ch. 6 (parallel)
//	output [11:0]d_out_ch7,	//12-bit output of ch. 7 (parallel)
//	output [1:0]data_frame, //To represent 16-cycle frame (optional)
	output l,
	output r,
	output c
);
	
////////////////////////WRITE YOUR CODE FROM HERE////////////////////
reg l_r=0;
reg r_r=0;
reg c_r=0;

reg [11:0] t5=12'd0;
reg [11:0] t6=12'd0;
reg [11:0] t7=12'd0;

reg [11:0] o5;
reg [11:0]o6;
reg [11:0]o7;
reg [1:0] df = 2'd0;
reg cs =1;
assign adc_cs_n = cs;
assign data_frame = df;
assign d_out_ch5 = o5;
assign d_out_ch6 = o6;
assign d_out_ch7 = o7;

reg y=0;
assign adc_sck = y;
reg x=0;
assign din =x;
integer a =0;

reg [3:0] ct;
reg [2:0] addr;
initial
begin
ct = 4'd0;
addr = 3'd111;
end
always @(negedge clk_50)
begin
	if(a==10)
	begin
	y = y?0:1;
	a=0;
	end
	a = a+1;
end

always @(negedge adc_sck)
begin
case(ct)
0:
begin
x=0;
o7 = t7;
o5 = t5;
o6 =t6;
addr = addr + 1;
cs = 0;
df = df + 1'd1;
if({df}==0)
begin
df[1]=0;
df[0]=1;
end
end

1:x=0;
2:
begin
x =addr[2];
end
3:x =addr[1];
4:
begin
x =addr[0];
end
default:
begin
x=0;
end
endcase
if(ct>4)
begin
if({addr[2],addr[1],addr[0]} == 0)
begin
t7[16-ct]=dout;
if(t5 >= 'd3300)
l_r=1;
else
l_r=0;
end
if({addr[2],addr[1],addr[0]} == 1)
begin
t5[16-ct]=dout;
if(t6 >= 'd3400)
c_r=1;
else
c_r=0;
end
if({addr[2],addr[1],addr[0]} == 2)
begin
t6[16-ct]=dout;
if(t7 >= 'd2500)
r_r=1;
else
r_r=0;
end
end
ct = ct + 1;

end

assign l=~l_r;
assign c=~c_r;
assign r=~r_r;

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule