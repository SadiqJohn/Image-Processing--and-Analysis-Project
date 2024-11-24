% zigzag function
function out = zigzag(in)
[rows, columns]=size(in);
% Initialise the output vector
out=zeros(1,rows*columns);
% i = current row; j = current column; pos = current position
i=1;	j=1;	pos=1;
%Loop until reaches the end
while i<=rows && j<=columns
    if i==1 && mod(i+j,2)==0 && j~=columns
		out(pos)=in(i,j);
		j=j+1;							% Move right at the top
		pos=pos+1;
		
	elseif i==rows && mod(i+j,2)~=0 && j~=columns
		out(pos)=in(i,j);
		j=j+1;							% Move right at the bottom
		pos=pos+1;
		
	elseif j==1 && mod(i+j,2)~=0 && i~=rows
		out(pos)=in(i,j);
		i=i+1;							% Move down at the left
		pos=pos+1;
		
	elseif j==columns && mod(i+j,2)==0 && i~=rows
		out(pos)=in(i,j);
		i=i+1;							% Move down at the right
		pos=pos+1;
		
	elseif j~=1 && i~=rows && mod(i+j,2)~=0
		out(pos)=in(i,j);
		i=i+1;		j=j-1;	            % Move diagonally left down
		pos=pos+1;
		
	elseif i~=1 && j~=columns && mod(i+j,2)==0
		out(pos)=in(i,j);
		i=i-1;		j=j+1;	            % Move diagonally right up
		pos=pos+1;
		
	elseif i==rows && j==columns	    % Get the bottom right element
        out(end)=in(end);		
		break;				    
    end
end