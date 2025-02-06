% Initialize SPM
spm('defaults', 'fmri');
spm_jobman('initcfg');

% Directories
subject_dir = 'subjects/test/raw_mri'; % Directory containing the subject MRI scans
output_dir = 'subjects/test/normalized_mri'; % Directory to save normalized images
tpm_file = fullfile(spm('Dir'), 'tpm', 'TPM.nii'); % Path to SPM's default TPM.nii file

% List of subject MRI scans
subject_files = dir(fullfile(subject_dir, '*.nii')); % Assuming MRI files are .nii format

% Loop through each subject
for s = 1:length(subject_files)
    % Get subject file
    subject_file = fullfile(subject_dir, subject_files(s).name);
    [~, subject_name, ~] = fileparts(subject_files(s).name); % Extract subject name
    
    % Define output prefix (default: 'w' for "warped")
    output_prefix = 'w';
    
    % SPM Normalize batch
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {subject_file};
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {subject_file};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {tpm_file};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70; 78 76 85];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    
    % Run the normalization for the current subject
    spm_jobman('run', matlabbatch);
    
    % Clear the batch for the next iteration
    clear matlabbatch;
    
    % Display progress
    fprintf('Normalized MRI for subject: %s\n', subject_name);
end

disp('Normalization complete!');
