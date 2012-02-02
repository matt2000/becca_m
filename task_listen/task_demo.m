
Fs = 44100; %{8000, 11025, 22050, and 44100}
Ts = 0.10;
Tup = 0.020;
Ns = round(Fs * Ts);
Nup = round(Fs * Tup);
%creates a Hamming window
window = .54 - .46*cos(2*pi*(0:Ns-1)'/(Ns-1));
alpha = 0.005;
y  = wavrecord(Ns, Fs);

% creates map to logarithmically-spaced bins
num_freqs = floor( Ns/2);
freqs = (1:num_freqs) / Ts;
bin_density = 20; % number of bins per decade
min_freq = 10^1;
min_log_freq = log10(min_freq);
max_freq = 10^4;
max_log_freq = log10(max_freq);
num_bins = (max_log_freq - min_log_freq) * bin_density;
x_data = min_log_freq + ((1:num_bins) - 0.5)/bin_density;
log_freqs = log10(freqs);
bin_map = zeros(num_bins,num_freqs); 
for i = 1:num_bins,
    low_log_freq = min_log_freq + (i-1) / bin_density;
    hi_log_freq =  min_log_freq + i / bin_density;
    freqs_in_bin = (find( ( log_freqs >= low_log_freq) & ...
                           (log_freqs <  hi_log_freq)));
    num_freqs_in_bin = length( freqs_in_bin);
    bin_map(i, freqs_in_bin) = ...
        ones(1, num_freqs_in_bin) / num_freqs_in_bin;
end
[r ~] = find(bin_map);
r = unique(r);
r_empty = setdiff(1:num_bins, r);

if (~isempty( r_empty))
    if (r_empty(1) == 1)
        bin_map(1) = 10 ^ -6;
        r_empty = r_empty( 2:end);
    end
    for i = 1:length(r_empty),
        bin_map(r_empty(i),:) = bin_map(r_empty(i)-1,:);
    end
end

b_filt = zeros(num_bins,1);

figure(1);
clf
axis([min_log_freq max_log_freq -1 1])
hold on
set(gca,'Drawmode','Fast');
ph = plot(x_data, 1:num_bins);
xlabel('log 10 frequency')
figure(3)
clf

while(1)
    for q = 1:200    
        yup  = wavrecord(Nup, Fs);
        y(1:end-Nup) = y(1+Nup:end);
        y(end-Nup+1:end) = yup;
        y_hamm = window .* y;
        %wavplay(y, Fs);
        %y  = wavrecord(Ns, Fs);
        m = abs( fft(y_hamm));
        g = m(1:num_freqs);
        b_new = log2(bin_map * g);
        b_inc = (b_new - b_filt)/7;
        b_inc( b_inc < 0) = 0;
        b_inc = becca.util.sigm(b_inc);
        b_filt = (1 - alpha) * b_filt + alpha * b_new;

        sg(:,q) = b_inc;

        set(ph,'ydata',b_inc);
        drawnow
    end
    figure(3)
    surf(sg)
    view(2)
    drawnow
end
