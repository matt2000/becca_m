%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% executes one step of the listen task
function task = task_step( task)

% handle switch
if ~isrecording(task.recorder_dummy)

    this_time = clock;
    elapsed_time = etime(this_time, task.last_time);
    task.last_time = this_time;

    if (task.active_recorder == 1)
        stop( task.recorder1);
        recording = getaudiodata( task.recorder1);
        recording_keep = recording( round( ...
           end - elapsed_time * task.sampling_frequency + 1) : end);
        task.recording_master = vertcat( ...
                task.recording_master, recording_keep);

        task.active_recorder = 2;
        record( task.recorder1);
        record( task.recorder_dummy, task.half_period);

    else
        stop( task.recorder2);
        recording = getaudiodata( task.recorder2);
        recording_keep = recording( round( ...
           end - elapsed_time * task.sampling_frequency + 1) ...
                                                    : end);
        task.recording_master = vertcat( ...
            task.recording_master, recording_keep);

        task.active_recorder = 1;
        record( task.recorder2);
        record( task.recorder_dummy, task.half_period);

    end

end

if (length( task.recording_master) > task.sample_count_shift)

    new_waveform  = task.recording_master ...
        (1:task.sample_count_shift);
    task.recording_master( 1:task.sample_count_shift) = [];
    task.waveform( 1: end - task.sample_count_shift) = ...
        task.waveform( 1 + task.sample_count_shift : end);
    task.waveform( end - task.sample_count_shift + 1 : end) = ...
                new_waveform;
    waveform_windowed = task.window .* task.waveform;
    frequency_magnitude = abs( fft( waveform_windowed));
    bins_new = log2( task.bin_map * ...
            frequency_magnitude( 1 : task.frequency_count));
    bins_inc = (bins_new - task.bins_filtered) / 3;
    bins_inc( bins_inc < 0) = 0;
    bins_inc = util_sigm( bins_inc);
    task.bins_filtered = (1 - task.filter_time_constant) * ...
       task.bins_filtered + ...
       task.filter_time_constant * bins_new;

    task.sensory_input = bins_inc;

    if( task.animate_flag)
        task.display_sound(task.sensory_input, []);
        set( task.frequency_plot_handle, 'ydata', bins_inc);
        set( task.time_series_plot_handle, ...
            'xdata', 1:length(new_waveform), ...
            'ydata', new_waveform);
        drawnow
    end                
end
