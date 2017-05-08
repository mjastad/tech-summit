# Tech Summit - 2017 (Bash Solution)
%% readme.txt
%% ntnx bash-scripts(version 1.0.1 Beta 0514.01)

- Name:         NTNX Bash REST Tool-Kit (NTNX-BaRT) (Bash v3.2, OSX 10.12.4)
- Authors:      M. Jastad (michael.jastad@nutanix.com), Reggie Allen (reggie@nutanux.com)

- Date:         Apr 19, 2017

(1) DEFECTS/FEATURES 
--------------------------
BETA-0408.01
- Defects: added authentication to "config.sh".
- Defects: added ipaddress/port to "config.sh".  

BETA-0414.01  
- Feature: Separated files into "config.sh", "functions.sh", and "main.sh" for easy management. 


(2) INTRODUCTION
-----------------
BaRT is an open-source `VM Management’ resource enabling users to manage NTNX VM elements through RESTful control (allows the flexible use of REST API commands, relative addressing, macros, libraries, and bash programs).

BaRT is a bash-shell program which processes command line instructions which can be processed by 3rd party scripts or consumed directly. Please read the comprehensive manual for details of commands, usage, examples, installation etc.

BaRT will run on most platform(s) having a working Bash v3.2 installation. However, there may of course be minor differences regarding installation and usage between platforms.

BaRT has been tested using Mac OSX, 10.12.4 and BSD/Linux which the author(s) are familiar with. Feedback regarding installation and usage on other platforms will be greatly appreciated, and included in future distributions.


(3) HISTORY
-----------
BaRT is designed for Tech Summit 2017 as a guide for particiapnts to stand-up VM configurations on a Nutanix Cluster. BaRT is implemented in Bash in order to (a) greatly improve its utility, and (b) to make it available to the wide range of platforms which run Bash.

(4) REQUIRED SOFTWARE
-----------------------
- Bash v3.2 (interpreters are available for windows, see https://www.cygwin.com/)
- jq 1.5


(5)INSTALL JQ (OSX)
---------------------
1. Open a terminal window and run the following command:
* _ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null_

2. Wait for the command to finish.
3. When complete, Run:
**_brew install jq_**

4. Done! You can now use jq.


(6) PACKAGE FILES
------------------
The following files are included in the BaRT package.

- config.sh             -- Bash & REST runtime paramters (Access parameters)
- functions.sh          -- Bash reusable functions for REST implementations and invocation.  
- main.sh               -- BaRT main driver 
- README                -- this file


(7) INSTALLATION (Linux, Mac)
--------------------------------
File:
- file: ts-bash.osx-10.12.4.tar 
- file: shell extracted using tar or RAR utilities. No checks for dependencies during install (extraction).

Install steps:
1. Copy file to filesystem folder -- run “tar -xvf bash-script.osx-10.12.4.tar”.
2. Extraction will place files in "bash-scripts" folder.
3. Edit config.h with appropriate ipaddress and port information for connection to the REST endpoint.

Execution(OS X):
1. Insure that *_main.sh_* is executable by running:  *_chmod +x main.sh_*

(8) USAGE/CONFIGURATION 
-----------------------------
Configure (config.sh):

1. Set Host information (IPADDR and PORT) 
2. Set User credentials (USER, PASSWD)
3. Set ISO_CONTAINER_NAME variable with the container name containing the iso images
4. Set the DISK_CONTAINER_NAME variable with the default container used by VM for disk space...
5. Set the OS_IMG_NAME variable with the name of the image to construct the target VM 
6. Set the NGT_IMG_NAME variable with the name of the Nutanix Gust Tools image needed by the target VM 

(9) DIRECTORY STRUCTURE 
--------------------------
The following describes the directory structure for BaRT installation.

- /bash-scripts	        % Executables and configuration files used to control execution.

(10) LICENSE (LPPL):
-----------------------
This program is free software; Project Public License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

-----------------
End of README.txt
-----------------
Contact GitHub API Training Shop Blog About
