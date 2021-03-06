% -----------------------------------------------------------------------------------------------------------------------------------
% PCA + LDA Combo Model
% Perform LDA on feature vectors obtained using PCA (1 to 10 images)
% Calculate the system using Mode #1 rules in PCA for LDA model
% -----------------------------------------------------------------------------------------------------------------------------------

clc
clear all
close all

% Initialize vectors
trainfeature = [];
testfeature = [];

% Build LDA Model
 [trainfeature, testfeature] = PCA_Process;
 [V, eigvector_sort, eigenVal] = LDA_for_PCA(trainfeature);
 

% Calculate Genuine and Impostor Scores
[GI] = Calc_Genuine_Impostor(trainfeature, testfeature, V);

% Label
[Label] = label();

% Plot ROC Curve
[roc,EER,area,EERthr,ALLthr] = ezroc3(GI, Label, 2, 0, 1);

% GAR and FAR from ROC
GAR = roc(1, :)';

% Get FRR and FAR
FRR = round((GAR + 1)*10^4)/10^4;
FAR = round((roc(2, :)')*10^4)/10^4;

% Obtain FRR values at 0%, 5%, 10% FAR
case1 = [];
case2 = [];
case3 = [];

% Obtain EER for corresponding threshold
for idx = 1:size(FAR,1)
% FRR = 0%
    if (FAR(idx, 1)  == 0)
        case1 = [case1,FRR(idx, 1)];
% FAR = 5%
    elseif (0.005 <= FAR(idx, 1) && FAR(idx, 1) <=0.0055)
        case2 = [case2,FRR(idx, 1)];
% FAR = 10%
    elseif (0.1 <= FAR(idx, 1) && FAR(idx, 1) <=0.1015)
        case3 = [case3,FRR(idx, 1)];
    end
end

