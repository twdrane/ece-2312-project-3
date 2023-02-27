close all

isolateSpeech();
splitSignal();

function splitSignal

[audioFile,Fs] = audioread('teamG5-filteredspeech.wav');

figure
F = [0 3999/Fs 4000/Fs 1];
A = [1 1 0 0];
[fil1, fil2] = firls(255,F,A);
lowpassAudio = filter(fil1,fil2,audioFile);

B = [0 0 1 1];
[fil3, fil4] = firls(256,F,B);
highpassAudio = filter(fil3,fil4,audioFile);

lowpassAudio = downsample(lowpassAudio,2);
Fs = Fs/2;

subplot(2,1,1);
makeSpectrogram(highpassAudio,Fs);
ylim([0 8000])
subplot(2,1,2);
makeSpectrogram(lowpassAudio,Fs);
ylim([0 8000])

audiowrite('teamG5-highpass.wav',highpassAudio,Fs);
audiowrite('teamG5-lowpass.wav',lowpassAudio,Fs);

end

function isolateSpeech

[audioFile,Fs] = audioread('thequickbrownfox.wav');
makeSpectrogram(audioFile,Fs)
figure


F = [0 7999/Fs 8000/Fs 1];
A = [1 1 0 0];
[fil1, fil2] = firls(255,F,A);
filteredAudio = filter(fil1,fil2,audioFile);

downAudio = downsample(filteredAudio,2);
Fs = Fs/2;

makeSpectrogram(downAudio,Fs);

sound(downAudio,Fs)

audiowrite('teamG5-filteredspeech.wav',downAudio,Fs);

end

function makeSpectrogram(audio_data,Fs)

% A function to create a spectrogram of an audio recording (with time plot)

window = hamming(512);
N_overlap = 256;
N_fft = 1024;
[~,F,T,P] = spectrogram(audio_data,window,N_overlap,N_fft,Fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none');
axis tight;
view(0,90);
colormap(jet);
set(gca,'clim',[-80,-20]);
ylim([0 8000]);
title('Spectrogram');xlabel('Time (s)');ylabel('Frequency (Hz)');

end