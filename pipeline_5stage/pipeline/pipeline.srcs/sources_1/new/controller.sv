`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2020 10:42:59 AM
// Design Name: 
// Module Name: controller
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


module controller(
    
     input  logic       clk        , 
     input  logic       resetn     ,
     input  logic [5:0] d_op       , 
     input  logic [5:0] d_funct    ,
     input  logic       e_flush    , 
     
     output logic       e_memtoreg , 
     output logic       m_memtoreg , 
     output logic       w_memtoreg , 
     output logic       e_regwrite , 
     output logic       m_regwrite ,
     output logic       w_regwrite ,
     output logic       d_pcsrc    ,
     output logic       e_alusrc   ,
     output logic       e_regdst   , 
     
     output logic       m_memwrite ,
     
     
     output logic [2:0] d_branch   ,
     output logic [1:0] d_jump     ,
     output logic       d_jr       ,
     output logic [2:0] e_alu_func ,
     output logic [1:0] e_sft_func  
     
    );
    
    
    
    
    
    
endmodule
