# Intro to Keeling

# Table of Contents:

* [Concepts](#concepts)
* [Accessing Keeling through SSH](#ssh)
* [Intro to the Terminal](#terminal)
* [Example Jobs](#examples)
* [Installing and Using Anaconda](#conda)
* [Managing Data on Keeling](#data)
  * [Getting Data to Keeling](#data2keeling)
  * [Basics of Permissions](#datapermissions)
  * [Getting Data off Keeling](#datafromkeeling)
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

( If this does not work then just restart your terminal )

5. To check that the installation succeeded, use `conda --version`. Now you can use conda normally.

6. To use your conda environment in a SLURM job, be sure to include the line `source ~/.bashrc` so that conda will be loaded. After that line, you can also activate any environments with `conda activate <environment>`.

<hr id="data" />

# Managing Data

We recommend that everything you can put in Github you do put in a repo, but not everything can go in Github repositories. This section goes over getting larger data to Keeling, the basics of data management, and then getting data back from Keeling.

<hr id="data2keeling" />

## Getting Data to Keeling

<hr id="datapermissions" />

### Simple Downloading with Wget

What is wget? To find you, run the following command on Keeling:

```
man wget
```

This brings up the "man page" (short for manual page) for the wget command. This is a way of reading basic documentation in the terminal and should work for most commands. You can scroll with the arrow keys and the man page should tell you at the bottom that "q" let's you quit the page. As the man page says, it is a "non-interactive network downloader" which is fancy-speak for a simple way to download stuff from the web.

For a very easy test, let's grab the README from Github:

```
> wget https://raw.githubusercontent.com/cybergis/intro-to-keeling/main/README.md

--2022-04-25 10:26:49--  https://raw.githubusercontent.com/cybergis/intro-to-keeling/main/README.md
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.110.133, 185.199.111.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.110.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 10756 (11K) [text/plain]
Saving to: 'README.md'

100%[============================================================================>] 10,756      --.-K/s   in 0s      

2022-04-25 10:26:49 (49.8 MB/s) - 'README.md' saved [10756/10756]
```

Okay, but if what if I want to change the name and download it as "hello.md" instead of "README.md"? You can go back to the man page, or use the help flag:

```
> wget --help

GNU Wget 1.14, a non-interactive network retriever.
Usage: wget [OPTION]... [URL]...

Mandatory arguments to long options are mandatory for short options too.

Startup:
  -V,  --version           display the version of Wget and exit.
  -h,  --help              print this help.
  -b,  --background        go to background after startup.
  -e,  --execute=COMMAND   execute a `.wgetrc'-style command.
...
```

If you scroll down the help a bit, it tells you under the "Download" section that you can use `-O` to specify the output file. We can accomplish this using:

```
> wget https://raw.githubusercontent.com/cybergis/intro-to-keeling/main/README.md -O hello.md

--2022-04-25 10:29:26--  https://raw.githubusercontent.com/cybergis/intro-to-keeling/main/README.md
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.109.133, 185.199.111.133, 185.199.110.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 10756 (11K) [text/plain]
Saving to: 'hello.md'

100%[============================================================================>] 10,756      --.-K/s   in 0s      

2022-04-25 10:29:26 (47.8 MB/s) - 'hello.md' saved [10756/10756]
```

### Other options for Downloading

* [gdown (Python)](https://github.com/wkentaro/gdown) - downloading large files from Google Drive
* [scp (command line)](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/) - Secure CoPy. We will discuss this a bit in [Getting Data off Keeling](#datafromkeeling)

## Basics of Permissions

<hr id="datafromkeeling">

### Getting info on your Files (`ls -l`)

If you use the `ls` command you can see the files we just downloaded, but what do you do with the data once it's there? As we discussed earlier, Keeling has your directory (`~/` or `/data/keeling/a/<your netid>`) and a shared directory for the lab (`/data/cigi/common`). 

So if you put data in your folder, it's just for you and if you put it in the shared directory, it's shared with the lab, right? **No.** We refer to this as "our" and "shared" directory for simplicity, but Linux file permissions actually determine who has access to our files and what they can do with them. 

To see the permissions on files in your home directory, go there (`ls ~/`) and then use:

```
> ls -l
```

This means "list with the long format". You'll see lots of outputs with this format:

```
-rw-r--r--  1 michels9 cigi-algosys-group 10756 Apr 25 10:29 hello.md
```

so let's break this down.

* `-rw-r--r--` are the permissions, we will come back to that in a second.
* `1` is the number linked hard-links. You can ignore this for now.
* `michels9` is my net ID meaning that I own the file.
* `cigi-algosys-group` is the group for that file. Files and directories can have an owner and a group!
* `10756` is the size in bytes, you can also ignore this.
* `Apr 25 10:29` the data it was created or modified.
* `hello.md` is the name of the file. 

Putting this all together, you can read these line as:

```
[permissions] [ignore me] [owner] [group] [size] [date] [filename]
```

**Try yourself:** use the man page or help text for `ls` to figure out how to output the size of the files in a human-readble format instead of just bytes.

<details>
<summary>Answer</summary>

```
> ls -lh
```

The help text tells you that `-h` or `-human-readable` will print the sizes in a human readable format (i.e. 2G)
</details>

### Reading Permissions

Let's get back to figuring out what `-rw-r--r--` means. Well the basic breakdown of these permissions goes:

```
-rw-r--r-- 12 linuxize users 12.0K Apr  28 10:10 file_name
|[-][-][-]-   [------] [---]
| |  |  | |      |       |
| |  |  | |      |       +-----------> 7. Group
| |  |  | |      +-------------------> 6. Owner
| |  |  | +--------------------------> 5. Alternate Access Method
| |  |  +----------------------------> 4. Others Permissions
| |  +-------------------------------> 3. Group Permissions
| +----------------------------------> 2. Owner Permissions
+------------------------------------> 1. File Type

```

[Credit for the above](https://linuxize.com/post/understanding-linux-file-permissions)

We briefly covered 6-7 and wil ignore 5 for now because that's a bit advanced. We will focus on 1-4:

1. **File type:** There are a variety of files types, but the two most basic are `-` which identifies a normal file and `d` which is a directory. You may also run into `l` which means a symbolic link which can be thought of as a shortcut to access files elsewhere.
2. **Owner Permissions:** permissions are generally made up of three options Read (r), Write (w) and Execute (x). Permissions follow this format (rwx) and if there is a dash in a positions that means you do not have that permission. `rw-` means you can read and write the file, but not execute (think running code). 
3. **Group Permissions:** These follow the same format as owner permissions, but apply to everyone in your group of users. `r--` means everyone in your group can read the files, but not write (change) or execute (run) them.
4. **Others Permissions:** These also follow the same format (rwx), but apply to everyone. If a file is `r--` that means that anyone who can log onto the computer can read the file, but can't write (change) or execute (run) them.

**Try yourself:** What does `drwxr-xr-x` mean?

<details>
<summary>Answer</summary>

Let's break it down:

* `d` is the first character, so it's a directory
* `rwx` is the owner permissions, so the owner can read, write, and execute.
* `r-x` is the group and others permissions, so the group members and everyone else can read and execute the file, but not write (change) it.
</details>

I've heard people say stuff like "777" or "755" to refer to permissions, what does that mean? Well we get those from treating the permissions to binary/octal values. We treat r/w/x as 1 and `-` as 0. Let's try one:

`-rwxr-xrw-` means its a regular file (`-` as the first character) and we get the numbers from the permissions which are:

* `rwx` - Owner permissions are all ones (not dashes) so we treat this as 111 which in binary is 4+2+1=7.
* `r-x` - Group permissions are 101 and converting this to "regular" numbers is 4+0+1=5.
* `rw-` - Others permissions are 110 which is 4+2+0=6.

So this is 756.

**Try yourself** Convert these two: `-rwxrwxrwx` and `-rwxr-xr-x`.

<details>
<summary>Answer</summary>

The first (`-rwxrwxrwx`) is 777. We ignore the first character and find that owner, group, and others permission are all `rwx` which is 111=4+2+1=7. Practically this means "anyone can do whatever they want to our files."

The second (`-rwxr-xr-x`) is 755. We ignore the first character. Owner permissions are `rwx` which is 111=4+2+1=7. Both Group and Others permissions are `r-x` which is 111=4+0+1=5. This means "anyone can read or execute my files, but only I can write to/change them."

</details>

### Changing Permissions

How do you change permissions? Very carefully! It is very easy to run the wrong command or for a quick typo to mess things up, so if you aren't comfortable, please reach out to someone trusted (your group leader, Anand, Drew, etc.) to help! 

However, if you were to accomplish this, you can do it with `chmod` which means CHange MODe. To get a quick description of chmod, look at the help text or the man page.

The help page gives us some example usage:

```
> chmod --help
Usage: chmod [OPTION]... MODE[,MODE]... FILE...
  or:  chmod [OPTION]... OCTAL-MODE FILE...
  or:  chmod [OPTION]... --reference=RFILE FILE...
Change the mode of each FILE to MODE.
```

Let's try to change the permission on the README.md file we downloaded (`wget https://raw.githubusercontent.com/cybergis/intro-to-keeling/main/README.md` if you don't have it anymore). First, let's see what permissions are:

```
> ls -l README.md

-rw-r--r-- 1 michels9 cigi-algosys-group 10756 Apr 25 10:26 README.md
```

Now, let's change it read, write, and execute for everyone (777):

```
> chmod 777 README.md
```

To check that it worked, you can run the ls command again:

```
> ls -l README.md

-rwxrwxrwx 1 michels9 cigi-algosys-group 10756 Apr 25 10:26 README.md
```

For change permissions for a directory recursively (apply the permissions to everything in the directory) you need to use the `-R` flag. Be very careful when doing this!! Let's make a simple directory with a file inside to test this:

```
> mkdir test
> echo "hello" > test/text.txt
```

This makes a directory called test and creates a file named "text.txt" that says "hello" in the directory. Use `ls` and `cat` to investigate and verify this.

If you use `chmod` on the folder, it only changes the folder and not the contents. To see this run:

```
> chmod 777 test
```

Then use `ls -l` to verify that the folder `test` has changed and `ls -l test/*` to see that `test/text.txt` is unchanged. To change the folder and contents you need the `-R` flag like so:

```
> chmod -R 755 test
```
Use `ls -l` to verify that both the folder and test.txt have changed!

## Getting Data off Keeling

**Under Construction** TODO

Talk about zip and scp.

<hr id="resources">

7. Run the following command in your terminal. It tells conda to also look on the conda-forge channel when you search for packages. Channels are basically servers for people to host packages on and the community-driven conda-forge is usually a good place to start when packages are not available via the standard channels.

`conda config --append channels conda-forge`

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