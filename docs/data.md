# Managing Data

We recommend that everything you can put in Github you do put in a repo, but not everything can go in Github repositories. This section goes over getting larger data to Keeling, the basics of data management, and then getting data back from Keeling.

<hr id="data2keeling" />

## Getting Data to Keeling

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

!!! todo

    Use the man page or help text for `ls` to figure out how to output the size of the files in a human-readble format instead of just bytes.

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

!!! todo

    What does `drwxr-xr-x` mean?

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

!!! todo

    Convert these two: `-rwxrwxrwx` and `-rwxr-xr-x`.

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


<hr id="datafromkeeling">

## Getting Data off Keeling

**Under Construction** TODO

Talk about zip and scp.

### Secure Copy (scp)

Before we jump into `scp`, let's look at the syntax for basic `cp`. We will copy a simple file: the README.md you downloaded earlier (redownload if needed). The syntax for `cp` is simple: `cp <thing to copy> <where to copy it>`. You can think of this as `command source destination` which is a pattern many CLIs rely on. Let's copy the README to a different name:

```
> cp README.md hello.md
```

check out the new file and verify that it's a copy.

!!! tip

    One way to verify that a file is the same is to take a hash of it. Many package managers and other tools use this to verify that (1) the files are the ones they are expecting and (2) there was no corruption in transit. You can use the `shasum` command to get the hash for a file. If you run the command on both files and check that the hashes are the same, they are virtually guaranteed to be the same. However, slight changes (a extra blank line or character) will result in a drastically different hash. The syntax is `shasum <file>`.

Secure CoPy (`scp`) works in much the same way as the regular `cp`, but allows us to copy files across machines securely. For this, we will need a terminal on your laptop. The instructions should work for MacOS, Linux, and Windows Subsystem for Linux. If you're on Windows without WSL, you could use [WinSCP](https://winscp.net/eng/index.php).

Let's secure copy our hello.md back to our laptops/desktops:

!!! todo

    First, identify where the file is on keeling. You want the full/absolute path!

<details>
<summary>Answer</summary>

You can do this by going to the folder of the file and running `pwd`. So the full path for the file would be `<output of pwd>+<filename>`. There is also the `realpath` command which can return the full path (including filename).

```
> pwd
/data/keeling/a/michels9
> realpath hello.md 
/data/keeling/a/michels9/hello.md
```
</details>

Now that we have the full path, open your terminal on your laptop and change directories to where ever you want to download the file. 

!!! todo

    The `scp` command follows a similar `command source destination` pattern as `cp`. Can you guess what the `scp` command will be on your laptop? 
    
    **Hint:** you need to specify the location of the computer and the path on that computer. This part looks like an SSH command.

    **Hint 2:** You can use the man page if you need help!

<details>
<summary>Answer</summary>

The `scp` command syntax (run from your laptop) looks like:

```
> scp <username>@keeling.earth.illinois.edu:<full path of file> ./

hello.md                                      100%   21KB 283.1KB/s   00:00
```

Let's break this down: (1) You specifying `<username>@<hostname>` just like if you were to SSH into it. (2) You are specifying the location on your laptop where to put it (i.e. "right here")
</details>

### Copying Folders with scp

Does this work with folders?

!!! todo

    Use the test folder from earlier (or make a new folder with say a file in it) and try to `scp` it back to your laptop. What happens?

<details>
<summary>Answer</summary>
Nope! You should get an error that looks like:

```
scp: /data/keeling/a/michels9/test: not a regular file
```
</details>

So how do we copy folders? Check the man page or read on to find out!

You can copy folders with `scp` using the `-r` flag. This flag means "recursively download everything" so it traverses the file tree. Let's try that again with the `-r` flag:

```
> scp -r <username>@keeling.earth.illinois.edu:<your path to a folder>/ ./

text.txt                                      100%    6     0.2KB/s   00:00 
```

Note that while it doesn't say it downloaded the folder `test` and just says it downloaded the file within it, if you check the location in the file browser, you'll see test.txt within a folder name `test/`.

The other option here is to use `zip`. Remember how many commands use `command source destination`? Zip doesn't care about that and does the opposite because reasons! However, zip also still uses the `-r` flag to deal with folders. To zip the test folder on Keeling, the syntax looks like:

```
> zip -r test.zip test/
  adding: test/ (stored 0%)
  adding: test/text.txt (stored 0%)
```

Now you can copy the zipped file back to your laptop just how you would any regular file! This allows you to compress data and copy it back which can save you lots of time.