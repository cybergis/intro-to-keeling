# SSH and Terminal Basics

<hr id="ssh">

## Accessing Keeling Through SSH

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

!!! tip

    It can be very convenient to setup config scripts for your SSH which allow you to assign labels to user/hostname pairs and specify other options like algorithms and ports. For example, I have a config:

        Host    keeling
                Hostname keeling.earth.illinois.edu
                Port 22
                User <username>
    
    which allows me to quickly and easily ssh into keeling with the command `ssh keeling`.

!!! tip

    You can also setup passwordless SSH so that you don't have to type the password everytime you want to access a computer. 

    * For Linux (and MacOS?) [instructions can be found here](https://linuxize.com/post/how-to-setup-passwordless-ssh-login/).
    * [These instructions may work for Windows](https://codefaq.org/server/how-to-ssh-login-without-password-on-windows-10/).


<hr id="terminal">

## Intro to the Terminal


Once connected to Keeling, you should be at your home directory. 

1. To Print the Working Directory, you can use `pwd`. You should see `/data/keeling/a/<YOUR NETID>`. 
2. To see what you have at your home directory, you can use `ls`.
3. The CyberGIS Center has a shared directory at `/data/cigi/common/`. To Change Directories use `cd`. Try `cd /data/cigi/common` and then list (`ls`) to see what's there.
4. To return to your home directory, you can always use `cd ~/`. `~/` is a shortcut for your home.
5. We also have a "scratch" directory (`/data/cigi/scratch`) which is a temporary working directory. Note that any data stored here may be lost or deleted without warning. To see what's there we can use `ls /data/cigi/scratch`.

<hr />

## Cloning this Repo

Now, let's pull this Github repository to Keeling. First, we will configure git so they know who we are:

```
git config --global user.name "<YOUR GITHUB USERNAME>"
git config --global user.email <YOUR GITHUB EMAIL>
```

Next, you can clone a repository with the following syntax:

```
git clone <REPOSITORY LINK>
```
