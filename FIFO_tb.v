module tb_FIFO;

    parameter data_size = 8;
    parameter depth = 8;

    reg clk;
    reg rst;
    reg writeEN;
    reg readEN;
    reg [data_size-1:0] DIN;
    wire [data_size-1:0] DOUT;
    wire empty, full;

    // Instantiate the FIFO module
    FIFO #(data_size, depth) uut (
        .DOUT(DOUT),
        .empty(empty),
        .full(full),
        .clk(clk),
        .rst(rst),
        .readEN(readEN),
        .writeEN(writeEN),
        .DIN(DIN)
    );
    
    integer i;
    // Clock generation
    initial clk = 0;
    always  #5 clk = ~clk; 

    initial begin
        //Reset FIFO.
        rst = 1; writeEN = 0; readEN = 0; DIN = 0;
        
        #8 rst = 0; writeEN = 1;
        
        //Write data to FIFO.
        for (i=0; i<depth; i=i+1) begin 
            DIN <= $random % 256;
            #10;
        end 
        
        writeEN = 0; readEN = 1;
        
        //Read data from FIFO
        for (i=0; i<depth; i=i+1) begin
            #10;
        end

        readEN = 0;                           
        //FIFO is empty now.
        // Finish simulation
        #20 $stop;
    end

endmodule
