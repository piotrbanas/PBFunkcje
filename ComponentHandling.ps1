
Function Get-ComPlusAppState {

    $comAdmin = New-Object -ComObject COMAdmin.COMAdminCatalog
    $appColl = $comAdmin.GetCollection("Applications")
    $appColl.Populate()
    $appCollection = $comAdmin.GetCollection("Applications")
    $appCollection.Populate()
    $appList = @{}
    $appCollection | ForEach-Object {
        $appList.Add($_.Value("ID"), $_.Name)
    }
      
    $appInstances = $ComAdmin.GetCollection("ApplicationInstances")
    $appInstances.Populate()
    $appInstanceList = @{}
    $appInstances | ForEach-Object {
        $appValue = $_.Value("Application")
        $appInstanceList.Add($appValue, $appList[$appValue])
    } 
    $appList.Keys | ForEach-Object {
        New-Object PSObject -Property @{
            "Name"    = $appList[$_]
            "ID"      = $_
            "Running" = $appInstanceList.ContainsKey($_)
        }
    }
    

    [void][Runtime.Interopservices.Marshal]::ReleaseComObject($comAdmin)
    
}#end function

Function Remove-ComPlusApp {
    <#
  .SYNOPSIS
  Short description
  
  .DESCRIPTION
  Long description
  
  .PARAMETER comName
  Parameter description
  
  .EXAMPLE
  An example
  
  .NOTES
  General notes
  #>
    [Cmdletbinding()]
    Param (
        [Parameter(ValueFromPipelineByPropertyName = $True, ValueFromPipeline = $True, Mandatory = $True)]
        [string[]]$comName
    )
    BEGIN {
        $comAdmin = New-Object -ComObject COMAdmin.COMAdminCatalog
        $appColl = $comAdmin.GetCollection("Applications")
        $appColl.Populate()
    }
    PROCESS {
        $index = 0
        foreach ($app in $appColl) {
            if ($app.Name -eq $comName) {
                try {
                    $appColl.Remove($index)
                    $stat = $appColl.SaveChanges()
                    Write-Host("Com+ App Removed: $stat")
                }
                catch {
                    $_
                }
            }
            $index++
        }
    }#end process
    END {
        [void][Runtime.Interopservices.Marshal]::ReleaseComObject($comAdmin)
    }
}#end function

Function New-ComPlusApp {
  [Cmdletbinding()]
  Param (
      [Parameter(Mandatory = $True)]
      [string]$comName,
      [string]$user,
      [string]$pass,
      [string]$comList
  )

    $comAdmin = New-Object -comobject COMAdmin.COMAdminCatalog
    $apps = $comAdmin.GetCollection(“Applications”)
    $apps.Populate();
    $newComPackageName = $comName

    $appExistCheckApp = $apps | Where-Object {$_.Name -eq $newComPackageName}
    if($appExistCheckApp)
    {
        Write-Host(“This COM+ Application already exists : $newComPackageName”)
    }
    Else
    {
        $newApp1 = $apps.Add()
        $newApp1.Value(“Name”) = $newComPackageName
        $newApp1.Value(“ApplicationAccessChecksEnabled”) = 0

        $newApp1.Value(“Identity”) = $user
        $newApp1.Value(“Password”) = $pass

        $saveChangesResult = $apps.SaveChanges()
        Write-Host(“COM+ App Created : $saveChangesResult”)

        #Add Components
        Write-Host("Adding Components...")
        foreach($com in $comList) 
        {

            if(Test-Path $com)
            {
                try
                {
                    $comAdmin.InstallComponent($comName, $com, $null, $null)
                    Write-Host("$com added to $comName")
                }
                catch
                {
                    $_
                }
            }
            else
            {
                Write-Host("Err: File Not Found")
            }
        }
    }
}

function Get-COMPlusAppDLL {
    
    
      BEGIN {
          $comAdmin = New-Object -ComObject COMAdmin.COMAdminCatalog
          $appColl = $comAdmin.GetCollection("Applications")
          $appColl.Populate()
      }
    
      PROCESS {
      foreach ($application in $appColl)
      {
      
          $components = $appColl.GetCollection("Components",$application.key)
          $components.Populate()
          foreach ($component in $components)
          {
      
              $dllName = $component.Value("DLL")
              $componentName = $component.Name
      
              "Component Name:$componentName"
              "DllName: $dllName`n"
          }
      }
    }
    END {
      [void][Runtime.Interopservices.Marshal]::ReleaseComObject($comAdmin)
    }
    }
    
    Function Stop-ComApp {
        [Cmdletbinding()]
        Param (
            [Parameter(ValueFromPipelineByPropertyName = $True, ValueFromPipeline = $True, Mandatory = $True)]
            [string[]]$comName
        )
        BEGIN {
            $comAdmin = New-Object -ComObject COMAdmin.COMAdminCatalog
    
        }
        PROCESS{
            Foreach ($comapp in $comname) {
                $comAdmin.ShutdownApplication($comapp)
            }
        }
        END {
        [void][Runtime.Interopservices.Marshal]::ReleaseComObject($comAdmin)
    }
    }
    
    Function Start-ComApp {
        [Cmdletbinding()]
        Param (
            [Parameter(ValueFromPipelineByPropertyName = $True, ValueFromPipeline = $True, Mandatory = $True)]
            [string[]]$comName
        )
        BEGIN {
            $comAdmin = New-Object -ComObject COMAdmin.COMAdminCatalog
    
        }
        PROCESS{
            Foreach ($comapp in $comname) {
                $comAdmin.StartApplication($comapp)
            }
        }
        END {
        [void][Runtime.Interopservices.Marshal]::ReleaseComObject($comAdmin)
    }
    
    }