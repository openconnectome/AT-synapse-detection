function [overallCMat, predicted_positive_detection, ...
    predicted_negative_detection, testones] = ...
    run_classifier(pred, inputfeatures, puncta_isedge, feature_inds, ntrials)
% Run SVM Classifier
% INPUTS
% pred - vector, truth labels
% inputfeatures - mat, input features
% puncta_isedge - vec, 1 if puncta is on the edge
% feature_inds - vector, which features to use
% ntrials - int, number of times to run the classifier
% OUTPUTS
% overallCMat - average confusion matrix
% psd_ids - puncta
% RF requires tinevez-matlab-tree-07d4f1

overallCMat = zeros(2, 2, ntrials);

for trial=1:ntrials
    
    trainfrac = 0.2;
    
    randvec = rand(size(pred));
    
    trainones = find(and(randvec > trainfrac, puncta_isedge(:) == 0));
    testones = find(and(randvec <= trainfrac, puncta_isedge(:) == 0));
    
    % train/cross validate SVM
    
    SVMModel = fitcsvm(inputfeatures(trainones, feature_inds), ...
        pred(trainones), 'KernelFunction','linear','Standardize', true);
    
    % predict new data
    [predicted_labels, scoreTest] = predict(SVMModel, inputfeatures(testones, feature_inds));
    
    
    test_labels = double(pred(testones));
    
    % PR Curve
    [X, Y] = perfcurve(test_labels, scoreTest(:, 2) , 1, ...
        'xCrit', 'reca', 'yCrit', 'prec');
    
    %Confusion Matrix
    [CTest, orderTest] = confusionmat(double(predicted_labels), test_labels);
    overallCMat(:, :, trial) = CTest;
    
    predicted_positive_detection = testones(predicted_labels);
    predicted_negative_detection = testones(~predicted_labels);
    
end

% Plot PR Curve
figure; hold on;
plot(X, Y)
grid on
xlabel('Recall');
ylabel('Precision');
title('PR Curve');


end

