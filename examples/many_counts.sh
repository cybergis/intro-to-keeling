#!/bin/bash
for i in {30..40}; do
  export HOWHIGHTOCOUNT=$i
  sbatch my_count.sbatch
  sleep 1
done