# Hallam-Lab


## Workflow to make a SSN:

- Add cruise ID to the headers using the script below 
- Use grep to separate sequences based on enzymes
- Cluster each enzyme’s sequences using bb tools to find representative sequences (dedupe overlap clustering method) 
`dedupe.sh in=Enzymes/NosZ.fna pattern=clusters/NosZ/cluster%.fna ac=f am=f s=1 mo=200 c pc csf=stats.txt outbest=clusters/NosZ/NosZ_out.fna fo c mcs=3 cc`
(see how to install bb tools below)
- Blast the representative sequences
  1. make BLAST database
      For proteins: (faa)
  `Makeblastdb -in file.fasta -dbtype prot -out prot_db` 
      For nucleotides:(fna)
  `Makeblastdb -in file.fasta -dbtype nucl -out nucl_db`  -- for .fna file

  2. BLAST database against query
     For proteins: (faa)
  `Blastp -db prot_db -query file.fasta -outfmt 6 -out all_v_all.tsv -num_threads 4`
    For nucleotides:(fna)
`Blastn -db NirK -query NirK_cluster.fna -outfmt 6 -out Blast_files/NirK.tsv -num_threads 4`

- Copy the blast tsv files onto the local server
`scp cwl@shamwow.microbiology.ubc.ca:\FilePath\onServer \FilePath\onComputer `

- get Taxonomy annoations for each sample from contig_marker_map.tsv
- combine blast.tsv and contig_marker_map.tsv in R
- Import to Cytoscape 
- Annotate depth and Taxonomy
