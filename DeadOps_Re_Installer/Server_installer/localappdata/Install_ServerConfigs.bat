@echo off

xcopy /i /s "%CD%" "%localappdata%\Plutonium\storage\t5" /y

xcopy /i /s "%CD%" "%localappdata%\Plutonium-staging\storage\t5" /y

del %localappdata%\Plutonium\storage\t5\Install_ServerConfigs.bat

del %localappdata%\Plutonium-staging\storage\t5\Install_ServerConfigs.bat

del %localappdata%\Plutonium-staging\storage\t5\Install_ServerConfigs.bat

del %localappdata%\Plutonium\storage\t5\Install_ServerConfigs.bat
end
