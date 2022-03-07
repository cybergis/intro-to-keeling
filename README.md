# Intro to Keeling

# Table of Contents:

* [Concepts](#concepts)
* [Accessing Keeling through SSH](#ssh)
* [Intro to the Terminal](#terminal)
* [Example Jobs](#examples)
* [Installing and Using Anaconda](#conda)
* [Additional Resources](#resources)
* [FAQ](#faq)


See also: the [CyberGIS Center's HPC: A Quick Start Guide](https://cybergis.illinois.edu/infrastructure/hpc-user-guide/hpc-a-quick-start-guide/)

<hr id="concepts">

# Concepts

## SLURM

SLURM which originally stood for Simple Linux Utility for Resource Management is an open-source job scheduler. It allows you to reserve computational resources to run "jobs" (models, analysis, etc.).

[Read the wikipedia](https://en.wikipedia.org/wiki/Slurm_Workload_Manager)



<hr id="ssh">

# Accessing Keeling Through SSH

First, you need a way to remotely access UIUC's compute cluster, Keeling. To do this, we will use SSH which stands for Secure SHell protocol. 

For Linux and Mac users, you can do this in the terminal simply by typing:

```
ssh <YOUR NETID>@keeling.earth.illinois.edu
```

then use your Illinois password. If asked about a "fingerprint", say yes. This command is saying:

* `ssh` establish a secure shell
* `<YOUR NETID>` logging in with my username
* `keeling.earth.illinois.edu` on Keeling

For Windows users, there are a variety of options:

* We recommend [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html)
* You can also use [PuTTY](https://www.putty.org/)
* Another option is the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about)


<hr id="terminal">

# Intro to the Terminal


Once connected to Keeling, you should be at your home directory. 

* To Print the Working Directory, you can use `pwd`. You should see `/data/keeling/a/<YOUR NETID>`. 
* To see what you have at your home directory, you can use `ls`.
* The CyberGIS Center has a shared directory at `/data/cigi/common/`. To Change Directories use `cd`. Try `cd /data/cigi/common` and then list (`ls`) to see what's there.
* To return to your home directory, you can always use `cd ~/`. `~/` is a shortcut for your home.
* We also have a "scratch" directory (`/data/cigi/scratch`) which is a temporary working directory. Note that any data stored here may be lost or deleted without warning. To see what's there we can use `ls /data/cigi/scratch`.

Now, let's pull this Github repository to Keeling. First, we will configure git so they know who we are:

```
git config --global user.name "<YOUR GITHUB USERNAME>"
git config --global user.email <YOUR GITHUB EMAIL>
```

Next, you can clone a repository with the following syntax:

```
git clone <REPOSITORY LINK>
```


<hr id="examples">

# Example Jobs

Now that you're acquainted with Keeling and have this repository downloaded, we can get some hands-on experience in running jobs in SLURM.

## Count.py Example

1. Let's examine the count.py example. You can see what it looks like with the `cat` command which displays the contents of a file.

```
> cat count.py

import os
import time


count_to = 1
try:
  count_to = os.getenv("HOWHIGHTOCOUNT")
except Exception as e:
  print(e)

if count_to is None:
  count_to = 30

for i in range(int(count_to)):
  print(i)
  time.sleep(1)

```

It's a pretty simple script. It counts to `count_to` taking a one-second break after each number. It also tries to grab a number from the environment variables. The variable it tries to grab is `HOWHIGHTOCOUNT`. If that fails, it prints the exception and uses a default of 30.

2. **How do we run this job?**

You should try to not run things on the head node because:

* everyone is sharing that one node
* running through slurm means you can use multiple nodes at once.

To run the count.py job with `run_count.py`:

```
#!/bin/tcsh
#SBATCH --job-name=ex-count
#SBATCH -n 1
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=50MB
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=<YOUR EMAIL>

python3 count.py
```

Let's break it down line-by-line:

* `#!/bin/tcsh` - the `#!` is called a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) and tells the computer to run the script with `/bin/tcsh`.
* `#SBATCH --job-name=ex-count` - this tells SLURM to name the job "ex-count"
* `#SBATCH -n 1` - this says we only need one task. You may need more for parallel code.
* `#SBATCH --time=1:00:00` - this tells SLURM to stop the job after an hour. The format is hours:minutes:seconds.
* `#SBATCH --mem-per-cpu=50MB` - the amount of memory per CPU
* `#SBATCH --mail-type=FAIL` - email me if it fails
* `#SBATCH --mail-type=END` - email me when it ends
* `#SBATCH --mail-user=<YOUR EMAIL>` - your email
* `python3 count.py` - run count.py with python.

3. You can make a CoPy of the run_count.sbatch with the `cp`. The `cp` command (and many commands) work with source and destination. So to copy the `run_count.sbatch` file to `my_count.sbatch`, you could use:

```
cp run_count.sbatch my_count.sbatch
```

4. Now that you've copied it, you can edit the file with `nano`. Run

```
nano my_count.sbatch
```

Use arrows to navigate to the email section, then delete `<YOUR EMAIL>` and replace it with your email. Once this is done you can exit nano with `CTRL+X` (it says this at the bottom of the window). 

It will ask "Save modified buffer (ANSWERING "No" WILL DESTROY CHANGES) ?" To save your changes, answer "Y".

Next, it will ask "File Name to Write:" and you can just press enter.

5. To submit a job, you can use the `sbatch` command. Specifically:

```
> sbatch my_count.sbatch

Submitted batch job XXXXXX
```

It should say "Submitted batch job" with a number just as in above. To see what jobs are running you can use `squeue` to view the SLURM queue. To see your jobs, you can use `squeue -u <YOUR NETID>`.

6. The count job only takes about 30 seconds and once it is over, you should get an email. If you use `ls` you should also see a file of the form `slurm-XXXXX.out` where the "XXXXX" number matches the one you saw when you submitted the job. To view the contents of the file, use `cat slurm-XXXX.out`

7. Next, we will see how to pass the value of `HOWHIGHTOCOUNT` from the sbatch script. For something this simple it may not be entirely useful, but this method can be used to pass parameters and inputs to more complex analysis and models.

To set an environment variable in this script insert:

```
setenv HOWHIGHTOCOUNT 10
```

in the line above `python3 count.py`. The line sets an environmental variable called `HOWHIGHTOCOUNT` to "10". You can use any number here, but keep in mind that it will run for that many seconds **IMPORTANT NOTES:** 

* It must precede the python line or else the python script will run without the environmental variable set.
* All environmental variables are strings. You can treat it as different type in your script (such as we do), but it will be read from the environment as a string.

Now you can re-run the batch job and check the output again. You should see that it only counted up to your new number.

8. You probably don't want to make a separate sbatch file for each job though, especially if we are just changing a single parameter. First, delete the `setenv` line from the sbatch file. Now, let's submit the count job multiple times for many different values of `HOWHIGHTOCOUNT`. You can do that with the `many_counts.sh` bash script:

```
#!/bin/bash
for i in {30..40}; do
  export HOWHIGHTOCOUNT=$i
  sbatch my_count.sbatch
  sleep 1
done
```

Breaking this down:

* `#!/bin/bash` - this is the shebang again, this time telling us to use bash. Bash is the default language in the terminal, so we've been using it the whole time!
* `for i in {30..40}; do .... done` - is a bash for loop which loops from 30 to 40. The [bash cheat sheet](https://devhints.io/bash) has more on this syntax.
* Within the loop we are:
  * `export HOWHIGHTOCOUNT=$i` - this is the bash equivalent of `setenv`
  * `sbatch my_count.sbatch` - this submits our job
  * `sleep 1` - pause for a second. It is best practice to pause a bit between submitting jobs


<hr id="conda">

# Installing and Using Anaconda

We will be following the guidance from [mgrover1's keeling-crash-course](https://github.com/mgrover1/keeling-crash-course)

1. From your home directory `cd ~/` you can run the following command to download the miniconda installer:

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

`wget` is a command line utility to to download files.

2. Next, make the file executable (meaning your computer can run it as a script):

```
chmod u+x Miniconda3-latest-Linux-x86_64.sh 
```

3. Now that the file is exectuable, you can run it:

```
./Miniconda3-latest-Linux-x86_64.sh 
```

you will need to agree to terms and should be fine with the default values.

4. The installer will alter a file called `~/.bashrc` which runs everytime you login. To reload the file with the changes, you can run:

```
source ~/.bashrc
```

`source` runs the script in the current shell, meaning any variables or functions will be available in your shell.

5. To check that the installation succeeded, use `conda --version`. Now you can use conda normally.

6. To use your conda environment in a SLURM job, be sure to include the line `source ~/.bashrc` so that conda will be loaded. After that line, you can also activate any environments with `conda activate <environment>`.

<hr id="resources">

# Additional Resources

* [CyberGIS Center HPC Quick Start Guide](https://cybergis.illinois.edu/infrastructure/hpc-user-guide/hpc-a-quick-start-guide/)
* [mgrover1's keeling-crash-course](https://github.com/mgrover1/keeling-crash-course)
* [SLURM Documentation](https://slurm.schedmd.com/documentation.html)
* [SLURM Quick Start User Guide](https://slurm.schedmd.com/quickstart.html)

<hr id="faq">

# Frequently Asked Questions (FAQ)

## How can I see information on the nodes?

The [`sinfo` command](https://slurm.schedmd.com/sinfo.html) gives you information on the nodes in the cluster:

```
sinfo --Node --long
```

## How can I cancel a job?

You can use the [`scancel` command](https://slurm.schedmd.com/scancel.html). Specifically:

```
scancel <job ID>
```

## Am I using too much of the cluster?

You can use [`sshare -U`](https://slurm.schedmd.com/sshare.html) to see your Effective Usage

```
sshare -U
```