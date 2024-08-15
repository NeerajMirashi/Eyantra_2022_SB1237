module path_plan
	(	input clk,
	input start,
	input [4:0] s_node,
	input [4:0] e_node,
	output reg done,
	output reg [10*5-1:0] final_path);

integer adj[25:0][3:0];
integer graph[25:0][25:0];
integer vis[26];
integer dist[26];
integer state =7;
integer i;
integer parent[26];
integer mi,mn,j,k;
integer temp_e_node;
integer path[10];
integer c;
initial
begin
done =0;
temp_e_node <= e_node;
adj[0][0] <= 27;adj[0][1] <= 27;adj[0][2] <= 27;adj[0][3] <= 27;
adj[1][0] <= 27;adj[1][1] <= 13;adj[1][2] <= 0;adj[1][3] <= 2;
adj[2][0] <= 1;adj[2][1] <= 3;adj[2][2] <= 27;adj[2][3] <= 5;
adj[3][0] <= 27;adj[3][1] <= 27;adj[3][2] <= 2;adj[3][3] <= 27;
adj[4][0] <= 27;adj[4][1] <= 27;adj[4][2] <= 27;adj[4][3] <= 6;
adj[5][0] <= 2;adj[5][1] <= 9;adj[5][2] <= 27;adj[5][3] <= 6;
adj[6][0] <= 5;adj[6][1] <= 27;adj[6][2] <= 4;adj[6][3] <= 16;
adj[7][0] <= 27;adj[7][1] <= 27;adj[7][2] <= 27;adj[7][3] <= 12;
adj[8][0] <= 27;adj[8][1] <= 27;adj[8][2] <= 27;adj[8][3] <= 9;
adj[9][0] <= 8;adj[9][1] <= 15;adj[9][2] <= 5;adj[9][3] <= 27;
adj[10][0] <= 27;adj[10][1] <= 16;adj[10][2] <= 27;adj[10][3] <= 27;
adj[11][0] <= 27;adj[11][1] <= 27;adj[11][2] <= 12;adj[11][3] <= 27;
adj[12][0] <= 11;adj[12][1] <= 17;adj[12][2] <= 7;adj[12][3] <= 13;
adj[13][0] <= 12;adj[13][1] <= 18;adj[13][2] <= 1;adj[13][3] <= 27;
adj[14][0] <= 27;adj[14][1] <= 27;adj[14][2] <= 27;adj[14][3] <= 15;
adj[15][0] <= 14;adj[15][1] <= 22;adj[15][2] <= 9;adj[15][3] <= 27;
adj[16][0] <= 10;adj[16][1] <= 23;adj[16][2] <= 6;adj[16][3] <= 27;
adj[17][0] <= 27;adj[17][1] <= 27;adj[17][2] <= 12;adj[17][3] <= 27;
adj[18][0] <= 27;adj[18][1] <= 19;adj[18][2] <= 13;adj[18][3] <= 20;
adj[19][0] <= 27;adj[19][1] <= 27;adj[19][2] <= 18;adj[19][3] <= 27;
adj[20][0] <= 18;adj[20][1] <= 21;adj[20][2] <= 27;adj[20][3] <= 22;
adj[21][0] <= 20;adj[21][1] <= 27;adj[21][2] <= 27;adj[21][3] <= 27;
adj[22][0] <= 20;adj[22][1] <= 25;adj[22][2] <= 15;adj[22][3] <= 23;
adj[23][0] <= 22;adj[23][1] <= 24;adj[23][2] <= 27;adj[23][3] <= 16;
adj[24][0] <= 27;adj[24][1] <= 27;adj[24][2] <= 23;adj[24][3] <= 27;
adj[25][0] <= 27;adj[25][1] <= 27;adj[25][2] <= 22;adj[25][3] <= 27;
graph[0][0] <=0;graph[0][1] <=3;graph[0][2] <=0;graph[0][3] <=0;graph[0][4] <=0;graph[0][5] <=0;graph[0][6] <=0;graph[0][7] <=0;graph[0][8] <=0;graph[0][9] <=0;graph[0][10] <=0;graph[0][11] <=0;graph[0][12] <=0;graph[0][13] <=0;graph[0][14] <=0;graph[0][15] <=0;graph[0][16] <=0;graph[0][17] <=0;graph[0][18] <=0;graph[0][19] <=0;graph[0][20] <=0;graph[0][21] <=0;graph[0][22] <=0;graph[0][23] <=0;graph[0][24] <=0;graph[0][25] <=0;
graph[1][0] <=3;graph[1][1] <=0;graph[1][2] <=3;graph[1][3] <=0;graph[1][4] <=0;graph[1][5] <=0;graph[1][6] <=0;graph[1][7] <=0;graph[1][8] <=0;graph[1][9] <=0;graph[1][10] <=0;graph[1][11] <=0;graph[1][12] <=0;graph[1][13] <=3;graph[1][14] <=0;graph[1][15] <=0;graph[1][16] <=0;graph[1][17] <=0;graph[1][18] <=0;graph[1][19] <=0;graph[1][20] <=0;graph[1][21] <=0;graph[1][22] <=0;graph[1][23] <=0;graph[1][24] <=0;graph[1][25] <=0;
graph[2][0] <=0;graph[2][1] <=3;graph[2][2] <=0;graph[2][3] <=1;graph[2][4] <=0;graph[2][5] <=3;graph[2][6] <=0;graph[2][7] <=0;graph[2][8] <=0;graph[2][9] <=0;graph[2][10] <=0;graph[2][11] <=0;graph[2][12] <=0;graph[2][13] <=0;graph[2][14] <=0;graph[2][15] <=0;graph[2][16] <=0;graph[2][17] <=0;graph[2][18] <=0;graph[2][19] <=0;graph[2][20] <=0;graph[2][21] <=0;graph[2][22] <=0;graph[2][23] <=0;graph[2][24] <=0;graph[2][25] <=0;
graph[3][0] <=0;graph[3][1] <=0;graph[3][2] <=1;graph[3][3] <=0;graph[3][4] <=0;graph[3][5] <=0;graph[3][6] <=0;graph[3][7] <=0;graph[3][8] <=0;graph[3][9] <=0;graph[3][10] <=0;graph[3][11] <=0;graph[3][12] <=0;graph[3][13] <=0;graph[3][14] <=0;graph[3][15] <=0;graph[3][16] <=0;graph[3][17] <=0;graph[3][18] <=0;graph[3][19] <=0;graph[3][20] <=0;graph[3][21] <=0;graph[3][22] <=0;graph[3][23] <=0;graph[3][24] <=0;graph[3][25] <=0;
graph[4][0] <=0;graph[4][1] <=0;graph[4][2] <=0;graph[4][3] <=0;graph[4][4] <=0;graph[4][5] <=0;graph[4][6] <=3;graph[4][7] <=0;graph[4][8] <=0;graph[4][9] <=0;graph[4][10] <=0;graph[4][11] <=0;graph[4][12] <=0;graph[4][13] <=0;graph[4][14] <=0;graph[4][15] <=0;graph[4][16] <=0;graph[4][17] <=0;graph[4][18] <=0;graph[4][19] <=0;graph[4][20] <=0;graph[4][21] <=0;graph[4][22] <=0;graph[4][23] <=0;graph[4][24] <=0;graph[4][25] <=0;
graph[5][0] <=0;graph[5][1] <=0;graph[5][2] <=3;graph[5][3] <=0;graph[5][4] <=0;graph[5][5] <=0;graph[5][6] <=1;graph[5][7] <=0;graph[5][8] <=0;graph[5][9] <=2;graph[5][10] <=0;graph[5][11] <=0;graph[5][12] <=0;graph[5][13] <=0;graph[5][14] <=0;graph[5][15] <=0;graph[5][16] <=0;graph[5][17] <=0;graph[5][18] <=0;graph[5][19] <=0;graph[5][20] <=0;graph[5][21] <=0;graph[5][22] <=0;graph[5][23] <=0;graph[5][24] <=0;graph[5][25] <=0;
graph[6][0] <=0;graph[6][1] <=0;graph[6][2] <=0;graph[6][3] <=0;graph[6][4] <=3;graph[6][5] <=1;graph[6][6] <=0;graph[6][7] <=0;graph[6][8] <=0;graph[6][9] <=0;graph[6][10] <=0;graph[6][11] <=0;graph[6][12] <=0;graph[6][13] <=0;graph[6][14] <=0;graph[6][15] <=0;graph[6][16] <=3;graph[6][17] <=0;graph[6][18] <=0;graph[6][19] <=0;graph[6][20] <=0;graph[6][21] <=0;graph[6][22] <=0;graph[6][23] <=0;graph[6][24] <=0;graph[6][25] <=0;
graph[7][0] <=0;graph[7][1] <=0;graph[7][2] <=0;graph[7][3] <=0;graph[7][4] <=0;graph[7][5] <=0;graph[7][6] <=0;graph[7][7] <=0;graph[7][8] <=0;graph[7][9] <=0;graph[7][10] <=0;graph[7][11] <=0;graph[7][12] <=2;graph[7][13] <=0;graph[7][14] <=0;graph[7][15] <=0;graph[7][16] <=0;graph[7][17] <=0;graph[7][18] <=0;graph[7][19] <=0;graph[7][20] <=0;graph[7][21] <=0;graph[7][22] <=0;graph[7][23] <=0;graph[7][24] <=0;graph[7][25] <=0;
graph[8][0] <=0;graph[8][1] <=0;graph[8][2] <=0;graph[8][3] <=0;graph[8][4] <=0;graph[8][5] <=0;graph[8][6] <=0;graph[8][7] <=0;graph[8][8] <=0;graph[8][9] <=1;graph[8][10] <=0;graph[8][11] <=0;graph[8][12] <=0;graph[8][13] <=0;graph[8][14] <=0;graph[8][15] <=0;graph[8][16] <=0;graph[8][17] <=0;graph[8][18] <=0;graph[8][19] <=0;graph[8][20] <=0;graph[8][21] <=0;graph[8][22] <=0;graph[8][23] <=0;graph[8][24] <=0;graph[8][25] <=0;
graph[9][0] <=0;graph[9][1] <=0;graph[9][2] <=0;graph[9][3] <=0;graph[9][4] <=0;graph[9][5] <=2;graph[9][6] <=0;graph[9][7] <=0;graph[9][8] <=1;graph[9][9] <=0;graph[9][10] <=0;graph[9][11] <=0;graph[9][12] <=0;graph[9][13] <=0;graph[9][14] <=0;graph[9][15] <=1;graph[9][16] <=0;graph[9][17] <=0;graph[9][18] <=0;graph[9][19] <=0;graph[9][20] <=0;graph[9][21] <=0;graph[9][22] <=0;graph[9][23] <=0;graph[9][24] <=0;graph[9][25] <=0;
graph[10][0] <=0;graph[10][1] <=0;graph[10][2] <=0;graph[10][3] <=0;graph[10][4] <=0;graph[10][5] <=0;graph[10][6] <=0;graph[10][7] <=0;graph[10][8] <=0;graph[10][9] <=0;graph[10][10] <=0;graph[10][11] <=0;graph[10][12] <=0;graph[10][13] <=0;graph[10][14] <=0;graph[10][15] <=0;graph[10][16] <=2;graph[10][17] <=0;graph[10][18] <=0;graph[10][19] <=0;graph[10][20] <=0;graph[10][21] <=0;graph[10][22] <=0;graph[10][23] <=0;graph[10][24] <=0;graph[10][25] <=0;
graph[11][0] <=0;graph[11][1] <=0;graph[11][2] <=0;graph[11][3] <=0;graph[11][4] <=0;graph[11][5] <=0;graph[11][6] <=0;graph[11][7] <=0;graph[11][8] <=0;graph[11][9] <=0;graph[11][10] <=0;graph[11][11] <=0;graph[11][12] <=3;graph[11][13] <=0;graph[11][14] <=0;graph[11][15] <=0;graph[11][16] <=0;graph[11][17] <=0;graph[11][18] <=0;graph[11][19] <=0;graph[11][20] <=0;graph[11][21] <=0;graph[11][22] <=0;graph[11][23] <=0;graph[11][24] <=0;graph[11][25] <=0;
graph[12][0] <=0;graph[12][1] <=0;graph[12][2] <=0;graph[12][3] <=0;graph[12][4] <=0;graph[12][5] <=0;graph[12][6] <=0;graph[12][7] <=2;graph[12][8] <=0;graph[12][9] <=0;graph[12][10] <=0;graph[12][11] <=3;graph[12][12] <=0;graph[12][13] <=1;graph[12][14] <=0;graph[12][15] <=0;graph[12][16] <=0;graph[12][17] <=3;graph[12][18] <=0;graph[12][19] <=0;graph[12][20] <=0;graph[12][21] <=0;graph[12][22] <=0;graph[12][23] <=0;graph[12][24] <=0;graph[12][25] <=0;
graph[13][0] <=0;graph[13][1] <=3;graph[13][2] <=0;graph[13][3] <=0;graph[13][4] <=0;graph[13][5] <=0;graph[13][6] <=0;graph[13][7] <=0;graph[13][8] <=0;graph[13][9] <=0;graph[13][10] <=0;graph[13][11] <=0;graph[13][12] <=1;graph[13][13] <=0;graph[13][14] <=0;graph[13][15] <=0;graph[13][16] <=0;graph[13][17] <=0;graph[13][18] <=2;graph[13][19] <=0;graph[13][20] <=0;graph[13][21] <=0;graph[13][22] <=0;graph[13][23] <=0;graph[13][24] <=0;graph[13][25] <=0;
graph[14][0] <=0;graph[14][1] <=0;graph[14][2] <=0;graph[14][3] <=0;graph[14][4] <=0;graph[14][5] <=0;graph[14][6] <=0;graph[14][7] <=0;graph[14][8] <=0;graph[14][9] <=0;graph[14][10] <=0;graph[14][11] <=0;graph[14][12] <=0;graph[14][13] <=0;graph[14][14] <=0;graph[14][15] <=1;graph[14][16] <=0;graph[14][17] <=0;graph[14][18] <=0;graph[14][19] <=0;graph[14][20] <=0;graph[14][21] <=0;graph[14][22] <=0;graph[14][23] <=0;graph[14][24] <=0;graph[14][25] <=0;
graph[15][0] <=0;graph[15][1] <=0;graph[15][2] <=0;graph[15][3] <=0;graph[15][4] <=0;graph[15][5] <=0;graph[15][6] <=0;graph[15][7] <=0;graph[15][8] <=0;graph[15][9] <=1;graph[15][10] <=0;graph[15][11] <=0;graph[15][12] <=0;graph[15][13] <=0;graph[15][14] <=1;graph[15][15] <=0;graph[15][16] <=0;graph[15][17] <=0;graph[15][18] <=0;graph[15][19] <=0;graph[15][20] <=0;graph[15][21] <=0;graph[15][22] <=1;graph[15][23] <=0;graph[15][24] <=0;graph[15][25] <=0;
graph[16][0] <=0;graph[16][1] <=0;graph[16][2] <=0;graph[16][3] <=0;graph[16][4] <=0;graph[16][5] <=0;graph[16][6] <=3;graph[16][7] <=0;graph[16][8] <=0;graph[16][9] <=0;graph[16][10] <=2;graph[16][11] <=0;graph[16][12] <=0;graph[16][13] <=0;graph[16][14] <=0;graph[16][15] <=0;graph[16][16] <=0;graph[16][17] <=0;graph[16][18] <=0;graph[16][19] <=0;graph[16][20] <=0;graph[16][21] <=0;graph[16][22] <=0;graph[16][23] <=2;graph[16][24] <=0;graph[16][25] <=0;
graph[17][0] <=0;graph[17][1] <=0;graph[17][2] <=0;graph[17][3] <=0;graph[17][4] <=0;graph[17][5] <=0;graph[17][6] <=0;graph[17][7] <=0;graph[17][8] <=0;graph[17][9] <=0;graph[17][10] <=0;graph[17][11] <=0;graph[17][12] <=3;graph[17][13] <=0;graph[17][14] <=0;graph[17][15] <=0;graph[17][16] <=0;graph[17][17] <=0;graph[17][18] <=0;graph[17][19] <=0;graph[17][20] <=0;graph[17][21] <=0;graph[17][22] <=0;graph[17][23] <=0;graph[17][24] <=0;graph[17][25] <=0;
graph[18][0] <=0;graph[18][1] <=0;graph[18][2] <=0;graph[18][3] <=0;graph[18][4] <=0;graph[18][5] <=0;graph[18][6] <=0;graph[18][7] <=0;graph[18][8] <=0;graph[18][9] <=0;graph[18][10] <=0;graph[18][11] <=0;graph[18][12] <=0;graph[18][13] <=2;graph[18][14] <=0;graph[18][15] <=0;graph[18][16] <=0;graph[18][17] <=0;graph[18][18] <=0;graph[18][19] <=1;graph[18][20] <=1;graph[18][21] <=0;graph[18][22] <=0;graph[18][23] <=0;graph[18][24] <=0;graph[18][25] <=0;
graph[19][0] <=0;graph[19][1] <=0;graph[19][2] <=0;graph[19][3] <=0;graph[19][4] <=0;graph[19][5] <=0;graph[19][6] <=0;graph[19][7] <=0;graph[19][8] <=0;graph[19][9] <=0;graph[19][10] <=0;graph[19][11] <=0;graph[19][12] <=0;graph[19][13] <=0;graph[19][14] <=0;graph[19][15] <=0;graph[19][16] <=0;graph[19][17] <=0;graph[19][18] <=1;graph[19][19] <=0;graph[19][20] <=0;graph[19][21] <=0;graph[19][22] <=0;graph[19][23] <=0;graph[19][24] <=0;graph[19][25] <=0;
graph[20][0] <=0;graph[20][1] <=0;graph[20][2] <=0;graph[20][3] <=0;graph[20][4] <=0;graph[20][5] <=0;graph[20][6] <=0;graph[20][7] <=0;graph[20][8] <=0;graph[20][9] <=0;graph[20][10] <=0;graph[20][11] <=0;graph[20][12] <=0;graph[20][13] <=0;graph[20][14] <=0;graph[20][15] <=0;graph[20][16] <=0;graph[20][17] <=0;graph[20][18] <=1;graph[20][19] <=0;graph[20][20] <=0;graph[20][21] <=1;graph[20][22] <=2;graph[20][23] <=0;graph[20][24] <=0;graph[20][25] <=0;
graph[21][0] <=0;graph[21][1] <=0;graph[21][2] <=0;graph[21][3] <=0;graph[21][4] <=0;graph[21][5] <=0;graph[21][6] <=0;graph[21][7] <=0;graph[21][8] <=0;graph[21][9] <=0;graph[21][10] <=0;graph[21][11] <=0;graph[21][12] <=0;graph[21][13] <=0;graph[21][14] <=0;graph[21][15] <=0;graph[21][16] <=0;graph[21][17] <=0;graph[21][18] <=0;graph[21][19] <=0;graph[21][20] <=1;graph[21][21] <=0;graph[21][22] <=0;graph[21][23] <=0;graph[21][24] <=0;graph[21][25] <=0;
graph[22][0] <=0;graph[22][1] <=0;graph[22][2] <=0;graph[22][3] <=0;graph[22][4] <=0;graph[22][5] <=0;graph[22][6] <=0;graph[22][7] <=0;graph[22][8] <=0;graph[22][9] <=0;graph[22][10] <=0;graph[22][11] <=0;graph[22][12] <=0;graph[22][13] <=0;graph[22][14] <=1;graph[22][15] <=0;graph[22][16] <=0;graph[22][17] <=0;graph[22][18] <=0;graph[22][19] <=0;graph[22][20] <=2;graph[22][21] <=0;graph[22][22] <=0;graph[22][23] <=1;graph[22][24] <=0;graph[22][25] <=3;
graph[23][0] <=0;graph[23][1] <=0;graph[23][2] <=0;graph[23][3] <=0;graph[23][4] <=0;graph[23][5] <=0;graph[23][6] <=0;graph[23][7] <=0;graph[23][8] <=0;graph[23][9] <=0;graph[23][10] <=0;graph[23][11] <=0;graph[23][12] <=0;graph[23][13] <=0;graph[23][14] <=0;graph[23][15] <=2;graph[23][16] <=2;graph[23][17] <=0;graph[23][18] <=0;graph[23][19] <=0;graph[23][20] <=0;graph[23][21] <=0;graph[23][22] <=1;graph[23][23] <=0;graph[23][24] <=2;graph[23][25] <=0;
graph[24][0] <=0;graph[24][1] <=0;graph[24][2] <=0;graph[24][3] <=0;graph[24][4] <=0;graph[24][5] <=0;graph[24][6] <=0;graph[24][7] <=0;graph[24][8] <=0;graph[24][9] <=0;graph[24][10] <=0;graph[24][11] <=0;graph[24][12] <=0;graph[24][13] <=0;graph[24][14] <=0;graph[24][15] <=0;graph[24][16] <=0;graph[24][17] <=0;graph[24][18] <=0;graph[24][19] <=0;graph[24][20] <=0;graph[24][21] <=0;graph[24][22] <=0;graph[24][23] <=2;graph[24][24] <=0;graph[24][25] <=0;
graph[25][0] <=0;graph[25][1] <=0;graph[25][2] <=0;graph[25][3] <=0;graph[25][4] <=0;graph[25][5] <=0;graph[25][6] <=0;graph[25][7] <=0;graph[25][8] <=0;graph[25][9] <=0;graph[25][10] <=0;graph[25][11] <=0;graph[25][12] <=0;graph[25][13] <=0;graph[25][14] <=0;graph[25][15] <=0;graph[25][16] <=0;graph[25][17] <=0;graph[25][18] <=0;graph[25][19] <=0;graph[25][20] <=0;graph[25][21] <=0;graph[25][22] <=3;graph[25][23] <=0;graph[25][24] <=0;graph[25][25] <=0;



end


always @(posedge clk)
begin

case(state)
0:
begin
for(i=0;i<26;i=i+1)
begin
if(i<10)
path[i]=27;
dist[i]=27;
vis[i]=0;
end
if(i >=26)
begin
state =1;
i=0;
end
end

1:
begin
parent[s_node]=-1;
dist[s_node]=0;
state = 2;
i =0;
end
2:
begin
if(i <=26)
begin
j=0;
mi=-1;
mn = 1000;
for(k=0;k<26;k=k+1)
begin
if(vis[k]==0 && dist[k]<mn)
begin
mn = dist[k];
mi = k;
end
end
vis[mi]=1;
state=3;
end
else
begin
state =5;
end
end
3:
begin
if(j<=26)
begin
  if(vis[j]==0 && graph[mi][j] !=0)
  begin
	if(graph[mi][j] + dist[mi] < dist[j])
	begin
		dist[j] = graph[mi][j] + dist[mi];
		parent[j] = mi;
	end
	end
	j = j+1;
	state = 3;
	end
	else
	begin
		i = i+1;
		state =2;
	end
end
5:
begin
	for(c =0; c<10;c=c+1)
	begin
		if(temp_e_node != -1)
		begin
			path[c] = temp_e_node;
			temp_e_node <= parent[temp_e_node];
		end
	end
	state =6;
end

6:
begin
final_path[4:0] = path[0];
final_path[9:5] = path[1];
final_path[14:10] = path[2];
final_path[19:15] = path[3];
final_path[24:20] = path[4];
final_path[29:25] = path[5];
final_path[34:30] = path[6];
final_path[39:35] = path[7];
final_path[44:40] = path[8];
final_path[49:45] = path[9];
done =1;
state = 7;
end
7:
begin
if(start ==1)
begin
 done =0;
 temp_e_node = e_node;
 state =0;
end
end
endcase

end


endmodule