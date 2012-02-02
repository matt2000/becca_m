
sampling_frequency = 44100; %{8000, 11025, 22050, and 44100}
sample_period = 0.10;
sample_duration_shift = 0.020;
filter_time_constant = 0.005;
bin_density = 20;
record_period = 4;
animate_flag = 1;

half_period = record_period / 2;
cycles_per_half_period = half_period / sample_duration_shift;
recorder1 = audiorecorder(sampling_frequency, 16, 1);
recorder2 = audiorecorder(sampling_frequency, 16, 1);
recorder_dummy = audiorecorder(sampling_frequency, 16, 1);

recording_master = [];


sample_count = round( sampling_frequency * sample_period);
sample_count_shift = round( sampling_frequency * ...
                                sample_duration_shift);
%creates a Hamming window
window = .54 - .46 * cos( 2 * pi * (0:sample_count - 1)' / ...
                                         (sample_count - 1));
                                     
waveform  = zeros(sample_count, 1);

% creates map to logarithmically-spaced bins
frequency_count = floor( sample_count / 2);
freqs = ( 1 : frequency_count) / sample_period;
min_freq = 10^1;
max_freq = 10^4;
min_log_freq = log10(min_freq);
max_log_freq = log10(max_freq);
num_bins = (max_log_freq - min_log_freq) * bin_density;
frequency_bin_labels = min_log_freq + ( (1:num_bins) - 0.5) / ...
                                bin_density;
log_freqs = log10( freqs);
bin_map = zeros( num_bins, frequency_count); 
for i = 1:num_bins,
    low_log_freq = min_log_freq + (i - 1) / bin_density;
    hi_log_freq  = min_log_freq + i       / bin_density;
    freqs_in_bin = (find( ( log_freqs >= low_log_freq) & ...
                           (log_freqs <  hi_log_freq)));
    frequency_count_in_bin = length( freqs_in_bin);
    bin_map( i, freqs_in_bin) = ...
        ones( 1, frequency_count_in_bin) / frequency_count_in_bin;
end
[r indx] = find( bin_map);
r = unique( r);
r_empty = setdiff( 1:num_bins, r);
bin_map( r_empty, :) = [];
num_bins = size( bin_map, 1);
frequency_bin_labels( r_empty) = [];

bins_filtered = zeros( num_bins, 1);


if( animate_flag)
    figure(1);
    clf
    axis( [min_log_freq max_log_freq -0.1 1])
    hold on
    set( gca, 'Drawmode', 'Fast');
    frequency_plot_handle = plot( frequency_bin_labels, 1:num_bins);
    xlabel('log 10 frequency')
    
    figure(2)
    clf
    axis( [0 1000 -1 1])
    hold on
    set( gca, 'Drawmode', 'Fast');
    time_series_plot_handle = plot( frequency_bin_labels, 1:num_bins);
    xlabel('sample number')

end

counter = 1;


%gives recorder1 a head start
record(recorder1);
pause( half_period);
last_time = clock;
record(recorder2);
pause( half_period);
this_time = clock;
elapsed_time = etime(this_time, last_time);
last_time = this_time;

stop(recorder1);
recording = getaudiodata(recorder1);
recording_keep = recording(round(end - elapsed_time * sampling_frequency + 1) : end);
recording_master = [recording_master recording_keep];

active_recorder = 2;
record(recorder1);
record(recorder_dummy, half_period);

while(1)
    % handle switch
    if ~isrecording(recorder_dummy)
        
        this_time = clock;
        elapsed_time = etime(this_time, last_time);
        last_time = this_time;

        if (active_recorder == 1)
            stop(recorder1);
            recording = getaudiodata(recorder1);
            recording_keep = recording( ...
                round( end - elapsed_time * sampling_frequency + 1) : end);
            recording_master = vertcat(recording_master, recording_keep);

            active_recorder = 2;
            record(recorder1);
            record(recorder_dummy, half_period);
            
        else
            stop(recorder2);
            recording = getaudiodata(recorder2);
            recording_keep = recording( ...
                round( end - elapsed_time * sampling_frequency + 1) : end);
            recording_master = vertcat(recording_master, recording_keep);

            active_recorder = 1;
            record(recorder2);
            record(recorder_dummy, half_period);
            
        end
        
    end
    
    if (length( recording_master) > sample_count_shift)
        
        new_waveform  = recording_master(1:sample_count_shift);
        recording_master(1:sample_count_shift) = [];
        waveform( 1: end - sample_count_shift) = ...
            waveform( 1 + sample_count_shift : end);
        waveform( end - sample_count_shift + 1 : end) = ...
                    new_waveform;
        waveform_windowed = window .* waveform;
        frequency_magnitude = abs( fft( waveform_windowed));
        bins_new = log2( bin_map * ...
                frequency_magnitude( 1 : frequency_count));
        bins_inc = (bins_new - bins_filtered) / 3;
        bins_inc( bins_inc < 0) = 0;
        bins_inc = becca.util.sigm( bins_inc);
        bins_filtered = (1 - filter_time_constant) * ...
            bins_filtered + filter_time_constant * bins_new;

        sensory_input = bins_inc;

        if( animate_flag)
            %display;
            %bins_inc'
            %counter = counter + 1
            %log10(length( recording_master))
            set( frequency_plot_handle, 'ydata', bins_inc);
            set( time_series_plot_handle, ...
                'xdata', 1:length(new_waveform), 'ydata', new_waveform);
            drawnow
            p = audioplayer(new_waveform, sampling_frequency);
            play(p);
        end
    end
    
    
end