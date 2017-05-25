function [] = main()

if isempty(getenv('SCA_SERVICE_DIR'))
    disp('setting SCA_SERVICE_DIR to pwd')
    setenv('SCA_SERVICE_DIR', pwd)
end

disp('loading paths')
addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))


% normalizes the bvals and splits the bvecs

% load config.json
config = loadjson('config.json.copy');

% copy the dwi file to this directory
copyfile(config.dwi, 'dwi.nii.gz');

% Parameters used for normalization
params.thresholds.b0_normalize    = 200;
params.thresholds.bvals_normalize = 100;


%% Normalize HCP files to the VISTASOFT environment

bvals.val = dlmread(config.bvals);

% Round the numbers to the closest thousand 
% This is necessary because the VISTASOFT software does not handle the B0
% when they are not rounded.
[bvals.unique, ~, bvals.uindex] = unique(bvals.val);

bvals.unique(bvals.unique <= params.thresholds.b0_normalize) = 0;
bvals.unique  = round(bvals.unique./params.thresholds.bvals_normalize) ...
    *params.thresholds.bvals_normalize;
bvals.valnorm = bvals.unique( bvals.uindex );
dlmwrite('dwi.bvals',bvals.valnorm);



%load bvecs
bvecs = dlmread(config.bvecs);

%params
params.x_flip = config.xflip;
params.y_flip = config.yflip;
params.z_flip = config.zflip;

if ~(size(bvecs,1) == 3), bvecs = bvecs'; end

if params.x_flip
    bvecs(1,:) = -bvecs(1,:);
end
if params.y_flip
    bvecs(2,:) = -bvecs(2,:);
end
if params.z_flip
    bvecs(3,:) = -bvecs(3,:);
end

savejson('', config,'products.json')

dlmwrite('dwi.bvecs', bvecs);



% may not be necessary depending on the data structure?
% 
% if params.x_flip && params.y_flip && params.z_flip
%     dlmwrite(dwi_x_y_z_flipped.bvecs, bvecs);
% elseif params.x_flip && params.y_flip && ~params.z_flip
%     dlmwrite(dwi_x_y_flipped.bvecs, bvecs);
% elseif params.x_flip && ~params.y_flip && params.z_flip
%     dlmwrite(dwi_x_z_flipped.bvecs, bvecs);   
% elseif ~params.x_flip && params.y_flip && params.z_flip
%     dlmwrite(dwi_y_z_flipped.bvecs, bvecs);
% elseif params.x_flip && ~params.y_flip && ~params.z_flip
%     dlmwrite(dwi_x_flipped.bvecs, bvecs);
% elseif ~params.x_flip && params.y_flip && ~params.z_flip
%     dlmwrite(dwi_y_flipped.bvecs, bvecs);
% elseif ~params.x_flip && ~params.y_flip && params.z_flip
%     dlmwrite(dwi_z_flipped.bvecs, bvecs);
% end
end


