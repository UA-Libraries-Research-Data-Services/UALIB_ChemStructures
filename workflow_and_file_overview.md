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

For UALIB-1 through UALIB-1364, if a descriptive name was provided for the substance in the thesis, we included that in the data and in the PubChem SUBSTANCE_SYNONYM tag. However, including the substance names quickly proved too time consuming. After UALIB-1364, we included a local Substance ID (often the ID given in the thesis) instead of a name. These are useful internally only for tracking and not submitted to PubChem. Given that PubChem computes IUPAC names for submitted structures and the names provided in theses most often appeared to be some type of systematic name (maybe?), we felt it was higher value to focus on getting as many structures as we can out of the theses and discoverable as a priority for the community.

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

3. **/StructureData/raw** - Working files for compiling SMILES, InChIs, and our internal REGID, substance name (or ID), thesis citation, and permalink into a CSV.

4. **/StructureData/rdkit_processed_csv** - same as number 2, only adding RDKit kekulized SMILES (RDKit 2019.09.2 release), calculated InChI and InChIKeys for the substances(InChIs v1.05 as computed by RDKit 2019.09.2 release). 

5. **/StructureData/rdkit_processed_sdf** - SDfiles containing RDKit connection table, and 
the following SDfile data: SMILES (RDKit 2019.09.2 release), InChI (v1.05 as computed by RDKit 2019.09.2 release), our internal REGID, substance name (or ID), thesis citation, and permalink.


