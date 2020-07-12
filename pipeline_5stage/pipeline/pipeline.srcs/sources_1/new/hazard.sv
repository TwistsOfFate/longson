module hazard(input  logic [4:0] d_rs, d_rt, e_rs, e_rt,
              input  logic [4:0] e_writereg, m_writereg, w_writereg,
              input  logic       e_regwrite, m_regwrite, w_regwrite,
              input  logic       e_memtoreg, m_memtoreg,
              input  logic       d_isbranch,
              output logic       d_forwarda, d_forwardb,
              output logic [1:0] e_forwarda, e_forwardb,
              output logic       f_stall, d_stall, e_flush);
              
    
logic d_lwstall, d_branchstall ;

assign d_forwarda = ( (d_rs != 0) && (d_rs == m_writereg) && m_regwrite ) ;
assign d_forwardb = ( (d_rt != 0) && (d_rt == m_writereg) && m_regwrite ) ;
    
always@(*)
    begin
        e_forwarda = 2'b00 ; e_forwardb = 2'b00 ;
        if(e_rs != 0)
            if((e_rs == m_writereg) && m_regwrite) e_forwarda = 2'b10 ;
            else if ((e_rs == w_writereg) && w_regwrite) e_forwarda = 2'b01 ;
            else e_forwarda = 2'b00 ;
        if(e_rt != 0)
            if((e_rt == m_writereg) && m_regwrite) e_forwardb = 2'b10 ;
            else if ((e_rt == w_writereg) && w_regwrite) e_forwardb = 2'b01 ;
            else e_forwardb = 2'b00 ;
            
    end
        
assign d_lwstall = e_memtoreg && ((e_rt == d_rs) || (e_rt == d_rt)) ;
assign d_branchstall = ( d_isbranch ) && ((e_regwrite && ((e_writereg == d_rs) 
|| (e_writereg == d_rt))) || (m_memtoreg &&  ((m_writereg == d_rs) || (m_writereg == d_rt)))) ;
assign d_stall = d_lwstall | d_branchstall ;
assign f_stall = d_stall ;
assign e_flush = d_stall ;
    
              
              
endmodule