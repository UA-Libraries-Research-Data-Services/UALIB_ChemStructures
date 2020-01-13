#!/usr/bin/env python
# coding: utf-8

# # Jupyter Notebook for Compiling The University of Alabama Thesis Chemical Structure Data
# 
# ### Vincent F. Scalfani

# In[5]:


from rdkit.Chem import AllChem as Chem
from rdkit.Chem.Draw import IPythonConsole

from rdkit.Chem import PandasTools
#PandasTools.RenderImagesInAllDataFrames(images=True)

from rdkit.Chem import Draw
from rdkit import DataStructs
import numpy
import pandas as pd
import os # for changing directories

import rdkit
rdkit.__version__


# In[6]:


# Many thanks to Chris Swain's tutorial linked below, which helped me adapt the 
# the code for the thesis indexing project:
# https://www.macinchem.org/reviews/molsimilar/SimilarMyMolecules.html


# In[7]:


# Import the thesis chemical structure data

# The file names are in the format:
# year_author_UACatalogAccession#_substances_raw.csv (e.g.,2000_Eom_KD_UA.1128100_substances_raw.csv)

# The format of the data within the file is as follows:

# SMILES_CHEMAXON_19.27.0	DATASOURCE_REGID	SUBSTANCE_SYNONYM	SUBSTANCE_COMMENT	SUBSTANCE_URL	INCHIKEY_1.05_CHEMAXON_19.27.0
# [H][C@@](Br)(CC)C(C)(C)C(O)=O	UALIB-339	Erythro-2,3-Dibromo-2-methylpentanoic acid	Eom, K.D. Total Synthesis of (+)-Asteltoxin. Ph.D. Thesis, The University of Alabama, 2000.	https://search.ebscohost.com/login.aspx?direct=true&db=cat00456a&AN=ua.1128100&site=eds-live&scope=site&custid=s4594951&groupid=main&profid=eds&authtype=ip,guest	UCKHUOHUOYJTCV-RXMQYKEDSA-N
# [H]\C(CC)=C(/C)Br	UALIB-340	Z-2-Bromo-2-pentene	Eom, K.D. Total Synthesis of (+)-Asteltoxin. Ph.D. Thesis, The University of Alabama, 2000.	https://search.ebscohost.com/login.aspx?direct=true&db=cat00456a&AN=ua.1128100&site=eds-live&scope=site&custid=s4594951&groupid=main&profid=eds&authtype=ip,guest	RWKAFOQZRPDXDT-PLNGDYQASA-N
# [H]\C(CC)=C(/C)C(O)=O	UALIB-341	cis-2-Methyl-2-pentenoic acid	Eom, K.D. Total Synthesis of (+)-Asteltoxin. Ph.D. Thesis, The University of Alabama, 2000.	https://search.ebscohost.com/login.aspx?direct=true&db=cat00456a&AN=ua.1128100&site=eds-live&scope=site&custid=s4594951&groupid=main&profid=eds&authtype=ip,guest	JJYWRQLLQAKNAD-PLNGDYQASA-N
# ...

os.chdir('/home/username/UALIB_ChemStructures/StructureData/raw/CSV')

file_name_raw = '1960_Baker_GM_UA.673860_substances_raw.csv' # change this line each time, that's it. 
thesis_df = pd.read_csv(file_name_raw, sep = '\t')

# view first 10 rows
thesis_df.head(10)


# In[8]:


# Add RDKit Molecular Objects
PandasTools.AddMoleculeColumnToFrame(thesis_df,'SMILES_CHEMAXON_19.27.0','RDMol', includeFingerprints=False)
print([str(x) for x in  thesis_df.columns])


# In[9]:


# rearrange table order
thesis_df = thesis_df[['RDMol',
 'DATASOURCE_REGID',
 'SMILES_CHEMAXON_19.27.0',
 'SUBSTANCE_SYNONYM',
 'SUBSTANCE_COMMENT',
 'SUBSTANCE_URL',
 'INCHIKEY_1.05_CHEMAXON_19.27.0']]

# Display table
# thesis_df
# fixes mol display in dataframes (RDKit Issue# 2673)
from IPython.display import HTML;HTML(thesis_df.head(len(thesis_df.index)).to_html()) 


# In[10]:


# we can also display just the molecules like this:
PandasTools.FrameToGridImage(thesis_df,column= 'RDMol', molsPerRow=4,subImgSize=(300,300),legendsCol="DATASOURCE_REGID")


# In[11]:


# Now we need to caluclate the InChIs from RDKit and add to thesis_df
# These are InChI 1.05 as computed by RDKit 2019.09.2 release.

inchi_list = []
for mol in thesis_df['RDMol']:
    inchi = Chem.MolToInchi(mol)
    inchi_list.append(inchi)

# add to dataframe
thesis_df['INCHI_1.05_RDKIT_2019.09.2']=inchi_list


# In[12]:


# Repeat for RDKit InChIKey
# These are InChI 1.05 as computed by RDKit 2019.09.2 release.
ik_list = []
for mol in thesis_df['RDMol']:
    ik = Chem.MolToInchiKey(mol)
    ik_list.append(ik)
       
# add to dataframe
thesis_df['INCHIKEY_1.05_RDKIT_2019.09.2']=ik_list


# In[13]:


# Repeat for RDKit SMILES, write kekulized SMILES
# SMILES are from RDKit 2019.09.2 release.

smiles_list = []
for mol in thesis_df['RDMol']:
    Chem.Kekulize(mol)
    smiles = Chem.MolToSmiles(mol,kekuleSmiles=True)
    smiles_list.append(smiles)

# add to dataframe
thesis_df['SMILES_RDKIT_2019.09.2']=smiles_list


# In[14]:


# Export the SDF for PubChem upload

# create the file name
file_name_sdf = file_name_raw.replace('raw.csv','rdkit2019092.sdf')

# cd
os.chdir('/home/username/UALIB_ChemStructures/StructureData/rdkit_processed_sdf')


PandasTools.WriteSDF(thesis_df,file_name_sdf, molColName='RDMol', 
    properties=['DATASOURCE_REGID',
                'SMILES_RDKIT_2019.09.2',
                'INCHI_1.05_RDKIT_2019.09.2',
                'SUBSTANCE_SYNONYM',
                'SUBSTANCE_COMMENT',
                'SUBSTANCE_URL'])


# In[15]:


# Export to csv (tab seperated) without RDKit mol object image

# create the file name
file_name_csv = file_name_raw.replace('raw.csv','rdkit2019092.csv')

sel_cols = ['DATASOURCE_REGID',
                'SMILES_RDKIT_2019.09.2',
                'SUBSTANCE_SYNONYM',
                'SUBSTANCE_COMMENT',
                'SUBSTANCE_URL',
                'INCHI_1.05_RDKIT_2019.09.2',
                'INCHIKEY_1.05_RDKIT_2019.09.2',
                'INCHIKEY_1.05_CHEMAXON_19.27.0',
                'SMILES_CHEMAXON_19.27.0']

# cd
os.chdir('/home/username/UALIB_ChemStructures/StructureData/rdkit_processed_csv')

thesis_df.to_csv(file_name_csv, sep ='\t', index=False, columns = sel_cols)


# In[ ]:





# In[16]:


# Create the SDfile for all indexed structures (run this after updating
# UALIB_Chemical_Structures_REGID.csv and submitting to PubChem)

# cd
os.chdir('/home/username/UALIB_ChemStructures')

All_df = pd.read_csv('UALIB_Chemical_Structures_REGID.csv', sep = '\t')

# view first 10 rows
All_df.head(10)


# In[17]:


# Add RDKit Molecular Objects
PandasTools.AddMoleculeColumnToFrame(All_df,'SMILES_RDKIT_2019.09.2**','Structure', includeFingerprints=False)

# export the sdf

PandasTools.WriteSDF(All_df,'UALIB_Chemical_Structures_REGID.sdf', molColName='Structure', 
    properties=list(All_df.columns))


# In[ ]:





# In[ ]:




