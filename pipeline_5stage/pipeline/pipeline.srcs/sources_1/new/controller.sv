module controller(
    
     input  logic       clk               , 
     input  logic       resetn            ,
     input  logic [5:0] d_op              , 
     input  logic [5:0] d_funct           ,
     input  logic [4:0] d_branchfunct     ,
     input  logic       e_flush           ,
     
     input  logic       d_equal           ,
     input  logic       d_g0              ,
     input  logic       d_e0              , 
     
     output logic       e_memtoreg        , 
     output logic       m_memtoreg        , 
     output logic       w_memtoreg        , 
     
     output logic       e_regwrite        , 
     output logic       m_regwrite        , 
     output logic       w_regwrite        ,
      
     output logic       d_pcsrc           , 
     output logic       e_regdst          , 
     
     output logic       m_memwrite        , 
     
     output logic       d_isbranch        ,
     output logic [2:0] d_branch          , 
     
     output logic       d_isjump          ,
     output logic [1:0] d_jump            , 
     
     output logic [2:0] e_alu_func        , 
     output logic [1:0] e_sft_func        , 
     
     output logic       e_imm_sign        , 
     output logic       e_mul_sign        , 
     output logic       e_div_sign        , 
     
     output logic       e_intovf_en       , 
     output logic       e_out_sel         , 
     
     output logic       e_alu_srcb_sel_rt , 
     output logic       e_sft_srcb_sel_rs ,
     
     output logic       w_writer31          
     
    );
    
logic        d_memtoreg, d_regwrite, d_memwrite, e_memwrite, d_regdst, d_regwrite ;

logic [ 2:0] d_alu_func ;
logic [ 1:0] d_sft_func ; 
logic        d_imm_sign, d_mul_sign, d_div_sign, d_intovf_en, d_out_sel, d_alu_srcb_sel_rt, d_sft_srcb_sel_rs ;
logic [22:0] controls  ;

logic [ 7:0] branch ;

logic        d_writer31, e_writer31, m_writer31 ;

assign {d_memtoreg, d_regwrite, d_regdst, d_memwrite, d_isbranch, d_branch, d_jump, d_alu_func, d_sft_func, d_imm_sign, d_mul_sign, d_div_sign, d_intovf_en, d_out_sel, d_alu_srcb_sel_rt, d_sft_srcb_sel_rs, d_writer31} = controls ;

always@(posedge clk)
begin
    case(d_op)
    
        6'b000000: 
        begin
            case(d_funct)
                6'b100000: //ADD
                    controls <= ;
                6'b100001: //ADDU
                    controls <= ;
                6'b100010: //SUB
                    controls <= ;
                6'b100011: //SUBU
                    controls <= ;
                6'b101010: //SLT
                    controls <= ;
                6'b101011: //SLTU
                    controls <= ;
                6'b011010: //DIV
                    controls <= ;
                6'b011011: //DIVU
                    controls <= ;
                6'b011000: //MULT
                    controls <= ;
                6'b011001: //MULTU
                    controls <= ;
                6'b100100: //AND
                    controls <= ;
                6'b100111: //NOR
                    controls <= ;
                6'b100101: //OR
                    controls <= ;
                6'b100110: //XOR
                    controls <= ;
                6'b000100: //SLLV
                    controls <= ;
                6'b000000: //SLL
                    controls <= ;
                6'b000111: //SRAV
                    controls <= ;
                6'b000011: //SRA
                    controls <= ;
                6'b000110: //SRLV
                    controls <= ;
                6'b000010: //SRL
                    controls <= ;         
                6'b001000: //JR
                    controls <= ;
                6'b001001: //JALR
                    controls <= ;
                6'b010000: //MFHI
                    controls <= ;
                6'b010010: //MFLO
                    controls <= ;
                6'b010001: //MTHI
                    controls <= ;
                6'b010011: //MTLO
                    controls <= ;
            endcase                                           
        end
        
        6'b001000://ADDI
            controls <= ;
        6'b001001://ADDIU
            controls <= ;
        6'b001010://SLTI
            controls <= ;
        6'b001011://SLTIU
            controls <= ;
        6'b001100://ANDI
            controls <= ;
        6'b001111://LUI
            controls <= ;
        6'b001101://ORI
            controls <= ;
        6'b001110://XORI
            controls <= ;
        6'b000100://BEQ
            controls <= ;
        6'b000101://BNE
            controls <= ;
        6'b000001:
        begin 
            case(branchfunct)
                5'b00001: //BGEZ
                    controls <= ;
                5'b00000: //BLTZ
                    controls <= ;
                5'b10001: //BGEZAL
                    controls <= ;
                5'b10000: //BLTZAL
                    controls <= ;
            endcase                      
        end    
        6'b000111://BGTZ
            controls <= ;
        6'b000110://BLEZ
            controls <= ;
        6'b000001://BLTZ
            controls <= ;
        6'b000010: //J
            controls <= ;
        6'b000011: //JAL
            controls <= ;
        6'b100000://LB
            controls <= ;
        6'b100100://LBU
            controls <= ;
        6'b100001://LH
            controls <= ;
        6'b100101://LHU
            controls <= ;
        6'b100011://LW
            controls <= ;
        6'b101000://SB
            controls <= ;
        6'b101001://SH
            controls <= ;
        6'b101011://SW
            controls <= ;                                
       
    endcase    
end



assign branch[0] = (d_branch == 3'b000) &&  d_equal  && d_isbranch ;
assign branch[1] = (d_branch == 3'b001) && !d_equal  && d_isbranch ;
assign branch[2] = (d_branch == 3'b010) &&  (d_g0 | d_e0) && d_isbranch ;
assign branch[3] = (d_branch == 3'b011) &&  d_g0  && d_isbranch ;
assign branch[4] = (d_branch == 3'b100) &&  !d_g0 && d_isbranch ;
assign branch[5] = (d_branch == 3'b101) && (!d_g0 && !d_e0) && d_isbranch ;
assign branch[6] = (d_branch == 3'b110) && (d_g0 | d_e0) && d_isbranch ;
assign branch[7] = (d_branch == 3'b111) && (!d_g0 && !d_e0) && d_isbranch ;

assign d_pcsrc = |branch ;    
    
    
    
    
    
    
endmodule
