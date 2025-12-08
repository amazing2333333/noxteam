%% 音频小波分析
clear; clc; close all;

% 1. 读取音频
data_path = 'D:\MATLAB_file\CWT\audiofile.wav';%写入路径
if ~exist(data_path, 'file')
    error('错误：文件不存在，请检查路径');
end

[z, fs] = audioread(data_path);
z = z(:, 1);  % 取左声道
z = (z - mean(z)) / (std(z) + eps);  % 零均值单位方差归一化

% 2. 参数设置
L = length(z);
dt = 1/fs;
t = (0:L-1)*dt;

% 3. 小波变换
[wt, f, coi] = cwt(z, 'amor', fs);
wt_mag = abs(wt);

% 4. 时频图
figure(1); clf;
pcolor(t, f, wt_mag);
shading interp;
colormap(gray(256));
colorbar;
hold on;
coi_interp = interp1(linspace(t(1), t(end), length(coi)), coi, t);
plot(t, coi_interp, 'w--', 'LineWidth', 1.5);
hold off;

xlabel('时间 (s)'); ylabel('频率 (Hz)');
title(['时频分析 (', num2str(fs), 'Hz)']);
xlim([t(1), min(t(end), 10)]);
ylim([0, min(fs/2, 2000)]);  




% 5. 数据导出
output_dir = '小波分析结果';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end
time_limit = min(2, t(end));
time_idx = find(t <= time_limit, 1, 'last');
if ~isempty(time_idx)
    freq_step = 15;
    freq_indices = 1:freq_step:size(wt_mag, 1);
    freq_indices = freq_indices(1:min(40, length(freq_indices)));  
    % 最多40个频率
    time_step = 150;
    time_indices = 1:time_step:time_idx;
    time_indices = time_indices(1:min(40, length(time_indices)));  
    % 最多40个时间点
    wt_mag_subset = wt_mag(freq_indices, time_indices);
    t_subset = t(time_indices);
    f_subset = f(freq_indices);
    excel_file = fullfile(output_dir, '小波系数样本.xlsx');
    excel_data = cell(length(f_subset)+1, length(t_subset)+1);
    excel_data{1, 1} = '频率(Hz)\时间(s)';
    for j = 1:length(t_subset)
        excel_data{1, j+1} = sprintf('t=%.3fs', t_subset(j));
    end
    for i = 1:length(f_subset)
        excel_data{i+1, 1} = f_subset(i);
        for j = 1:length(t_subset)
            excel_data{i+1, j+1} = wt_mag_subset(i, j);
        end
    end
    writecell(excel_data, excel_file);
    disp(['小波系数样本已保存到: ', excel_file]);
    disp(['数据维度: ', num2str(length(f_subset)), '×', num2str(length(t_subset))]);
end

% 6. 显示音频基本信息
disp('=== 音频基本信息 ===');
disp(['文件: ', data_path]);
disp(['采样率: ', num2str(fs), ' Hz']);
disp(['时长: ', num2str(L/fs, '%.2f'), ' 秒']);
disp(['小波系数维度: ', num2str(size(wt,1)), '×', num2str(size(wt,2))]);
disp('=== 分析完成 ===');