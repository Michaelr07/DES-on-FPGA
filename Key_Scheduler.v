`timescale 1ns / 1ps
module Key_scheduler(
  output reg [48:1] key1, key2, key3, key4, key5, key6, key7, key8,
  key9, key10, key11, key12, key13, key14, key15, key16,
  input [64:1] key
);

  // Precompute the PC1 permutation combinationally
wire [56:1] PC1_perm = {
    // Assigning bits directly based on the PC1 permutation table
    key[64 - 57 + 1],  // key[8]
    key[64 - 49 + 1],  // key[16]
    key[64 - 41 + 1],  // key[24]
    key[64 - 33 + 1],  // key[32]
    key[64 - 25 + 1],  // key[40]
    key[64 - 17 + 1],  // key[48]
    key[64 - 9 + 1],   // key[56]
    key[64 - 1 + 1],   // key[64]
    
    key[64 - 58 + 1],  // key[7]
    key[64 - 50 + 1],  // key[15]
    key[64 - 42 + 1],  // key[23]
    key[64 - 34 + 1],  // key[31]
    key[64 - 26 + 1],  // key[39]
    key[64 - 18 + 1],  // key[47]
    key[64 - 10 + 1],  // key[55]
    key[64 - 2 + 1],   // key[63]
    
    key[64 - 59 + 1],  // key[6]
    key[64 - 51 + 1],  // key[14]
    key[64 - 43 + 1],  // key[22]
    key[64 - 35 + 1],  // key[30]
    key[64 - 27 + 1],  // key[38]
    key[64 - 19 + 1],  // key[46]
    key[64 - 11 + 1],  // key[54]
    key[64 - 3 + 1],   // key[62]
    
    key[64 - 60 + 1],  // key[5]
    key[64 - 52 + 1],  // key[13]
    key[64 - 44 + 1],  // key[21]
    key[64 - 36 + 1],  // key[29]
    key[64 - 63 + 1],  // key[2]
    key[64 - 55 + 1],  // key[10]
    key[64 - 47 + 1],  // key[18]
    key[64 - 39 + 1],  // key[26]
    
    key[64 - 31 + 1],  // key[34]
    key[64 - 23 + 1],  // key[42]
    key[64 - 15 + 1],  // key[50]
    key[64 - 7 + 1],   // key[58]
    key[64 - 62 + 1],  // key[3]
    key[64 - 54 + 1],  // key[11]
    key[64 - 46 + 1],  // key[19]
    key[64 - 38 + 1],  // key[27]
    
    key[64 - 30 + 1],  // key[35]
    key[64 - 22 + 1],  // key[43]
    key[64 - 14 + 1],  // key[51]
    key[64 - 6 + 1],   // key[59]
    key[64 - 61 + 1],  // key[4]
    key[64 - 53 + 1],  // key[12]
    key[64 - 45 + 1],  // key[20]
    key[64 - 37 + 1],  // key[28]
    
    key[64 - 29 + 1],  // key[36]
    key[64 - 21 + 1],  // key[44]
    key[64 - 13 + 1],  // key[52]
    key[64 - 5 + 1],   // key[60]
    key[64 - 28 + 1],  // key[37]
    key[64 - 20 + 1],  // key[45]
    key[64 - 12 + 1],  // key[53]
    key[64 - 4 + 1]    // key[61]
};


  // Use wire-based logic for PC2 permutation
  function [48:1] PC2_perm(input [56:1] key_s);
    begin
      PC2_perm = {
        key_s[56 - 14 + 1], key_s[56 - 17 + 1], key_s[56 - 11 + 1], key_s[56 - 24 + 1], key_s[56 - 1 + 1], key_s[56 - 5 + 1], key_s[56 - 3 + 1], key_s[56 - 28 + 1], 
        key_s[56 - 15 + 1], key_s[56 - 6 + 1], key_s[56 - 21 + 1], key_s[56 - 10 + 1], key_s[56 - 23 + 1], key_s[56 - 19 + 1], key_s[56 - 12 + 1], key_s[56 - 4 + 1], 
        key_s[56 - 26 + 1], key_s[56 - 8 + 1], key_s[56 - 16 + 1], key_s[56 - 7 + 1], key_s[56 - 27 + 1], key_s[56 - 20 + 1], key_s[56 - 13 + 1], key_s[56 - 2 + 1], 
        key_s[56 - 41 + 1], key_s[56 - 52 + 1], key_s[56 - 31 + 1], key_s[56 - 37 + 1], key_s[56 - 47 + 1], key_s[56 - 55 + 1], key_s[56 - 30 + 1], key_s[56 - 40 + 1], 
        key_s[56 - 51 + 1], key_s[56 - 45 + 1], key_s[56 - 33 + 1], key_s[56 - 48 + 1], key_s[56 - 44 + 1], key_s[56 - 49 + 1], key_s[56 - 39 + 1], key_s[56 - 56 + 1], 
        key_s[56 - 34 + 1], key_s[56 - 53 + 1], key_s[56 - 46 + 1], key_s[56 - 42 + 1], key_s[56 - 50 + 1], key_s[56 - 36 + 1], key_s[56 - 29 + 1], key_s[56 - 32 + 1]
      };
    end
  endfunction

  // Perform the C_i and D_i shifts directly
  function [56:1] shift_left(input integer i, input [28:1] C_last, D_last);
    integer shift[1:16];
    begin
      shift[1] = 1;
      shift[2] = 1;
      shift[3] = 2;
      shift[4] = 2;
      shift[5] = 2;
      shift[6] = 2;
      shift[7] = 2;
      shift[8] = 2;
      shift[9] = 1;
      shift[10] = 2;
      shift[11] = 2;
      shift[12] = 2;
      shift[13] = 2;
      shift[14] = 2;
      shift[15] = 2;
      shift[16] = 1;
      
      if(shift[i] == 'd1)
        shift_left = {C_last[27:1], C_last[28], D_last[27:1], D_last[28]};
      else if(shift[i] == 'd2)
        shift_left = {C_last[26:1], C_last[28:27], D_last[26:1], D_last[28:27]};
end
endfunction

  reg [28:1] C[16:0], D[16:0];
  reg [48:1] K[1:16];
  integer i;
  
  always @(key) begin
    C[0] = PC1_perm[56:29];
    D[0] = PC1_perm[28:1];
    
    for(i = 1; i <= 16; i = i + 1) begin
      {C[i], D[i]} = shift_left(i, C[i-1], D[i-1]);
      K[i] = PC2_perm({C[i], D[i]});
    end

    key1 = K[1];
    key2 = K[2];
    key3 = K[3];
    key4 = K[4];
    key5 = K[5];
    key6 = K[6];
    key7 = K[7];
    key8 = K[8];
    key9 = K[9];
    key10 = K[10];
    key11 = K[11];
    key12 = K[12];
    key13 = K[13];
    key14 = K[14];
    key15 = K[15];
    key16 = K[16];
  end
endmodule
