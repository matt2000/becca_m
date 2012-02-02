function task = task_display_sound(task, sound_by_frequency, filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% re-interprets the raw sensory vector as sound

x = task.frequency_bin_labels;
t = (1:task.sample_count_shift * 40)';
s = zeros(size(t));

for i = 1:length(x)
    phase = rand(1);
    f = 10 .^ x(i);
    s = s + sound_by_frequency(i) *...
        sin(2 * pi *(t *  f / task.sampling_frequency + phase));
end

VOLUME_SCALE = 12 * std(s);
if (VOLUME_SCALE > eps)
    s_scaled = s / VOLUME_SCALE;
else
    s_scaled = s;
end

% finds window
if isempty( task.playback_window)
    task.playback_window = 1:length(s);
    
    % sqrt( Hanning window)
    task.playback_window = ...
        sqrt( 0.5 * (1 - cos(2 * pi * task.playback_window' / length(t))));
end

s_scaled = s_scaled .* task.playback_window;

wavplay(s_scaled, task.sampling_frequency);

if ~isempty(filename)
    if (exist( filename, 'file'))
        delete(filename);
    end
    filename
    wavwrite(s_scaled, task.sampling_frequency, filename);
end
