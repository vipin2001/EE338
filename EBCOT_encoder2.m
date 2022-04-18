function [CX, D, bit_plane_max] = EBCOT_encoder2(DWT, subband)
% EBCOT encoder to encode the subbands of the DWT transformed matrix DWT;
A = DWT;
m = size(A,1);
bit_plane_max = floor(log2(max(abs(A(:)))));
bit_plane = bit_plane_max;
sigma = zeros(size(A));
sigp = zeros(size(A));
eta = zeros(size(A));
chi = A<0;
%chi = zeros(size(A));
CX = [];
D = '';

while(bit_plane>=0)
    for i = 1:4:m
        clear Atmp;
        Atmp = A(i:i+3,:);
        %bit_plane = bit_plane_max;
    
        % Call procedure CUP (Clean Up Pass);
        [sigma, CX, D] = Cleanup_pass1(Atmp, i, sigma, chi, eta, bit_plane, CX, D, subband);
        
        %bit_plane = bit_plane - 1;
        if(bit_plane-1<0)
            %break;
            continue;
        end
        
        % Call procedure SPP (Significance Propagation Pass);
        [CX, D, sigma, eta] = SP_pass(Atmp, i, sigma, chi, bit_plane-1, CX, D, subband);
        
        % Call procedure MRP (Magnitude Refinement Pass);
        [CX, D, sigp] = MR_pass(Atmp, i, sigma, eta, sigp, bit_plane_max, bit_plane-1, CX, D);
    end
    bit_plane = bit_plane - 1;
end
% MQ-coder for converting [CX, D] pairs to bitstream;
% bitstream = MQcoder(CX,D);
end