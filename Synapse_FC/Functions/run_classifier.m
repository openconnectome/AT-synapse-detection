function [overallCMat, psd_ids] = run_classifier(pred, inputfeatures, ...
    puncta_isedge, feature_inds, ntrials)
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

overallCMat = zeros(2, 2, ntrials);

figure; hold on;
for trial=1:ntrials
    
    trainfrac = 0.2; % #ARBITRARY
    
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
    
    psd_ids = testones(predicted_labels);
    
end

% Plot PR Curve
plot(X, Y)
grid on
xlabel('Recall');
ylabel('Precision');
title('PR Curve');


end

