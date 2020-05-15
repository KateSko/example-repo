

#sourcing the program
source /etc/profile.d/markcbm.sh

#getting data
cp -r /home/manager/linux/ ~/Desktop/.

#go to the file
cd ~/Desktop/linux/advanced/rnaseq/

#running the program
fastqc fastq/*.fastq

#open 1 results in firefox (in background)
firefox fastq/myoblast_del_fastqc.html &

#open 2 results in firefox (in background)
firefox fastq/myoblast_wt_fastqc.html &

#change directions again
cd index/

#build index 
bowtie-build mm9_chr1.fa mm9_chr1

#go up 1 in directory
cd ..

#align fastq 1
tophat2 -G mm9_chr1.gtf -o tophat_wt/ index/mm9_chr1 fastq/myoblast_wt.fastq 

#align fastq 2
tophat2 -G mm9_chr1.gtf -o tophat_del/ index/mm9_chr1 fastq/myoblast_del.fastq 

#check if output was created
cd tophat_wt/
ls -l
cd ../tophat_del/
ls -l
cd ..

#check outputs
cat tophat_wt/align_summary.txt 
cat tophat_del/align_summary.txt

#index
samtools index tophat_wt/accepted_hits.bam 
samtools index tophat_del/accepted_hits.bam 

#calculate differential expression
cuffdiff --no-update-check -o cuffdiff_out -L wt,del mm9_chr1.gtf tophat_wt/accepted_hits.bam tophat_del/accepted_hits.bam

#checking output
ls -lh cuffdiff_out/

echo DONE


