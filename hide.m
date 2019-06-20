msg_txt = 'Hello, this is a secret message.';
infile = 'F:\MATLAB\R2017a\bin\Test1\Sounds\train.wav';
outfile = 'F:\MATLAB\R2017a\bin\Test1\Sounds\trainout.wav';

% header
in = fopen(infile,'r');
header = fread(in,40,'uint8=>char');
data_size = fread(in,1,'uint32');
[data,count] = fread(in,inf,'uint16');
fclose(in);

% convert message to binary
msg_double = double(msg_txt);
msg_bin = de2bi(msg_double,8);
[m,n] = size(msg_bin);
msg = reshape(msg_bin,m*n,1);
m = de2bi(m,10)';
n = de2bi(n,10)';
len = length(msg);
len_bin = de2bi(len,20)';

% code identity 
identity = [1 0 1 0 1 0 1 0]';
data(1:8) = bitset(data(1:8),1,identity(1:8));

% code message length
data(9:18) = bitset(data(9:18),1,m(1:10));
data(19:28) = bitset(data(19:28),1,n(1:10));

% code message data
data(29:28+len)=bitset(data(29:28+len),1,msg_bin(1:len)');

out = fopen(outfile,'w');

% write out the header stuff and "dirty" data
fwrite(out,header,'uint8');
fwrite(out,data_size,'uint32');
fwrite(out,data,'uint16');
fclose(out);

% Waveform plot input/output

[x,fs1] = audioread(infile);
subplot(2,1,1), plot(x)
title('Original Sound')
xlabel('sample [n]')
ylabel('magnitude')

[out,fs2] = audioread(outfile);
subplot(2,1,2), plot(out)
title('Stego Sound')
xlabel('sample [n]')
ylabel('magnitude')