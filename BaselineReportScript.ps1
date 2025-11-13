$computerName = $env:COMPUTERNAME
$os = (Get-WmiObject Win32_OperatingSystem).Caption

$freeSpace = (Get-PSDrive C).Free / 1GB
$totalSpace = ((Get-PSDrive C).Used + (Get-PSDrive C).Free) / 1GB

Write-Output "Computer Name: $computerName"
Write-Output "Operating System: $os"
Write-Output ("Free Space (GB): {0:N2}" -f $freeSpace)
Write-Output ("Total Space (GB): {0:N2}" -f $totalSpace)

$reportPath = "$env:USERPROFILE\Desktop\Simple_System_Report.txt"

"Computer Name: $computerName"                 | Out-File $reportPath
"Operating System: $os"                        | Out-File $reportPath -Append
("Free Space (GB): {0:N2}" -f $freeSpace)      | Out-File $reportPath -Append
("Total Space (GB): {0:N2}" -f $totalSpace)    | Out-File $reportPath -Append

Write-Output "Report saved to: $reportPath"
