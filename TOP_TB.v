`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2024 16:09:01
// Design Name: 
// Module Name: TOP_TB
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


module TOP_TB();

reg Hclk,Hresetn;
wire [31:0]Haddr,Hwdata,Hrdata,Paddr,Pwdata,Pwdata_out,pr_data;
wire [1:0] Hresp,Htrans;
wire [2:0] tempselx,Pselx,Pselx_out;
wire Hreadyout,Hwrite,Hreadyin,Hwritereg,Penable,Pwrite_out,Penable_out;

AHB_MASTER ahb( Hclk,Hresetn,Hreadyout,Hrdata,Haddr,Hwdata,Hwrite,Hreadyin,Htrans);
APB_INTERFACE apb (Pwrite,Pselx,Penable,Paddr,Pwdata,Pwriteout,Pselxout,Penableout,Paddrout,Pwdataout,Prdata);
BRIDGE_TOP bridge(Hclk,Hresetn,Hwrite,Hreadyin,Htrans,Haddr,Hwdata,Prdata, Pwrite,Penable,Hreadyout,Pselx,Paddr,Pwdata,Hrdata,Hresp);
   
   initial begin
   Hclk=1'b0;
   forever Hclk=~Hclk;
   end
   
   
   task reset();
   begin
    @(negedge Hclk)
    Hresetn=1'b0;
    @(negedge Hclk)
    Hresetn=1'b1;
   end
   endtask
   initial begin
    reset;
    ahb.single_write();
   // ahb.burst_write();
    //ahb.single_read();
    //ahb.burst_read();
    end
endmodule
