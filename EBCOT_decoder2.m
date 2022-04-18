function A = EBCOT_decoder2(CX, D, sz, bit_plane_max)
% EBCOT decoder to decode the bitstream and get back subbands of the DWT matrix;
% First Step:- decode the bitstream to get CX and D.
%[CX, D] = MQdecoder(bitstream);

% Next Step;- Decode using CX and D.
m = sz(1,1);
n = sz(1,2);
%A = zeros(m,n);
bit_plane = bit_plane_max;
sigma = zeros(m,n);
sigp = zeros(m,n);
eta = zeros(m,n);
chi = zeros(m,n);
A = zeros(m,n);

while(bit_plane>=0)
    for i = 1:4:m
        %clear Atmp;
        %Atmp = zeros(4,n);
        Atmp = A(i:i+3,:);
        %bit_plane = bit_plane_max;
        
        % Clean Up Pass (CUP):-
        [Atmp, sigma, chi, CX, D] = Cleanup_pass_decode(Atmp, CX, D, sigma, chi, eta, bit_plane, i);
        
        A(i:i+3,:) = Atmp; % Accumulating bit planeth Atmps in A;
        if(bit_plane-1<0)
            %break;
            continue;
        end
        
        % Significance Propagation Pass (SPP):-
        [Atmp, CX, D, sigma, chi, eta] = SP_pass_decode(Atmp, CX, D, sigma, chi, bit_plane-1, i);
        
        % Magnitude Refinement Pass (MRP):-
        [Atmp, CX, D, sigp] = MR_pass_decode(Atmp, CX, D, sigma, eta, sigp, bit_plane-1, i);
        A(i:i+3,:) = Atmp; % Accumulating (bit plane-1)th Atmps in A;
    end
    %A = [A; Atmp];
    bit_plane = bit_plane - 1;
end
end