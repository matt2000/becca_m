function task = task_initialize( task )

task.REPORTING_BLOCK_SIZE = 10 ^ 1;
task.MAX_NUM_FEATURES = 5000;

task.sampling_frequency = 44100; %{8000, 11025, 22050, and 44100}
task.sample_period = 0.10;
task.sample_duration_shift = 0.020;
task.filter_time_constant = 0.005;
task.bin_density = 20;
task.record_period = 4;
task.animate_flag = 0;        
task.BACKUP_PERIOD = 10 ^ 3;

task.state_length = [];
task.basic_feature_length = 1;
task.action_length = 1;

task.sensory_input = [];
task.basic_feature_input = 0;
task.action = 0;
task.reward = 0;
        
task.step_ctr = 0;
task.restore_filename_prefix = 'log/task_listen';
task.backup_filename_prefix = 'log/task_listen';
task.backup_filename_postfix = '_task.mat';

task.half_period = task.record_period / 2;
%cycles_per_half_period = task.half_period / task.sample_duration_shift;
task.recorder1 = audiorecorder(task.sampling_frequency, 16, 1);
task.recorder2 = audiorecorder(task.sampling_frequency, 16, 1);
task.recorder_dummy = audiorecorder(task.sampling_frequency, 16, 1);

task.recording_master = [];


task.sample_count = round( task.sampling_frequency * task.sample_period);
task.sample_count_shift = round( task.sampling_frequency * ...
                                task.sample_duration_shift);
%creates a Hamming window
task.window = .54 - .46 * cos( 2 * pi * (0:task.sample_count - 1)' / ...
                                         (task.sample_count - 1));
                                     
task.waveform  = zeros(task.sample_count, 1);

% creates map to logarithmically-spaced bins
task.frequency_count = floor( task.sample_count / 2);
freqs = ( 1 : task.frequency_count) / task.sample_period;
min_freq = 10^1;
max_freq = 10^4;
min_log_freq = log10(min_freq);
max_log_freq = log10(max_freq);
num_bins = (max_log_freq - min_log_freq) * task.bin_density;
task.frequency_bin_labels = min_log_freq + ( (1:num_bins) - 0.5) / ...
                                task.bin_density;
log_freqs = log10( freqs);
task.bin_map = zeros( num_bins, task.frequency_count); 
for i = 1:num_bins,
    low_log_freq = min_log_freq + (i - 1) / task.bin_density;
    hi_log_freq  = min_log_freq + i       / task.bin_density;
    freqs_in_bin = (find( ( log_freqs >= low_log_freq) & ...
                           (log_freqs <  hi_log_freq)));
    frequency_count_in_bin = length( freqs_in_bin);
    task.bin_map( i, freqs_in_bin) = ...
        ones( 1, frequency_count_in_bin) / frequency_count_in_bin;
end
[r indx] = find( task.bin_map);
r = unique( r);
r_empty = setdiff( 1:num_bins, r);
task.bin_map( r_empty, :) = [];
num_bins = size( task.bin_map, 1);
task.frequency_bin_labels( r_empty) = [];

task.bins_filtered = zeros( num_bins, 1);
task.state_length = num_bins;

%initializes figures for display
close all
long_gray_colormap = [[0:255]' [0:255]' [0:255]']./255;
figure(4);
colormap(long_gray_colormap);

figure(1);
clf
semilogx(10^min_log_freq, 10^max_log_freq)
axis( [10^min_log_freq 10^max_log_freq -0.1 1])
hold on
set( gca, 'Drawmode', 'Fast');
task.frequency_plot_handle = bar( 10.^task.frequency_bin_labels, 1:num_bins);
xlabel('Frequency (Hz)')
    
if( task.animate_flag)
    figure(2)
    clf
    axis( [0 1000 -1 1])
    hold on
    set( gca, 'Drawmode', 'Fast');
    task.time_series_plot_handle = plot( task.frequency_bin_labels, 1:num_bins);
    xlabel('sample number')

end

%gives recorder1 a head start
record( task.recorder1);
pause( task.half_period);
task.last_time = clock;
record( task.recorder2);
pause( task.half_period);
this_time = clock;
elapsed_time = etime( this_time, task.last_time);
task.last_time = this_time;

stop( task.recorder1);
recording = getaudiodata( task.recorder1);
recording_keep = recording( ...
    round(end - elapsed_time * task.sampling_frequency + 1) : end);
task.recording_master = [ task.recording_master recording_keep];

task.active_recorder = 2;
record( task.recorder1);
record( task.recorder_dummy, task.half_period);
