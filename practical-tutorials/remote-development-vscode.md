# Configuring VS Code for Remote Development

## Installing the Remote Development extension

* Choose the "Extensions" icon on the left sidebar in VS Code 

![](./pics/vscode-starting-screen.png)

* Search for the "Remote Development" extension from Microsoft

![](./pics/search-remote-development-extension.png)

* Click the "Install" button on the extension information page to install

![](./pics/install-remote-development-extension.png)

## Setting up a remote host

* In the "View" menu choose "Command Palette" 

![](./pics/choose-command-palette.png)

* Use the command palette search bar to search for "Remote-SSH: Add New SSH Host..."

![](./pics/add-new-ssh-host.png)

* Enter the info for your VM

![](./pics/ssh-info-for-vm.png)

* Choose the default option (`/Users/username/.ssh/config`) for updating the SSH config file

![](./pics/ssh-config-file.png)

* After completing the above steps you should get a "Host Added" dialog as shown below. You can click the "Connect" button to start a connection to the host (see below)

![](./pics/host-added-dialog.png)


## Connecting to a host you've already created

* From the "View > Command Palette" menu search for "Remote-SSH: Connect to Host..."

![](./pics/connect-to-host.png)

* The first time you login to your VM you will be prompted to choose the platform of the host. For the Duke hosted VMs the appropriate choice is "Linux"

![](./pics/select-platform.png)

* The first time logging in you may also be prompted with the "fingerprint" of the host you're connecting to. This is another security measure and you should accept the default "Continue" option.  However, the host fingerprint should not change subsequently.

![](./pics/accept-fingerprint.png)

* To complete the connection to your VM you will be prompted to enter your password.  You should enter your NetID password here.

![](./pics/enter-password.png)

* Once you've successfully connected to the VM, VS Code will open a new Window.  You should "SSH: yourhostname" in a status bar at the bottom left of the window. You can also open a terminal from the "Terminal > New Terminal" menu item and execute standard unix commands (`ls`, `pwd`, etc.) to confirm you're properly connected.

![](./pics/open-terminal.png)

![](./pics/vscode-with-terminal.png)
