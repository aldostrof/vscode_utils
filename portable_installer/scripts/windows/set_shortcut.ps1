# creates a new shortcut in DestinationPath linked to executable given in SourceExe.

param ( [string]$SourceExe, [string]$DestinationPath )
# param ( [string]$SourceExe, [string]$DestinationPath, [string]$ExtensionsFolder )
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($DestinationPath)
$Shortcut.TargetPath = $SourceExe
# $Shortcut.Arguments = "--extensions-dir=`"$ExtensionsFolder`""
$Shortcut.Save()
