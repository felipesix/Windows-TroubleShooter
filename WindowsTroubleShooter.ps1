﻿Begin {

    Add-Type -AssemblyName PresentationFramework
    $LoadPath = Split-Path -Path $MyInvocation.MyCommand.Definition
    . "$LoadPath\TroubleShooterForm.ps1"
    . "$LoadPath\TroubleShooterFunctions.ps1"
    $Win.Icon = "$LoadPath\Icon.ico"
}

Process {

    $SearchComputer.add_click({        

        Reset-Data

        $ComputerName = $Computer.Text

        If ($ComputerName -ne "") {
        
            If (!(Test-Connection $ComputerName -Quiet -Count 1)) {

                $Message = $ConnectionMessage.Replace('*', $ComputerName)
                [System.Windows.MessageBox]::Show($Message,'Error',$OKButton,$Exclamation)            
            }

            Else {
                
                Try {

                    Get-SysTab $ComputerName

                    $SysEvents = Get-SysEvent $ComputerName
                    $ArrSysEv.AddRange($SysEvents)
                    $SeDG.ItemsSource = @($ArrSysEv)

                    $Events = Get-EventTab $ComputerName
                    $ArrEv.AddRange($Events)
                    $Edg.ItemsSource = @($ArrEv)

                    $Procs = Get-ProcTab $ComputerName
                    $ArrProc.AddRange($Procs)
                    $Pdg.ItemsSource = @($ArrProc)
                    
                    $Message = $SuccessMessage.Replace('*',$ComputerName)
                    [System.Windows.MessageBox]::Show($Message,'Success',$OKButton,$Success)                    
                }

                Catch { [System.Windows.MessageBox]::Show("Failed to grab information from $ComputerName",'Failed',$OKButton,$Exclamation) } 
            }
        }
        
        Else { [System.Windows.MessageBox]::Show($BlankMessage,'Error',$OKButton,$Warning)}
    })
}

End { $Win.ShowDialog() }