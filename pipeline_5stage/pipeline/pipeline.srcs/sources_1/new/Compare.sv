`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2020 11:46:08 AM
// Design Name: 
// Module Name: Compare
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


module Compare(
    
    input  logic signed [31:0] valA      ,
    
    output logic               greater   ,
    output logic               equal       
    
    );

assign greater   = (valA >  0) ;
assign equal     = (valA == 0) ;

    
endmodule
