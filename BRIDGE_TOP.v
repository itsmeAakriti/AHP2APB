`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.07.2024 17:44:59
// Design Name: 
// Module Name: BRIDGE_TOP
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


module BRIDGE_TOP(
input Hclk,Hresetn,Hwrite,Hreadyin,
input [1:0]Htrans,
input [31:0]Haddr,Hwdata,Prdata,
output Pwrite,Penable,Hreadyout,
output [2:0]Pselx,
output [31:0]Paddr,Pwdata,Hrdata,
output [1:0]Hresp
    );
    wire valid,Hwritereg;
    wire [31:0]Hadrr1,Haddr2,Hwdata1,Hwdata2;
    wire [2:0]templselx;
  AHB_SLAVE S1(Hclk,Hresetn,Hwrite,Hreadyin,Htrans,Haddr,Hwdata,Prdata,valid,Haddr1,Haddr2,Hwdata1,Hwdata2,Hrdata,Hwritereg,tempselx,Hresp);
  APB_CONTROLLER C1(Hclk,Hresetn,valid,Hwrite,Hwritereg,Haddr,Haddr1,Haddr2,Prdata,Hwdata,Hwdata1,Hwdata2,tempselx,Hreadyout,Penable,Pwrite,Paddr,Pwdata,Pselx );
endmodule
