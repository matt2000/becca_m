% util_bounded_sum.m
%
% C = util_bounded_sum (A, B)
%
% Sums the values A and B, which are assumed to fall on the interval
% [-1,1], to create a value C with the following properties:
%
% for A and B on [0,1]
% 1. if C = bsum(A,B), C > A, C > B
% 2. C is on [0,1]
% 3. bsum(A,B) = bsum(B,A)
% 4. if A1 > A2, bsum(A1,B) > bsum(A2, B)
%
% opposites are true for A and B on [-1,0]
%
% for A and B on [-1,1]
% 1. C is on [-1,1]
%
% for A and B oppositely signed, C = A + B
%
% if A and B are vectors or matrices, they must be of the same size, and
% C will be of the same size too

function c = util_bounded_sum (a, b)

    if ~isempty( find( (size(a) ~= size(b))))
        disp('Error: util_bounded_sum.m. Matrices must be of the same size');
        c = NaN;
        return
    end
    c = zeros(size(a));
    % maps [0,1]  onto [1,Inf)
    % maps [-1,1] onto (-Inf,Inf)
    
    % different functions for when a and b are same or opposite signs
    same_sign_indx = find( sign(a) == sign(b));
    a_ss = a(same_sign_indx);
    b_ss = b(same_sign_indx);
    a_t = sign(a_ss) ./ (1 - abs(a_ss) + eps) - sign(a_ss);
    b_t = sign(b_ss) ./ (1 - abs(b_ss) + eps) - sign(b_ss);
    
    c_t = a_t + b_t; 
    
    c_ss = sign(c_t) .* (1 - 1 ./ (abs(c_t) + 1));
    c_ss( c_t == 0) = 0;
    
    opp_sign_indx = find( sign(a) ~= sign(b));
    a_os = a(opp_sign_indx);
    b_os = b(opp_sign_indx);
    c_os = a_os + b_os;
    
    c(same_sign_indx) = c_ss;
    c(opp_sign_indx) = c_os;
    
end