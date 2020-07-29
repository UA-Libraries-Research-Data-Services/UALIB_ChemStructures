% UALIB_Chemical_Structures_Stats
% V.F. Scalfani
% Matlab R2020a, run on Ubuntu Linux 18.04
% July 15, 2020

%% import data

% UALIB_Structure_Data_TableExport_edited_NaNsubs_filtered.txt

%{
Columnn Number:

1. SID
2. RegID
3. CID	
4. IsomericSMILES
5. InChI
6. InChIKey
7. Num_SIDs_Same
8. Num_SIDs_Mixture
9. Num_SIDs_All
10. Num_CIDs_Component
11. Num_CIDs_SameConnectivity
12. Num_CIDs_Similarity90
13. Num_assay_Summary
14. Num_SynthRefs
15. Num_CIDs_wRelatedAnnotations
16. Num_thiemechemistry
17. Num_patent
18. Num_pubmed
19. Num_springernature
20. Num_wiley
21. Num_Literature_total
%}

cd('/home/.../Data Analysis');
fileID = fopen('UALIB_Structure_Data_TableExport_edited_NaNsubs_filtered.txt', 'r');
formatSpec = '%s %s %s %s %s %s %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d';
UABibData = textscan(fileID, formatSpec,'HeaderLines',1, 'Delimiter', '\t');
fclose(fileID);

SID = UABibData{:,1};

UABibData_Nums = UABibData(7:21);
UABibData_Nums_labels = {'Number of SIDs (Same)', 'Number of SIDs (Mixture)', 'Number of SIDs (All)',...
    'Number of CIDs (Component)','Number of CIDs (Same Connectivity)', 'Number of CIDs (Similarity 90%)',...
    'Number of Assay (Summary)','Number of Synthetic References','Number of CIDs (with Related Annotations)',...
    'Number of Thieme Chemistry Literature', 'Number of Patent Literature ', 'Number of PubMed Literature',...
    'Number of Springer Nature Literature ','Number of Wiley Literature ','Number of Literature (all)'};

%% A few background numbers:

% Overall, how many of the substances are mixtures (including counter ions)?

IsomericSMILES = UABibData{:,4};
% find occurences of `.` in SMILES
mixtures_index = strfind(IsomericSMILES, '.');
% retrieve non-empty cell numbers
mixtures_cells = find(~cellfun('isempty',mixtures_index));
% get length for overall number
numberMixtures = length(mixtures_cells);

% How many substance submissions are unique on PubChem (based on SIDs all)?
% Calculate how many Num_SIDs_Same == 1
unique_SIDs = sum(UABibData_Nums{:,3}==1);


% can also do a range, like how many SIDs with less than 5 lit references
SIDs_LTE5refs = sum(UABibData_Nums{:,15}<=5);


%% Calculate Basic statistics for Bibliometrics Data

%preallocate variables for speed 
max_Bibdescriptor = ones(1,15, 'int32');
row_max_Bibdescriptor = ones(1,15);
median_Bibdescriptor = ones(1,15, 'int32');
mode_Bibdescriptor = ones(1,15, 'int32');
mean_Bibdescriptor = ones(1,15);
Q1 = ones(1,15);
Q3 = ones(1,15);
IQR = ones(1,15);

for j = 1:15
    
    % calculate maximum for each descriptor and corresponding row index
    [max_Bibdescriptor(j),row_max_Bibdescriptor(j)] = max(UABibData_Nums{j});
         
    % calculate median for each descriptor
    [median_Bibdescriptor(j)] = median(UABibData_Nums{j});
    
    % calculate mode for each descriptor
    [mode_Bibdescriptor(j)] = mode(UABibData_Nums{j});
    
    % calculate mean of all descriptors
    [mean_Bibdescriptor(j)] = mean(UABibData_Nums{j});
        
    % calculate 1st and 3rd quartile, and Interquartile range
    Q1(j) = prctile(double(UABibData_Nums{j}), 25);
    Q3(j) = prctile(double(UABibData_Nums{j}), 75);
    IQR(j) = Q3(j)-Q1(j);
    
end


%% Histograms

for k = [1,3]
    figure(k);
    hist_plot = histogram(UABibData_Nums{k});
    hist_plot.FaceColor = 'green';
    hist_plot.EdgeColor = 'black';
    hist_plot.FaceAlpha = 0.3;
    hist_plot.BinMethod = 'integers';
    hist_plot.BinLimits = [-1,40];
    xlabel(UABibData_Nums_labels{k});
    ylabel('Frequency');
    set(gca, 'FontSize', 14);        
end

for k = [2,4,5,7,8,10,11,12,13,14,15]
    figure(k);
    hist_plot = histogram(UABibData_Nums{k});
    hist_plot.FaceColor = 'green';
    hist_plot.EdgeColor = 'black';
    hist_plot.FaceAlpha = 0.3;
    hist_plot.BinMethod = 'integers';
    hist_plot.BinLimits = [-1,20];
    xlabel(UABibData_Nums_labels{k});
    ylabel('Frequency');
    set(gca, 'FontSize', 14);        
end

for k = [6]
    figure(k);
    hist_plot = histogram(UABibData_Nums{k});
    hist_plot.FaceColor = 'green';
    hist_plot.EdgeColor = 'black';
    hist_plot.FaceAlpha = 0.3;
    hist_plot.BinMethod = 'integers';
    hist_plot.BinLimits = [-1,200];
    xlabel(UABibData_Nums_labels{k});
    ylabel('Frequency');
    set(gca, 'FontSize', 14);        
end

for k = [9]
    figure(k);
    hist_plot = histogram(UABibData_Nums{k});
    hist_plot.FaceColor = 'green';
    hist_plot.EdgeColor = 'black';
    hist_plot.FaceAlpha = 0.3;
    hist_plot.BinMethod = 'integers';
    hist_plot.BinLimits = [-1,150];
    xlabel(UABibData_Nums_labels{k});
    ylabel('Frequency');
    set(gca, 'FontSize', 14);        
end


%% Correlation Coefficient Matrix

% unpack descriptor cell array into matrix
UABibData_Nums_matrix = [UABibData_Nums{:}];

% Spearman corr_descriptors
Spearman_corr_descriptors = corr(double(UABibData_Nums_matrix), 'Type','Spearman');










