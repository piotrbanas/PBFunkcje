
function get-wmiUrz {
<#
.Synopsis
   Pobieranie informacji o urządzeniach, np. wagach.
.DESCRIPTION
   Funkcja odpytuje urządzenia przez WMI.
.PARAMETER computername
   Jeden lub więcej Hostname lub IP odpytywanej maszyny
.PARAMETER credential
   Poświadczenia
.PARAMETER soft
   Możemy odpytać urządzenie o zainstalowane oprogramowanie.
.EXAMPLE
   get-wmiUrz -computername ***REMOVED***.162.62 -credential Administrator
.EXAMPLE
   get-wmiUrz -computername (Get-content .\ListaIP.txt) -credential Administrator -soft 'Mettler Toledo' | ConvertTo-Csv -NoTypeInformation > .\wagi.csv
.EXAMPLE 
   get-wmiUrz -computername ***REMOVED***.162.62 -credential Administrator -soft "*" | select -ExpandProperty Oprogramowanie
#>
param(
        [parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   ValueFromPipelineByPropertyName=$True,
                   HelpMessage="Nazwa kompa.")]
        [Alias('Hostname','cn')]
        [string[]]$computername,
        [System.Management.Automation.CredentialAttribute()]$credential,
        [string]$soft = '*'
    )
    BEGIN {}

    PROCESS {
    foreach ($computer in $computername) {
        try {

            $os = Get-WmiObject -ComputerName $computer -ClassName win32_operatingsystem -ErrorAction Stop -Credential $credential
            $cs = Get-WmiObject -ComputerName $computer -ClassName win32_computersystem -ErrorAction Stop -Credential $credential
            $bs = Get-WmiObject -ComputerName $computer -ClassName win32_bios -ErrorAction Stop -Credential $credential
            $so = Get-WmiObject -ComputerName $computer -ClassName win32_Product -ErrorAction Stop -Credential $credential | where Name -like "$Soft"
            $ping = Test-Connection -ComputerName $computer -Count 1

            $properties = [ordered]@{Host = $computer
                            Nazwa = $os.CSName
                            Status = $cs.Status
                            'Ping[ms]' = $ping.ResponseTime
                            Organizacja = $os.Organization
                            NazwaOS = $os.Caption
                            WersjaOS = $os.Version
                            ServicePack = $os.CSDVersion
                            DataInstOS = [Management.ManagementDateTimeConverter]::ToDateTime($os.InstallDate)
                            Producent = $cs.Manufacturer
                            Model = $cs.Model
                            BIOS = $bs.Name
                            ProducentBIOS = $bs.Mnufacturer
                            Architektura = $cs.SystemType
                            Oprogramowanie = $so.Name
                            Boot = [Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
                            Domain = $cs.Domain
                            Rdzenie = $cs.NumberOfProcessors
                            'RAM[MB]' = $os.TotalVisibleMemorySize/1kb
                            'FreeRAM[MB]' = $os.FreePhysicalMemory/1kb
                            'FreeSpaceInPagingFiles[MB]' = $os.FreeSpaceInPagingFiles/1kb
                            }
   
        } catch {
   
            $properties = @{Host = $computer
                            Status = 'Brak odpowiedzi'
                            'Ping[ms]' = $ping.ResponseTime
                            }
        } finally {               
   
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
        }
        }
    }
    END {}
    }