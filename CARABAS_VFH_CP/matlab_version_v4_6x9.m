% SAR Change Detection Project - MATLAB Implementation
% This script implements the NPCBS and NPC methods using a FIXED,
% NON-OVERLAPPING WINDOW approach for background estimation.
% CORRECTED VERSION: Uses direct math for PDF/CDF calculations.

clear; clc; close all;

%% 1. SETUP: Paths, Metadata, and Helper Functions

% --- TO DO: Update these paths ---
IMAGE_DIR = 'images';
TARGET_DIR = 'target_lists';
PARAM_DIR = 'parameter_maps_matlab_fixed_6x9'; % Use a new directory for these results

if ~exist(PARAM_DIR, 'dir')
   mkdir(PARAM_DIR);
end

% --- Image Metadata ---
image_metadata = [
    struct('mission', 2, 'pass', 1, 'heading', 225, 'deployment', 'Sigismund', 'filename', 'v02_2_1_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 2, 'pass', 2, 'heading', 135, 'deployment', 'Sigismund', 'filename', 'v02_2_2_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 2, 'pass', 3, 'heading', 225, 'deployment', 'Sigismund', 'filename', 'v02_2_3_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 2, 'pass', 4, 'heading', 135, 'deployment', 'Sigismund', 'filename', 'v02_2_4_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 2, 'pass', 5, 'heading', 230, 'deployment', 'Sigismund', 'filename', 'v02_2_5_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 2, 'pass', 6, 'heading', 230, 'deployment', 'Sigismund', 'filename', 'v02_2_6_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 3, 'pass', 1, 'heading', 225, 'deployment', 'Karl', 'filename', 'v02_3_1_2.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 3, 'pass', 2, 'heading', 135, 'deployment', 'Karl', 'filename', 'v02_3_2_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 3, 'pass', 3, 'heading', 225, 'deployment', 'Karl', 'filename', 'v02_3_3_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 3, 'pass', 4, 'heading', 135, 'deployment', 'Karl', 'filename', 'v02_3_4_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 3, 'pass', 5, 'heading', 230, 'deployment', 'Karl', 'filename', 'v02_3_5_2.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 3, 'pass', 6, 'heading', 230, 'deployment', 'Karl', 'filename', 'v02_3_6_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 4, 'pass', 1, 'heading', 225, 'deployment', 'Fredrik', 'filename', 'v02_4_1_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 4, 'pass', 2, 'heading', 135, 'deployment', 'Fredrik', 'filename', 'v02_4_2_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 4, 'pass', 3, 'heading', 225, 'deployment', 'Fredrik', 'filename', 'v02_4_3_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 4, 'pass', 4, 'heading', 135, 'deployment', 'Fredrik', 'filename', 'v02_4_4_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 4, 'pass', 5, 'heading', 230, 'deployment', 'Fredrik', 'filename', 'v02_4_5_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 4, 'pass', 6, 'heading', 230, 'deployment', 'Fredrik', 'filename', 'v02_4_6_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 5, 'pass', 1, 'heading', 225, 'deployment', 'Adolf-Fredrik', 'filename', 'v02_5_1_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 5, 'pass', 2, 'heading', 135, 'deployment', 'Adolf-Fredrik', 'filename', 'v02_5_2_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 5, 'pass', 3, 'heading', 225, 'deployment', 'Adolf-Fredrik', 'filename', 'v02_5_3_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 5, 'pass', 4, 'heading', 135, 'deployment', 'Adolf-Fredrik', 'filename', 'v02_5_4_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 5, 'pass', 5, 'heading', 230, 'deployment', 'Adolf-Fredrik', 'filename', 'v02_5_5_1.a.Fbp.RFcorr.Geo.Magn'), ...
    struct('mission', 5, 'pass', 6, 'heading', 230, 'deployment', 'Adolf-Fredrik', 'filename', 'v02_5_6_1.a.Fbp.RFcorr.Geo.Magn')
];
epsilon = 1e-9;

%% 2. Data Preparation
disp('--- Data Preparation ---');
surveillance_info = image_metadata(1);
background_stack_info = image_metadata([image_metadata.heading] == surveillance_info.heading & ~strcmp({image_metadata.deployment}, surveillance_info.deployment));
fprintf('Surveillance Image: %s\n', surveillance_info.filename);
surveillance_image = readSARImage(fullfile(IMAGE_DIR, surveillance_info.filename));
background_stack = zeros(3000, 2000, 6);
for i = 1:6
    background_stack(:,:,i) = readSARImage(fullfile(IMAGE_DIR, background_stack_info(i).filename));
end
ground_truth = loadGroundTruth(surveillance_info.deployment, TARGET_DIR);
fprintf('Loaded %d ground truth targets for %s.\n\n', size(ground_truth, 1), surveillance_info.deployment);

%% 3. Rician Background Modeling (FIXED WINDOWS)
disp('--- Rician Background Modeling (Fixed, Non-Overlapping Windows) ---');
param_file = fullfile(PARAM_DIR, 'rician_fixed_params_6x9.mat');

if exist(param_file, 'file')
    disp('Loading pre-calculated fixed-window Rician parameter maps...');
    load(param_file, 'nu_map', 'sigma_map');
else
    disp('Performing fixed-window Rician MLE fit. This will be faster.');
    tic;
    [rows, cols] = size(surveillance_image);
    nu_map = zeros(rows, cols);
    sigma_map = zeros(rows, cols);
    
    BLOCK_HEIGHT = 6;
    BLOCK_WIDTH = 9;
    
    rician_pdf = @(x, nu, sigma) (x ./ (sigma^2)) .* exp(-(x.^2 + nu^2) / (2 * sigma^2)) .* besseli(0, (x * nu) / (sigma^2));
    options = statset('MaxIter', 2000, 'MaxFunEvals', 4000);

    for r_start = 1:BLOCK_HEIGHT:rows
        for c_start = 1:BLOCK_WIDTH:cols
            r_end = min(r_start + BLOCK_HEIGHT - 1, rows);
            c_end = min(c_start + BLOCK_WIDTH - 1, cols);
            block_data = background_stack(r_start:r_end, c_start:c_end, :);
            samples = block_data(:);
            try
                start_points = [mean(samples), std(samples)];
                params = mle(samples, 'pdf', rician_pdf, 'start', start_points, 'LowerBound', [0, epsilon], 'Options', options);
                nu_val = params(1);
                sigma_val = params(2);
            catch
                nu_val = mean(samples);
                sigma_val = std(samples);
            end
            nu_map(r_start:r_end, c_start:c_end) = nu_val;
            sigma_map(r_start:r_end, c_start:c_end) = sigma_val;
        end
        if mod(r_start - 1, 96) == 0
             fprintf('Processed up to row %d/%d... Time elapsed: %.2f minutes.\n', r_start, rows, toc/60);
        end
    end
            
    fprintf('Fixed-window MLE fitting complete. Saving maps to disk...\n');
    save(param_file, 'nu_map', 'sigma_map');
end

% Ensure sigma is not zero to avoid division errors
sigma_map(sigma_map <= 0) = epsilon;

disp('Background model is ready.');
disp(' ');

%% 4. ROC Curve Generation
disp('--- ROC Curve Generation ---');
pfa_thresholds = [1e-2, 5e-3, 1e-3, 5e-4, 1e-4, 5e-5, 1e-5, 5e-6, 1e-6];
tau_thresholds = [1, 10, 100, 1000, 1e4, 1e5, 1e6, 1e7];
npcbs_results = zeros(length(pfa_thresholds), 2);
npc_results = zeros(length(tau_thresholds), 2);

% --- Method 1: NPCBS ---
disp('Running NPCBS method...');
for i = 1:length(pfa_thresholds)
    p_fa = pfa_thresholds(i);
    detection_threshold = 1 - p_fa;
    % --- MODIFIED SECTION: Direct CDF calculation using Marcum Q-function ---
    cdf_values = 1 - marcumq(nu_map ./ sigma_map, surveillance_image ./ sigma_map);
    % --- END MODIFIED SECTION ---
    detection_map = cdf_values >= detection_threshold;
    [pd, far] = evaluatePerformance(detection_map, ground_truth);
    npcbs_results(i, :) = [far, pd];
    fprintf('  P_FA=%.1e -> Pd=%.2f%%, FAR=%.2f\n', p_fa, pd*100, far);
end

% --- Method 2: NPC ---
disp(newline); disp('Running NPC method...');
a_min = 0.4;
a_max = max(surveillance_image(:));

% --- MODIFIED SECTION: Direct PDF calculation ---
x = surveillance_image;
nu = nu_map;
sigma = sigma_map;
p_background = (x ./ (sigma.^2)) .* exp(-(x.^2 + nu.^2) ./ (2 * sigma.^2)) .* besseli(0, (x .* nu) ./ sigma.^2);
% --- END MODIFIED SECTION ---

p_target = unifpdf(surveillance_image, a_min, a_max);
likelihood_ratio = p_target ./ (p_background + epsilon);
for i = 1:length(tau_thresholds)
    tau = tau_thresholds(i);
    detection_map = likelihood_ratio >= tau;
    [pd, far] = evaluatePerformance(detection_map, ground_truth);
    npc_results(i, :) = [far, pd];
    fprintf('  Tau=%.0e -> Pd=%.2f%%, FAR=%.2f\n', tau, pd*100, far);
end

%% 5. Plotting the ROC Curve
disp(newline); disp('--- Plotting ROC Curve ---');
figure('Name', 'ROC Curve (6x9 Fixed Windows)', 'Position', [100, 100, 800, 600]);
npcbs_results = sortrows(npcbs_results);
npc_results = sortrows(npc_results);
semilogx(npcbs_results(:,1), npcbs_results(:,2), 'o-', 'LineWidth', 1.5, 'MarkerSize', 8);
hold on;
semilogx(npc_results(:,1), npc_results(:,2), 's-', 'LineWidth', 1.5, 'MarkerSize', 8);
hold off;
grid on;
xlabel('False Alarm Rate (FAR) [alarms/km²]');
ylabel('Probability of Detection (Pd)');
title('ROC Curve Comparison (6x9 Fixed-Window MLE)');
legend('NPCBS Method', 'NPC Method (a_min=0.4)', 'Location', 'SouthEast');
ylim([0, 1.05]);
xlim([1e-2, 1e2]);

%% Helper Functions
function img = readSARImage(filepath, rows, cols)
    if nargin < 2; rows = 3000; cols = 2000; end
    fid = fopen(filepath, 'r', 'ieee-be');
    img = fread(fid, [cols, rows], 'float32')';
    fclose(fid);
end
function gt_pixels = loadGroundTruth(deployment_name, target_dir)
    filename = fullfile(target_dir, [deployment_name, '.Targets.txt']);
    data = readmatrix(filename);
    geo_coords = data(:, 1:2);
    Nmax = 7370488; Emin = 1653166;
    gt_pixels = zeros(size(geo_coords));
    gt_pixels(:,1) = round(Nmax - geo_coords(:,1));
    gt_pixels(:,2) = round(geo_coords(:,2) - Emin);
end
function [pd, far] = evaluatePerformance(detection_map, ground_truth_pixels)
    se = strel('disk', 1);
    eroded_map = imerode(detection_map, se);
    processed_map = imdilate(eroded_map, se, 2);
    cc = bwconncomp(processed_map);
    if cc.NumObjects == 0; pd = 0; far = 0; return; end
    stats = regionprops(cc, 'Centroid');
    detected_centroids = cat(1, stats.Centroid);
    detected_centers = [detected_centroids(:,2), detected_centroids(:,1)];
    match_radius = 10.0;
    num_true_targets = size(ground_truth_pixels, 1);
    dist_matrix = pdist2(ground_truth_pixels, detected_centers);
    min_dists_to_detection = min(dist_matrix, [], 2);
    true_positives = sum(min_dists_to_detection <= match_radius);
    min_dists_to_target = min(dist_matrix, [], 1);
    false_positives = sum(min_dists_to_target > match_radius);
    image_area_km2 = 6.0;
    pd = true_positives / num_true_targets;
    far = false_positives / image_area_km2;
end

