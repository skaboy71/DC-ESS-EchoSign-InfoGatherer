del changeWatch_v.ps1 
del changeWatch_v1.ps1
del changeWatch_v2.ps1
del changeWatch_v3.ps1
del changeWatch_v4.ps1

copy changeWatch.ps1 changeWatch_v.ps1
copy changeWatch.ps1 changeWatch_v1.ps1
copy changeWatch.ps1 changeWatch_v2.ps1
copy changeWatch.ps1 changeWatch_v3.ps1
copy changeWatch.ps1 changeWatch_v4.ps1

start powershell.exe -noninteractive -Command "./changeWatch_v.ps1"

PING 1.1.1.1 -n 1 -w 4000 >NUL

start powershell.exe -noninteractive -Command "./changeWatch_v1.ps1"

PING 1.1.1.1 -n 1 -w 4000 >NUL

start powershell.exe -noninteractive -Command "./changeWatch_v2.ps1"

PING 1.1.1.1 -n 1 -w 4000 >NUL

start powershell.exe -noninteractive -Command "./changeWatch_v3.ps1"

PING 1.1.1.1 -n 1 -w 4000 >NUL

start powershell.exe -noninteractive -Command "./changeWatch_v4.ps1"

EXIT