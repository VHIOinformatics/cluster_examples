#!/bin/bash
#SBATCH --job-name=20211126_HPalmer_WES  # Job name
#SBATCH -p long
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=paumunoz@vhio.net     # Where to send mail	
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=1G                     # Job memory request
#SBATCH --cpus-per-task=1
#SBATCH --output=%x_%j.log   # Standard output and error lo
#SBATCH --error=%x_%j.err


samples="Samplefile.csv"
version="xxx"
pipeline="nf-core/xxx"
profile="singularity"
genome="GATK.GRCh38"
tools="xxxxx"
sarekoutput="results_"$SLURM_JOB_NAME
logdir="XXXXX"
logfile=$SLURM_JOB_NAME".txt"
other=""
igenomes='/mnt/bioinfnas/general/refs/igenomes'

maxmem="74.GB"
max_cpu="30"
max_time="12.h"
cmd="nextflow run $pipeline -profile $profile --input $samples -c nextflow.conf  --genome $genome -r $version --tools $tools --igenomes_base $igenomes --outdir $sarekoutput $other"

if [ ! -d "cache" ]
then
	mkdir cache
fi

read -r -d '' config <<- EOM
params {
  config_profile_description = 'bioinfo config'
  config_profile_contact = '$SLURM_JOB_USER $SLURM_JOB_USER@vhio.net'
  config_profile_url ='tobecopiedingithub'
}
singularity {
  enabled = true
  autoMounts = true
  cacheDir='./cache/'
}

executor {
  name = 'slurm'
  queueSize = 12
}

process { 
  executor = 'slurm'
  queue    = { task.time <= 5.h && task.memory <= 10.GB ? 'short': (task.memory <= 95.GB ? 'long' : 'highmem')}

}

params {
  max_memory = '$maxmem'
  max_cpus = $max_cpu
  max_time = '$max_time'
}
EOM

echo "$config" > nextflow.conf

message=$(date +"%D %T")"        "$(whoami)"     "$SLURM_JOB_NAME"       "$cmd
echo  $message >> $logdir$logfile
$cmd
tail -n 20 $SLURM_JOB_NAME"_"$SLURM_JOB_ID".log" >> $logdir$logfile


: <<'END'

process {
  withName:SORTMERNA  {
    cpus = 16
    memory = '32 GB'
    time = '30h'
  }
}
process {
  withName:BBMAP_BBSPLIT  {   
    cpus = 20 
    time = '32h'
  }
}

process {
  withName:FASTQC  {
    cpus = 2    
    time = '1h'
    memory = '2 GB'
  }
}

process {
  withName:TRIMGALORE  {
    cpus = 5    
    time = '4h'
    memory = '5 GB'
  }
}


process {
  withName:RSEM_CALCULATEEXPRESSION  {
    cpus = 10    
    time = '5h'
    memory = '40 GB'
  }
}

process {
  withName:SAMTOOLS_SORT  {
    cpus = 6    
    time = '1h'
    memory = '6 GB'
  }
}

process {
  withName:SAMTOOLS_INDEX  {
    cpus = 2    
    time = '1h'
    memory = '1 GB'
  }
}

process {
  withName:PRESEQ_LCEXTRAP  {
    cpus = 1    
    time = '1h'
    memory = '2 GB'
  }
}

process {
  withName:PICARD_MARKDUPLICATES  {
    cpus = 2    
    time = '1h'
    memory = '32 GB'
  }
}

process {
  withName:STRINGTIE_STRINGTIE  {
    cpus = 2    
    time = '1h'
    memory = '1 GB'
  }
}

process {
  withName:RSEQC_JUNCTIONANNOTATION  {
    cpus = 1    
    time = '1h'
    memory = '1 GB'
  }
}


process {
  withName:RSEQC_INNERDISTANCE  {
    cpus = 1    
    time = '1h'
    memory = '1 GB'
  }
}

process {
  withName:RSEQC_INFEREXPERIMENT  {
    cpus = 2    
    time = '1h'
    memory = '1 GB'
  }
}

process {
  withName:RSEQC_JUNCTIONSATURATION  {
    cpus = 1    
    time = '1h'
    memory = '3 GB'
  }
}

process {
  withName:RSEQC_READDUPLICATION  {
    cpus = 1    
    time = '1h'
    memory = '20 GB'
  }
}


process {
  withName:DUPRADAR  {
    cpus = 1    
    time = '1h'
    memory = '1 GB'
  }
}

process {
  withName:RSEQC_BAMSTAT  {
    cpus = 1    
    time = '1h'
    memory = '1 GB'
  }
}

process {
  withName:RSEQC_READDISTRIBUTION  {
    cpus = 1    
    time = '1h'
    memory = '2 GB'
  }
}

process {
  withName:QUALIMAP_RNASEQ  {
    cpus = 2    
    time = '3h'
    memory = '40 GB'
  }
}

process {
  withName:SAMTOOLS_IDXSTATS  {
    cpus = 1    
    time = '1h'
    memory = '1 GB'
  }
}

process {
  withName:SAMTOOLS_FLAGSTAT  {
    cpus = 2    
    time = '1h'
    memory = '1 GB'
  }
}

process {
  withName:SAMTOOLS_STATS  {
    cpus = 2    
    time = '1h'
    memory = '1 GB'
  }
}
END
