module uart(
	input clk_50M,	//50 MHz clock
	output tx		//UART transmit output
);
parameter n =4;
parameter idle = 0;
parameter start =1;
parameter data = 2;
parameter stop =3;
integer ct =0;
integer state = idle;
integer j =0;
integer i = 0;

reg temp_clk=1;
reg x = 1;
reg [n*8:0]str;
initial
str = "GBI1";

assign tx = x;
always @(posedge clk_50M)
begin
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
if(i==n)
begin
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
x = 1;
state = idle;
end
endcase
end

endmodule