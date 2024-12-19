#!/bin/bash
#SBATCH -p long
#SBATCH --job-name=copy
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=<username@vhio.net>
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --time=20-0
#SBATCH --cpus-per-task=1
#SBATCH --output=%x_%j.log
#SBATCH --error=%x_%j.err


#Commands to use to copy files within the cluster without keeping origin permissions and timestamps
#You can use either rsync or cp (rsync is a bit faster)

rsync -rtvOP --no-perms --no-owner --no-times <origin> <destiny> 

cp <origin> <destiny> --no-preserve=ownership,timestamps


