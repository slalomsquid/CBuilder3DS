IF "%1"=="" set /p short=Short name: 
IF "%2"=="" set /p long=Long name: 
IF "%3"=="" set /p author=Author name: 

IF "%short%"=="" set short=Short Name
IF "%long%"=="" set long=Long Names
IF "%author%"=="" set author=Unknown

make
bannertool.exe makebanner -i banner.png -a audio.wav -o banner.bnr
bannertool.exe makesmdh -s "%short%" -l "%long%" -p "%author%" -i icon.png  -o icon.icn
makerom -f cia -o "%short%".cia -DAPP_ENCRYPTED=false -rsf template.rsf -target t -exefslogo -elf homebrew.elf -icon icon.icn -banner banner.bnr
makerom -f cci -o "%short%".3ds -DAPP_ENCRYPTED=true -rsf template.rsf -target t -exefslogo -elf homebrew.elf -icon icon.icn -banner banner.bnr
echo Finished! 3DS and CIA have been built!
pause