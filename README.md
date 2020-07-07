# UALIB_ChemStructures
Chemical Substances from The University of Alabama Dissertations and Theses

## What is this?
This repository contains the machine-readable registered (converted to machine format and checked for uniqueness) chemical substances (non-standardized) from The University of Alabama Dissertations and Theses (hereafter, theses).

**There are currently ~3000 chemical substances registered across 73 theses**

Chemical structure data includes the name (or ID), SMILES, and InChI of synthesized chemical
substances within the thesis along with a permalink to the thesis full-text or 
catalog link (if not yet available online), Moreover, an SDfile containing the connection table, name (or ID), SMILES, InChI, citation, permalink, and local structure registry ID is included. PubChem is likely where you want to download our data from as PubChem handles the standardization (on Compound database) of the chemical structures:
[The University of Alabama Libraries PubChem Data Source](https://pubchem.ncbi.nlm.nih.gov/source/15645).

> **This GitHub repository is useful for those seeking to download our non-standardized data, understand our workflow, and read our notes on copyright and reuse. Please be aware that there may be multiple files for each thesis (e.g., corrections may be in different folders). For the most complete and latest data, please download directly from PubChem.**

## How are we registering the chemical structures?

This is a manually curated effort, no machine extraction. We are redrawing, encoding, and annotating the structures from the theses ourselves. See our workflow below for complete details.

## What structures are you including? 

There are two key requirements that must be met for us to assign a registry identifier to a substance:

1. The substance can be represented with the SMILES line notation. This includes most small molecule organic chemistry with some limited organometallic chemical substances.

2. Chemical substances registered have synthetic preparatory procedures. Most often these preparatory procedures are specific to the substance, however in certain cases we registered substances that had only general synthetic procedures associated with it (e.g., it is common in organic synthesis to run the same reaction across multiple similar substrates). Substances registered also had to have some associated experimental characterization details such as NMR, IR, melting point, elemental analysis, or mass spec. The exception is with early theses (e.g., 1920s), where we registered the substances if there was a preparation method with an associated analytical or qualitative test. Lastly, we tried to avoid registration of substances where the synthetic preparatory method, as noted by the author, directly followed a prior reported literature preparation.

## What is your workflow? 

We are still working on creating an optimal open workflow that is highly reproducible. Here is an overview of our current strategy:

**Main Workflow for Most Substances**

1. Draw chemical structures in [ChemAxon MarvinSketch](https://chemaxon.com/products/marvin). We endeavored to accurately represent the structures as originally drawn, however in some cases we needed to standardize the structures (see below).
2. Export as ChemAxon SMILES (v19.27.0). The Daylight variant was typically used. Exceptions are when we needed to represent enhanced features such as radicals. In these cases, CXSMILES were used.  
3. Calculate InChIKeys (v1.05 as computed by ChemAxon molconvert v19.27.0).
4. Create a tab delimited file with a substance registry number (i.e., UALIB-###), 
citation, permalink to the thesis record, and substance name (or ID) from the thesis.
5. Check for duplicates with prior registered substances with the InChIKey using a shell sort command. Any duplicates are assigned the same local Registry ID (i.e., UALIB-###) and noted in the REGID file.
6. Import the tabbed text file into an RDKit Pandas dataframe to calculate the 
InChIs, InChIKeys (InChIs v1.05 as computed by RDKit 2019.09.2 release), write kekulized SMILES, and generate the SDfile. Note that enhanced features are not represented in exported RDKit SMILES, but they are flagged in the connection table. 
7. Compare RDKit and ChemAxon InChIKeys (this helps catch any issues with SMILES parsing across the toolkits). If the InChIKeys do not match, we figure out the issue before adding the structure to the local Registry file.
8. Submit the SDfile to PubChem.
9. Update the UALIB_Chemical_Structures_REGID files
10. Create a record on our [Institutional Repository](https://ir.ua.edu/) with the SDfile and associated thesis references.

**Note on Substance Names and Thesis Substance IDs**

For UALIB-1 through UALIB-1364, if a descriptive name was provided for the substance, we included that in the data and in the PubChem SUBSTANCE_SYNONYM tag. However, including the substance names quickly proved too time consuming. After UALIB-1364, we included a local Substance ID (often the ID given in the thesis) instead of a name. These are useful internally only for tracking and not submitted to PubChem. Given that PubChem computes IUPAC names for submitted structures and the names provided in theses most often appeared to be a software generated systematic name, we felt it was higher value to focus on getting as many structures as we can out of the theses and discoverable as a priority for the community.

**Special Case: Dative Bonds Workflow**

For organometallic dative bonds, we did not use SMILES extensions, but rather left these as disconnections (`.`). Dative bonds were then added to the RDKit processed SDfile using the PubChem nonstandard bond syntax. Note: we did experiment with using the dative bonds feature in RDKit with SMILES (`->, <-`) and V3000 molfiles, but these files did not parse correctly in PubChem. 

**Special Case: Perspective Drawings including Chair and Fischer projection Stereochemistry Workflow**

When substances were drawn as chair conformations or Fischer projections within the thesis, we used Bio-Rad's KnowItAll 2018 to determine the correct stereochemistry and export as SMILES. The Bio-Rad KnowItAll SMILES were then submitted directly to PubChem without any further processing.

**Internal Standardization**

In most cases, we were able to accurately draw the chemical substances as the author originally drew them with either standard covalent or dative bonds. However, in some cases, we needed to make choices on how to best represent the structures such that both humans and cheminformatics software can best interpret them based on the limitations of valence rules and file formats. As such, these are the internal standardization rules we applied in an effort to best represent what the author originally meant:

1. Phosphine Ligands (e.g., triphenylphosphine) were drawn as dative bonds to a metal.
2. Phosphorous Selenium bonds were standardized to double bonds.
3. Carbene metal bonds were standardized to double bonds. Complexes with carbene to non-metal and metalloids were drawn with charges.
4. Hapticity coordination (e.g., Ferrocene) were drawn with dative bonds to the metal center and charges were added as necessary to maintain original structure hydrogen count.

PubChem further standardizes the structures on the Compound pages.

**Note on Configuration, Non-specific bonds (e.g., wavy), and Stereochemical Mixtures**

We generally drew the substances however the author depicted the double bond configuration and/or tetrahedral stereochemistry in the chemical skeleton drawing. Haworth projections were manually converted to skeletal depictions, in an effort to preserve the original stereochemistry in machine-readable format. In cases where the substance name included racemic notation, (±), we drew both enantiomers within one REGID (see below). However, in rare situations where the author defined the stereochemistry in the 2D depiction, but named the compound with relative notation symbols: R* or S*, we considered the depiction as the correct (absolute) stereochemistry.

When substances were drawn by an author with stereo non-specific wavy bonds, we also reproduced these substances as drawn with the non-specific stereocenters (equivalent to having plain bonds). (See: [IUPAC Graphical Representation of Stereochemical Configuration](https://doi.org/10.1351/pac200678101897)). However, when additional information was provided such that the final product was not an isolated stereoisomer, and instead an identified mixture of enantiomers (racemic/ee) or diasteriomers (de), we drew both substance configurations and combined them into one REGID as two components. Note: in cases where the diastereomeric mixture was not easily identifiable (i.e., not clear which stereocenter or bond to flip), and when the diastereomeric mixture was greater than two substance configurations (e.g., 2 double bond configurations with 4 stereoisomers), we drew those as stereo non-specific single component substances.

As PubChem does not support enhanced stereochemistry files nor ratios of stereoisomers, depositions do not indicate the relative stereoisomeric ratios (racemate, ee, de).

Lastly, atropisomers were encoded as non-specific bonds since PubChem can not represent atropisomers.

**N.B. The PubChem folks are awesome and created a custom script for our submissions that adds annotations to the PubChem Compound pages. These annotations add the thesis reference under "Synthesis".** 

## File Overview Notes

1. A complete list of all structures registered and notes is available in the files:

 * UALIB_Chemical_Structures_REGID.ods (LibreOffice Calc)
 * UALIB_Chemical_Structures_REGID.csv (tab delimited)

2. **/StructureData/KnowItAll_processed_csv** - KnowItAll 2018 processed SMILES and InChI compiled CSV files submitted to PubChem. 

3. **/StructureData/raw/CA_Marvin_19.27.0** - files in here are the original ChemAxon 
MarvinSketch v19.27 .mrv, .smi, and .inchikey chemical structure files.

4. **/StructureData/raw/CSV** - original files which
include ChemAxon MarvinSketch v19.27 SMILES, InChIKeys (v1.05 as computed by ChemAxon molconvert v19.27.0), our internal REGID, substance name (or ID), thesis citation, and permalink.

5. **/StructureData/rdkit_processed_csv** - same as number 2, only adding RDKit kekulized SMILES (RDKit 2019.09.2 release), calculated InChI and InChIKeys for the substances(InChIs v1.05 as computed by RDKit 2019.09.2 release). 

6. **/StructureData/rdkit_processed_sdf** - SDfiles containing RDKit connection table, and 
the following SDfile data: SMILES (RDKit 2019.09.2 release), InChI (v1.05 as computed by RDKit 2019.09.2 release), our internal REGID, substance name (or ID), thesis citation, and permalink.

## References

Much of our inspiration for this project came from the following similar project:

Andrews, D. M.; Broad, L. M.; Edwards, P. J.; Fox, D. N. A.; Gallagher, T.;
Garland, S. L.; Kidd, R.; Sweeney, J. B. The Creation and Characterisation of 
a National Compound Collection: The Royal Society of Chemistry Pilot. Chem. Sci. 2016,
7 (6), 3869–3878. [DOI:10.1039/C6SC00264A](https://doi.org/10.1039/C6SC00264A)

## Current Contributors

Vincent F. Scalfani (Chemical Registration), Barbara Dahlbach (Digitization of full text Theses), and Jacob Robertson (Institutional Repository Records).

## Acknowledgments

VFS thanks The University of Alabama and The University of Alabama Libraries for approving research sabbatical leave for this project. We are grateful to ChemAxon for providing the MarvinSketch academic license and Bio-Rad for providing the KnowItAll academic license.

## Notes on Copyright and Reuse

**Disclaimer: Not legal advice, just our own personal (non-lawyer) thoughtful notes.**

The purpose of The University of Alabama Dissertation and Thesis Substance Registration project 
is to allow greater discovery, use, and credit of the original authors' theses, 
not to claim any ownership of the written thesis content. The thesis authors hold the 
copyright to their own thesis.

For all substances extracted and registered: no judgment is made on the appropriateness of the synthetic method reported, safety precautions required, nor accuracy of the characterization data. Readers need to make their own assessment of the authors claims, procedures, and necessary safety precautions.

During registration and processing of the chemical substances, inaccuracies may be present due to human and/or machine software error. We attempted to minimize inaccuracies and share chemical substances with fidelity to the original thesis, however, we can not make any guarantees on the accuracy of the chemical substance data. You should always check the original thesis to verify the data.

We have only extracted and shared scientific facts (i.e., the chemical substances) and bibliographic
information from the theses. Such scientific facts and bibliographic data are not subject 
to U.S. copyright protection: 
[Compendium of U.S. Copyright Office Practices](https://www.copyright.gov/comp3/).
See specifically section 313.3(A), where examples are listed that are excluded 
from copyright protection, one of which includes chemical substances:

..."DNA sequences and other genetic, biological, or chemical substances or 
compounds, regardless of whether they are man-made or produced by nature..."

We have endeavored to credit each thesis author respectfully by including a citation reference and permalink (where possible) on all shared chemical structure data including within
this Git Repository data files, The University of Alabama Institutional Repository,
and PubChem Substance Pages.

Our intention is for you to reuse the chemical structure data 
however you like. All chemical structure data in this repository is licensed 
with [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/). Please give the 
original authors of the theses credit by citing their work and following 
standard scholarly practice for reuse of the scientific literature, 
particularly if the chemical structure has led you to useful content within their 
thesis (as noted above, each thesis Author holds their own copyright). If you are
reusing a large corpus of the structures as a dataset, then it is appreciated 
if you cite our work as we put the effort into the data compilation. Lastly, any code in this repository is licensed under the BSD-2 license.

