`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2024 15:40:40
// Design Name: 
// Module Name: AHB_MASTER
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


module AHB_MASTER(
input Hclk,Hresetn,Hreadyout,
input [31:0]Hrdata,
output reg [31:0]Haddr,Hwdata,
output reg Hwrite,Hreadyin,
output reg [1:0]Htrans
);
reg [2:0]Hburst;
reg [2:0]Hsize;
integer i,j;

task single_write();
 begin
  @(posedge Hclk)
  #1;
   begin
    Haddr = 32'h8000_0001;
    Hwrite=1;
    Hreadyin=1;
    Htrans =2'd2; 
    Hburst=0;
    Hsize=0;
   end
  @(posedge Hclk)
    #1;
     begin
      Htrans =2'd0; 
      Hwdata=8'h80;
     
     end
   
 end
endtask
task single_read ();
 begin
  @(posedge Hclk)
  #1;
   begin
    Haddr = 32'h8000_0001;
    Hwrite=0;
    Hreadyin=1;
    Htrans =2'd2; 
    Hburst=0;
    Hsize=0;
   end
  @(posedge Hclk)
    #1;
     begin
      Htrans =2'd0; 
     end
   
 end
 endtask
task burst_write();
  begin
   @(posedge Hclk)
   #1;
    begin
     Haddr = 32'h8000_0001;
     Hwrite=1;
     Hreadyin=1;
     Htrans =2'd2; 
     Hburst=3'd2;
     Hsize=0;
    end
   @(posedge Hclk)
     #1;
      begin
       Haddr=Haddr+1;
       Htrans =2'd3; 
       Hwdata=($random)%256;    
      end
   for(i=0;i<2;i=i+1)
   begin
    @(posedge Hclk)
       #1;
        begin
         Haddr=Haddr+1;
         Htrans =2'd3; 
         Hwdata=($random)%256;    
        end
   end 
  end
 endtask
 task wrap_write();
   begin
    @(posedge Hclk)
    #1;
     begin
      Haddr = 32'h8000_0048;
      Hwrite=1;
      Hreadyin=1;
      Htrans =2'd2; 
      Hburst=3'd3;
      Hsize=1;
     end
    @(posedge Hclk)
      #1;
       begin
        Haddr={Haddr[31:3],Haddr[2:1]+1'b1,Haddr[0]};
        Htrans =2'd3; 
        Hwdata=($random)%256;    
       end
    for(j=0;j<2;j=j+1)
    begin
     @(posedge Hclk)
        #1;
         begin
          Haddr={Haddr[31:3],Haddr[2:1]+1'b1,Haddr[0]};
          Hwdata=($random)%256;    
         end
         @(posedge Hclk)
                 #1;
                  begin
                 Htrans=0;
                   Hwdata=($random)%256;    
                  end
    end 
   end
  endtask

endmodule
