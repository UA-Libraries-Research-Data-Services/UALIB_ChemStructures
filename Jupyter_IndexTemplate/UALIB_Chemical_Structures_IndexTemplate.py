#!/usr/bin/env python
# coding: utf-8

# # Jupyter Notebook for Compiling The University of Alabama Thesis Chemical Structure Data
# 
# ### Vincent F. Scalfani

# In[2]:


from rdkit.Chem import AllChem as Chem
from rdkit.Chem.Draw import IPythonConsole

from rdkit.Chem import PandasTools
#PandasTools.RenderImagesInAllDataFrames(images=True)

from rdkit.Chem import Draw
from rdkit import DataStructs
import numpy
import pandas as pd

import rdkit
rdkit.__version__


# In[19]:


# Many thanks to Chris Swain's tutorial linked below, which helped me adapt the 
# the code for the thesis indexing project:
# https://www.macinchem.org/reviews/molsimilar/SimilarMyMolecules.html


# In[20]:


# Import the thesis chemical structure data

# The file names are in the format:
# year_author_UACatalogAccession#_substances_raw.csv (e.g.,1995_Battle_W_UA.849024_substances_raw.csv)

# The format of the data within the file is as follows:
# PUBCHEM_EXT_DATASOURCE_SMILES	PUBCHEM_EXT_DATASOURCE_REGID	PUBCHEM_SUBSTANCE_SYNONYM	PUBCHEM_SUBSTANCE_COMMENT	PUBCHEM_EXT_SUBSTANCE_URL
# [H]C#CB1OC(C)(C)C(C)(C)O1	UALIB-270	Pinacol ethynylborate	Battle, W. The Synthesis of 5-(Boronic Ester)-Isoxazoles and Their use in Palladium-Catalyzed Cross-Coupling Reactions with Iodobenzene. M.A. Thesis, The University of Alabama, 1995.	https://search.ebscohost.com/login.aspx?direct=true&db=cat00456a&AN=ua.849024&site=eds-live&scope=site&custid=s4594951&groupid=main&profid=eds&authtype=ip,guest
# CC1(C)C(C)(C)OB(C2=CC(C3=CC=C(OC)C=C3)=NO2)O1	UALIB-271	3-(4’Methoxyphenyl)-5-(pinacolboronate)-isoxazole	Battle, W. The Synthesis of 5-(Boronic Ester)-Isoxazoles and Their use in Palladium-Catalyzed Cross-Coupling Reactions with Iodobenzene. M.A. Thesis, The University of Alabama, 1995.	https://search.ebscohost.com/login.aspx?direct=true&db=cat00456a&AN=ua.849024&site=eds-live&scope=site&custid=s4594951&groupid=main&profid=eds&authtype=ip,guest
# CC1(C)C(C)(C)OB(C2=CC(C3=CC=C(Br)C=C3)=NO2)O1	UALIB-272	3-(4’-Bromophenyl)-5-(pinacolboronate)-isoxazole	Battle, W. The Synthesis of 5-(Boronic Ester)-Isoxazoles and Their use in Palladium-Catalyzed Cross-Coupling Reactions with Iodobenzene. M.A. Thesis, The University of Alabama, 1995.	https://search.ebscohost.com/login.aspx?direct=true&db=cat00456a&AN=ua.849024&site=eds-live&scope=site&custid=s4594951&groupid=main&profid=eds&authtype=ip,guest
# ...

file_name_raw = 'test_substances_raw.csv' # change this line each time, that's it. 
thesis_df = pd.read_csv(file_name_raw, sep = '\t')

# view first 10 rows
thesis_df.head(10)


# In[21]:


# Add RDKit Molecular Objects
PandasTools.AddMoleculeColumnToFrame(thesis_df,'PUBCHEM_EXT_DATASOURCE_SMILES','Structure', includeFingerprints=False)
print([str(x) for x in  thesis_df.columns])


# In[22]:


# rearrange table order
thesis_df = thesis_df[['Structure',
 'PUBCHEM_EXT_DATASOURCE_REGID',
 'PUBCHEM_EXT_DATASOURCE_SMILES',
 'PUBCHEM_SUBSTANCE_SYNONYM',
 'PUBCHEM_SUBSTANCE_COMMENT',
 'PUBCHEM_EXT_SUBSTANCE_URL']]

# Display table
# thesis_df
# fixes mol display in dataframes (RDKit Issue# 2673)
from IPython.display import HTML;HTML(thesis_df.head(len(thesis_df.index)).to_html()) 


# In[23]:


# we can also display just the molecules like this:
PandasTools.FrameToGridImage(thesis_df,column= 'Structure', molsPerRow=4,subImgSize=(300,300),legendsCol="PUBCHEM_EXT_DATASOURCE_REGID")


# In[24]:


# Now we need to caluclate the InChI and add to thesis_df
inchi_list = []
for mol in thesis_df['Structure']:
    inchi = Chem.MolToInchi(mol)
    inchi_list.append(inchi)

# add to dataframe
thesis_df['PUBCHEM_EXT_DATASOURCE_INCHI']=inchi_list


# In[25]:


# Repeat for InChIKey 
ik_list = []
for mol in thesis_df['Structure']:
    ik = Chem.MolToInchiKey(mol)
    ik_list.append(ik)

# add to dataframe
thesis_df['INCHIKEY']=ik_list


# In[26]:


# Export the SDF for PubChem upload

# create the file name
file_name_sdf = file_name_raw.replace('raw.csv','rdkit2019092.sdf')

PandasTools.WriteSDF(thesis_df,file_name_sdf, molColName='Structure', 
    properties=['PUBCHEM_EXT_DATASOURCE_REGID',
                'PUBCHEM_EXT_DATASOURCE_SMILES',
                'PUBCHEM_SUBSTANCE_SYNONYM',
                'PUBCHEM_SUBSTANCE_COMMENT',
                'PUBCHEM_EXT_SUBSTANCE_URL',
                'PUBCHEM_EXT_DATASOURCE_INCHI',])


# In[27]:


# Export to csv (tab seperated) without RDKit mol object image

# create the file name
file_name_csv = file_name_raw.replace('raw.csv','rdkit2019092.csv')

sel_cols = ['PUBCHEM_EXT_DATASOURCE_REGID',
                'PUBCHEM_EXT_DATASOURCE_SMILES',
                'PUBCHEM_SUBSTANCE_SYNONYM',
                'PUBCHEM_SUBSTANCE_COMMENT',
                'PUBCHEM_EXT_SUBSTANCE_URL',
                'PUBCHEM_EXT_DATASOURCE_INCHI',
                'INCHIKEY']

thesis_df.to_csv(file_name_csv, sep ='\t', index=False, columns = sel_cols)


# In[ ]:





# In[8]:


# Create the SDfile for all indexed structures (run this after updating
# UALIB_Chemical_Structures_REGID.csv)

All_df = pd.read_csv('UALIB_Chemical_Structures_REGID.csv', sep = '\t')

# view first 10 rows
All_df.head(10)


# In[10]:


# Add RDKit Molecular Objects
PandasTools.AddMoleculeColumnToFrame(All_df,'PUBCHEM_EXT_DATASOURCE_SMILES','Structure', includeFingerprints=False)

# export the sdf
PandasTools.WriteSDF(All_df,'UALIB_Chemical_Structures_REGID.sdf', molColName='Structure', 
    properties=list(All_df.columns))


# In[ ]:




