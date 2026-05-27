clc;
clear;
close all;

%% 参数设置
N = 1e5;                 % 比特数
SNR_dB = 0:10;           % SNR范围(dB)
BER = zeros(size(SNR_dB));

%% 生成随机比特
bits = randi([0 1], 1, N);

%% BPSK调制
% 0 -> -1
% 1 -> +1
symbols = 2*bits - 1;

%% SNR循环
for k = 1:length(SNR_dB)

    % dB转线性
    snr_linear = 10^(SNR_dB(k)/10);

    % 高斯噪声标准差
    noise_sigma = sqrt(1/(2*snr_linear));

    % 生成AWGN噪声
    noise = noise_sigma * randn(1, N);

    % 接收信号
    received = symbols + noise;

    % BPSK解调
    detected_bits = received > 0;

    % 误码统计
    errors = sum(bits ~= detected_bits);

    % BER计算
    BER(k) = errors / N;

    fprintf('SNR = %d dB, BER = %e\n', ...
        SNR_dB(k), BER(k));

end

%% 理论BER
snr_theory = 10.^(SNR_dB/10);

BER_theory = 0.5 * erfc(sqrt(snr_theory));

%% 绘图
figure;

semilogy(SNR_dB, BER, 'ro-','LineWidth',2);
hold on;

semilogy(SNR_dB, BER_theory, 'b--','LineWidth',2);

grid on;

xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BPSK over AWGN Channel');

legend('Simulation','Theory');