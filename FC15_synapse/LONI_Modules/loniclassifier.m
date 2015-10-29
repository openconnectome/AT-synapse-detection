function loniclassifier(inputMatFile, outputFileName)
% SVM Classifier

load(inputMatFile);
ntrials = 100;

% Index of features to select
feature_inds = 1:(length(channelList) + 2);
[overallCMat, predicted_positive_detection, ...
    predicted_negative_detection, testones] = run_classifier(pred,...
    inputfeatures, puncta_isedge, feature_inds, ntrials);
disp('Classifier');

% Calculate accuracy
accuracyvec = zeros(ntrials, 1);
recallvec = zeros(ntrials, 1);
precisionvec = zeros(ntrials, 1);

for n=1:ntrials
    accuracyvec(n) = ...
        (overallCMat(1, 1, n) + overallCMat(2, 2, n)) ...
        / sum(sum(overallCMat(:, :, n)));
    
    precisionvec(n) = overallCMat(1, 1, n)/(overallCMat(1, 1, n) + overallCMat(2, 1, n));
    recallvec(n) = overallCMat(1, 1, n)/(overallCMat(1, 1, n) + overallCMat(1, 2, n));
end

final_accuracy = mean(accuracyvec)
final_recall = mean(recallvec)
final_precision = mean(precisionvec)


save(outputFileName, 'final_accuracy', 'final_recall', 'final_precision', ...
    'predicted_positive_detection', 'predicted_negative_detection', 'testones');


end
