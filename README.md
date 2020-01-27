# UALIB_ChemStructures
Chemical Substances from The University of Alabama Dissertations and Theses

## What is this?
This repository contains the machine-readable indexed chemical substances (non-standardized) 
from The University of Alabama Dissertations and Theses (hereafter, theses). 

**At the moment, there are about 500 structures. Our goal is to share 10,000 structures by June 2020.**

Chemical structure data includes the name, SMILES, and InChI of all synthesized chemical
substances within the thesis along with a permalink to the thesis full-text or 
catalog link (if not yet available online), Moreover, an SDfile containing the connection table, name, 
SMILES, InChI, citation, permalink, and local structure registry ID is included. 
The RDKit processed SDfile is what we submit directly to PubChem. PubChem is likely where you want to download our 
data from as PubChem handles the standardization (on Compound database) of the chemical structures:
[The University of Alabama Libraries PubChem Data Source](https://pubchem.ncbi.nlm.nih.gov/source/15645).
However, this GitHub repository is useful for those seeking to download our non-standardized data, understand our workflow, and read our notes on copyright and reuse.

## How are we indexing the chemical structures?

This is a manually curated effort, no machine extraction. We are redrawing, encoding, and annotating the structures from the theses ourselves. See our workflow below for complete details.

## What structures are you including? 

There are two key requirements that must be met for us to index a substance:

1. The substance can be represented with the SMILES line notation. This includes most small molecule organic chemistry with some limited organometallic chemical substances.

2. Chemical substances indexed must have synthetic preparatory and some associated experimental characterization details such as NMR, mass spec, elemental analysis, or melting point. The exception is 
with early theses (e.g. 1920s), where we indexed the substances if there was a preparation method with an associated analytical or qualitative test.

## What is your workflow? 

We're still working on creating an optimal open workflow that is highly reproducible. Here is an overview of our current strategy:

1. Draw chemical structures in [ChemAxon MarvinSketch](https://chemaxon.com/products/marvin). We really like the free [PubChem Sketcher](https://pubchem.ncbi.nlm.nih.gov/edit3/index.html) too, however, we found it much faster to use MarvinSketch.
2. Export as ChemAxon SMILES (v19.27.0). Note that for organometallic dative bonds, we did not use SMILES extensions, but rather left these as disconnections (`.`) and then edited later (see step 8).
3. Calculate InChIKeys (v1.05 as computed by ChemAxon molconvert v19.27.0).
4. Create a tab delimited file with an index number for each substance (i.e., UALIB-###), 
citation, permalink to the thesis, and substance name. The substance name given in the dissertation is used. Often this is a systematic or common name, other times it is simply "Compound 50" or "Diol 70a." Since PubChem computes the IUPAC name of submitted substances, we decided not to compute systematic names locally and use the name given in the thesis.
5. Check for duplicates with prior indexed substances with the InChIKey using a shell sort command. Any duplicates are assigned the same local Registry ID (i.e., UALIB-###). The original PubChem Substance record is then updated with the additional thesis reference.
6. Import the tabbed text file into an RDKit Pandas dataframe to calculate the 
InChIs, InChIKeys, write kekulized SMILES, and generate the SDfile (InChIs v1.05 as computed by RDKit 2019.09.2 release). 
7. Compare RDKit and ChemAxon InChIKeys (this helps catch any issues with SMILES parsing across the toolkits). If the InChIKeys do not match, we figure out the issue before adding the structure to the local Registry Index.
8. If there were any organometallics with dative bonds, we manually added these to the SDfile using the PubChem nonstandard bond syntax. Note: we did experiment with using the dative bonds feature in RDKit with SMILES (`->, <-`) and V3000 molfile, but these files did not parse correctly in PubChem. 
9. Submit the SDfile to PubChem. 
10. Update the UALIB_Chemical_Structures_REGID files
11. Create a record on our [Institutional Repository](https://ir.ua.edu/) with the SDfile and associated thesis references.

**N.B. The PubChem folks are awesome and created a custom script for our submissions that add annotations to the PubChem Compound pages. These annotations add the thesis reference under "Synthesis".** 

## File Overview Notes

1. A complete list of all structures indexed and notes is available in the files:

 * UALIB_Chemical_Structures_REGID.ods (LibreOffice Calc)
 * UALIB_Chemical_Structures_REGID.csv (tab delimited)
 * UALIB_Chemical_Structures_REGID.sdf (SDfile)

2. **/StructureData/raw/CA_Marvin_19.27.0** - files in here are the original ChemAxon 
MarvinSketch v19.27 .mrv, .smi, and .inchikey chemical structure files.

2. **/StructureData/raw/CSV** - files in here are the original indexing files which
include ChemAxon MarvinSketch v19.27 SMILES, InChIKeys (v1.05 as computed by ChemAxon molconvert v19.27.0), our internal REGID, substance name, thesis citation, and permalink.

3. **/StructureData/rdkit_processed_csv** - same as number 2, only adding RDKit kekulized SMILES (RDKit 2019.09.2 release), calculated InChI and InChIKeys for the substances(InChIs v1.05 as computed by RDKit 2019.09.2 release). 

4. **/StructureData/rdkit_processed_sdf** - SDfile containing RDKit connection table, and 
the following SDfile data: SMILES (RDKit 2019.09.2 release), InChI (v1.05 as computed by RDKit 2019.09.2 release), our internal REGID, substance name, thesis citation, and permalink. These files are submitted to PubChem.

## References

Much of our inspiration for this project came from the following similar project:

Andrews, D. M.; Broad, L. M.; Edwards, P. J.; Fox, D. N. A.; Gallagher, T.;
Garland, S. L.; Kidd, R.; Sweeney, J. B. The Creation and Characterisation of 
a National Compound Collection: The Royal Society of Chemistry Pilot. Chem. Sci. 2016,
7 (6), 3869–3878. [DOI:10.1039/C6SC00264A](https://doi.org/10.1039/C6SC00264A)

## Current Contributors

Vincent F. Scalfani (Chemical Indexing), Barbara Dahlbach (Digitization of full text Theses), and Jacob Robertson (Institutional Repository Records).

## Acknowledgments

VFS thanks The University of Alabama and The University of Alabama Libraries for approving research sabbatical leave for this project. We are grateful to ChemAxon for providing the MarvinSketch Academic Research License.

## Notes on Copyright and Reuse

**Disclaimer: Not legal advice, just our own personal (non-lawyer) thoughtful notes.**

The purpose of The University of Alabama Dissertation and Thesis indexing project 
is to allow greater discovery, use, and credit of the original authors' theses, 
not to claim any ownership of the written thesis content. The thesis authors hold the 
copyright to their own thesis.

For all substances indexed, no judgment is made on the appropriateness of the synthetic method reported, safety precautions required, nor accuracy of the characterization data. Readers need to make their own assessment of the authors claims and procedures. In addition, during indexing and processing of the chemical substance data, inaccuracies may be present due to human and/or machine software error. We attempted to minimize inaccuracies and share chemical substance data with fidelity to the original thesis, however, we can not make any guarantees on the accuracy of the chemical substance data. You should always check the original thesis to verify the chemical data.

We have only indexed and shared scientific facts (i.e., the chemical substances) and bibliographic
information from the theses. Such scientific facts and bibliographic data are not subject 
to U.S. copyright protection: 
[Compendium of U.S. Copyright Office Practices](https://www.copyright.gov/comp3/).
See specifically section 313.3(A), where examples are listed that are excluded 
from copyright protection, one of which includes chemical substances:

..."DNA sequences and other genetic, biological, or chemical substances or 
compounds, regardless of whether they are man-made or produced by nature..."

We have endeavored to credit each thesis author respectfully by including a citation reference and permalink on all shared chemical structure data including within
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
if you cite our work as we put the effort into the indexing and data compilation. Lastly, any code in this repository is licensed under the BSD-2 license.

