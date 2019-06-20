function b = de2bi(varargin) 
%DE2BI Convert decimal numbers to binary numbers.  
 
%typical error checking. 
error(nargchk(1,4,nargin)); 
 
%placeholder for the signature string. 
sigStr = ''; 
flag = ''; 
p = []; 
n = []; 
 
%identify string and numeric arguments 
for i=1:nargin 
   if(i>1) 
      sigStr(size(sigStr,2)+1) = '/'; 
   end; 
   %assign the string and numeric flags 
   if(ischar(varargin{i})) 
      sigStr(size(sigStr,2)+1) = 's'; 
   elseif(isnumeric(varargin{i})) 
      sigStr(size(sigStr,2)+1) = 'n'; 
   else 
      error('Only string and numeric arguments are accepted.'); 
   end; 
end; 
 
% identify parameter signitures and assign values to variables 
switch sigStr 
   % de2bi(d) 
   case 'n' 
      d		= varargin{1}; 
 
	% de2bi(d, n) 
	case 'n/n' 
      d		= varargin{1}; 
      n		= varargin{2}; 
 
	% de2bi(d, flag) 
	case 'n/s' 
      d		= varargin{1}; 
      flag	= varargin{2}; 
 
	%de2bi(d, n, flag) 
	case 'n/n/s' 
      d		= varargin{1}; 
      n		= varargin{2}; 
      flag	= varargin{3}; 
 
	% de2bi(d, flag, n) 
	case 'n/s/n' 
      d		= varargin{1}; 
      flag	= varargin{2}; 
      n		= varargin{3}; 
 
	% de2bi(d, n, p) 
	case 'n/n/n' 
      d		= varargin{1}; 
      n		= varargin{2}; 
      p  	= varargin{3}; 
 
	% de2bi(d, n, p, flag) 
	case 'n/n/n/s' 
      d		= varargin{1}; 
      n		= varargin{2}; 
      p  	= varargin{3}; 
      flag	= varargin{4}; 
 
	% de2bi(d, n, flag, p) 
	case 'n/n/s/n' 
      d		= varargin{1}; 
      n		= varargin{2}; 
      flag	= varargin{3}; 
      p  	= varargin{4}; 
 
	% de2bi(d, flag, n, p) 
	case 'n/s/n/n' 
      d		= varargin{1}; 
      flag	= varargin{2}; 
      n		= varargin{3}; 
      p  	= varargin{4}; 
 
   %if the parameter list does not match one of these signatures. 
   otherwise 
      error('Syntax error.'); 
end; 
 
if isempty(d) 
   error('Required parameter empty.'); 
end 
 
d = d(:); 
len_d = length(d); 
 
if max(max(d < 0)) | max(max(~isfinite(d))) | (~isreal(d)) | (max(max(floor(d) ~= d))) 
   error('Input must contain only finite real positive integers.'); 
end 
 
%assign the base to convert to. 
if isempty(p) 
    p = 2; 
elseif max(size(p) ~= 1) 
   error('Destination base must be scalar.'); 
elseif (~isfinite(p)) | (~isreal(p)) | (floor(p) ~= p) 
   error('Destination base must be a finite real integer.'); 
elseif p < 2 
   error('Cannot convert to a base of less than two.'); 
end; 
 
%determine minimum length required. 
tmp = max(d); 
if tmp ~= 0 				% Want base-p log of tmp. 
   ntmp = floor( log(tmp) / log(p) ) + 1; 
else 							% Since you can't take log(0). 
   ntmp = 1; 
end 
 
%this takes care of any round off error that occurs for really big inputs. 
if ~( (p^ntmp) > tmp ) 
   ntmp = ntmp + 1; 
end 
 
%assign number of columns in output matrix. 
if isempty(n) 
   n = ntmp; 
elseif max(size(n) ~= 1) 
   error('Specified number of columns must be scalar.'); 
elseif (~isfinite(n)) | (~isreal(n)) | (floor(n) ~= n) 
   error('Specified number of columns must be a finite real integer.'); 
elseif n < ntmp 
   error('Specified number of columns in output matrix is too small.'); 
end 
 
%check if the string flag is valid. 
if isempty(flag) 
   flag = 'right-lsb'; 
elseif ~(strcmp(flag, 'right-lsb') | strcmp(flag, 'left-lsb')) 
   error('Invalid string flag.'); 
end 
 
%initial value. 
b = zeros(len_d, n); 
 
%perform conversion. 
for i = 1 : len_d                   %cycle through each element of the input vector/matrix. 
    j = 1; 
    tmp = d(i); 
    while (j <= n) & (tmp > 0)      %cycle through each digit. 
        b(i, j) = rem(tmp, p);      %determine current digit. 
        tmp = floor(tmp/p); 
        j = j + 1; 
    end; 
end; 
 
%if a flag is specified to flip the output such that the LSB is to the left. 
if strcmp(flag, 'left-lsb') 
 
   b2 = b; 
   b = b2(:,n:-1:1); 
 
end 