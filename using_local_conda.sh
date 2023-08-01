#!/bin/bash
#SBATCH -p long
#SBATCH --job-name="chrX_VEP"
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=32G
#SBATCH --time=15:00:00
#SBATCH --output=out.%x.%j
#SBATCH --error=err.%x.%j

echo "*"
echo "** Running VEP"
echo "*"
date
cat run_VEP.sh
echo "*"
#command_line
#CONDA ACTIVATE
source /home/anadueso@vhio.org/.bashrc
source activate vep109
/mnt/bioinfnas/immunocomp/anadueso/ensembl-vep-release-109/vep --offline -i /mnt/bioinfnas/immunocomp/anadueso/blueprint-immuno/ANALYSIS/generated_snvs/chrx/chrx-exons_vep_sort.txt -o /mnt/bioinfnas/immunocomp/anadueso/blueprint-immuno/ANALYSIS/VEP_annotation/chrx-exons_sort_joblong.vep.vcf --fasta /home/anadueso@vhio.org/.vep/homo_sapiens/109_GRCh38/ --hgvs --canonical --biotype --clin_sig_allele 0 --af_gnomad --af --protein --symbol --numbers
date
echo "** Finish succesfully"


