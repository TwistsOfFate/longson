`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2020 11:25:47 AM
// Design Name: 
// Module Name: datapath
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


module datapath(

    input  logic          clk           ,
    input  logic          resetn        ,
    
    // the instr fetched
    input  logic [31:0]   f_instr       ,
    
    
    // signals of the corresponding instr
    input  logic          e_memtoreg    ,
    input  logic          m_memtoreg    ,
    input  logic          w_memtoreg    ,
    input  logic          e_regwrite    ,
    input  logic          m_regwrite    ,
    input  logic          w_regwrite    ,
    input  logic          d_pcsrc       ,
    input  logic          e_alusrc      ,
    input  logic          e_regdst      ,
   
    // tell what the instr is
    input  logic [ 2:0]   d_branch      , 
    input  logic [ 1:0]   d_jump        ,
    input  logic          d_jr          ,
    input  logic [ 2:0]   e_alu_func    ,
    input  logic [ 1:0]   e_sft_func    ,
    
    
    // interact with dmem
    input  logic [31:0]   m_readdata    ,      // read data from mem
    output logic [31:0]   m_aluout      ,      // write data to this addr
    output logic [31:0]   m_writedata   ,      // write data to mem
    
    // give the controller the inf of instr 
    output logic [ 5:0]   d_op          , 
    output logic [ 5:0]   d_funct       ,
      
    // the next pc 
    output logic [31:0]   f_pc          ,
    
    // whether choose to flush 
    output logic          e_flush
    
    );
endmodule
