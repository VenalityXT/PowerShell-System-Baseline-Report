# **PowerShell System Information Report**

[![Windows](https://img.shields.io/badge/OS-Windows%20Server-blue?logo=windows)](https://www.microsoft.com/windows-server)
[![PowerShell](https://img.shields.io/badge/Shell-PowerShell-5391FE?logo=powershell)](https://learn.microsoft.com/powershell/)
[![Automation](https://img.shields.io/badge/Focus-System%20Automation-orange)](https://en.wikipedia.org/wiki/Automation)
[![System Reporting](https://img.shields.io/badge/Module-System%20Reporting-yellow)](https://learn.microsoft.com/powershell/module/microsoft.powershell.management/)
[![Scripting](https://img.shields.io/badge/Skill-Scripting-lightgrey)](https://learn.microsoft.com/powershell/scripting/overview)

---

## **Project Overview**

This project demonstrates how to use PowerShell ISE to build an automated **system information report**.  
The script retrieves details such as the computer name, Windows version, available disk space, and total disk capacity, then exports the results into a clean, readable text file.  

This reflects real-world system administration workflows where documenting system baselines, collecting host information, and organizing output for team use are routine responsibilities.

---

## **Objectives**

1. Retrieve system details using PowerShell cmdlets.  
2. Format output for readability and documentation.  
3. Export the results to a persistent text file.  
4. Use PowerShell ISE to write, run, and debug scripts as an administrator.

---

## **Step 1: Open PowerShell ISE & Create a New Script**

Launch **PowerShell ISE** in Administrator mode to allow access to system-level commands.  
Use the *New Script* button to create a blank `.ps1` file where the report logic will be written.

<img width="904" height="76" alt="image" src="https://github.com/user-attachments/assets/739b4956-4b6f-43cc-af52-b1ad832ee5ba" />

---

## **Step 2: Define System Variables**

The script begins by collecting the computer name and operating system:

```PowerShell
$computerName = $env:COMPUTERNAME
$os = (Get-WmiObject Win32_OperatingSystem).Caption
```

These values provide the basic identity of the system and will be included in the final report.

---

## **Step 3: Calculate Disk Space**

Next, the script retrieves information about the C: drive:

```PowerShell
$freeSpace = (Get-PSDrive C).Free / 1GB
$totalSpace = ((Get-PSDrive C).Used + (Get-PSDrive C).Free) / 1GB
```

Using `/ 1GB` converts the output into gigabytes, making the results more readable.

---

## **Step 4: Output Results to Console**

The script prints each value to the terminal to provide real-time confirmation:

```PowerShell
Write-Output "Computer Name: $computerName"
Write-Output "Operating System: $os"
Write-Output ("Free Space (GB): {0:N2}" -f $freeSpace)
Write-Output ("Total Space (GB): {0:N2}" -f $totalSpace)
```

**Terminal Output:**

<img width="651" height="395" alt="image" src="https://github.com/user-attachments/assets/0ec9063f-45e4-439f-b934-04dd3f380879" />

---

## **Step 5: Save the Report to a Text File**

A file path is created on the Desktop, and the results are written into `Simple_System_Report.txt`:

```PowerShell
$reportPath = "$env:USERPROFILE\Desktop\Simple_System_Report.txt"
"Computer Name: $computerName" | Out-File $reportPath
"Operating System: $os"         | Out-File $reportPath -Append
("Free Space (GB): {0:N2}" -f $freeSpace)  | Out-File $reportPath -Append
("Total Space (GB): {0:N2}" -f $totalSpace) | Out-File $reportPath -Append
```

A final confirmation message is displayed with the saved file path.

---

## **Step 6: Verify Output File**

The script generates a clean, readable system report:

<img width="583" height="146" alt="image" src="https://github.com/user-attachments/assets/1f0f3c37-dd2d-4e6d-91f5-cd2caf036317" />

This confirms that variable assignments, disk calculations, and file export operations executed successfully.

---

## **Summary**

This project demonstrates how PowerShell can automate routine system reporting tasks by collecting host details, formatting output, and exporting results for documentation or auditing.  
By completing this workflow, I gained hands-on experience with PowerShell ISE, cmdlet usage, variable handling, text formatting, and file output creation—all essential skills for Windows system administration.

