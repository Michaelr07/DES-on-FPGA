`timescale 1ns/1ps

module DES_Encryption(
    input encryption,
    output reg [64:1] ciphertext,
    input [64:1] plaintext, [64:1] key
    );
    
// Define IP, IP inverse, E, and P permutations as constants
wire [64:1] IP_perm = { 
    plaintext[64 - 58 + 1], plaintext[64 - 50 + 1], plaintext[64 - 42 + 1], plaintext[64 - 34 + 1], plaintext[64 - 26 + 1], plaintext[64 - 18 + 1], plaintext[64 - 10 + 1],  plaintext[64 - 2 + 1],
    plaintext[64 - 60 + 1], plaintext[64 - 52 + 1], plaintext[64 - 44 + 1], plaintext[64 - 36 + 1], plaintext[64 - 28 + 1], plaintext[64 - 20 + 1], plaintext[64 - 12 + 1], plaintext[64 - 4 + 1],
    plaintext[64 - 62 + 1], plaintext[64 - 54 + 1], plaintext[64 - 46 + 1], plaintext[64 - 38 + 1], plaintext[64 - 30 + 1], plaintext[64 - 22 + 1], plaintext[64 - 14 + 1], plaintext[64 - 6 + 1],
    plaintext[64 - 64 + 1], plaintext[64 - 56 + 1], plaintext[64 - 48 + 1], plaintext[64 - 40 + 1], plaintext[64 - 32 + 1], plaintext[64 - 24 + 1], plaintext[64 - 16 + 1], plaintext[64 - 8 + 1],
    plaintext[64 - 57 + 1], plaintext[64 - 49 + 1], plaintext[64 - 41 + 1], plaintext[64 - 33 + 1], plaintext[64 - 25 + 1], plaintext[64 - 17 + 1], plaintext[64 - 9 + 1],  plaintext[64 - 1 + 1],
    plaintext[64 - 59 + 1], plaintext[64 - 51 + 1], plaintext[64 - 43 + 1], plaintext[64 - 35 + 1], plaintext[64 - 27 + 1], plaintext[64 - 19 + 1], plaintext[64 - 11 + 1], plaintext[64 - 3 + 1],
    plaintext[64 - 61 + 1], plaintext[64 - 53 + 1], plaintext[64 - 45 + 1], plaintext[64 - 37 + 1], plaintext[64 - 29 + 1], plaintext[64 - 21 + 1], plaintext[64 - 13 + 1], plaintext[64 - 5 + 1], 
    plaintext[64 - 63 + 1], plaintext[64 - 55 + 1], plaintext[64 - 47 + 1], plaintext[64 - 39 + 1], plaintext[64 - 31 + 1], plaintext[64 - 23 + 1], plaintext[64 - 15 + 1], plaintext[64 - 7 + 1]
};
  
function [64:1] IP_Inverse_perm(input [64:1] message);
    integer IP_inverse[64:1];
    reg [64:1] temp_msg;
    integer i;
 	  begin
			IP_inverse[1] = 40;
			IP_inverse[2] = 8;
			IP_inverse[3] = 48;
			IP_inverse[4] = 16;
			IP_inverse[5] = 56;
			IP_inverse[6] = 24;
			IP_inverse[7] = 64;
			IP_inverse[8] = 32;
			IP_inverse[9] = 39;
			IP_inverse[10] = 7;
			IP_inverse[11] = 47;
			IP_inverse[12] = 15;
			IP_inverse[13] = 55;
			IP_inverse[14] = 23;
			IP_inverse[15] = 63;
			IP_inverse[16] = 31;
			IP_inverse[17] = 38;
			IP_inverse[18] = 6;
			IP_inverse[19] = 46;
			IP_inverse[20] = 14;
			IP_inverse[21] = 54;
			IP_inverse[22] = 22;
			IP_inverse[23] = 62;
			IP_inverse[24] = 30;
			IP_inverse[25] = 37;
			IP_inverse[26] = 5;
			IP_inverse[27] = 45;
			IP_inverse[28] = 13;
			IP_inverse[29] = 53;
			IP_inverse[30] = 21;
			IP_inverse[31] = 61;
			IP_inverse[32] = 29;
			IP_inverse[33] = 36;
			IP_inverse[34] = 4;
			IP_inverse[35] = 44;
			IP_inverse[36] = 12;
			IP_inverse[37] = 52;
			IP_inverse[38] = 20;
			IP_inverse[39] = 60;
			IP_inverse[40] = 28;
			IP_inverse[41] = 35;
			IP_inverse[42] = 3;
			IP_inverse[43] = 43;
			IP_inverse[44] = 11;
			IP_inverse[45] = 51;
			IP_inverse[46] = 19;
			IP_inverse[47] = 59;
			IP_inverse[48] = 27;
			IP_inverse[49] = 34;
			IP_inverse[50] = 2;
			IP_inverse[51] = 42;
			IP_inverse[52] = 10;
			IP_inverse[53] = 50;
			IP_inverse[54] = 18;
			IP_inverse[55] = 58;
			IP_inverse[56] = 26;
			IP_inverse[57] = 33;
			IP_inverse[58] = 1;
			IP_inverse[59] = 41;
			IP_inverse[60] = 9;
			IP_inverse[61] = 49;
			IP_inverse[62] = 17;
			IP_inverse[63] = 57;
			IP_inverse[64] = 25;

			for(i=1; i<=64; i=i+1)
        temp_msg[64-i+1] = message[64-IP_inverse[i]+1];
      IP_Inverse_perm = temp_msg;
      
 	  end
  endfunction
  
function [48:1] E_perm (input [32:1] in_data);
   integer E[48:1];
    reg [48:1] temp_E;
    integer i;
    begin
		
			E[1] = 32;
			E[2] = 1;
			E[3] = 2;
			E[4] = 3;
			E[5] = 4;
			E[6] = 5;
			E[7] = 4;
			E[8] = 5;
			E[9] = 6;
			E[10] = 7;
			E[11] = 8;
			E[12] = 9;
			E[13] = 8;
			E[14] = 9;
			E[15] = 10;
			E[16] = 11;
			E[17] = 12;
			E[18] = 13;
			E[19] = 12;
			E[20] = 13;
			E[21] = 14;
			E[22] = 15;
			E[23] = 16;
			E[24] = 17;
			E[25] = 16;
			E[26] = 17;
			E[27] = 18;
			E[28] = 19;
			E[29] = 20;
			E[30] = 21;
			E[31] = 20;
			E[32] = 21;
			E[33] = 22;
			E[34] = 23;
			E[35] = 24;
			E[36] = 25;
			E[37] = 24;
			E[38] = 25;
			E[39] = 26;
			E[40] = 27;
			E[41] = 28;
			E[42] = 29;
			E[43] = 28;
			E[44] = 29;
			E[45] = 30;
			E[46] = 31;
			E[47] = 32;
			E[48] = 1;

      for(i=1; i<=48; i=i+1)
        temp_E[48-i+1] = in_data[32-E[i]+1];

      E_perm = temp_E;
    end
  endfunction

function [32:1] P_perm (input [32:1] in_data);
    integer i;
    integer P[32:1];
    reg [32:1] temp_P;
    begin
			P[1] = 16;
			P[2] = 7;
			P[3] = 20;
			P[4] = 21;
			P[5] = 29;
			P[6] = 12;
			P[7] = 28;
			P[8] = 17;
			P[9] = 1;
			P[10] = 15;
			P[11] = 23;
			P[12] = 26;
			P[13] = 5;
			P[14] = 18;
			P[15] = 31;
			P[16] = 10;
			P[17] = 2;
			P[18] = 8;
			P[19] = 24;
			P[20] = 14;
			P[21] = 32;
			P[22] = 27;
			P[23] = 3;
			P[24] = 9;
			P[25] = 19;
			P[26] = 13;
			P[27] = 30;
			P[28] = 6;
			P[29] = 22;
			P[30] = 11;
			P[31] = 4;
			P[32] = 25;

      for(i=1; i<=32; i=i+1)
        temp_P[32-i+1] = in_data[32-P[i]+1];
      P_perm = temp_P;
    end
  endfunction
  
function [3:0] S_out (input [5:0] in, input [3:0] box_num); 
    reg [1:0] row;
    reg [3:0] col;
begin                                               // begin 1


    row = {in[5], in[0]}; // Determine row using the first and last bits
    col = in[4:1];       // Determine column using the middle bits

 if (box_num == 1) begin
        case (row)                                  // case 1
            2'b00: begin                            // begin 2
                case (col)                          // case 2
                    4'b0000: S_out = 4'b1110; // 14
                    4'b0001: S_out = 4'b0100; // 4
                    4'b0010: S_out = 4'b1101; // 13
                    4'b0011: S_out = 4'b0001; // 1
                    4'b0100: S_out = 4'b0010; // 2
                    4'b0101: S_out = 4'b1111; // 15
                    4'b0110: S_out = 4'b1011; // 11
                    4'b0111: S_out = 4'b1000; // 8
                    4'b1000: S_out = 4'b0011; // 3
                    4'b1001: S_out = 4'b1010; // 10
                    4'b1010: S_out = 4'b0110; // 6
                    4'b1011: S_out = 4'b1100; // 12
                    4'b1100: S_out = 4'b0101; // 5
                    4'b1101: S_out = 4'b1001; // 9
                    4'b1110: S_out = 4'b0000; // 0
                    4'b1111: S_out = 4'b0111; // 7
                    default: S_out = 4'b0000; // Default value
                endcase                         // endcase 2
            end                                 // end 2
            
            2'b01: begin
                case (col)
                    4'b0000: S_out = 4'b0000; // 0
                    4'b0001: S_out = 4'b1111; // 15
                    4'b0010: S_out = 4'b0111; // 7
                    4'b0011: S_out = 4'b0100; // 4
                    4'b0100: S_out = 4'b1110; // 14
                    4'b0101: S_out = 4'b0010; // 2
                    4'b0110: S_out = 4'b1101; // 13
                    4'b0111: S_out = 4'b0001; // 1
                    4'b1000: S_out = 4'b1010; // 10
                    4'b1001: S_out = 4'b0110; // 6
                    4'b1010: S_out = 4'b1100; // 12
                    4'b1011: S_out = 4'b1011; // 11
                    4'b1100: S_out = 4'b1001; // 9
                    4'b1101: S_out = 4'b0101; // 5
                    4'b1110: S_out = 4'b0011; // 3
                    4'b1111: S_out = 4'b1000; // 8
                    default: S_out = 4'b0000; // Default value
                endcase
            end

            2'b10: begin
                case (col)
                    4'b0000: S_out = 4'b0100; // 4
                    4'b0001: S_out = 4'b0001; // 1
                    4'b0010: S_out = 4'b1110; // 14
                    4'b0011: S_out = 4'b1000; // 8
                    4'b0100: S_out = 4'b1101; // 13
                    4'b0101: S_out = 4'b0110; // 6
                    4'b0110: S_out = 4'b0010; // 2
                    4'b0111: S_out = 4'b1011; // 11
                    4'b1000: S_out = 4'b1111; // 15
                    4'b1001: S_out = 4'b1100; // 12
                    4'b1010: S_out = 4'b1001; // 9
                    4'b1011: S_out = 4'b0111; // 7
                    4'b1100: S_out = 4'b0011; // 3
                    4'b1101: S_out = 4'b1010; // 10
                    4'b1110: S_out = 4'b0101; // 5
                    4'b1111: S_out = 4'b0000; // 0
                    default: S_out = 4'b0000; // Default value
                endcase
            end

            2'b11: begin
                case (col)
                    4'b0000: S_out = 4'b1111; // 15
                    4'b0001: S_out = 4'b1100; // 12
                    4'b0010: S_out = 4'b1000; // 8
                    4'b0011: S_out = 4'b0010; // 2
                    4'b0100: S_out = 4'b0100; // 4
                    4'b0101: S_out = 4'b1001; // 9
                    4'b0110: S_out = 4'b0001; // 1
                    4'b0111: S_out = 4'b0111; // 7
                    4'b1000: S_out = 4'b0101; // 5
                    4'b1001: S_out = 4'b1011; // 11
                    4'b1010: S_out = 4'b0011; // 3
                    4'b1011: S_out = 4'b1110; // 14
                    4'b1100: S_out = 4'b1010; // 10
                    4'b1101: S_out = 4'b0000; // 0
                    4'b1110: S_out = 4'b0110; // 6
                    4'b1111: S_out = 4'b1101; // 13
                    default: S_out = 4'b0000; // Default value
                endcase
            end
        endcase

    end

else if (box_num == 2)begin
        // Use case statement to determine output based on row and column
        case (row)
            2'b00: begin
                 case (col)
                    4'b0000: S_out = 4'b1111; // 15
                    4'b0001: S_out = 4'b0001; // 1
                    4'b0010: S_out = 4'b1000; // 8
                    4'b0011: S_out = 4'b1110; // 14
                    4'b0100: S_out = 4'b0110; // 6
                    4'b0101: S_out = 4'b1011; // 11
                    4'b0110: S_out = 4'b0011; // 3
                    4'b0111: S_out = 4'b0100; // 4
                    4'b1000: S_out = 4'b1001; // 9
                    4'b1001: S_out = 4'b0111; // 7
                    4'b1010: S_out = 4'b0010; // 2
                    4'b1011: S_out = 4'b1101; // 13
                    4'b1100: S_out = 4'b1100; // 12
                    4'b1101: S_out = 4'b0000; // 0
                    4'b1110: S_out = 4'b0101; // 5
                    4'b1111: S_out = 4'b1010; // 10
                    default: S_out = 4'b0000; // Default value
                endcase
            end

            2'b01: begin
                case (col)
                    4'b0000: S_out = 4'b0011; // 3
                    4'b0001: S_out = 4'b1101; // 13
                    4'b0010: S_out = 4'b0100; // 4
                    4'b0011: S_out = 4'b0111; // 7
                    4'b0100: S_out = 4'b1111; // 15
                    4'b0101: S_out = 4'b0010; // 2
                    4'b0110: S_out = 4'b1000; // 8
                    4'b0111: S_out = 4'b1110; // 14
                    4'b1000: S_out = 4'b1100; // 12
                    4'b1001: S_out = 4'b0000; // 0
                    4'b1010: S_out = 4'b0001; // 1
                    4'b1011: S_out = 4'b1010; // 10
                    4'b1100: S_out = 4'b0110; // 6
                    4'b1101: S_out = 4'b1001; // 9
                    4'b1110: S_out = 4'b1011; // 11
                    4'b1111: S_out = 4'b0101; // 5
                    default: S_out = 4'b0000; // Default value
                endcase
            end

            2'b10: begin
                case (col)
                    4'b0000: S_out = 4'b0000; // 0
                    4'b0001: S_out = 4'b1110; // 14
                    4'b0010: S_out = 4'b0111; // 7
                    4'b0011: S_out = 4'b1011; // 11
                    4'b0100: S_out = 4'b1010; // 10
                    4'b0101: S_out = 4'b0100; // 4
                    4'b0110: S_out = 4'b1101; // 13
                    4'b0111: S_out = 4'b0001; // 1
                    4'b1000: S_out = 4'b0101; // 5
                    4'b1001: S_out = 4'b1000; // 8
                    4'b1010: S_out = 4'b1100; // 12
                    4'b1011: S_out = 4'b0110; // 6
                    4'b1100: S_out = 4'b1001; // 9
                    4'b1101: S_out = 4'b0011; // 3
                    4'b1110: S_out = 4'b0010; // 2
                    4'b1111: S_out = 4'b1111; // 15
                    default: S_out = 4'b0000; // Default value
                endcase
            end

            2'b11: begin
                case (col)
                    4'b0000: S_out = 4'b1101; // 13
                    4'b0001: S_out = 4'b1000; // 8
                    4'b0010: S_out = 4'b1010; // 10
                    4'b0011: S_out = 4'b0001; // 1
                    4'b0100: S_out = 4'b0011; // 3
                    4'b0101: S_out = 4'b1111; // 15
                    4'b0110: S_out = 4'b0100; // 4
                    4'b0111: S_out = 4'b0010; // 2
                    4'b1000: S_out = 4'b1011; // 11
                    4'b1001: S_out = 4'b0110; // 6
                    4'b1010: S_out = 4'b0111; // 7
                    4'b1011: S_out = 4'b1100; // 12
                    4'b1100: S_out = 4'b0000; // 0
                    4'b1101: S_out = 4'b0101; // 5
                    4'b1110: S_out = 4'b1110; // 14
                    4'b1111: S_out = 4'b1001; // 9
                    default: S_out = 4'b0000; // Default value
                endcase
            end
        endcase
    end
    
    else if(box_num == 3) begin
        // Use case statement to determine output based on row and column
        case (row)
            2'b00: begin
                case (col)
                    4'b0000: S_out = 4'b1010; // 10
                    4'b0001: S_out = 4'b0000; // 0
                    4'b0010: S_out = 4'b1001; // 9
                    4'b0011: S_out = 4'b1110; // 14
                    4'b0100: S_out = 4'b0110; // 6
                    4'b0101: S_out = 4'b0011; // 3
                    4'b0110: S_out = 4'b1111; // 15
                    4'b0111: S_out = 4'b0101; // 5
                    4'b1000: S_out = 4'b0001; // 1
                    4'b1001: S_out = 4'b1101; // 13
                    4'b1010: S_out = 4'b1100; // 12
                    4'b1011: S_out = 4'b0111; // 7
                    4'b1100: S_out = 4'b1011; // 11
                    4'b1101: S_out = 4'b0100; // 4
                    4'b1110: S_out = 4'b0010; // 2
                    4'b1111: S_out = 4'b1000; // 8
                    default: S_out = 4'b0000; // Default value
                endcase
            end

            2'b01: begin
                case (col)
                    4'b0000: S_out = 4'b1101; // 13
                    4'b0001: S_out = 4'b0111; // 7
                    4'b0010: S_out = 4'b0000; // 0
                    4'b0011: S_out = 4'b1001; // 9
                    4'b0100: S_out = 4'b0011; // 3
                    4'b0101: S_out = 4'b0100; // 4
                    4'b0110: S_out = 4'b0110; // 6
                    4'b0111: S_out = 4'b1010; // 10
                    4'b1000: S_out = 4'b0010; // 2
                    4'b1001: S_out = 4'b1000; // 8
                    4'b1010: S_out = 4'b0101; // 5
                    4'b1011: S_out = 4'b1110; // 14
                    4'b1100: S_out = 4'b1100; // 12
                    4'b1101: S_out = 4'b1011; // 11
                    4'b1110: S_out = 4'b1111; // 15
                    4'b1111: S_out = 4'b0001; // 1
                    default: S_out = 4'b0000; // Default value
                endcase
            end

            2'b10: begin
                case (col)
                    4'b0000: S_out = 4'b1101; // 13
                    4'b0001: S_out = 4'b0110; // 6
                    4'b0010: S_out = 4'b0100; // 4
                    4'b0011: S_out = 4'b1001; // 9
                    4'b0100: S_out = 4'b1000; // 8
                    4'b0101: S_out = 4'b1111; // 15
                    4'b0110: S_out = 4'b0011; // 3
                    4'b0111: S_out = 4'b0000; // 0
                    4'b1000: S_out = 4'b1011; // 11
                    4'b1001: S_out = 4'b0001; // 1
                    4'b1010: S_out = 4'b0010; // 2
                    4'b1011: S_out = 4'b1100; // 12
                    4'b1100: S_out = 4'b0101; // 5
                    4'b1101: S_out = 4'b1010; // 10
                    4'b1110: S_out = 4'b1110; // 14
                    4'b1111: S_out = 4'b0111; // 7
                    default: S_out = 4'b0000; // Default value
                endcase
            end

            2'b11: begin
                case (col)
                    4'b0000: S_out = 4'b0001; // 1
                    4'b0001: S_out = 4'b1010; // 10
                    4'b0010: S_out = 4'b1101; // 13
                    4'b0011: S_out = 4'b0000; // 0
                    4'b0100: S_out = 4'b0110; // 6
                    4'b0101: S_out = 4'b1001; // 9
                    4'b0110: S_out = 4'b1000; // 8
                    4'b0111: S_out = 4'b0111; // 7
                    4'b1000: S_out = 4'b0100; // 4
                    4'b1001: S_out = 4'b1111; // 15
                    4'b1010: S_out = 4'b1110; // 14
                    4'b1011: S_out = 4'b0011; // 3
                    4'b1100: S_out = 4'b1011; // 11
                    4'b1101: S_out = 4'b0101; // 5
                    4'b1110: S_out = 4'b0010; // 2
                    4'b1111: S_out = 4'b1100; // 12
                    default: S_out = 4'b0000; // Default value
                endcase
            end
        endcase
   
    end
    
    else if(box_num == 4)begin

        case (row)
            2'b00: begin
                case (col)
                    4'b0000: S_out = 4'b0111;  // 7
                    4'b0001: S_out = 4'b1101;  // 13
                    4'b0010: S_out = 4'b1110;  // 14
                    4'b0011: S_out = 4'b0011;  // 3
                    4'b0100: S_out = 4'b0000;  // 0
                    4'b0101: S_out = 4'b0110;  // 6
                    4'b0110: S_out = 4'b1001;  // 9
                    4'b0111: S_out = 4'b1010;  // 10
                    4'b1000: S_out = 4'b0001;  // 1
                    4'b1001: S_out = 4'b0010;  // 2
                    4'b1010: S_out = 4'b1000;  // 8
                    4'b1011: S_out = 4'b0101;  // 5
                    4'b1100: S_out = 4'b1011;  // 11
                    4'b1101: S_out = 4'b1100;  // 12
                    4'b1110: S_out = 4'b0100;  // 4
                    4'b1111: S_out = 4'b1111;  // 15
                endcase
            end
            2'b01: begin
                case (col)
                    4'b0000: S_out = 4'b1101;  // 13
                    4'b0001: S_out = 4'b1000;  // 8
                    4'b0010: S_out = 4'b1011;  // 11
                    4'b0011: S_out = 4'b0101;  // 5
                    4'b0100: S_out = 4'b0110;  // 6
                    4'b0101: S_out = 4'b1111;  // 15
                    4'b0110: S_out = 4'b0000;  // 0
                    4'b0111: S_out = 4'b0011;  // 3
                    4'b1000: S_out = 4'b0100;  // 4
                    4'b1001: S_out = 4'b0111;  // 7
                    4'b1010: S_out = 4'b0010;  // 2
                    4'b1011: S_out = 4'b1100;  // 12
                    4'b1100: S_out = 4'b0001;  // 1
                    4'b1101: S_out = 4'b1010;  // 10
                    4'b1110: S_out = 4'b1110;  // 14
                    4'b1111: S_out = 4'b1001;  // 9
                endcase
            end
            2'b10: begin
                case (col)
                    4'b0000: S_out = 4'b1010;  // 10
                    4'b0001: S_out = 4'b0110;  // 6
                    4'b0010: S_out = 4'b1001;  // 9
                    4'b0011: S_out = 4'b0000;  // 0
                    4'b0100: S_out = 4'b1100;  // 12
                    4'b0101: S_out = 4'b1011;  // 11
                    4'b0110: S_out = 4'b0111;  // 7
                    4'b0111: S_out = 4'b1101;  // 13
                    4'b1000: S_out = 4'b1111;  // 15
                    4'b1001: S_out = 4'b0001;  // 1
                    4'b1010: S_out = 4'b0011;  // 3
                    4'b1011: S_out = 4'b1110;  // 14
                    4'b1100: S_out = 4'b0101;  // 5
                    4'b1101: S_out = 4'b0010;  // 2
                    4'b1110: S_out = 4'b1000;  // 8
                    4'b1111: S_out = 4'b0100;  // 4
                endcase
            end
            2'b11: begin
                case (col)
                    4'b0000: S_out = 4'b0011;  // 3
                    4'b0001: S_out = 4'b1111;  // 15
                    4'b0010: S_out = 4'b0000;  // 0
                    4'b0011: S_out = 4'b0110;  // 6
                    4'b0100: S_out = 4'b1010;  // 10
                    4'b0101: S_out = 4'b0001;  // 1
                    4'b0110: S_out = 4'b1101;  // 13
                    4'b0111: S_out = 4'b1000;  // 8
                    4'b1000: S_out = 4'b1001;  // 9
                    4'b1001: S_out = 4'b0100;  // 4
                    4'b1010: S_out = 4'b0101;  // 5
                    4'b1011: S_out = 4'b1011;  // 11
                    4'b1100: S_out = 4'b1100;  // 12
                    4'b1101: S_out = 4'b0111;  // 7
                    4'b1110: S_out = 4'b0010;  // 2
                    4'b1111: S_out = 4'b1110;  // 14
                endcase
            end
        endcase
    end
    
    else if(box_num == 5) begin
        case (row)
            2'b00: begin
                case (col)
                    4'b0000: S_out = 4'b0010;  // 2
                    4'b0001: S_out = 4'b1100;  // 12
                    4'b0010: S_out = 4'b0100;  // 4
                    4'b0011: S_out = 4'b0001;  // 1
                    4'b0100: S_out = 4'b0111;  // 7
                    4'b0101: S_out = 4'b1010;  // 10
                    4'b0110: S_out = 4'b1011;  // 11
                    4'b0111: S_out = 4'b0110;  // 6
                    4'b1000: S_out = 4'b1000;  // 8
                    4'b1001: S_out = 4'b0101;  // 5
                    4'b1010: S_out = 4'b0011;  // 3
                    4'b1011: S_out = 4'b1111;  // 15
                    4'b1100: S_out = 4'b1101;  // 13
                    4'b1101: S_out = 4'b0000;  // 0
                    4'b1110: S_out = 4'b1110;  // 14
                    4'b1111: S_out = 4'b1001;  // 9
                endcase
            end
            2'b01: begin
                case (col)
                    4'b0000: S_out = 4'b1110;  // 14
                    4'b0001: S_out = 4'b1011;  // 11
                    4'b0010: S_out = 4'b0010;  // 2
                    4'b0011: S_out = 4'b1100;  // 12
                    4'b0100: S_out = 4'b0100;  // 4
                    4'b0101: S_out = 4'b0111;  // 7
                    4'b0110: S_out = 4'b1101;  // 13
                    4'b0111: S_out = 4'b0001;  // 1
                    4'b1000: S_out = 4'b0101;  // 5
                    4'b1001: S_out = 4'b0000;  // 0
                    4'b1010: S_out = 4'b1111;  // 15
                    4'b1011: S_out = 4'b1010;  // 10
                    4'b1100: S_out = 4'b0011;  // 3
                    4'b1101: S_out = 4'b1001;  // 9
                    4'b1110: S_out = 4'b1000;  // 8
                    4'b1111: S_out = 4'b0110;  // 6
                endcase
            end
            2'b10: begin
                case (col)
                    4'b0000: S_out = 4'b0100;  // 4
                    4'b0001: S_out = 4'b0010;  // 2
                    4'b0010: S_out = 4'b0001;  // 1
                    4'b0011: S_out = 4'b1011;  // 11
                    4'b0100: S_out = 4'b1010;  // 10
                    4'b0101: S_out = 4'b1101;  // 13
                    4'b0110: S_out = 4'b0111;  // 7
                    4'b0111: S_out = 4'b1000;  // 8
                    4'b1000: S_out = 4'b1111;  // 15
                    4'b1001: S_out = 4'b1001;  // 9
                    4'b1010: S_out = 4'b1100;  // 12
                    4'b1011: S_out = 4'b0101;  // 5
                    4'b1100: S_out = 4'b0110;  // 6
                    4'b1101: S_out = 4'b0011;  // 3
                    4'b1110: S_out = 4'b0000;  // 0
                    4'b1111: S_out = 4'b1110;  // 14
                endcase
            end
            2'b11: begin
                case (col)
                    4'b0000: S_out = 4'b1011;  // 11
                    4'b0001: S_out = 4'b1000;  // 8
                    4'b0010: S_out = 4'b1100;  // 12
                    4'b0011: S_out = 4'b0111;  // 7
                    4'b0100: S_out = 4'b0001;  // 1
                    4'b0101: S_out = 4'b1110;  // 14
                    4'b0110: S_out = 4'b0010;  // 2
                    4'b0111: S_out = 4'b1101;  // 13
                    4'b1000: S_out = 4'b0110;  // 6
                    4'b1001: S_out = 4'b1111;  // 15
                    4'b1010: S_out = 4'b0000;  // 0
                    4'b1011: S_out = 4'b1001;  // 9
                    4'b1100: S_out = 4'b1010;  // 10
                    4'b1101: S_out = 4'b0100;  // 4
                    4'b1110: S_out = 4'b0101;  // 5
                    4'b1111: S_out = 4'b0011;  // 3
                endcase
            end
        endcase
    end

    else if(box_num == 6) begin
        case (row)
            2'b00: begin
                case (col)
                    4'b0000: S_out = 4'b1100;  // 12
                    4'b0001: S_out = 4'b0001;  // 1
                    4'b0010: S_out = 4'b1010;  // 10
                    4'b0011: S_out = 4'b1111;  // 15
                    4'b0100: S_out = 4'b1001;  // 9
                    4'b0101: S_out = 4'b0010;  // 2
                    4'b0110: S_out = 4'b0110;  // 6
                    4'b0111: S_out = 4'b1000;  // 8
                    4'b1000: S_out = 4'b0000;  // 0
                    4'b1001: S_out = 4'b1101;  // 13
                    4'b1010: S_out = 4'b0011;  // 3
                    4'b1011: S_out = 4'b0100;  // 4
                    4'b1100: S_out = 4'b1110;  // 14
                    4'b1101: S_out = 4'b0111;  // 7
                    4'b1110: S_out = 4'b0101;  // 5
                    4'b1111: S_out = 4'b1011;  // 11
                endcase
            end
            2'b01: begin
                case (col)
                    4'b0000: S_out = 4'b1010;  // 10
                    4'b0001: S_out = 4'b1111;  // 15
                    4'b0010: S_out = 4'b0100;  // 4
                    4'b0011: S_out = 4'b0010;  // 2
                    4'b0100: S_out = 4'b0111;  // 7
                    4'b0101: S_out = 4'b1100;  // 12
                    4'b0110: S_out = 4'b1001;  // 9
                    4'b0111: S_out = 4'b0101;  // 5
                    4'b1000: S_out = 4'b0110;  // 6
                    4'b1001: S_out = 4'b0001;  // 1
                    4'b1010: S_out = 4'b1101;  // 13
                    4'b1011: S_out = 4'b1110;  // 14
                    4'b1100: S_out = 4'b0000;  // 0
                    4'b1101: S_out = 4'b1011;  // 11
                    4'b1110: S_out = 4'b0011;  // 3
                    4'b1111: S_out = 4'b1000;  // 8
                endcase
            end
            2'b10: begin
                case (col)
                    4'b0000: S_out = 4'b1001;  // 9
                    4'b0001: S_out = 4'b1110;  // 14
                    4'b0010: S_out = 4'b1111;  // 15
                    4'b0011: S_out = 4'b0101;  // 5
                    4'b0100: S_out = 4'b0010;  // 2
                    4'b0101: S_out = 4'b1000;  // 8
                    4'b0110: S_out = 4'b1100;  // 12
                    4'b0111: S_out = 4'b0011;  // 3
                    4'b1000: S_out = 4'b0111;  // 7
                    4'b1001: S_out = 4'b0000;  // 0
                    4'b1010: S_out = 4'b0100;  // 4
                    4'b1011: S_out = 4'b1010;  // 10
                    4'b1100: S_out = 4'b0001;  // 1
                    4'b1101: S_out = 4'b1101;  // 13
                    4'b1110: S_out = 4'b1011;  // 11
                    4'b1111: S_out = 4'b0110;  // 6
                endcase
            end
            2'b11: begin
                case (col)
                    4'b0000: S_out = 4'b0100;  // 4
                    4'b0001: S_out = 4'b0011;  // 3
                    4'b0010: S_out = 4'b0010;  // 2
                    4'b0011: S_out = 4'b1100;  // 12
                    4'b0100: S_out = 4'b0101;  // 9
                    4'b0101: S_out = 4'b0101;  // 5
                    4'b0110: S_out = 4'b1111;  // 15
                    4'b0111: S_out = 4'b1010;  // 10
                    4'b1000: S_out = 4'b1011;  // 11
                    4'b1001: S_out = 4'b1110;  // 14
                    4'b1010: S_out = 4'b0001;  // 1
                    4'b1011: S_out = 4'b1000;  // 8
                    4'b1100: S_out = 4'b0110;  // 6
                    4'b1101: S_out = 4'b0000;  // 0
                    4'b1110: S_out = 4'b1000;  // 8
                    4'b1111: S_out = 4'b1101;  // 13
                endcase
            end
        endcase
    end

    else if(box_num == 7) begin
        case (row)
            2'b00: begin
                case (col)
                    4'b0000: S_out = 4'b0100;  // 4
                    4'b0001: S_out = 4'b1011;  // 11
                    4'b0010: S_out = 4'b0010;  // 2
                    4'b0011: S_out = 4'b1110;  // 14
                    4'b0100: S_out = 4'b1111;  // 15
                    4'b0101: S_out = 4'b0000;  // 0
                    4'b0110: S_out = 4'b1000;  // 8
                    4'b0111: S_out = 4'b1101;  // 13
                    4'b1000: S_out = 4'b0011;  // 3
                    4'b1001: S_out = 4'b1100;  // 12
                    4'b1010: S_out = 4'b1001;  // 9
                    4'b1011: S_out = 4'b0111;  // 7
                    4'b1100: S_out = 4'b0101;  // 5
                    4'b1101: S_out = 4'b1010;  // 10
                    4'b1110: S_out = 4'b0110;  // 6
                    4'b1111: S_out = 4'b0001;  // 1
                endcase
            end
            2'b01: begin
                case (col)
                    4'b0000: S_out = 4'b1101;  // 13
                    4'b0001: S_out = 4'b0000;  // 0
                    4'b0010: S_out = 4'b1011;  // 11
                    4'b0011: S_out = 4'b0111;  // 7
                    4'b0100: S_out = 4'b0100;  // 4
                    4'b0101: S_out = 4'b1001;  // 9
                    4'b0110: S_out = 4'b0001;  // 1
                    4'b0111: S_out = 4'b1010;  // 10
                    4'b1000: S_out = 4'b1110;  // 14
                    4'b1001: S_out = 4'b0011;  // 3
                    4'b1010: S_out = 4'b0101;  // 5
                    4'b1011: S_out = 4'b1100;  // 12
                    4'b1100: S_out = 4'b0010;  // 2
                    4'b1101: S_out = 4'b1111;  // 15
                    4'b1110: S_out = 4'b1000;  // 8
                    4'b1111: S_out = 4'b0110;  // 6
                endcase
            end
            2'b10: begin
                case (col)
                    4'b0000: S_out = 4'b0001;  // 1
                    4'b0001: S_out = 4'b0100;  // 4
                    4'b0010: S_out = 4'b1011;  // 11
                    4'b0011: S_out = 4'b1101;  // 13
                    4'b0100: S_out = 4'b1100;  // 12
                    4'b0101: S_out = 4'b0011;  // 3
                    4'b0110: S_out = 4'b0111;  // 7
                    4'b0111: S_out = 4'b1110;  // 14
                    4'b1000: S_out = 4'b1010;  // 10
                    4'b1001: S_out = 4'b1111;  // 15
                    4'b1010: S_out = 4'b0110;  // 6
                    4'b1011: S_out = 4'b1000;  // 8
                    4'b1100: S_out = 4'b0000;  // 0
                    4'b1101: S_out = 4'b0101;  // 5
                    4'b1110: S_out = 4'b1001;  // 9
                    4'b1111: S_out = 4'b0010;  // 2
                endcase
            end
            2'b11: begin
                case (col)
                    4'b0000: S_out = 4'b0110;  // 6
                    4'b0001: S_out = 4'b1011;  // 11
                    4'b0010: S_out = 4'b1101;  // 13
                    4'b0011: S_out = 4'b1000;  // 8
                    4'b0100: S_out = 4'b0001;  // 1
                    4'b0101: S_out = 4'b0100;  // 4
                    4'b0110: S_out = 4'b1010;  // 10
                    4'b0111: S_out = 4'b0111;  // 7
                    4'b1000: S_out = 4'b1001;  // 9
                    4'b1001: S_out = 4'b0101;  // 5
                    4'b1010: S_out = 4'b0000;  // 0
                    4'b1011: S_out = 4'b1111;  // 15
                    4'b1100: S_out = 4'b1110;  // 14
                    4'b1101: S_out = 4'b0010;  // 2
                    4'b1110: S_out = 4'b0011;  // 3
                    4'b1111: S_out = 4'b1100;  // 12
                endcase
            end
        endcase
    end

    else if(box_num == 8) begin
        case (row)
            2'b00: begin
                case (col)
                    4'b0000: S_out = 4'b1101;  // 13
                    4'b0001: S_out = 4'b0010;  // 2
                    4'b0010: S_out = 4'b1000;  // 8
                    4'b0011: S_out = 4'b0100;  // 4
                    4'b0100: S_out = 4'b0110;  // 6
                    4'b0101: S_out = 4'b1111;  // 15
                    4'b0110: S_out = 4'b1011;  // 11
                    4'b0111: S_out = 4'b0001;  // 1
                    4'b1000: S_out = 4'b1010;  // 10
                    4'b1001: S_out = 4'b1001;  // 9
                    4'b1010: S_out = 4'b0011;  // 3
                    4'b1011: S_out = 4'b1110;  // 14
                    4'b1100: S_out = 4'b0101;  // 5
                    4'b1101: S_out = 4'b0000;  // 0
                    4'b1110: S_out = 4'b1100;  // 12
                    4'b1111: S_out = 4'b0111;  // 7
                endcase
            end
            2'b01: begin
                case (col)
                    4'b0000: S_out = 4'b0001;  // 1
                    4'b0001: S_out = 4'b1111;  // 15
                    4'b0010: S_out = 4'b1101;  // 13
                    4'b0011: S_out = 4'b1000;  // 8
                    4'b0100: S_out = 4'b1010;  // 10
                    4'b0101: S_out = 4'b0011;  // 3
                    4'b0110: S_out = 4'b0111;  // 7
                    4'b0111: S_out = 4'b0100;  // 4
                    4'b1000: S_out = 4'b1100;  // 12
                    4'b1001: S_out = 4'b0101;  // 5
                    4'b1010: S_out = 4'b0110;  // 6
                    4'b1011: S_out = 4'b1011;  // 11
                    4'b1100: S_out = 4'b0000;  // 0
                    4'b1101: S_out = 4'b1110;  // 14
                    4'b1110: S_out = 4'b1001;  // 9
                    4'b1111: S_out = 4'b0010;  // 2
                endcase
            end
            2'b10: begin
                case (col)
                    4'b0000: S_out = 4'b0111;  // 7
                    4'b0001: S_out = 4'b1011;  // 11
                    4'b0010: S_out = 4'b0100;  // 4
                    4'b0011: S_out = 4'b0001;  // 1
                    4'b0100: S_out = 4'b1001;  // 9
                    4'b0101: S_out = 4'b1100;  // 12
                    4'b0110: S_out = 4'b1110;  // 14
                    4'b0111: S_out = 4'b0010;  // 2
                    4'b1000: S_out = 4'b0000;  // 0
                    4'b1001: S_out = 4'b0110;  // 6
                    4'b1010: S_out = 4'b1010;  // 10
                    4'b1011: S_out = 4'b1101;  // 13
                    4'b1100: S_out = 4'b1111;  // 15
                    4'b1101: S_out = 4'b0011;  // 3
                    4'b1110: S_out = 4'b0101;  // 5
                    4'b1111: S_out = 4'b1000;  // 8
                endcase
            end
            2'b11: begin
                case (col)
                    4'b0000: S_out = 4'b0010;  // 2
                    4'b0001: S_out = 4'b0001;  // 1
                    4'b0010: S_out = 4'b1110;  // 14
                    4'b0011: S_out = 4'b0111;  // 7
                    4'b0100: S_out = 4'b0100;  // 4
                    4'b0101: S_out = 4'b1010;  // 10
                    4'b0110: S_out = 4'b1000;  // 8
                    4'b0111: S_out = 4'b1101;  // 13
                    4'b1000: S_out = 4'b1111;  // 15
                    4'b1001: S_out = 4'b1100;  // 12
                    4'b1010: S_out = 4'b1001;  // 9
                    4'b1011: S_out = 4'b0000;  // 0
                    4'b1100: S_out = 4'b0011;  // 3
                    4'b1101: S_out = 4'b0101;  // 5
                    4'b1110: S_out = 4'b0110;  // 6
                    4'b1111: S_out = 4'b1011;  // 11
                endcase
            end
        endcase
    end
end
endfunction

  function [32:1] f(input [32:1] R, input [48:1] K);
    reg [48:1] temp;
    reg [32:1] temp_after_s_box;
    reg [5:0] B[8:1];
    begin
      temp = K ^ E_perm(R);
      B[1] = temp[48:43];
      B[2] = temp[42:37];
      B[3] = temp[36:31];
      B[4] = temp[30:25];
      B[5] = temp[24:19];
      B[6] = temp[18:13];
      B[7] = temp[12:7];
      B[8] = temp[6:1];
      
      temp_after_s_box = {S_out(B[1], 5'd1), S_out(B[2], 5'd2), S_out(B[3], 5'd3), S_out(B[4], 5'd4),
                          S_out(B[5], 5'd5), S_out(B[6], 5'd6), S_out(B[7], 5'd7), S_out(B[8], 5'd8)};

      f = P_perm(temp_after_s_box);
    end
  endfunction
  
  reg [32:1] L[16:0], R[16:0];
  wire [48:1] key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13, key14, key15, key16;
  reg [48:1] K[16:1];
  integer i;
  Key_scheduler pk(key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13, key14, key15, key16, key);

always @(encryption or key or plaintext) begin
  // Default assignment to prevent latches
  ciphertext[64:1] = 64'b0;  // or some other default value if needed

  if (encryption == 1) begin
    // ENCRYPTION
    {L[0], R[0]} = IP_perm;

    // Store the keys in order
    K[1] = key1; K[2] = key2; K[3] = key3; K[4] = key4; K[5] = key5; 
    K[6] = key6; K[7] = key7; K[8] = key8; K[9] = key9; K[10] = key10; 
    K[11] = key11; K[12] = key12; K[13] = key13; K[14] = key14; 
    K[15] = key15; K[16] = key16;

    for(i=1; i<=16; i=i+1) begin
      L[i] = R[i-1];
      R[i] = L[i-1] ^ f(R[i-1], K[i]);
    end

    ciphertext[64:1] = IP_Inverse_perm({R[16], L[16]});
  end

  else if (encryption == 0) begin
    // DECRYPTION
    {L[0], R[0]} = IP_perm;

    // Store the keys in reverse order
    K[1] = key16; K[2] = key15; K[3] = key14; K[4] = key13; K[5] = key12;
    K[6] = key11; K[7] = key10; K[8] = key9; K[9] = key8; K[10] = key7; 
    K[11] = key6; K[12] = key5; K[13] = key4; K[14] = key3; 
    K[15] = key2; K[16] = key1;

    for(i=1; i<=16; i=i+1) begin
      L[i] = R[i-1];
      R[i] = L[i-1] ^ f(R[i-1], K[i]);
    end

    ciphertext[64:1] = IP_Inverse_perm({R[16], L[16]});
  end
end
endmodule