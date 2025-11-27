# Autodesk 3ds Max 2026 conda build recipe

## Creating an archive file for Windows

The Windows installer requires Administrator permissions that are not available in most conda package
build environments, such as on Deadline Cloud service-managed fleets. Follow these instructions to
install 3ds Max 2026 on a freshly created EC2 instance as Administrator, and create an archive file
for use by the conda build recipe.

1. Launch a fresh Windows Server 2022 instance.
   1. From the AWS EC2 management console, select the option to Launch instance.
   2. Enter instance name "Create Windows 3ds Max archive".
   3. Select "Microsoft Windows Server 2022 Base" for the AMI.
   4. Select an instance type with enough vCPUs and RAM, for example c5.4xlarge has 8 vCPUs and 16 GiB RAM.
   5. Select "Proceed without a key pair" for the "Key pair (login)" option.
   6. We will use SSM port forwarding to avoid sending RDP protocol traffic directly over the internet.
      1. Make sure that "Allow RDP traffic" is unchecked.
      2. Make sure the security group does not allow any inbound traffic.
      3. Make sure to remove any public IP addresses from the instance.
   7. Set the storage to at least 64 GiB. Adjust other settings as you like, e.g. if you want an encrypted volume of type gp3.
   8. Select "Launch instance."
   9. If it asks, select "Proceed without key pair" and proceed with the launch.
   10. Once it launched, navigate to the instance detail page. Select "Connect," and with "Session manager" selected, again select "Connect."
       If it says "SSM Agent is not online," you may have to wait a few minutes for it to initialize.
   11. Create a secure password for the Administrator account. From the Administrator PowerShell window that session manager,
       enter the following command with your secure password substituted to change the password.
       1. `net user Administrator MY_SECURE_PASSWORD`
2. Connect to the instance with SSM port forwarding and RDP.
   1. Install or update the AWS CLI v2 from https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html.
   2. Install or update the Session Manager plugin from https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html.
   3. Run the following command, using AWS credentials that have suitable permissions, to start the SSM port forwarding. Replace INSTANCE_ID with the one you launched.
      1. `aws ssm start-session --document-name AWS-StartPortForwardingSession --parameters "localPortNumber=33389,portNumber=3389" --target INSTANCE_ID`
   4. Open RDP, and enter the following connection details:
      1. Computer: `localhost:33389`
      2. User name: `Administrator`
   5. Enter the password you set for Administrator after you created the instance. You should now have a remote desktop session to your instance.
3. Install 3ds Max 2026 on the instance.
   1. Download the 3ds Max 2026 installer for Windows from Autodesk (for example via Autodesk Access).
   2. Run the installer on the EC2 instance and complete installation using the default settings.
   3. Optionally install the `deadline-cloud-for-3ds-max` Python package inside 3ds Max if you want the Deadline Cloud integration available on the workstation you use for archiving.
4. From an Administrator PowerShell window, create the archive from the installed files and capture its hash.
   1. `Compress-Archive -Path 'C:\Program Files\Autodesk\3ds Max 2026' -DestinationPath Autodesk_3dsMax_2026_Windows_installation.zip`
   2. `(Get-FileHash -Path "Autodesk_3dsMax_2026_Windows_installation.zip" -Algorithm SHA256).Hash.ToLower()`
5. Upload the zip to your private S3 bucket. You can use a PowerShell command like
   `Write-S3Object -BucketName MY_BUCKET_NAME -Key Autodesk_3dsMax_2026_Windows_installation.zip -File Autodesk_3dsMax_2026_Windows_installation.zip`.
6. Terminate the EC2 instance.
7. Download the zip file to the `conda_recipes/archive_files` directory in your git clone of the
   [deadline-cloud-samples](https://github.com/aws-deadline/deadline-cloud-samples) repository for
   submitting package build jobs, and update the Windows source artifact hash in `meta.yaml`.

The build script installs `pywin32` into 3ds Max's embedded Python to enable automation and sets environment
variables (`ADSK_3DSMAX_*`, plus `3DSMAX_EXECUTABLE` in the Windows activation script) to simplify invoking
`3dsmaxbatch.exe` from Deadline Cloud jobs.
