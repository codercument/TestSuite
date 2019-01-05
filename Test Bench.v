`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.01.2018 23:43:56
// Design Name: 
// Module Name: tb_TLC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_TLC();
`define EOF -1
reg clk, btn;
wire [2:0] n_lights,s_lights,e_lights,w_lights;
wire [6:0] segment;
wire an;
reg [15:0] input_ligth_status;
wire [15:0] output_ligth_status;
reg [15:0] mem [15:0];
integer i,j;
// The file handle for the input file
integer file_id;
// The character received from $fgetc
integer c;
// The status register from $sscanf
integer r;
integer cl;
// Line buffer
reg [8*100:1] line;

// Command
reg [8*25:1]  cmd;

// The arguments extracted from the line
reg [7:0] a0;
reg [15:0] a1;
reg [7:0] a2;
reg [19:0] trans [0:17] [0:1];
reg [19:0] input_ligth_status_;
reg [3:0] a2_;
initial begin

file_id = $fopen("C:\\Users\\ercum\\Downloads\\Case_study\\TestSuites\\Mutant10\\Forward Right Decoded (FPGA) Test Cases.txt", "r");
//$readmemh("D:\\MYPROJECTS\\FPGA\\Projects\\Traffic_Light_Four_Input\\test.txt",mem);
  // Check if the file has been opened
if (file_id == 0) begin
  $display ("ERROR: test.txt not opened");
  $finish;
end
trans[0][0]= 20'h14440;
trans[0][1]= 20'h2444;

trans[1][0]= 20'h24440;
trans[1][1]= 20'h4144;

trans[2][0]= 20'h41440;
trans[2][1]= 20'h4244;

trans[3][0]= 20'h42440;
trans[3][1]= 20'h4414;

trans[4][0]= 20'h44140;
trans[4][1]= 20'h4424;

trans[5][0]= 20'h44240;
trans[5][1]= 20'h4441;

trans[6][0]= 20'h44410;
trans[6][1]= 20'h4442;

trans[7][0]= 20'h44420;
trans[7][1]= 20'h1444;

trans[8][0]= 20'h44441;
trans[8][1]= 20'h4444;

trans[9][0]= 206'h44441;
trans[9][1]= 20'h4444;

trans[10][0]= 20'h44441;
trans[10][1]= 20'h4444;

trans[11][0]= 20'h44441;
trans[11][1]= 20'h4444;

trans[12][0]= 20'h44441;
trans[12][1]= 20'h4444;

trans[13][0]= 20'h44441;
trans[13][1]= 20'h4444;

trans[14][0]= 20'h44441;
trans[14][1]= 20'h4444;

trans[15][0]= 20'h44441;
trans[15][1]= 20'h4444;

trans[16][0]= 20'h44441;
trans[16][1]= 20'h4444;

trans[17][0]= 20'h44440;
trans[17][1]= 20'h1444;

//for ( i=0; i<=17; i=i+1)
//      for ( j=0; j<1; j=j+1)
//          $display ("[%h] [%h] ",trans[i][j],trans[i][j+1] );  
          
input_ligth_status = 16'h0000;

cl = 0;
btn = 1;


c = $fgetc(file_id);

  // Repeat while the given line is not the eof
  while (c != `EOF) begin
  
  line = "";
  cmd  = "";
  a0   = 8'b0;
  a1   = 16'b0;
  a2   = 8'b0;
//  btn=1;
//  cl=!cl;
//  clk = cl;
  // Replace the character "c"
  r = $ungetc(c, file_id);
  // Get the next line
  r = $fgets(line, file_id);
  
   r = $sscanf(line, "%s %x", cmd, a0);
   
    if (r != 2) begin
    $display ("ERROR: Current line [%-s] not formatted correctly", line);
    $finish;
    end
    
    case (cmd)
          "CNT" : begin
            $display ("CNT value [%02x]", a0);
          end
        endcase
   
   btn=1;
   cl=!cl;
   clk = cl;
   //btn = 0;
   #10
   for(i=0;i<a0;i=i+1)
    begin
       // Get the next line
       r = $fgets(line, file_id);
       r = $sscanf(line, "%h %h", a1,a2);
       #10
       input_ligth_status = a1;
       btn=a2;

      // $display("*[%h],[%h]",a1,a2);
      
       cl=!cl;
       clk = cl;
       #10
       if (output_ligth_status == 16'h4444) begin
       $display ("ERROR: Test Failed led status: %h", output_ligth_status);
       $finish;
       end
       else
        begin
        a2_=a2;
        input_ligth_status_=a1<<4 | a2_ ;
         //$display("**[%h]",input_ligth_status_);
            for ( j=0; j<=17; j=j+1)
              begin
                  //$display ("[%h] ",trans[j][0] ); 
                  if(input_ligth_status_ == trans[j][0] && input_ligth_status !=0  )
                 begin
                    if (output_ligth_status !=trans[j][1] && output_ligth_status !=0 )
                        begin
                        $display ("ERROR: Test Failed led status: %h not equal %h", output_ligth_status, trans[j][1]);
                        $finish;
                        end
                  end
                  end
                  
        end
   
   end
    // Get the first character on the next line
    #15
    if (output_ligth_status == 16'h4444) begin
    $display ("ERROR: Test Failed led status: %h", output_ligth_status);
    $finish;
    end
    c = $fgetc(file_id);  
         
  end // while
  
    $display ("INFORMATION: Test is finished");
  $finish;
end

//always begin
//#5 clk = ! clk;
//end

TrafficLight TrafficLight_inst (
.n_lights (n_lights),
.s_lights (s_lights),
.e_lights (e_lights),
.w_lights (w_lights), 
.clk      (clk), 
.btn      (btn) , 
.segment  (segment),
.an       (an),
.input_ligth_status(input_ligth_status),
.output_ligth_status(output_ligth_status)
);

endmodule
