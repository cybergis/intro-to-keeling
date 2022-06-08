# Concepts, Resources, and FAQ


<hr id="concepts">

## Concepts

### SLURM

SLURM which originally stood for Simple Linux Utility for Resource Management is an open-source job scheduler. It allows you to reserve computational resources to run "jobs" (models, analysis, etc.).

[Read the wikipedia](https://en.wikipedia.org/wiki/Slurm_Workload_Manager)



<hr id="resources">

## Additional Resources

* [CyberGIS Center HPC Quick Start Guide](https://cybergis.illinois.edu/infrastructure/hpc-user-guide/hpc-a-quick-start-guide/)
* [mgrover1's keeling-crash-course](https://github.com/mgrover1/keeling-crash-course)
* [SLURM Documentation](https://slurm.schedmd.com/documentation.html)
* [SLURM Quick Start User Guide](https://slurm.schedmd.com/quickstart.html)


<hr id="faq">

## Frequently Asked Questions (FAQ)

### How can I see information on the nodes?

The [`sinfo` command](https://slurm.schedmd.com/sinfo.html) gives you information on the nodes in the cluster:

```
sinfo --Node --long
```

### How can I cancel a job?

You can use the [`scancel` command](https://slurm.schedmd.com/scancel.html). Specifically:

```
scancel <job ID>
```

### Am I using too much of the cluster?

You can use [`sshare -U`](https://slurm.schedmd.com/sshare.html) to see your Effective Usage

```
sshare -U
```