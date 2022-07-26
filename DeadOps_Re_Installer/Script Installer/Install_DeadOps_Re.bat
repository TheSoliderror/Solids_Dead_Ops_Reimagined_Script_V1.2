@echo off

xcopy /i /s "%CD%" "%localappdata%\Plutonium\storage\t5\scripts\sp" /y

xcopy /i /s "%CD%" "%localappdata%\Plutonium-staging\storage\t5\scripts\sp" /y

del %localappdata%\Plutonium\storage\t5\scripts\sp\Install_DeadOps_Re.bat

del %localappdata%\Plutonium-staging\storage\t5\scripts\sp\Install_DeadOps_Re.bat

del %localappdata%\Plutonium-staging\storage\t5\scripts\sp\README.txt

del %localappdata%\Plutonium\storage\t5\scripts\sp\README.txt

del %localappdata%\Plutonium-staging\storage\t5\scripts\sp\Install_DeadOps_Re.bat

del %localappdata%\Plutonium\storage\t5\scripts\sp\Install_DeadOps_Re.bat
end
