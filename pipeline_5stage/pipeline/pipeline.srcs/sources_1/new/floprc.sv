module floprc #(parameter WIDTH = 8 )
              (input logic clk , reset ,clear,
               input logic [WIDTH-1:0] d,
               output logic [WIDTH-1:0] q );
    initial
        q <= 0 ;          
    always@(posedge clk)
        if(reset) q <= 0 ;
        else if(clear) q <= 0 ;
        else q <= d ;
        
endmodule