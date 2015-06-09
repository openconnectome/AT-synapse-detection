function loniclassifier(inputMatFile, outputFileName) 
% SVM Classifier

load(inputMatFile); 

ntrials = 100;

% Classifier
% Index of features to select
feature_inds = 1:(length(channelList) + 2);
[overallCMat, psd_ids] = run_classifier(pred,...
    inputfeatures, puncta_isedge, feature_inds, ntrials);

disp('Classifier');

% Calculate accuracy

accuracyvec = zeros(ntrials, 1);

for n=1:ntrials
    accuracyvec(n) = ...
        (overallCMat(1, 1, n) + overallCMat(2, 2, n)) ...
        / sum(sum(overallCMat(:, :, n)));
end

final_accuracy = mean(accuracyvec)

save(outputFileName, 'final_accuracy', 'psd_ids'); 


end 
