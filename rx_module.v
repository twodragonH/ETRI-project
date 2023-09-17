module uart_rx(
    input wire clk,
    input wire rx_data,
    output reg [7:0] dout,
    output reg en
);
    localparam IDEL=0, START=1, DATA=2, STOP=3;

    (*keep="true"*) reg [1:0] state;
    (*keep="true"*) reg [3:0] counter;
    (*keep="true"*) reg [7:0] out_data;

    always @(posedge clk) begin
        case (state)
            IDEL  : if(rx_data==0) state <= START;
                    else state <= IDEL;
            START : state <= DATA;
            DATA  : if(counter==8) state <= STOP;
                    else state <= DATA;
            STOP :  state <= IDEL;
            default: state <= IDEL;
        endcase
    end
    
    always @(posedge clk) begin
        case (state)
            START : out_data[counter] <= rx_data;  
            DATA : out_data[counter] <= rx_data;
            default: out_data <= out_data;
        endcase
    end

    always @(posedge clk) begin
        case (state)
            STOP : dout <= out_data;
            default: dout <= dout;
        endcase
    end

    always @(posedge clk) begin
        case (state)
            STOP : en <= 1;
            default: en <= 0;
        endcase
    end

    always @(posedge clk) begin
        case (state)
            START: counter <= 1;
            DATA :if(counter==8) counter <= 0;
                  else counter <= counter + 1;
            default: counter <= 0;
        endcase
    end

endmodule
