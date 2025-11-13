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

<p align="left">
  <a href="./BaselineReportScript.ps1"><strong>View the Script »</strong></a>
</p>

---

## **Objectives**

1. Retrieve system details using PowerShell cmdlets.  
2. Format output for readability and documentation.  
3. Export the results to a persistent text file.  
4. Use PowerShell ISE to write, run, and debug scripts as an administrator.

---

### **Step 1: Open PowerShell ISE & Prepare the Script Environment**

PowerShell ISE provides a dedicated workspace for writing and testing PowerShell scripts. Running it with administrative privileges ensures the script can access system-level information such as disk properties, OS metadata, and environment variables.

The editor is divided into two main sections:

- **Script Pane** - where the `.ps1` file is written and saved  
- **Console Pane** - where script output is displayed during execution

<img width="903" height="791" alt="S1" src="https://github.com/user-attachments/assets/fe0e3f84-4b93-4ab7-bdc3-aea1aac1ef08" />

This setup makes it easy to draft, test, and refine the script while inspecting objects in real time. It’s especially useful for reporting tasks that rely on cmdlets returning structured data, such as OS details or drive statistics.

---

### **Step 2: Define System Variables**

The script begins by collecting basic system identity details. PowerShell stores information inside **variables**, which always start with a `$` symbol. These variables will later be used to print the system summary and write it to a report file.

#### **Computer Name**
```PowerShell
$computerName = $env:COMPUTERNAME
```

- `$env:` accesses Windows **environment variables** (values provided by the OS).  
- `COMPUTERNAME` holds the hostname of the machine.  
- PowerShell reads it and stores it into `$computerName`.

This gives the script a reliable identifier for the report.

#### **Operating System Name**
```PowerShell
$os = (Get-WmiObject Win32_OperatingSystem).Caption
```

- `Get-WmiObject` queries system information using **Windows Management Instrumentation (WMI)**.  
- `Win32_OperatingSystem` is a WMI class containing details about the installed OS.  
- `.Caption` extracts the human-readable name (e.g., “Microsoft Windows Server 2022 Datacenter”).

PowerShell returns the entire OS object, but using `.Caption` isolates the name we actually need.

> These two variables form the foundation of the report; they describe *what system* is being evaluated before gathering performance or storage details.

---

### **Step 3: Calculate Disk Space**

The next part of the script retrieves storage information from the system’s primary drive. PowerShell represents drives as **objects**, each containing properties such as `Used`, `Free`, and `Name`. By accessing these properties directly, the script can calculate readable disk values for the report.

#### **Free Space on C: Drive**
```PowerShell
$freeSpace = (Get-PSDrive C).Free / 1GB
```

- `Get-PSDrive C` returns the **C: drive object**.  
- `.Free` extracts the remaining space in **bytes**.  
- `/ 1GB` converts bytes into **gigabytes** using PowerShell’s built-in size constants.

PowerShell automatically understands units like `KB`, `MB`, and `GB`, making conversions straightforward.

#### **Total Space on C: Drive**
```PowerShell
$totalSpace = ((Get-PSDrive C).Used + (Get-PSDrive C).Free) / 1GB
```

- `.Used` returns the amount of consumed space (also in bytes).  
- Adding `.Used` + `.Free` produces the **total disk capacity**.  
- Dividing by `1GB` converts the final number into gigabytes.

> These calculations convert raw byte values into human-readable metrics, allowing the final report to show storage usage in a clear, standardized format.

---

### **Step 4: Output Results to Console**

With all system data stored in variables, the next step is to display the results in the PowerShell console.  
PowerShell uses `Write-Output` to print information, making it useful for quick verification before saving the final report.

#### **Console Output Commands**
```PowerShell
Write-Output "Computer Name: $computerName"
Write-Output "Operating System: $os"
Write-Output ("Free Space (GB): {0:N2}" -f $freeSpace)
Write-Output ("Total Space (GB): {0:N2}" -f $totalSpace)
```

#### **How These Lines Work**

- `Write-Output`  
  Sends text into the console pane so you can immediately confirm whether variable values are correct.

- `"Computer Name: $computerName"`  
  This uses **string interpolation**. PowerShell replaces `$computerName` with its actual value.

- `("Free Space (GB): {0:N2}" -f $freeSpace)`  
  This uses a **formatting operator (`-f`)**, which allows more control over numeric output:
  - `{0:N2}` means:  
    - `0` → placeholder for the first argument  
    - `N2` → format as a number with **2 decimal places**  
  - Example output:  
    `Free Space (GB): 27.45`

Using formatting ensures the report is clean, readable, and consistent.

> Displaying results before writing them to a file acts as a verification step; if something looks incorrect, the script can be corrected before generating the final report.

---

### **Step 5: Save the Report to a Text File**

After verifying the output in the console, the script writes the results to a report stored on the Desktop.  
PowerShell uses **file redirection cmdlets** like `Out-File` to save formatted text to disk.

#### **Define Where the Report Will Be Saved**
```PowerShell
$reportPath = "$env:USERPROFILE\Desktop\Simple_System_Report.txt"
```

- `$env:USERPROFILE` retrieves the current user’s profile directory (e.g., `C:\Users\Admin`).  
- `\Desktop\Simple_System_Report.txt` builds the full file path.  
- The final value is stored in `$reportPath`, which all subsequent commands will reference.

This makes the script flexible: it always saves to the correct Desktop, regardless of username.

---

#### **Write Each Line of the Report**
```PowerShell
"Computer Name: $computerName" | Out-File $reportPath
"Operating System: $os"         | Out-File $reportPath -Append
("Free Space (GB): {0:N2}" -f $freeSpace)  | Out-File $reportPath -Append
("Total Space (GB): {0:N2}" -f $totalSpace) | Out-File $reportPath -Append
```

##### **How It Works**

- `"text" | Out-File`  
  Sends the string through the pipeline (`|`) into the output file.

- The first line uses **no `-Append`**, meaning it **creates or overwrites** the file.

- The following lines use `-Append`, meaning:
  - they **add** new lines to the end of the file  
  - the original content remains untouched  

##### **Formatting Expressions Again**
Values like disk space use the same formatting expression from Step 4:
- `{0:N2}` → number with two decimal places  
- `-f` → formatting operator  

This gives the report a clean, consistent structure.

> Saving the output ensures the system information can be referenced later, shared with a team, or stored as part of a

---

### **Step 6: Verify the Output File**

Once the report is generated, reviewing the saved text file confirms that every component of the script executed correctly; variable assignment, disk calculations, formatting expressions, and file output.

The final report includes:

- **Computer Name**  
  Retrieved from the `$env:COMPUTERNAME` environment variable.

- **Operating System**  
  Extracted using WMI from the `Win32_OperatingSystem` class.

- **Free Disk Space (GB)**  
  Calculated by dividing the raw `.Free` byte property by `1GB`.

- **Total Disk Space (GB)**  
  Computed by adding `.Used` + `.Free`, then converting to gigabytes.

<img width="583" height="146" alt="image" src="https://github.com/user-attachments/assets/f782ccf9-3d12-4e06-a63c-3d6d5ad0d4b6" />

#### **What This Confirms**

- All variables were successfully assigned  
- WMI queries returned valid OS information  
- `Get-PSDrive` provided accurate storage metrics  
- Formatting expressions applied correctly  
- `Out-File` wrote and appended all lines in the correct order  
- The file path created with `$reportPath` is valid  

If all four fields appear with no errors and the values match expectations, the script has run exactly as intended.

> This final check ensures the script produces a clean, readable report suitable for documentation, baseline inventory, or system auditing workflows.

---

## **Summary**

Automating system reporting with PowerShell supports efficient collection of host details, storage metrics, and operating system information while producing consistent baseline documentation. The workflow demonstrates practical use of WMI queries, environment variables, object properties, formatting expressions, and file output handling within PowerShell ISE, reflecting core skills in Windows system administration.

---
