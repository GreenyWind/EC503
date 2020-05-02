% corrupt.m - corrupts a pattern by flipping bits
%

function Inew = corrupt(I,n)

N=length(I);

i=ceil(N*rand(n,1));

Inew=I;
Inew(i)=-I(i);
end
