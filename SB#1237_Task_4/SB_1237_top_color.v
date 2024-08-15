module SB_1237_top_color(input clk, output reg s2,output reg s3,output reg[2:0]color, input ip_signal);
wire [7:0]count;
reg [2:0]color_temp;
SB_1237_freq_counter(.clk(clk),
				.ip_signal(ip_signal),
				.count(count));
				
reg [7:0]r_freq;
reg [7:0]g_freq;
reg [7:0]b_freq;
reg [32:0]delay=0;
integer state=1;
integer next_state=2;
initial
begin
s2=0;
s3=0;
end

always @(posedge clk)
begin

case(state)
1:                      ////delay
begin
delay = delay+1;
if(delay=='d5000000)
begin
delay=0;
state = next_state;
end
end
2:
begin
r_freq[7:0] <= count[7:0];
s2=0;
s3=1;
next_state=3;
state=1;
end

3:
begin
b_freq[7:0] <= count[7:0];
s2=1;
s3=1;
next_state=4;
state=1;
end

4:
begin
g_freq[7:0] <= count[7:0];
s2=0;
s3=0;
next_state=5;
state = 1;
end

5:
begin
if(r_freq < g_freq)
begin
	if(r_freq < b_freq)
		color_temp = 'b100;
	else
		color = 'b001;
end
else
begin
	if(g_freq < b_freq)
		color_temp = 'b010;
	else
		color_temp = 'b001;
end
state = 1;
next_state=6;
end
6:
begin
color = color_temp;
state = 1;
next_state =2;
end
endcase

end
endmodule

