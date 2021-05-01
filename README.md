
# Hallam-Lab

## File Locations

All files can be found here:  
`/mnt/nfs/sharknado/Sandbox/Aarushi/TreeSAPP_Outputs/TreeSAPP_April21/ORF_files`

MetaG faa file name: `faa_files_MetaG.faa` 

MetaT faa file name: `faa_files_MetaT.faa`


concatonated contig file: `contig_marker_map.tsv`

Filetered NosZ files:

  [NosZ_seqs_MetaG_subset.csv](https://github.com/aarushi254/Hallam-Lab/files/6408744/NosZ_seqs_MetaG_subset.csv)
        
   [NosZ_seqs_MetaT_subset.csv](https://github.com/aarushi254/Hallam-Lab/files/6408746/NosZ_seqs_MetaT_subset.csv)


## Workflow to make a SSN:
Diagram: 
![SSN workflow (1)](https://user-images.githubusercontent.com/37523738/116767936-08cb9a80-a9e8-11eb-8905-304acd74424c.png)

- Add cruise ID to the headers 
    - issues faced while developing a script that puts cruise IDs to the headers
    - script found in Sandbox: `mnt/nfs/sharknado/Sandbox/Julia/TreeSAPP_Outputs_Apr_06_2021/faa_files_header_change`

- Use grep to separate sequences based on enzymes
`grep -i -A 1 'NapA' * > NapA_enzyme.fna`
- Cluster each enzyme’s sequences using bb tools to find representative sequences (dedupe overlap clustering method) 
`dedupe.sh in=Enzymes/NosZ.fna pattern=clusters/NosZ/cluster%.fna ac=f am=f s=1 mo=200 c pc csf=stats.txt outbest=clusters/NosZ/NosZ_out.fna fo c mcs=3 cc`
(see how to install bb tools below)
- Blast the representative sequences
  1. make BLAST database
  
      a. For proteins: (faa)
  `Makeblastdb -in file.fasta -dbtype prot -out prot_db` 
  
      b. For nucleotides:(fna)
  `Makeblastdb -in file.fasta -dbtype nucl -out nucl_db`  -- for .fna file

  2. BLAST database against query
  
     a. For proteins: (faa)
  `Blastp -db prot_db -query file.fasta -outfmt 6 -out all_v_all.tsv -num_threads 4`
  
    b. For nucleotides:(fna)
`Blastn -db NirK -query NirK_cluster.fna -outfmt 6 -out Blast_files/NirK.tsv -num_threads 4`

- Copy the blast tsv files onto the local server
`scp cwl@shamwow.microbiology.ubc.ca:\FilePath\onServer \FilePath\onComputer `

- get Taxonomy annoations for each sample from contig_marker_map.tsv
- combine blast.tsv and contig_marker_map.tsv in R
    - base R was used to do this, however tidyverse has better and easier ways of segratating/combining columns
- Import to Cytoscape 
- Annotate depth and Taxonomy
    - First type of SSN had nodes coloured based on Depth
    - Second type of SSN had nodes coloured based on taxonomy
    - Third type of SSN was separated by depth and nodes were coloured based on taxonomy


## bb tools Installation instructions
1. Setting up conda environment in ssh

  i. Download installer

`cd /tmp
curl -O https://repo.anaconda.com/archive/Anaconda3-<2019.10>-Linux-x86_64.sh`
(change <2019.10> to latest version from Anaconda distributions page)

  ii. Verify integrity of installer
`sha256sum Anaconda3-<2019.10>-Linux-x86_64.sh`

  iii. Run installer script and complete installation 
  `bash Anaconda3-<2019.10>-Linux-x86_64.sh`

  iv. Run
`source ~/(installation path)`

  v. Test installation
`conda list`

2. Install other tools (such as bb tools)
    
    i. Create environment
`conda create -n environmentName`
   
   ii. Activate environment
`conda activate environmentName`
  
   iii. Install tools
`conda install -c bbtools`


## Workflow to create 3D plots
Diagram: 
![3D plots Workflow](https://user-images.githubusercontent.com/37523738/116767896-dde14680-a9e7-11eb-9489-4347b225f196.png)

  - Add cruise ID to the headers and concatanate files
    - issues faced while developing a script that puts cruise IDs to the headers
    - script found in Sandbox: `/mnt/nfs/sharknado/Sandbox/Julia/TreeSAPP_Outputs_Apr_06_2021/faa_files_header_change`

  - Use grep to separate sequences based on enzymes
  `grep -i -A 1 'NapA' * > NapA_enzyme.fna`
 
  - Put each file on ghostKOALA to find KEGG IDs for each sample to differentiate between a gene sample and cytochrome samples
      - GhostKOALA also provides taxonomy for all samples

  - combine and filter marker_contig.tsv, KEGG annotation file and geochemistry data in R
      - filtering performed found here: 
  
  - calculate shannon diversity in R

      - code: https://github.com/aarushi254/Hallam-Lab/blob/main/diversity%20calculation.Rmd
     

  - create 3D plots with 
          X = Depth
          Y = Time
          Z = Diversity
     code:
     ** Problems with 3D plots:
     - Time need to be converted into numerical values: either julian dates or use cruise IDs instead
     - 3D plots should be iterated to make 3D kernel density plots

