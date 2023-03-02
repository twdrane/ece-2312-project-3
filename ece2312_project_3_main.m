close all

%isolateSpeech();
%splitSignal();
%downsampleSplit();
%downsampleSplitX2();
resythesize();

function resythesize

[audioHighpassTop,Fs] = audioread('teamG5-highpassdowntop.wav');
[audioHighpassBottom,Fs] = audioread('teamG5-highpassdownbottom.wav');
[audioLowpassTop,Fs] = audioread('teamG5-lowpassdowntop.wav');
[audioLowpassBottom,Fs] = audioread('teamG5-lowpassdownbottom.wav');
Fs

upHighpassTop = upsample(audioHighpassTop,8);
upHighpassBottom = upsample(audioHighpassBottom,8);
upLowpassTop = upsample(audioLowpassTop,8);
upLowpassBottom = upsample(audioLowpassBottom,8);
Fs = Fs*8

F = [0 4999/Fs 5000/Fs 1];
A = [1 1 0 0];
[fil1, fil2] = firls(255,F,A);
upLowBottom = filter(fil1,fil2,upLowpassBottom);

G = [0 4999/Fs 5000/Fs 9999/Fs 10000/Fs 1];
B = [0 0 1 1 0 0];
[fil3, fil4] = firls(256,G,B);
upLowTop = filter(fil3,fil4,upLowpassTop);

H = [0 9999/Fs 10000/Fs 14999/Fs 15000/Fs 1];
C = [0 0 1 1 0 0];
[fil3, fil4] = firls(256,H,C);
upHighBottom = filter(fil3,fil4,upHighpassBottom);

I = [0 14999/Fs 15000/Fs 1];
D = [0 0 1 1];
[fil3, fil4] = firls(256,I,D);
upHighTop = filter(fil3,fil4,upHighpassTop);

reconstructed = upLowBottom + upLowTop + upHighBottom + upHighTop;


makeSpectrogram(reconstructed,Fs)
%figure
%makeSpectrogram(upLowTop,Fs);

audiowrite('teamG5-synthesized.wav',reconstructed,Fs);

sound(reconstructed,Fs)

end

function downsampleSplitX2
figure
[audioHighpass,Fs] = audioread('teamG5-highpassdown1.wav');
[audioLowpass,Fs] = audioread('teamG5-lowpassdown1.wav');

F = [0 4999/Fs 5000/Fs 1];
A = [1 1 0 0];
[fil1, fil2] = firls(255,F,A);
lowpassBottomAudio = filter(fil1,fil2,audioLowpass);

B = [0 0 1 1];
[fil3, fil4] = firls(256,F,B);
lowpassTopAudio = filter(fil3,fil4,audioLowpass);

F = [0 4999/Fs 5000/Fs 1];
A = [1 1 0 0];
[fil1, fil2] = firls(255,F,A);
highpassBottomAudio = filter(fil1,fil2,audioHighpass);

B = [0 0 1 1];
[fil3, fil4] = firls(256,F,B);
highpassTopAudio = filter(fil3,fil4,audioHighpass);

subplot(4,1,3);
makeSpectrogram(lowpassTopAudio,Fs)
ylim([0 Fs/2])
subplot(4,1,4);
makeSpectrogram(lowpassBottomAudio,Fs)
ylim([0 Fs/2])
%figure
subplot(4,1,1);
makeSpectrogram(highpassTopAudio,Fs)
ylim([0 Fs/2])
subplot(4,1,2);
makeSpectrogram(highpassBottomAudio,Fs)
ylim([0 Fs/2])

downHighpassTop = downsample(highpassTopAudio,2);
downHighpassBottom = downsample(highpassBottomAudio,2);
downLowpassTop = downsample(lowpassTopAudio,2);
downLowpassBottom = downsample(lowpassBottomAudio,2);
Fs = Fs/2

figure
subplot(2,1,1);
makeSpectrogram(downHighpassTop,Fs)
ylim([0 Fs/2])
subplot(2,1,2);
makeSpectrogram(downHighpassBottom,Fs)
ylim([0 Fs/2])
figure
subplot(2,1,1);
makeSpectrogram(downLowpassTop,Fs)
ylim([0 Fs/2])
subplot(2,1,2);
makeSpectrogram(downLowpassBottom,Fs)
ylim([0 Fs/2])

audiowrite('teamG5-highpassdowntop.wav',downHighpassTop,Fs+.5);
audiowrite('teamG5-highpassdownbottom.wav',downHighpassBottom,Fs+.5);
audiowrite('teamG5-lowpassdowntop.wav',downLowpassTop,Fs+.5);
audiowrite('teamG5-lowpassdownbottom.wav',downLowpassBottom,Fs+.5);

end

function downsampleSplit
figure
[audioHighpass,Fs] = audioread('teamG5-highpass.wav');
[audioLowpass,Fs] = audioread('teamG5-lowpass.wav');

downHighpass = downsample(audioHighpass,2);
downLowpass = downsample(audioLowpass,2);
Fs = Fs/2

subplot(2,1,1);
makeSpectrogram(downHighpass,Fs)
ylim([0 Fs/2])
subplot(2,1,2);
makeSpectrogram(downLowpass,Fs)
ylim([0 Fs/2])

audiowrite('teamG5-highpassdown1.wav',downHighpass,Fs);
audiowrite('teamG5-lowpassdown1.wav',downLowpass,Fs);

end

function splitSignal

[audioFile,Fs] = audioread('teamG5-filteredspeech.wav');

figure
F = [0 9999/Fs 10000/Fs 1];
A = [1 1 0 0];
[fil1, fil2] = firls(255,F,A);
lowpassAudio = filter(fil1,fil2,audioFile);

B = [0 0 1 1];
[fil3, fil4] = firls(256,F,B);
highpassAudio = filter(fil3,fil4,audioFile);

%lowpassAudio = downsample(lowpassAudio,2);
%Fs = Fs/2;

subplot(2,1,1);
makeSpectrogram(highpassAudio,Fs);
ylim([0 Fs/2])
subplot(2,1,2);
makeSpectrogram(lowpassAudio,Fs);
ylim([0 Fs/2])

audiowrite('teamG5-highpass.wav',highpassAudio,Fs);
audiowrite('teamG5-lowpass.wav',lowpassAudio,Fs);

end

function isolateSpeech

[audioFile,Fs] = audioread('thequickbrownfox.wav');
makeSpectrogram(audioFile,Fs)
figure


F = [0 21999/Fs 22000/Fs 1];
A = [1 1 0 0];
[fil1, fil2] = firls(255,F,A);
filteredAudio = filter(fil1,fil2,audioFile);

downAudio = downsample(filteredAudio,2);
Fs = Fs/2;

makeSpectrogram(downAudio,Fs);%fixxxx

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