# Installing and Using Anaconda

We will be following the guidance from [mgrover1's keeling-crash-course](https://github.com/mgrover1/keeling-crash-course)

1. From your home directory `cd ~/` you can run the following command to download the miniconda installer:

        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh


    `wget` is a command line utility to to download files.

2. Next, make the file executable (meaning your computer can run it as a script):

        chmod u+x Miniconda3-latest-Linux-x86_64.sh 

3. Now that the file is exectuable, you can run it:

        ./Miniconda3-latest-Linux-x86_64.sh 

    you will need to agree to terms and should be fine with the default values.

4. The installer will alter a file called `~/.bashrc` which runs everytime you login. To reload the file with the changes, you can run:

        source ~/.bashrc

    `source` runs the script in the current shell, meaning any variables or functions will be available in your shell.

    ( If this does not work then just restart your terminal )

5. To check that the installation succeeded, use `conda --version`. Now you can use conda normally.

6. To use your conda environment in a SLURM job, be sure to include the line `source ~/.bashrc` so that conda will be loaded. After that line, you can also activate any environments with `conda activate <environment>`.

7. Run the following command in your terminal. It tells conda to also look on the conda-forge channel when you search for packages. Channels are basically servers for people to host packages on and the community-driven conda-forge is usually a good place to start when packages are not available via the standard channels.

    `conda config --append channels conda-forge`
