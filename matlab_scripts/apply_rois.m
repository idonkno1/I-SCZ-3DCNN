% Initialize SPM
spm('defaults', 'fmri');
spm_jobman('initcfg');

% Directories
subject_dir = 'subjects/test/normalized_mri'; % Directory with normalized MRIs
roi_dir = 'ROI'; % Directory with ROI masks
output_dir = 'subjects/test/subject_rois'; % Directory to save the results

% List of normalized MRIs
subject_files = dir(fullfile(subject_dir, 'w*.nii')); % Assuming subject files are named like "wT1_Subject01.nii"

% List of ROIs
roi_files = dir(fullfile(roi_dir, 'ROI_*.nii')); % Assuming ROI files are named like "ROI_Left_Thalamus.nii"

% Loop through each subject
for s = 1:length(subject_files)
    % Get subject file
    subject_file = fullfile(subject_dir, subject_files(s).name);
    [~, subject_name, ~] = fileparts(subject_files(s).name); % Extract subject name (e.g., "wT1_Subject01")
    
    % Loop through each ROI
    for r = 1:length(roi_files)
        % Get ROI file
        roi_file = fullfile(roi_dir, roi_files(r).name);
        [~, roi_name, ~] = fileparts(roi_files(r).name); % Extract ROI name (e.g., "ROI_Left_Thalamus")
        
        % Output filename
        output_file = fullfile(output_dir, [subject_name '_' roi_name '.nii']);
        
        % ImCalc batch
        matlabbatch{1}.spm.util.imcalc.input = {subject_file; roi_file};
        matlabbatch{1}.spm.util.imcalc.output = output_file;
        matlabbatch{1}.spm.util.imcalc.outdir = {output_dir};
        matlabbatch{1}.spm.util.imcalc.expression = 'i1 .* i2';
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{1}.spm.util.imcalc.options.mask = 0;
        matlabbatch{1}.spm.util.imcalc.options.interp = 1; % Trilinear interpolation
        matlabbatch{1}.spm.util.imcalc.options.dtype = 4; % INT16
        
        % Run batch
        spm_jobman('run', matlabbatch);
    end
end

disp('ROI processing complete!');
