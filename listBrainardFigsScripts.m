function vScriptsList = ListBrainardFigsScripts
% ListBrainardFigsScripts
%
% List the script directories to be validated.
  
% Get the validation rootDir
rootDir = UnitTest.getPref('validationRootDir');
        
vScriptsList = {...
                {fullfile(rootDir, 'scripts', 'AnnReviewColor2015', '1_TrichromMetam')} ... 
                {fullfile(rootDir, 'scripts', 'AnnReviewColor2015', '2_ConePlanes')} ... 
                {fullfile(rootDir, 'scripts', 'AnnReviewColor2015', '4_BasicAliasing')} ...
                {fullfile(rootDir, 'scripts', 'AnnReviewColor2015', 'X_SpatioChromaticAliasing')} ...
            };