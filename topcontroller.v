
module topcontroller(   input clk,
                        input rst,
                        input rxd,
                        output txd );
    
    wire [15:0] prescale=100000000/(115200*8);
    
    wire [7:0] senddata;
    reg sendvalid=0;
    
    wire [7:0] readdata;
    wire readvalid;
    
    reg [1:0] state=0;
    
    reg [15:0] data1=0,data2=0;
    
   
    uart uartuut(
    .clk(clk),
    .rst(rst),
    .s_axis_tdata(senddata),
    .s_axis_tvalid(sendvalid),
    .m_axis_tdata(readdata),
    .m_axis_tvalid(readvalid),
    .m_axis_tready(1),
    .rxd(rxd),
    .txd(txd),
    .prescale(prescale)

);

adder adderuut (.clk(clk),
                .data1(data1),
                .data2(data2),
                .dataout(senddata));

always @(posedge clk) begin
    if(rst==1) begin
        state=0;
        sendvalid=0;
        data1=0;
        data2=0;
    end
    
    case(state)
    
    2'b00: begin 
            sendvalid=0;
            if(readvalid) begin
                    state=2'b01;
                    data1=readdata;
                end
            end
    2'b01: if(readvalid) begin
            state=2'b10;
            data2=readdata;
            end
    2'b10: begin
               sendvalid=1;
               state=2'b00;
           end
    
    endcase

end


endmodule
