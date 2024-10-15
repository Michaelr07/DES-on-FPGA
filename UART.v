module uart_des(
    input clk,
    input rst,  
    input UART_RX,
    input ptorkey, encryption,
    output reg [15:0] LED,
    output UART_TX
);

  // UART Rx signals
  wire o_Rx_DV;
  wire [7:0] o_Rx_Byte;

  // UART Tx signals
  reg o_Tx_DV;
  reg [7:0] o_Tx_Byte;
  wire o_Tx_Ready;

  // 64-bit input buffer
  reg [63:0] input_buffer;
  reg [63:0] input_buffer_key;
  reg [5:0] nibble_count;

  // State machine
  reg [2:0] state;
  localparam IDLE = 3'd0,
             WAIT_FOR_SWITCH = 3'd1,
             RECEIVE_KEY = 3'd2,
             RECEIVE_MESSAGE = 3'd3,
             WAIT_ENCRYPT = 3'd4,
             ENCRYPT = 3'd5,
             TRANSMIT = 3'd6,
             TRANSMIT_NEWLINE = 3'd7;
  
  uart_tx_vlog tx0 (clk, o_Tx_DV, o_Tx_Byte, UART_TX, tx_done, o_Tx_Ready);
  uart_rx_vlog rx0 (clk, UART_RX, o_Rx_DV, o_Rx_Byte);

  reg [63:0] tx_buffer;

  // Instantiate DES Encryption module
  wire [63:0] des_cipher_text;
  DES_Encryption des_inst (
    .encryption(encryption),
    .key(input_buffer_key),
    .plaintext(input_buffer),
    .ciphertext(des_cipher_text)
  );

  // Main state machine with reset logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Reset all signals to their initial state
      state <= IDLE;
      nibble_count <= 0;
      input_buffer <= 64'b0;
      input_buffer_key <= 64'b0;
      tx_buffer <= 64'b0;
      o_Tx_DV <= 0;
      LED <= 16'b0;
    end else begin
      // Main state machine behavior
      LED[15:3] <= {des_cipher_text[63:51]};
      
      case (state)
        IDLE: begin
          LED[2:0] <= 3'b001;
          o_Tx_DV <= 0;
          nibble_count <= 0;
          if (ptorkey) begin
            state <= WAIT_FOR_SWITCH;
          end
        end

        WAIT_FOR_SWITCH: begin
          LED[2:0] <= 3'b010;
          if (o_Rx_DV && o_Rx_Byte == " ") begin
            nibble_count <= 0;
            state <= RECEIVE_KEY;
          end
        end

        RECEIVE_KEY: begin
          LED[2:0] <= 3'b011;
          if (o_Rx_DV) begin
            input_buffer_key[(nibble_count * 4) +: 4] <= (o_Rx_Byte >= "0" && o_Rx_Byte <= "9") ? (o_Rx_Byte - "0") :
                                                         (o_Rx_Byte >= "A" && o_Rx_Byte <= "F") ? (o_Rx_Byte - "A" + 4'hA) :
                                                         (o_Rx_Byte >= "a" && o_Rx_Byte <= "f") ? (o_Rx_Byte - "a" + 4'hA) : 4'b0000;
            nibble_count <= nibble_count + 1;
            if (nibble_count == 15) begin
              nibble_count <= 0;
              state <= RECEIVE_MESSAGE;
            end
          end
        end

        RECEIVE_MESSAGE: begin
          LED[2:0] <= 3'b100;
          if (o_Rx_DV) begin
            input_buffer[(nibble_count * 4) +: 4] <= (o_Rx_Byte >= "0" && o_Rx_Byte <= "9") ? (o_Rx_Byte - "0") :
                                                     (o_Rx_Byte >= "A" && o_Rx_Byte <= "F") ? (o_Rx_Byte - "A" + 4'hA) :
                                                     (o_Rx_Byte >= "a" && o_Rx_Byte <= "f") ? (o_Rx_Byte - "a" + 4'hA) : 4'b0000;
            nibble_count <= nibble_count + 1;
            if (nibble_count == 15) begin
              nibble_count <= 0;
              state <= WAIT_ENCRYPT;
            end
          end
        end

        WAIT_ENCRYPT: begin
          LED[2:0] <= 3'b101;
          tx_buffer <= {des_cipher_text[3:0], des_cipher_text[7:4], des_cipher_text[11:8], des_cipher_text[15:12], 
                        des_cipher_text[19:16], des_cipher_text[23:20], des_cipher_text[27:24], des_cipher_text[31:28], 
                        des_cipher_text[35:32], des_cipher_text[39:36], des_cipher_text[43:40], des_cipher_text[47:44], 
                        des_cipher_text[51:48], des_cipher_text[55:52], des_cipher_text[59:56], des_cipher_text[63:60]};
          state <= ENCRYPT;
        end

        ENCRYPT: begin
          LED[2:0] <= 3'b110;
          nibble_count <= 32;
          state <= TRANSMIT;
        end

        TRANSMIT: begin
          LED[2:0] <= 3'b111;
          if (o_Tx_Ready && nibble_count > 0) begin
            o_Tx_DV <= 1;
            if (nibble_count[0] == 1'b1) begin
              o_Tx_Byte <= (tx_buffer[7:4] < 10) ? (tx_buffer[7:4] + "0") : (tx_buffer[7:4] - 10 + "A");
            end else begin
              o_Tx_Byte <= (tx_buffer[3:0] < 10) ? (tx_buffer[3:0] + "0") : (tx_buffer[3:0] - 10 + "A");
              tx_buffer <= {4'b0, tx_buffer[63:4]};
            end
            nibble_count <= nibble_count - 1;
          end else if (nibble_count == 0) begin
            o_Tx_DV <= 1;     
            state <= TRANSMIT_NEWLINE;
          end else begin
            o_Tx_DV <= 0;
          end
        end

        TRANSMIT_NEWLINE: begin
          if (o_Tx_Ready) begin
            o_Tx_DV <= 1;
            o_Tx_Byte <= 8'h0D;
            o_Tx_Byte <= 8'h0A;
            state <= IDLE;
          end else begin
            o_Tx_DV <= 0;
          end
        end
        
      endcase
    end
  end

endmodule

module uart_tx_vlog 
  (
   input       i_Clock,           // master clock
   input       i_Tx_DV,           // data valid - set high to send byte
   input [7:0] i_Tx_Byte,         // byte to send
   output reg  o_Tx_Serial,       // UART serial TX wire
   output      o_Tx_Done,         // done signal, goes high for 2 clk cycles when finished sending
   output      o_Tx_Ready         // when high, UART TX is ready to send (not busy)
   );
  
  localparam s_IDLE         = 3'b000;
  localparam s_TX_START_BIT = 3'b001;
  localparam s_TX_DATA_BITS = 3'b010;
  localparam s_TX_STOP_BIT  = 3'b011;
  localparam s_CLEANUP      = 3'b100;
  localparam CLKS_PER_BIT   = 14'b10100010110000;   // hard coded to 9600 baud from the 100 MHz master clock
                                                    // i.e. 100 MHz / 9600 Hz = 10416 = 14'b10100010110000
   
  reg [2:0]    r_SM_Main     = 0;
  reg [13:0]    r_Clock_Count = 0;
  reg [2:0]    r_Bit_Index   = 0;
  reg [7:0]    r_Tx_Data     = 0;
  reg          r_Tx_Done     = 0;
  reg          r_Tx_Active   = 0;
     
  always @(posedge i_Clock)
    begin
       
      case (r_SM_Main)
        s_IDLE :
          begin
            o_Tx_Serial   <= 1'b1;         // Drive Line High for Idle
            r_Tx_Done     <= 1'b0;
            r_Clock_Count <= 0;
            r_Bit_Index   <= 0;
             
            if (i_Tx_DV == 1'b1)
              begin
                r_Tx_Active <= 1'b1;
                r_Tx_Data   <= i_Tx_Byte;
                r_SM_Main   <= s_TX_START_BIT;
              end
            else
              r_SM_Main <= s_IDLE;
          end // case: s_IDLE
         
         
        // Send out Start Bit. Start bit = 0
        s_TX_START_BIT :
          begin
            o_Tx_Serial <= 1'b0;
             
            // Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
            if (r_Clock_Count < CLKS_PER_BIT-1)
              begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_SM_Main     <= s_TX_START_BIT;
              end
            else
              begin
                r_Clock_Count <= 0;
                r_SM_Main     <= s_TX_DATA_BITS;
              end
          end // case: s_TX_START_BIT
         
         
        // Wait CLKS_PER_BIT-1 clock cycles for data bits to finish         
        s_TX_DATA_BITS :
          begin
            o_Tx_Serial <= r_Tx_Data[r_Bit_Index];
             
            if (r_Clock_Count < CLKS_PER_BIT-1)
              begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_SM_Main     <= s_TX_DATA_BITS;
              end
            else
              begin
                r_Clock_Count <= 0;
                 
                // Check if we have sent out all bits
                if (r_Bit_Index < 7)
                  begin
                    r_Bit_Index <= r_Bit_Index + 1;
                    r_SM_Main   <= s_TX_DATA_BITS;
                  end
                else
                  begin
                    r_Bit_Index <= 0;
                    r_SM_Main   <= s_TX_STOP_BIT;
                  end
              end
          end // case: s_TX_DATA_BITS
         
         
        // Send out Stop bit.  Stop bit = 1
        s_TX_STOP_BIT :
          begin
            o_Tx_Serial <= 1'b1;
             
            // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
            if (r_Clock_Count < CLKS_PER_BIT-1)
              begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_SM_Main     <= s_TX_STOP_BIT;
              end
            else
              begin
                r_Tx_Done     <= 1'b1;
                r_Clock_Count <= 0;
                r_SM_Main     <= s_CLEANUP;
                r_Tx_Active   <= 1'b0;
              end
          end // case: s_Tx_STOP_BIT
         
         
        // Stay here 1 clock
        s_CLEANUP :
          begin
            r_Tx_Done <= 1'b1;
            r_SM_Main <= s_IDLE;
          end
         
         
        default :
          r_SM_Main <= s_IDLE;
         
      endcase
    end
 
  assign o_Tx_Done   = r_Tx_Done;
  assign o_Tx_Ready = ~r_Tx_Active;  
endmodule

module uart_rx_vlog 
  (
   input        i_Clock,           // master clock
   input        i_Rx_Serial,       // UART serial RX wire
   output       o_Rx_DV,           // data valid - goes high for 1 clk cycle when data byte has been received
   output [7:0] o_Rx_Byte          // byte received
   );

  localparam CLKS_PER_BIT = 14'b10100010110000;   
  localparam s_IDLE         = 3'b000;
  localparam s_RX_START_BIT = 3'b001;
  localparam s_RX_DATA_BITS = 3'b010;
  localparam s_RX_STOP_BIT  = 3'b011;
  localparam s_CLEANUP      = 3'b100;
   
  reg           r_Rx_Data_R = 1'b1;
  reg           r_Rx_Data   = 1'b1;
   
  reg [13:0]    r_Clock_Count = 0;
  reg [2:0]     r_Bit_Index   = 0; //8 bits total
  reg [7:0]     r_Rx_Byte     = 0;
  reg           r_Rx_DV       = 0;
  reg [2:0]     r_SM_Main     = 0;
  
   
  // Purpose: Double-register the incoming data.
  // This allows it to be used in the UART RX Clock Domain.
  // (It removes problems caused by metastability)
  always @(posedge i_Clock)
    begin
      r_Rx_Data_R <= i_Rx_Serial;
      r_Rx_Data   <= r_Rx_Data_R;
    end
   
   
  // Purpose: Control RX state machine
  always @(posedge i_Clock)
    begin
       
      case (r_SM_Main)
        s_IDLE :
          begin
            r_Rx_DV       <= 1'b0;
            r_Clock_Count <= 0;
            r_Bit_Index   <= 0;
             
            if (r_Rx_Data == 1'b0)          // Start bit detected
              r_SM_Main <= s_RX_START_BIT;
            else
              r_SM_Main <= s_IDLE;
          end
         
        // Check middle of start bit to make sure it's still low
        s_RX_START_BIT :
          begin
            if (r_Clock_Count == (CLKS_PER_BIT-1)/2)
              begin
                if (r_Rx_Data == 1'b0)
                  begin
                    r_Clock_Count <= 0;  // reset counter, found the middle
                    r_SM_Main     <= s_RX_DATA_BITS;
                  end
                else
                  r_SM_Main <= s_IDLE;
              end
            else
              begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_SM_Main     <= s_RX_START_BIT;
              end
          end // case: s_RX_START_BIT
         
         
        // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
        s_RX_DATA_BITS :
          begin
            if (r_Clock_Count < CLKS_PER_BIT-1)
              begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_SM_Main     <= s_RX_DATA_BITS;
              end
            else
              begin
                r_Clock_Count          <= 0;
                r_Rx_Byte[r_Bit_Index] <= r_Rx_Data;
                 
                // Check if we have received all bits
                if (r_Bit_Index < 7)
                  begin
                    r_Bit_Index <= r_Bit_Index + 1;
                    r_SM_Main   <= s_RX_DATA_BITS;
                  end
                else
                  begin
                    r_Bit_Index <= 0;
                    r_SM_Main   <= s_RX_STOP_BIT;
                  end
              end
          end // case: s_RX_DATA_BITS
     
     
        // Receive Stop bit.  Stop bit = 1
        s_RX_STOP_BIT :
          begin
            // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
            if (r_Clock_Count < CLKS_PER_BIT-1)
              begin
                r_Clock_Count <= r_Clock_Count + 1;
                r_SM_Main     <= s_RX_STOP_BIT;
              end
            else
              begin
                r_Rx_DV       <= 1'b1;
                r_Clock_Count <= 0;
                r_SM_Main     <= s_CLEANUP;
              end
          end // case: s_RX_STOP_BIT
     
         
        // Stay here 1 clock
        s_CLEANUP :
          begin
            r_SM_Main <= s_IDLE;
            r_Rx_DV   <= 1'b0;
          end
         
         
        default :
          r_SM_Main <= s_IDLE;
         
      endcase
    end   
   
  assign o_Rx_DV   = r_Rx_DV;
  assign o_Rx_Byte = r_Rx_Byte;
   
endmodule // uart_rx