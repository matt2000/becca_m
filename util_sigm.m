function b = util_sigm (a)
    b = (2 ./ ( 1 + exp(-2*a))) - 1;
end
