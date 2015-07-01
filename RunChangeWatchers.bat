del changeWatch1.ps1
del changeWatch2.ps1
del changeWatch3.ps1
del changeWatch4.ps1

copy changeWatch.ps1 changeWatch1.ps1
copy changeWatch.ps1 changeWatch2.ps1
copy changeWatch.ps1 changeWatch3.ps1
copy changeWatch.ps1 changeWatch4.ps1

start powershell.exe -windowstyle hidden -noninteractive -Command "./changeWatch.ps1"

PING 1.1.1.1 -n 1 -w 4000 >NUL

start powershell.exe -windowstyle hidden -noninteractive -Command "./changeWatch1.ps1"

PING 1.1.1.1 -n 1 -w 4000 >NUL

start powershell.exe -windowstyle hidden -noninteractive -Command "./changeWatch2.ps1"

PING 1.1.1.1 -n 1 -w 4000 >NUL

start powershell.exe -windowstyle hidden -noninteractive -Command "./changeWatch3.ps1"

PING 1.1.1.1 -n 1 -w 4000 >NUL

start powershell.exe -windowstyle hidden -noninteractive -Command "./changeWatch4.ps1"

EXIT