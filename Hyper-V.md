## Remote Hyper-V Administration via SSH + PowerShell

One of the biggest milestones in this lab journey was successfully managing the Hyper-V infrastructure remotely using SSH and native PowerShell.

In this stage of the `dubz-fort.corp` environment buildout, the Hyper-V host was configured with OpenSSH Server, allowing secure remote administration directly from a workstation terminal using PuTTY.

The screenshot below captures the moment the Exchange virtual machine (`_EXCH01_`) was powered on remotely through PowerShell over SSH.

### Commands Used

```powershell
Get-VM

Start-VM -Name "_EXCH01_"

Get-VM "_EXCH01_" | Select Name,State,Uptime
```
<img width="1591" height="550" alt="Putty-To-Hyper-V-01" src="https://github.com/user-attachments/assets/f450e517-0e74-4b8c-85c4-53cabbef9291" />
