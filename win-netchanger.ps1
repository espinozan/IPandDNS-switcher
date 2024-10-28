# Configuración inicial
$dnsList = @(
    "8.8.8.8", "8.8.4.4", "1.1.1.1", "1.0.0.1", "9.9.9.9", "149.112.112.112",
    "208.67.222.222", "208.67.220.220", "84.200.69.80", "84.200.70.40"
)

$networkAdapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.HardwareInterface -eq $true }

if (-not $networkAdapter) {
    Write-Output "No se encontró ningún adaptador de red activo y habilitado para cambiar la configuración."
    exit
}

# Detectar la IP y gateway actuales
$currentIPInfo = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $networkAdapter.Name
$currentGateway = (Get-NetRoute | Where-Object { $_.DestinationPrefix -eq "0.0.0.0/0" }).NextHop

# Generar lista de IPs aleatorias basada en la IP actual
$ipList = @()
for ($i = 1; $i -le 100; $i++) {
    $randomOctet = Get-Random -Minimum 1 -Maximum 254
    $newIP = "$($currentIPInfo.IPAddress.Split('.')[0]).$($currentIPInfo.IPAddress.Split('.')[1]).$($currentIPInfo.IPAddress.Split('.')[2]).$randomOctet"
    
    # Evitar duplicados y la IP actual
    if ($newIP -ne $currentIPInfo.IPAddress -and -not ($ipList -contains $newIP)) {
        $ipList += $newIP
    }
}

# Generar lista de MACs aleatorias (Formato válido para MAC unicast)
$macList = @()
for ($i = 1; $i -le 50; $i++) {
    $mac = ((Get-Random -Minimum 0x02 -Maximum 0xFE).ToString("X2") + "-") + 
           ((1..5 | ForEach-Object { "{0:X2}" -f (Get-Random -Minimum 0 -Maximum 255) }) -join "-")
    $macList += $mac
}

# Función para cambiar IP, MAC y DNS
function Set-NetworkConfig {
    param (
        [string]$ip,
        [string]$dns,
        [string]$mac
    )
    
    try {
        # Cambiar la IP
        Write-Output "Cambiando IP a $ip"
        New-NetIPAddress -InterfaceAlias $networkAdapter.Name -IPAddress $ip -PrefixLength 24 -DefaultGateway $currentGateway -ErrorAction Stop

        # Cambiar DNS
        Write-Output "Cambiando DNS a $dns"
        Set-DnsClientServerAddress -InterfaceAlias $networkAdapter.Name -ServerAddresses $dns -ErrorAction Stop

        # Cambiar MAC
        Write-Output "Intentando cambiar MAC a $mac"
        $networkAdapter | Set-NetAdapterAdvancedProperty -RegistryKeyword "NetworkAddress" -RegistryValue $mac -ErrorAction Stop

        # Guardar log del cambio
        $logEntry = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] IP: $ip, DNS: $dns, MAC: $mac"
        Add-Content -Path "NetworkChangeLog.txt" -Value $logEntry

        Write-Output "Cambio realizado con éxito: $logEntry"
    } catch {
        Write-Output "Error al aplicar configuración: $_"
    }
}

# Función para ejecutar cambios en intervalos
function Start-NetworkChanger {
    param (
        [int]$intervalSeconds
    )
    
    if ($intervalSeconds -lt 60) {
        Write-Output "El intervalo debe ser de al menos 60 segundos para evitar problemas de conectividad."
        return
    }
    
    while ($true) {
        # Selecciona IP, DNS y MAC aleatoriamente de las listas
        $randomIP = Get-Random -InputObject $ipList
        $randomDNS = Get-Random -InputObject $dnsList
        $randomMAC = Get-Random -InputObject $macList

        # Cambia la configuración de red
        Set-NetworkConfig -ip $randomIP -dns $randomDNS -mac $randomMAC

        # Espera el intervalo especificado antes de volver a cambiar la configuración
        Start-Sleep -Seconds $intervalSeconds
    }
}

# Parámetros de usuario
# Cambia estos valores según prefieras (por ejemplo, 3600 para cada hora)
$intervalSeconds = 3600  # Cambia cada hora

# Validación de permisos de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "Este script necesita ejecutarse como Administrador para cambiar configuraciones de red."
    exit
}

# Iniciar el cambiador de red
Start-NetworkChanger -intervalSeconds $intervalSeconds
