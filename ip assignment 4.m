clear all; close all; clc;

%% Load Image
img = imread('Barbara.png');

% Convert to grayscale if needed
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Convert to double for processing
img = im2double(img);

[M, N] = size(img);
fprintf('Image size: %d x %d\n', M, N);

%% ========================================================================
%% TASK 1: Manual Frequency Analysis (2D FFT + Visualization)
%% ========================================================================

fprintf('\n--- TASK 1: Computing 2D Fourier Transform ---\n');

% Compute 2D FFT
F = fft2(img);

% Shift zero frequency to center
F_shifted = fftshift(F);

% Compute magnitude and phase
magnitude = abs(F_shifted);
phase = angle(F_shifted);

% Log-scaled magnitude for visualization
magnitude_log = log(1 + magnitude);

% Create figure for Task 1
figure('Name', 'Task 1: Fourier Transform Analysis', 'Position', [100 100 1400 800]);

% Original Image
subplot(2,3,1);
imshow(img);
title('(a) Original Image', 'FontSize', 12, 'FontWeight', 'bold');

% Raw Magnitude Spectrum 
subplot(2,3,2);
mag_display = magnitude;
mag_display(mag_display > max(magnitude(:))*0.005) = max(magnitude(:))*0.005; % Clip extreme values
imshow(mag_display, []);
title('(b) Magnitude Spectrum (Raw - Clipped)', 'FontSize', 12, 'FontWeight', 'bold');
colormap(gca, 'hot');
colorbar;
text(10, 30, sprintf('Max: %.0f\nClipped at: %.0f', max(magnitude(:)), max(magnitude(:))*0.001), ...
    'Color', 'white', 'FontSize', 8, 'BackgroundColor', 'black');

% Log-Scaled Magnitude Spectrum
subplot(2,3,3);
imshow(magnitude_log, []);
title('(c) Magnitude Spectrum (Log-Scaled)', 'FontSize', 12, 'FontWeight', 'bold');
colormap(gca, 'hot');
colorbar;

% Phase Spectrum
subplot(2,3,4);
imshow(phase, []);
title('(d) Phase Spectrum', 'FontSize', 12, 'FontWeight', 'bold');
colormap(gca, 'hsv');
colorbar;

% Magnitude comparison 
subplot(2,3,5);
imshow(magnitude, [0 median(magnitude(:))*10]); % Use median for better scaling
title('(e) Magnitude (Enhanced)', 'FontSize', 12, 'FontWeight', 'bold');
colormap(gca, 'jet');
colorbar;

% 3D visualization of log magnitude
subplot(2,3,6);
[X, Y] = meshgrid(1:N, 1:M);
surf(X, Y, magnitude_log, 'EdgeColor', 'none');
view(45, 30);
title('(f) 3D Log Magnitude', 'FontSize', 12, 'FontWeight', 'bold');
colormap(gca, 'jet');
colorbar;
axis tight;
zlabel('Log Magnitude');

I = img;
log_mag = magnitude_log;
cx = floor(N/2) + 1;
cy = floor(M/2) + 1;

%% =========================================================
%% TASK 2 - MAGNITUDE VS PHASE EXPERIMENT
%% =========================================================

% 2D Fourier Transform
F = fft2(I);

% Separate magnitude and phase
Mag = abs(F);
Ph  = angle(F);

% Reconstruction using only magnitude (phase = 0)
F_mag_only = Mag .* exp(1j * 0);
I_mag_only = real(ifft2(F_mag_only));

% Reconstruction using only phase (magnitude = constant = 1)
F_phase_only = ones(size(F)) .* exp(1j * Ph);
I_phase_only = real(ifft2(F_phase_only));

I_mag_disp   = rescale(log(1 + abs(I_mag_only)));
I_phase_disp = rescale(I_phase_only);

% Show Task 2 results
figure('Color','w','Position',[100 100 1300 400]);

subplot(1,3,1);
imshow(I, []);
title('Original Barbara Image', 'FontSize', 14, 'FontWeight', 'bold');

subplot(1,3,2);
imshow(I_mag_disp, []);
title('Only Magnitude (Phase = 0)', 'FontSize', 14, 'FontWeight', 'bold');

subplot(1,3,3);
imshow(I_phase_disp, []);
title('Only Phase (Magnitude = Constant)', 'FontSize', 14, 'FontWeight', 'bold');

sgtitle('TASK 2 - Magnitude vs Phase Reconstruction', 'FontSize', 16, 'FontWeight', 'bold');


%% =========================================================
%% ---------------- TASK 3 : Frequency Interpretation ----------------
%% =========================================================

fprintf('\n========== TASK 3: FREQUENCY INTERPRETATION ==========\n');
fprintf('Center of spectrum -> LOW frequency components\n');
fprintf('Edges/corners -> HIGH frequency components\n');
fprintf('Smooth regions -> Low frequencies\n');
fprintf('Sharp edges/details -> High frequencies\n');

% Task 3 - Show spectrum with marked regions
figure('Name','Task 3 - Frequency Interpretation','NumberTitle','off', ...
       'Position', [50, 100, 1600, 700]);

% Original image with marked regions
subplot(2,3,1);
imshow(I, []);
title('Original Image');
hold on;
% Mark smooth region (background/uniform area)
rectangle('Position', [50, 50, 100, 100], 'EdgeColor', 'b', 'LineWidth', 2.5);
text(55, 45, 'Smooth Region', 'Color', 'b', 'FontSize', 11, 'FontWeight', 'bold');

% Mark edge region (hair, fabric patterns)
rectangle('Position', [300, 150, 100, 100], 'EdgeColor', 'r', 'LineWidth', 2.5);
text(305, 145, 'Edge/Detail Region', 'Color', 'r', 'FontSize', 11, 'FontWeight', 'bold');
hold off;

% Log Magnitude Spectrum with annotations
subplot(2,3,2);
imshow(log_mag, [], 'InitialMagnification', 'fit');
title('Log Magnitude Spectrum');
colormap(gca, gray);
hold on;

% Low-frequency region (center circle)
r_low = 40;
theta = linspace(0, 2*pi, 300);
x_low = cx + r_low*cos(theta);
y_low = cy + r_low*sin(theta);
plot(x_low, y_low, 'g', 'LineWidth', 2.5);
text(cx+10, cy, 'Low Frequency (Center)', 'Color', 'g', ...
     'FontSize', 11, 'FontWeight', 'bold', 'BackgroundColor', 'k');

% High-frequency regions (corners/edges)
% Top-left corner
rectangle('Position', [5, 5, 70, 70], 'EdgeColor', 'r', 'LineWidth', 2.5);
% Top-right corner
rectangle('Position', [N-75, 5, 70, 70], 'EdgeColor', 'r', 'LineWidth', 2.5);
% Bottom-left corner
rectangle('Position', [5, M-75, 70, 70], 'EdgeColor', 'r', 'LineWidth', 2.5);
% Bottom-right corner
rectangle('Position', [N-75, M-75, 70, 70], 'EdgeColor', 'r', 'LineWidth', 2.5);

% Labels for high-frequency regions
text(20, 20, 'High Freq', 'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'k');
text(N-65, 20, 'High Freq', 'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'k');
text(20, M-15, 'High Freq', 'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'k');
text(N-65, M-15, 'High Freq', 'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'k');
hold off;

% 3D visualization of spectrum
subplot(2,3,3);
mesh(log_mag(cy-50:cy+50, cx-50:cx+50));
title('3D View of Spectrum (Center Region)');
xlabel('X'); ylabel('Y'); zlabel('Log Magnitude');
colormap(gca, jet);

%% =========================================================
%% ---------------- TASK 4 : Frequency Domain Filtering ----------------
%% =========================================================

fprintf('\n========== TASK 4: FREQUENCY DOMAIN FILTERING ==========\n');

% Create distance matrix from center
[X, Y] = meshgrid(1:N, 1:M);
D = sqrt((X - cx).^2 + (Y - cy).^2);

% Test different cutoff frequencies
D0_values = [20, 40, 80];

%% IDEAL FILTERS
figure('Name','Task 4 - Ideal Filters (Multiple D0 values)','NumberTitle','off', ...
       'Position', [50, 50, 1600, 900]);

for idx = 1:length(D0_values)
    D0 = D0_values(idx);
    fprintf('\n--- Cutoff radius D0 = %d pixels ---\n', D0);
    
    % Ideal Low-pass and High-pass masks
    H_low = double(D <= D0);
    H_high = double(D > D0);
    
    % Apply filters
    F_low = F_shifted .* H_low;
    F_high = F_shifted .* H_high;
    
    % Reconstruct images
    img_low = real(ifft2(ifftshift(F_low)));
    img_high = real(ifft2(ifftshift(F_high)));
    
    % Calculate magnitude spectra
    log_mag_low = log(1 + abs(F_low));
    log_mag_high = log(1 + abs(F_high));
    
    % Display Low-pass results
    subplot(3, 6, idx);
    imshow(H_low, []);
    title(sprintf('Low-pass Mask (D0=%d)', D0));
    
    subplot(3, 6, idx + 3);
    imshow(log_mag_low, []);
    title(sprintf('Filtered Spectrum'));
    colormap(gca, gray);
    
    subplot(3, 6, idx + 6);
    imshow(img_low, []);
    title(sprintf('Reconstructed (Blurred)'));
    
    % Display High-pass results
    subplot(3, 6, idx + 9);
    imshow(H_high, []);
    title(sprintf('High-pass Mask (D0=%d)', D0));
    
    subplot(3, 6, idx + 12);
    imshow(log_mag_high, []);
    title(sprintf('Filtered Spectrum'));
    colormap(gca, gray);
    
    subplot(3, 6, idx + 15);
    imshow(img_high, []);
    title(sprintf('Reconstructed (Edges)'));
    
    fprintf('Low-pass: Removes high freq -> Blurring effect\n');
    fprintf('High-pass: Removes low freq -> Edge enhancement\n');
end

%% GAUSSIAN FILTERS (Smoother results)
fprintf('\n========== BONUS: GAUSSIAN FILTERS (Smoother than Ideal) ==========\n');

figure('Name','Task 4 - Gaussian Filters','NumberTitle','off', ...
       'Position', [100, 100, 1600, 800]);

D0 = 40;  % Choose middle value
fprintf('Using Gaussian filter with D0 = %d\n', D0);

% Gaussian Low-pass and High-pass
H_low_gauss = exp(-(D.^2) / (2*(D0^2)));
H_high_gauss = 1 - H_low_gauss;

% Apply filters
F_low_gauss = F_shifted .* H_low_gauss;
F_high_gauss = F_shifted .* H_high_gauss;

% Reconstruct
img_low_gauss = real(ifft2(ifftshift(F_low_gauss)));
img_high_gauss = real(ifft2(ifftshift(F_high_gauss)));

% Magnitude spectra
log_mag_low_gauss = log(1 + abs(F_low_gauss));
log_mag_high_gauss = log(1 + abs(F_high_gauss));

% Display
subplot(2,4,1);
imshow(I, []);
title('Original Image');

subplot(2,4,2);
imshow(log_mag, []);
title('Original Spectrum');
colormap(gca, gray);

subplot(2,4,3);
imshow(H_low_gauss, []);
title('Gaussian Low-pass Mask');

subplot(2,4,4);
imshow(log_mag_low_gauss, []);
title('Filtered Spectrum (Low-pass)');
colormap(gca, gray);

subplot(2,4,5);
imshow(img_low_gauss, []);
title('Reconstructed (Gaussian Low-pass)');

subplot(2,4,6);
imshow(H_high_gauss, []);
title('Gaussian High-pass Mask');

subplot(2,4,7);
imshow(log_mag_high_gauss, []);
title('Filtered Spectrum (High-pass)');
colormap(gca, gray);

subplot(2,4,8);
imshow(img_high_gauss, []);
title('Reconstructed (Gaussian High-pass)');

fprintf('\nGaussian filters provide smoother transitions (less ringing artifacts)\n');

%% COMPARISON: Ideal vs Gaussian
figure('Name','Comparison: Ideal vs Gaussian Filters','NumberTitle','off', ...
       'Position', [150, 150, 1400, 600]);

subplot(2,3,1);
imshow(I, []);
title('Original Image');

% Ideal filters
H_low_ideal = double(D <= 40);
H_high_ideal = 1 - H_low_ideal;
img_low_ideal = real(ifft2(ifftshift(F_shifted .* H_low_ideal)));
img_high_ideal = real(ifft2(ifftshift(F_shifted .* H_high_ideal)));

subplot(2,3,2);
imshow(img_low_ideal, []);
title('Ideal Low-pass (D0=40)');

subplot(2,3,3);
imshow(img_high_ideal, []);
title('Ideal High-pass (D0=40)');

subplot(2,3,4);
plot(0:N-1, H_low_ideal(cy, :), 'r', 'LineWidth', 2);
hold on;
plot(0:N-1, H_low_gauss(cy, :), 'b', 'LineWidth', 2);
title('Filter Profile Comparison');
xlabel('Distance from center');
ylabel('Filter response');
legend('Ideal', 'Gaussian', 'Location', 'best');
grid on;

subplot(2,3,5);
imshow(img_low_gauss, []);
title('Gaussian Low-pass (D0=40)');

subplot(2,3,6);
imshow(img_high_gauss, []);
title('Gaussian High-pass (D0=40)');

%% =========================================================
%% TASK 5 - FAILURE CASE DESIGN
%% Chosen case: Noise-dominated image
%% =========================================================

% Variance = 0.1
I_noise = imnoise(I, 'gaussian', 0, 0.1);

% Improvement method: Gaussian smoothing before FFT
% Sigma = 1.2
% 1.2 It strikes a balance between noise reduction and detail preservation.
I_denoised = imgaussfilt(I_noise, 1.2);

% Fourier transforms 
F_orig     = fftshift(fft2(I));
F_noise    = fftshift(fft2(I_noise));
F_denoised = fftshift(fft2(I_denoised));

% Log-magnitude spectra
Mag_orig     = log(1 + abs(F_orig));
Mag_noise    = log(1 + abs(F_noise));
Mag_denoised = log(1 + abs(F_denoised));

% Normalize for display
Mag_orig_disp     = mat2gray(Mag_orig);
Mag_noise_disp    = mat2gray(Mag_noise);
Mag_denoised_disp = mat2gray(Mag_denoised);

% Show Task 5 results
figure('Color','w','Position',[100 100 1400 800]);

subplot(2,3,1);
imshow(I, []);
title('Original Image', 'FontSize', 14, 'FontWeight', 'bold');

subplot(2,3,2);
imshow(I_noise, []);
title('Noise-Dominated Image (\sigma^2=0.1)', 'FontSize', 14, 'FontWeight', 'bold');

subplot(2,3,3);
imshow(I_denoised, []);
title('Denoised Image (Gaussian \sigma=1.2)', 'FontSize', 14, 'FontWeight', 'bold');

subplot(2,3,4);
imshow(Mag_orig_disp, []);
title('Original Fourier Spectrum', 'FontSize', 14, 'FontWeight', 'bold');

subplot(2,3,5);
imshow(Mag_noise_disp, []);
title('Failure: Noisy Fourier Spectrum', 'FontSize', 14, 'FontWeight', 'bold');

subplot(2,3,6);
imshow(Mag_denoised_disp, []);
title('Improved Spectrum After Denoising', 'FontSize', 14, 'FontWeight', 'bold');

sgtitle('TASK 5 - Failure Case: Noise-Dominated Frequency Analysis', 'FontSize', 16, 'FontWeight', 'bold');

%% =========================================================
%% Mathematical explanation in command window
%% =========================================================

disp('====================================================');
disp('TASK 2 - MAGNITUDE VS PHASE');
disp('F(u,v) = |F(u,v)| * exp(j*phi(u,v))');
disp('Only Magnitude: F_mag(u,v) = |F(u,v)| * exp(j*0) = |F(u,v)|');
disp('Only Phase:     F_phase(u,v) = 1 * exp(j*phi(u,v))');
disp(' ');
disp('Phase encodes SPATIAL POSITION of each frequency component.');
disp('Without phase, object locations are lost -> image unrecognizable.');
disp('Magnitude encodes ENERGY/STRENGTH only -> no structural info.');
disp('====================================================');
disp('TASK 5 - FAILURE CASE DESIGN');
disp('g(x,y) = f(x,y) + n(x,y)');
disp('G(u,v) = F(u,v) + N(u,v)');
disp('Strong noise (var=0.1) spreads energy across ALL frequencies,');
disp('especially high frequencies -> structural content masked.');
disp('Noisy spectrum: high-freq region elevated uniformly (flat noise floor).');
disp('Improvement: Gaussian smoothing (sigma=1.2) before FFT');
disp('  -> attenuates high-freq noise -> structural peaks become visible.');
disp('====================================================');

%% ========================================================================
%% TASK 6: Log Scaling Analysis 
%% ========================================================================

fprintf('\n--- TASK 6: Log Scaling Analysis ---\n');

figure('Name', 'Task 6: Log Scaling Comparison', 'Position', [350 350 1400 600]);

% Without log (DÜZELTME: Show only DC spike)
subplot(1,3,1);
mag_display = magnitude;
mag_display(mag_display > max(magnitude(:))*0.01) = max(magnitude(:))*0.01;
imshow(mag_display, []);
title('Without Log Scaling', 'FontSize', 12, 'FontWeight', 'bold');
colormap(gca, 'jet');
colorbar;
text(10, 30, 'Only DC visible!', 'Color', 'white', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'red');

% With log
subplot(1,3,2);
imshow(magnitude_log, []);
title('With Log Scaling', 'FontSize', 12, 'FontWeight', 'bold');
colormap(gca, 'jet');
colorbar;
text(10, 30, 'All frequencies visible', 'Color', 'white', 'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', 'green');

% Histogram comparison 
subplot(1,3,3);
hold on;
h1 = histogram(magnitude(:), 1000, 'Normalization', 'count', 'EdgeColor', 'none', 'FaceColor', 'blue', 'FaceAlpha', 0.6);
h2 = histogram(magnitude_log(:), 100, 'Normalization', 'count', 'EdgeColor', 'none', 'FaceColor', 'red', 'FaceAlpha', 0.6);
set(gca, 'YScale', 'log'); % CRITICAL: Log scale for Y
set(gca, 'XScale', 'log');
legend('Raw Magnitude', 'Log Magnitude', 'Location', 'northeast');
title('Histogram Comparison', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Intensity Value');
ylabel('Pixel Count (log scale)');
grid on;
hold off;

% Statistics 
fprintf('\n=== MAGNITUDE STATISTICS ===\n');
fprintf('Raw Magnitude:\n');
fprintf('  Min     = %.4e\n', min(magnitude(:)));
fprintf('  Max     = %.4e\n', max(magnitude(:)));
fprintf('  Mean    = %.4e\n', mean(magnitude(:)));
fprintf('  Median  = %.4e\n', median(magnitude(:)));
fprintf('  Dynamic Range = %.2e (%.0f:1)\n', max(magnitude(:))/min(magnitude(magnitude>0)), max(magnitude(:))/min(magnitude(magnitude>0)));
fprintf('\nLog Magnitude:\n');
fprintf('  Min     = %.4f\n', min(magnitude_log(:)));
fprintf('  Max     = %.4f\n', max(magnitude_log(:)));
fprintf('  Mean    = %.4f\n', mean(magnitude_log(:)));
fprintf('  Median  = %.4f\n', median(magnitude_log(:)));
fprintf('  Dynamic Range = %.2f (%.0f:1)\n', max(magnitude_log(:))/min(magnitude_log(:)), max(magnitude_log(:))/min(magnitude_log(:)));