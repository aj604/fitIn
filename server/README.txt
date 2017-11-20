
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
******************************************************************************************************
TA's:
To test the server, please double click on "install-build-test.sh" in the same directory as this file.
******************************************************************************************************
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Just in case double clicking fails, you may also open up a terminal, cd to this directory and type in:

bash install-build-test.sh

Which should run the script. The install-build-test.sh script will:
 1. download and install nvm
 2. download and install node and npm
 3. download all necessary dependancies
 4. compile the typescript source to javascript
 5. run a single iteration of the server, to show it is working.
    - you may notice a lot of zeros, that simply indicates that the database is empty, indicating the real database is doing its job.


If you have some experience with node, npm, or nvm, and wish to poke around our server some more,
you need to prefix all commands with "bash ", as a workaround for the permissions on the CSIL macs.
These commands only work in this folder, as they are bash scripts wrapping the true commands.
some examples:

bash nvm install latest
bash npm install
bash npm run build
bash node main.js
