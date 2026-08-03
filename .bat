@echo off
:: Define the repository URL and the target subfolder name
set "Git_REPO=https://github.com/247i/Git"
set "Git_FOLDER="

:: Clone the repository into the specified subfolder
git clone %Git_REPO% %Git_FOLDER%


:: Define the repository URL and the target subfolder name
set "WinMerge_REPO=https://github.com/247i/WinMerge.git"
set "WinMerge_FOLDER="

:: Clone the repository into the specified subfolder
git clone %WinMerge_REPO% %WinMerge_FOLDER%


:: Get the VSCode portable into vscode folder manually
:: Get the VSCodium portable into vscodium folder manually
pause
