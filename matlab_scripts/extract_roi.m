% Load SPM
spm('defaults', 'fmri');

% Define atlas file and output directory
atlas_file = 'Atlases/HarvardOxford-sub-maxprob-thr25-1mm.nii'; % Update with your path
output_dir = 'ROI'; % Update with your directory

% List of ROIs with their intensity values and names
roi_list = {
    4, 'Left_Thalamus';
    5, 'Left_Caudate';
    6, 'Left_Putamen';
    7, 'Left_Pallidum';
    9, 'Left_Hippocampus';
    10, 'Left_Amygdala';
    11, 'Left_Accumbens';
    15, 'Right_Thalamus';
    16, 'Right_Caudate';
    17, 'Right_Putamen';
    18, 'Right_Pallidum';
    19, 'Right_Hippocampus';
    20, 'Right_Amygdala';
    21, 'Right_Accumbens'
};

% Loop through each ROI and extract it
for i = 1:size(roi_list, 1)
    intensity = roi_list{i, 1};
    roi_name = roi_list{i, 2};
    
    % Define output filename
    output_file = fullfile(output_dir, ['ROI_' roi_name '.nii']);
    
    % ImCalc settings
    matlabbatch{1}.spm.util.imcalc.input = {atlas_file};
    matlabbatch{1}.spm.util.imcalc.output = output_file;
    matlabbatch{1}.spm.util.imcalc.outdir = {output_dir};
    matlabbatch{1}.spm.util.imcalc.expression = sprintf('i1 == %d', intensity);
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4; % INT16
    
    % Run batch
    spm_jobman('run', matlabbatch);
end
