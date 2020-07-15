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
    input  logic [ 1:0]   e_regdst          ,

    input  logic          m_memreq          , 
    input  logic          m_memwr           ,
   
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
    input  logic [ 1:0]   e_out_sel         ,
    
    input  logic          e_alu_srcb_sel_rt ,
    input  logic          e_sft_srcb_sel_rs ,
    
    input  logic          m_link            , // +8
    input  logic          m_reserved_instr  ,
    input  logic          m_break           ,
    input  logic          m_syscall         ,
    input  logic          m_rdata_sign      ,            
    
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
    output logic          d_e0              ,

    output logic [31:0]   debug_wb_pc       ,
    output logic          debug_wb_rf_wen   ,
    output logic [ 4:0]   debug_wb_rf_wnum  ,
    output logic [31:0]   debug_wb_rf_wdata 

    
    );

logic [31:0] f_pcplus4, d_pcplus4  ;
logic [31:0] pcnextbr, d_pcbranch, pcnextjr  ;
logic [31:0] d_instr  ;
logic [31:0] d_signimm, d_signimmsh ;
logic [ 4:0] d_rs, d_rt, d_rd, d_sa ;
logic [ 4:0] e_rs, e_rt, e_rd, e_sa ;
logic [ 5:0] e_op, e_funct ;
logic        f_isindelayslot, d_isindelayslot, e_isindelayslot, m_isindelayslot ;
logic [31:0] delayslot_addr ;
logic [ 4:0] m_writereg, w_writereg ; 
logic [ 1:0] d_forwarda, d_forwardb ;
logic [ 1:0] e_forwarda, e_forwardb ;
logic        f_stall, d_stall, e_flush ;
logic [31:0] d_rsdata, d_rtdata ;
logic [31:0] e_rsdata, e_rtdata ;
logic [31:0] d_for_rsdata, d_for_rtdata ;
logic [31:0] e_for_rsdata, e_for_rtdata ;
logic [31:0] e_ex_out, m_ex_out, w_ex_out ;
logic [31:0] w_reg_wdata ;
logic [31:0] w_memreg_out ;
logic f_addr_err_if, d_addr_err_if ;
logic f_stall_tmp ;

assign f_stall = f_stall_tmp || insert_stall ;

//---------------------------hazardmodule---------------------------------------
hazard hz(
    .d_rs(d_rs),
    .d_rt(d_rt),
    .e_rs(e_rs),
    .e_rt(e_rt),

    .e_writereg(e_writereg),
    .m_writereg(m_writereg),
    .w_writereg(w_writereg),

    .e_regwrite(e_regwrite),
    .m_regwrite(m_regwrite),
    .w_regwrite(w_regwrite),

    .e_memtoreg(e_memtoreg),
    .m_memtoreg(m_memtoreg),

    .d_isbranch(d_isbranch),

    .d_forwarda(d_forwarda),
    .d_forwardb(d_forwardb),

    .e_forwarda(e_forwarda),
    .e_forwardb(e_forwardb),

    .f_stall(f_stall_tmp),
    .d_stall(d_stall),
    .e_flush(e_flush)


);


regfile rf(
    .clk           (clk)         ,
    .reset         (resetn)      ,
    .regwrite_en   (regwriteW)   ,
    .regwrite_addr (writeregW)   ,
    .regwrite_data (w_reg_wdata) , //mux2
    .rs_addr       (d_rs)        ,
    .rt_addr       (d_rt)        ,
    .rs_data       (d_rsdata)    ,
    .rt_data       (d_rtdata)
);


//---------------------------branchcompare---------------------------------------    
eqcmp   cmpeq(
    .a  (d_for_rsdata)  ,
    .b  (d_for_rtdata)  ,
    .eq (d_equal)    
);

Compare cmp0(
    .valA    (d_for_rsdata) ,
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

setdelayslot setds(
    .clk           (clk)            ,
    .resetn        (resetn)         ,
    .en            (d_isbranch)     ,
    .addr          (d_pcplus4)      ,
    .delayslot_sig (f_isindelayslot), // Because this edition has no bpb, so the next pc must be the previous pc+4, if we add bpb, we must make some changes
    .delayslot_addr(delayslot_addr) 
) ;


//---------------------------------------------------------------------------

//use w_writer31 as a signal to regfile to write the data

mux2 #(32) pcjmux(
    .mux2_valA  (pcnextbr)                                ,
    .mux2_valB  ({f_pcplus4[31:28],d_instr[25:0],2'b00})  ,
    .mux2_sel   (~d_jump[0])                              ,
    .mux2_result(pcnextjpc)
) ;

mux2 #(32) pcjrmux(
    .mux2_valA  (pcnextjpc) ,
    .mux2_valB  (d_for_rsdata) ,
    .mux2_sel   (d_jump[0]) ,
    .mux2_result(pcnextjr)  ,
) ;

mux3 #(5)  wrmux(
    .mux3_valA  (e_rt)        ,
    .mux3_valB  (e_rd)        ,
    .mux3_valC  (5'd31)       ,
    .mux3_sel   (e_regdst)    ,
    .mux3_result(e_writereg)    
) ;

//---------------------------forward---------------------------------------    
mux2 #(32) resmux(
    .mux2_valA   (w_ex_out)     ,
    .mux2_valB   (w_rdata_out)  ,
    .mux2_sel    (w_memtoreg)   ,
    .mux2_result (w_memreg_out)
) ;

mux3 #(32) d_forwardrsmux(
    .mux3_valA   (d_rsdata)     ,
    .mux3_valB   (w_memreg_out)  ,
    .mux3_valC   (m_ex_out)     ,
    .mux3_sel    (d_forwarda)   ,
    .mux3_result (d_for_rsdata) 
) ;

mux3 #(32) d_forwardrtmux(
    .mux3_valA   (d_rtdata)     ,
    .mux3_valB   (w_memreg_out)  ,
    .mux3_valC   (m_ex_out)     ,
    .mux3_sel    (d_forwardb)   ,
    .mux3_result (d_for_rtdata) 
) ;

mux3 #(32) e_forwardrsmux(
    .mux3_valA   (e_rsdata)     ,
    .mux3_valB   (w_memreg_out)  ,
    .mux3_valC   (m_ex_out)     ,
    .mux3_sel    (e_forwarda)   ,
    .mux3_result (e_for_rsdata)
) ;

mux3 #(32) e_forwardrtmux(
    .mux3_valA  (e_rtdata)      ,
    .mux3_valB  (w_memreg_out)   ,
    .mux3_valC  (m_ex_out)      ,
    .mux3_sel   (e_forwarda)    ,
    .mux3_result(e_for_rtdata)
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
    .val_after (d_pcplus4) 
) ;

flopenr   #(32) r2D(
    .clk       (clk)       ,
    .reset     (resetn)    ,
    .en        (~d_stall)  ,
    .val_before(f_instr)   ,
    .val_after (d_instr)    
) ;

flopr    #(32) r3D(
    .clk       (clk)                                     ,
    .reset     (resetn)                                  ,
    .val_before({d_op, d_rs, d_rt, d_rd, d_sa, d_funct}) ,
    .val_after ({e_op, e_rs, e_rt, e_rd, e_sa, e_funct})  
) ;





//forward 


assign f_addr_err_if = (f_pc[1:0] != 2'b00) ;


assign d_op          = d_instr[31:26] ;
assign d_funct       = d_instr[5:0]   ;
assign d_rs          = d_instr[25:21] ;
assign d_rt          = d_instr[20:16] ;
assign d_rd          = d_instr[15:11] ;
assign d_sa          = d_instr[10:6]  ;
assign d_branchfunct = d_instr[20:16] ;

    
    
    
    
    
    
endmodule
