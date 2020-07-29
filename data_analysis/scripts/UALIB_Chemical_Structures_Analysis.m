% UALIB_Chemical_Structures_Analysis
% V.F. Scalfani
% Matlab R2020a, run on Ubuntu Linux 18.04
% May 2, 2020
%% Import SID data

% N.B. PubChem SDQ is used internally by PubChem webpages and is still being rapidly developed.
% NCBI Data Usage Policies: https://www.ncbi.nlm.nih.gov/home/about/policies/

cd('/home/.../Data Analysis')
UALIB_Structure_Data = readtable('UALIB_Chemical_Structures_SIDs.csv','Format', '%s');
UALIB_Structure_Data = table2cell(UALIB_Structure_Data);
SIDs = UALIB_Structure_Data(:,1);

%% Define PubChem PUG-REST API and options

api = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/';
options = weboptions('Timeout', 20);

%% Retrieve Registry IDs
% Run on May 2, 2020

for r = 1:length(SIDs)
    SID = SIDs{r};
    
    % define api call
    RegistryID_url = [api 'substance/sid/' num2str(SID) '/xrefs/RegistryID/TXT'];
        
    % retrieve data
    try
        RegistryID = webread(RegistryID_url,options);      
    catch ME
        switch ME.identifier
            % happens if providing invalid call such as invalid SID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                RegistryID = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                RegistryID = 'Not Found';
            otherwise
                RegistryID = 'UnknownError';
        end       
                 
    end
                        
   % add to data array
        UALIB_Structure_Data{r,2} = RegistryID;
   
   % be polite to PubChem server
        n = 0.25;
        pause(n)
   
end

% remove leading and trailing whitespace
UALIB_Structure_Data = strtrim(UALIB_Structure_Data);

%% Save Variables

save UALIB_Structure_Data.mat
%% Retrieve Associated standardized CIDs
% Run on May 2, 2020

for r = 1:length(SIDs)
    SID = SIDs{r};

% define api call
CID_url = [api 'substance/sid/' num2str(SID) '/cids/TXT?cids_type=standardized'];

    try
        CID = webread(CID_url,options);      
    catch ME
         switch ME.identifier
            % happens if providing invalid call such as invalid SID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                CID = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                CID = '0';
            otherwise
                CID = 'UnknownError';
        end                    
    end
        % be polite to PubChem server
        n = 0.25;
        pause(n)

 % add to data array
UALIB_Structure_Data{r,3} = CID;

end

% remove leading and trailing whitespace
UALIB_Structure_Data = strtrim(UALIB_Structure_Data);
%% Save Variables

save UALIB_Structure_Data.mat

%% Create List of CIDs

CIDs = UALIB_Structure_Data(:,3);

%% Retrieve Isomeric SMILES from CIDs
% Run on May 2, 2020

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
IsomericSMILES_url = [api 'compound/cid/' num2str(CID) '/property/IsomericSMILES/TXT'];

    try
        IsomericSMILES = webread(IsomericSMILES_url,options);      
       catch ME
        switch ME.identifier
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                IsomericSMILES = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                IsomericSMILES = 'NoIsomericSMILES_Found';
            otherwise
                IsomericSMILES = 'UnknownError';
        end 
       
    end
    
    % be polite to PubChem server
        n = 0.25;
        pause(n)
    
% add to data array

UALIB_Structure_Data{r,4} = IsomericSMILES;
 
end

% remove leading and trailing whitespace
UALIB_Structure_Data = strtrim(UALIB_Structure_Data);

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve InChIs from CIDs
% Run on May 2, 2020

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
InChI_url = [api 'compound/cid/' num2str(CID) '/property/InChI/TXT'];

    try
        InChI = webread(InChI_url,options);      
     catch ME
        switch ME.identifier
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                InChI = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                InChI = 'NoInChI_Found';
            otherwise
                InChI = 'UnknownError';
        end     
    end
        % be polite to PubChem server
        n = 0.25;
        pause(n)

 % add to data array

UALIB_Structure_Data{r,5} = InChI;

end

% remove leading and trailing whitespace
UALIB_Structure_Data = strtrim(UALIB_Structure_Data);

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve InChIKeys from CIDs
% Run on May 2, 2020

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
IK_url = [api 'compound/cid/' num2str(CID) '/property/InChIKey/TXT'];

    try
        IK = webread(IK_url,options);      
      catch ME
        switch ME.identifier
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                IK = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                IK = 'NoInChIKey_Found';
            otherwise
                IK = 'UnknownError';
        end     
    end
        % be polite to PubChem server
        n = 0.25;
        pause(n)

 % add to data array

UALIB_Structure_Data{r,6} = IK;

end

% remove leading and trailing whitespace
UALIB_Structure_Data = strtrim(UALIB_Structure_Data);

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve Number of related substances (standardized option, which is "same")
% Run on May 18, 2020

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
num_SIDs_same_url = [api 'compound/cid/' num2str(CID) '/sids/JSON?sids_type=standardized'];

    try
        num_SIDs_same = webread(num_SIDs_same_url,options);      
    catch ME
        switch ME.identifier
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                num_SIDs_same = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                num_SIDs_same = 0;
            otherwise
                % try again      
                try
                   m = 60;
                   pause(m)
                   num_SIDs_same = webread(num_SIDs_same_url,options);
                catch ME
                   num_SIDs_same = 'UnknownError';
                end
        end       
    end
        % be polite to PubChem server
        n = 0.5;
        pause(n)

 % add to data array
 % check data type first
type = class(num_SIDs_same);

switch type
    case 'char'
        UALIB_Structure_Data{r,7} = num_SIDs_same;
    case 'double'
        UALIB_Structure_Data{r,7} = num_SIDs_same;
    case 'struct'
        UALIB_Structure_Data{r,7} = length(num_SIDs_same.InformationList.Information.SID);
    otherwise
        UALIB_Structure_Data{r,7} = 'Error storing data!';
end


end

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve Number of related substances (component option, which is "mixture")
% Run on May 18, 2020

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
num_SIDs_mix_url = [api 'compound/cid/' num2str(CID) '/sids/JSON?sids_type=component'];

    try
        num_SIDs_mix = webread(num_SIDs_mix_url,options);      
    catch ME
        switch ME.identifier
            
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                num_SIDs_mix = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                num_SIDs_mix = 0;
            otherwise
                num_SIDs_mix = 'UnknownError';
        end       
    end
        % be polite to PubChem server
        n = 0.5;
        pause(n)

 % add to data array
 % check data type first
type = class(num_SIDs_mix);

switch type
    case 'char'
        UALIB_Structure_Data{r,8} = num_SIDs_mix;
    case 'double'
        UALIB_Structure_Data{r,8} = num_SIDs_mix;
    case 'struct'
        UALIB_Structure_Data{r,8} = length(num_SIDs_mix.InformationList.Information.SID);
    otherwise
        UALIB_Structure_Data{r,8} = 'Error storing data!';
end


end

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve Number of related substances (all option)
% Run on May 18, 2020

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
num_SIDs_all_url = [api 'compound/cid/' num2str(CID) '/sids/JSON?sids_type=all'];

    try
        num_SIDs_all = webread(num_SIDs_all_url,options);      
    catch ME
        switch ME.identifier
            
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                num_SIDs_all = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                num_SIDs_all = 0;
            otherwise
                % try again
                try
                   m = 60;
                   pause(m)
                   num_SIDs_all = webread(num_SIDs_all_url,options);
                catch ME
                   num_SIDs_all = 'UnknownError';
                end   
        end       
    end
        % be polite to PubChem server
        n = 0.5;
        pause(n)

 % add to data array
 % check data type first
type = class(num_SIDs_all);

switch type
    case 'char'
        UALIB_Structure_Data{r,9} = num_SIDs_all;
    case 'double'
        UALIB_Structure_Data{r,9} = num_SIDs_all;
    case 'struct'
        UALIB_Structure_Data{r,9} = length(num_SIDs_all.InformationList.Information.SID);
    otherwise
        UALIB_Structure_Data{r,9} = 'Error storing data!';
end


end

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve Number of related compound "mixtures, components, and neutralized forms" (cids_type component)
% Run on May 19, 2020

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
num_CIDs_component_url = [api 'compound/cid/' num2str(CID) '/cids/JSON?cids_type=component'];

    try
        num_CIDs_component = webread(num_CIDs_component_url,options);      
    catch ME
        switch ME.identifier
            
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                num_CIDs_component = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                num_CIDs_component = 0;
            otherwise
                num_CIDs_component = 'UnknownError';
        end       
    end
        % be polite to PubChem server
        n = 0.5;
        pause(n)

 % add to data array
 % check data type first
type = class(num_CIDs_component);

switch type
    case 'char'
        UALIB_Structure_Data{r,10} = num_CIDs_component;
    case 'double'
        UALIB_Structure_Data{r,10} = num_CIDs_component;
    case 'struct'
        UALIB_Structure_Data{r,10} = length(num_CIDs_component.IdentifierList.CID);
    otherwise
        UALIB_Structure_Data{r,10} = 'Error storing data!';
end


end

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve Number of related compounds with same connectivity (fastidentity)
% Run on May 20, 2020

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
num_CIDs_same_connectivity_url = [api 'compound/fastidentity/cid/' num2str(CID) '/cids/JSON?identity_type=same_connectivity'];

    try
        num_CIDs_same_connectivity = webread(num_CIDs_same_connectivity_url,options);      
    catch ME
        switch ME.identifier
            
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                num_CIDs_same_connectivity = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                num_CIDs_same_connectivity = 0;
            otherwise
                % try again
                try
                    m = 60;
                    pause(m)
                    num_CIDs_same_connectivity = webread(num_CIDs_same_connectivity_url,options);
                catch ME    
                    num_CIDs_same_connectivity = 'UnknownError';
                end    
        end       
    end
        % be polite to PubChem server
        n = 0.5;
        pause(n)

 % add to data array
 % check data type first
type = class(num_CIDs_same_connectivity);

switch type
    case 'char'
        UALIB_Structure_Data{r,11} = num_CIDs_same_connectivity;
    case 'double'
        UALIB_Structure_Data{r,11} = num_CIDs_same_connectivity;
    case 'struct'
        UALIB_Structure_Data{r,11} = length(num_CIDs_same_connectivity.IdentifierList.CID);
    otherwise
        UALIB_Structure_Data{r,11} = 'Error storing data!';
end


end


%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve Number of related compounds with 2d Similarity, theshold 90. 
% Run on May 21, 2020

% https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/fastsimilarity_2d/cid/2244/cids/XML?Threshold=99

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
num_CIDs_similarity90_url = [api 'compound/fastsimilarity_2d/cid/' num2str(CID) '/cids/JSON?Threshold=90'];

    try
        num_CIDs_similarity90 = webread(num_CIDs_similarity90_url,options);      
    catch ME
        switch ME.identifier
            
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                num_CIDs_similarity90 = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                num_CIDs_similarity90 = 0;
            otherwise
                num_CIDs_similarity90 = 'UnknownError';
        end       
    end
        % be polite to PubChem server
        n = 0.5;
        pause(n)

 % add to data array
 % check data type first
type = class(num_CIDs_similarity90);

switch type
    case 'char'
        UALIB_Structure_Data{r,12} = num_CIDs_similarity90;
    case 'double'
        UALIB_Structure_Data{r,12} = num_CIDs_similarity90;
    case 'struct'
        UALIB_Structure_Data{r,12} = length(num_CIDs_similarity90.IdentifierList.CID);
    otherwise
        UALIB_Structure_Data{r,12} = 'Error storing data!';
end


end

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve Associated number of Bioassay tests
% Run on May 22, 2020

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
num_assay_summary_url = [api 'compound/cid/' num2str(CID) '/assaysummary/JSON'];

    try
        num_assay_summary = webread(num_assay_summary_url,options);      
    catch ME
        switch ME.identifier
            
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                num_assay_summary = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                num_assay_summary = 0;
            otherwise
                % try again
                try
                    m = 60;
                    pause(m)
                    num_assay_summary = webread(num_assay_summary_url,options);
                catch ME    
                    num_assay_summary = 'UnknownError';
                end    
        end       
    end
        % be polite to PubChem server
        n = 0.5;
        pause(n)

 % add to data array
 % check data type first
type = class(num_assay_summary);

switch type
    case 'char'
        UALIB_Structure_Data{r,13} = num_assay_summary;
    case 'double'
        UALIB_Structure_Data{r,13} = num_assay_summary;
    case 'struct'
        UALIB_Structure_Data{r,13} = length(num_assay_summary.Table.Row);
    otherwise
        UALIB_Structure_Data{r,13} = 'Error storing data!';
end


end

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve Number of Synthesis References associated with each CID
% Run on May 22, 2020

api_view = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug_view/';

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
num_synthRefs_url = [api_view 'data/compound/' num2str(CID) '/JSON?heading=Synthesis+References'];

    try
        num_synthRefs = webread(num_synthRefs_url,options);      
    catch ME
        switch ME.identifier
            
            % happens if providing invalid call such as invalid CID ('BadRequest')
            case 'MATLAB:webservices:HTTP400StatusCodeError'
                num_synthRefs = 'N/A';
            % happens if no associated data is returned (i.e., 'NotFound', 0 results)
            case 'MATLAB:webservices:HTTP404StatusCodeError'
                num_synthRefs = 0;
            otherwise
                num_synthRefs = 'UnknownError';
        end       
    end
        % be polite to PubChem server
        n = 0.5;
        pause(n)

 % add to data array
 % check data type first
type = class(num_synthRefs);

switch type
    case 'char'
        UALIB_Structure_Data{r,14} = num_synthRefs;
    case 'double'
        UALIB_Structure_Data{r,14} = num_synthRefs;
    case 'struct'
        UALIB_Structure_Data{r,14} = length(num_synthRefs.Record.Section.Section.Information);
    otherwise
        UALIB_Structure_Data{r,14} = 'Error storing data!';
end


end

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve Number of related compounds with biomedical annotations
% Run on May 23, 2020

api_SDQ1 = 'https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi?infmt=json&outfmt=json&query=';
options_sdq = weboptions('Timeout', 30,'ContentType','json');

for r = 1:length(CIDs)
    CID = CIDs{r};

% define api call
num_rel_annotations_url = [api_SDQ1 '{"hide":"*","collection":"compound","where":{"ands":[{"cid":"' num2str(CID) '"},{"relatedidtype":"cidneighbor"}]}}'];

    try
        num_rel_annotations = webread(num_rel_annotations_url,options_sdq);
    catch ME
        num_rel_annotations = 'UnknownError';     
    end
    
    n = 1;
    pause(n)
    
       
% test for error code -4 returned from SDQ agent, which is a bad input
    if num_rel_annotations.SDQOutputSet.status.code == -4
       UALIB_Structure_Data{r,15} = 'N/A';     
    else
       UALIB_Structure_Data{r,15} = num_rel_annotations.SDQOutputSet.totalCount;  
    end
    
end
    

%% Save Variables

save UALIB_Structure_Data.mat

%% Retrieve Literature Counts
% Run on May 23, 2020

api_SDQ2 = 'https://pubchem.ncbi.nlm.nih.gov/sdq/sdqagent.cgi?outfmt=json&query=';

for r = 1:length(CIDs)
    CID = CIDs{r};
    
    litCountQ_url = [api_SDQ2 '{"hide":"*","collection":"*","where":{"ands":{"cid":"' num2str(CID) '"}}}'];
    
    try
        litCountQ = webread(litCountQ_url, options_sdq);
    catch ME
        litCountQ = 'UnknownError'; 
    end

        % thiemechemistry
        UALIB_Structure_Data{r,16} = litCountQ.SDQOutputSet(12).totalCount; 
        
        % patent
        UALIB_Structure_Data{r,17} = litCountQ.SDQOutputSet(4).totalCount;
       
        % pubmed
        UALIB_Structure_Data{r,18} = litCountQ.SDQOutputSet(7).totalCount;
                         
        % springernature
        UALIB_Structure_Data{r,19} = litCountQ.SDQOutputSet(14).totalCount;
        
        % wiley
        UALIB_Structure_Data{r,20} = litCountQ.SDQOutputSet(13).totalCount;
        
        n = 1;
        pause(n)
        
          
end

%% Save Variables

save UALIB_Structure_Data.mat


%% export data

UALIB_Structure_Data_Table = array2table(UALIB_Structure_Data, 'VariableNames',...
    {'SID','RegID','CID','IsomericSMILES','InChI','InChIKey','Num_SIDs_Same',...
    'Num_SIDs_Mixture','Num_SIDs_All','Num_CIDs_Component','Num_CIDs_SameConnectivity',...
    'Num_CIDs_Similarity90','Num_assay_Summary','Num_SynthRefs','Num_CIDs_wRelatedAnnotations',...
    'Num_thiemechemistry','Num_patent','Num_pubmed','Num_springernature','Num_wiley'});

writetable(UALIB_Structure_Data_Table,'UALIB_Structure_Data_TableExport.txt','Delimiter','tab');



