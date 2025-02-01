order = 8; % Filter order
cutoff_frequency = 4000; % Cutoff frequency in Hz

% Recording
fs = 44100; % Sampling frequency
recorder = audiorecorder(fs, 16, 1); % 16 bits, 1 channel (mono)
disp('Start speaking...');
recordblocking(recorder, 5); % Record for 5 seconds
disp('End of recording');

% Get the recorded signal
speech_signal = getaudiodata(recorder);
lowpass_filter = designfilt('lowpassfir', 'FilterOrder', order, 'CutoffFrequency', cutoff_frequency, 'SampleRate', fs);

enhanced_signal = filter(lowpass_filter, speech_signal);
t = (0:length(speech_signal)-1) / fs;

% Visualize the signals
figure;
subplot(3,1,1);
plot(t, speech_signal);
title('Original Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, enhanced_signal);
title('Enhanced Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Analysis
original_snr = snr(speech_signal, speech_signal - enhanced_signal);
disp(['Original SNR: ' num2str(original_snr) ' dB']);

% Visualize the spectrogram
subplot(3,1,3);
spectrogram(enhanced_signal, hann(256), 128, 1024, fs, 'yaxis');
title('Spectrogram of Enhanced Speech Signal');

% Save the enhanced signal
audiowrite('enhanced_speech.wav', enhanced_signal, fs);