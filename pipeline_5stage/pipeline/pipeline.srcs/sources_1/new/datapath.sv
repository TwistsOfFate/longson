module datapath(

    input  logic          clk               ,
    input  logic          resetn            ,
    
    // the instr fetched
    input  logic [31:0]   f_instr           ,
    
    // whether wait for RAM 
    input  logic          insert_stall      ,
    
    // signals of the corresponding instr
    input  logic          e_memtoreg        ,
    input  logic          m_memtoreg        ,
    input  logic          w_memtoreg        ,
    
    input  logic          e_regwrite        ,
    input  logic          m_regwrite        ,
    input  logic          w_regwrite        ,
    
    input  logic          d_pcsrc           ,
    input  logic          e_regdst          ,
   
    // tell what the instr is
    input  logic          d_isbranch        ,
    input  logic [ 2:0]   d_branch          ,
    
    input  logic          d_isjump          , 
    input  logic [ 1:0]   d_jump            ,
        
    input  logic [ 2:0]   e_alu_func        ,
    input  logic [ 1:0]   e_sft_func        ,
    
    input  logic          e_imm_sign        ,
    input  logic          e_mul_sign        ,
    input  logic          e_div_sign        ,
    
    input  logic          e_intovf_en       ,
    input  logic          e_out_sel         ,
    
    input  logic          e_alu_srcb_sel_rt ,
    input  logic          e_sft_srcb_sel_rs ,
    
    input  logic          w_writer31        ,
    
    
    // interact with dmem
    input  logic [31:0]   m_readdata        ,      // read data from mem
    output logic [31:0]   m_aluout          ,      // write data to this addr
    output logic [31:0]   m_writedata       ,      // write data to mem
    
    // give the controller the inf of instr 
    output logic [ 5:0]   d_op              , 
    output logic [ 5:0]   d_funct           ,
    output logic [ 4:0]   d_branchfunct     ,
      
    // the next pc 
    output logic [31:0]   f_pc              ,
    
    // whether choose to flush 
    output logic          e_flush           ,
        
    //compare num
    output logic          d_equal           ,
    output logic          d_g0              ,
    output logic          d_e0                   
    
    );

logic [31:0] f_pcplus4, d_pcplus4  ;
logic [31:0] pcnextbr, d_pcbranch, pcnextjr  ;
logic [31:0] d_instr  ;
logic [31:0] d_signimm, d_signimmsh ;
logic [ 4:0] d_rs, d_rt, d_rd, d_sa ;
logic [ 4:0] e_rs, e_rt, e_rd, e_sa ;
logic [ 5:0] e_op, e_funct ;


//---------------------------branchcompare---------------------------------------    
eqcmp   cmpeq(
    .a  (/*rs after forward*/)  ,
    .b  (/*rt after forward*/)  ,
    .eq (d_equal)    
);

Compare cmp0(
    .valA    (/*rs*/) ,
    .greater (d_g0)   ,
    .equal   (d_e0) 
);

//---------------------------branch---------------------------------------    
adder   pcadd1( 
    .add_valA   (f_pc)      ,
    .add_valB   (32'b100)   ,
    .add_result (f_pcplus4) 
) ; //add 4 to get the pc in the delay slot

signext se(
    .ext_valA   (d_instr[15:0]) ,
    .ext_result (d_signimm)     
) ; //imm extends to 32 bits

sl2     immsh(
    .sl2_valA   (d_signimm)     ,
    .sl2_result (d_signimmsh)   
) ; //imm shifts left 2

adder   pcadd2(
    .add_valA   (d_pcplus4)     ,
    .add_valB   (d_signimmsh)   ,
    .add_result (d_pcbranch)    
) ; //add pc in the delay slot and imm

mux2 #(32) pcbrmux(
    .mux2_valA  (f_pcplus4)     ,
    .mux2_valB  (d_pcbranch)    ,
    .mux2_sel   (d_pcsrc)       ,
    .mux2_result(pcnextbr)      
) ;//next pc


//---------------------------------------------------------------------------

//use w_writer31 as a signal to regfile to write the data

mux2 #(32) pcmux(
    .mux2_valA  (pcnextbr)                                ,
    .mux2_valB  ({f_pcplus4[31:28],d_instr[25:0],2'b00})  ,
    .mux2_sel   (~d_jump[0])                              ,
    .mux2_result(pcnextjpc)
) ;
mux2 #(32) pcmux(
    .mux2_valA  (pcnextjpc) ,
    .mux2_valB  (/*forward_result*/) ,
    .mux2_sel   (d_jump[0]) ,
    .mux2_result(pcnextjr)  ,
) ;


// jump 
// data -> w_pcplus4 signal -> w_jump[1] addr ->  (JALR -> w_RD JAL -> R31)

// branch 
// data -> w_pcbranch signal -> w_writer31 addr -> R31


// transfer the data 
flopenr   #(32) r1D(
    .clk       (clk)       ,
    .reset     (resetn)    ,
    .en        (~d_stall)  ,
    .val_before(f_pcplus4) ,
    .val_after (d_pcplus4) , 
) ;

flopenr   #(32) r2D(
    .clk       (clk)       ,
    .reset     (resetn)    ,
    .en        (~d_stall)  ,
    .val_before(f_instr)   ,
    .val_after (d_instr)   , 
) ;

flopr    #(32) r3D(
    .clk       (clk)                                     ,
    .reset     (resetn)                                  ,
    .val_before({d_op, d_rs, d_rt, d_rd, d_sa, d_funct}) ,
    .val_after ({e_op, e_rs, e_rt, e_rd, e_sa, e_funct})  
) ;



//forward 


// always @(*)
// begin
//     if(f_pc[1:0] != 2'b00)
//     begin
        
//     end
// end


assign d_op          = d_instr[31:26] ;
assign d_funct       = d_instr[5:0]   ;
assign d_rs          = d_instr[25:21] ;
assign d_rt          = d_instr[20:16] ;
assign d_rd          = d_instr[15:11] ;
assign d_sa          = d_instr[10:6]  ;
assign d_branchfunct = d_instr[20:16] ;

    
    
    
    
    
    
endmodule
