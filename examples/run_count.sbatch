#!/bin/tcsh
#SBATCH --job-name=ex-count
#SBATCH -n 1
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=50MB
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=<YOUR EMAIL>

python3 count.py