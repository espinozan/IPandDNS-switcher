

# Win-NetChanger

![PowerShell](https://img.shields.io/badge/PowerShell-7.1-blue) ![Windows](https://img.shields.io/badge/Platform-Windows-blue)

**Win-NetChanger** es un script avanzado de PowerShell que permite cambiar automáticamente la configuración de red de Windows, incluyendo la IP, dirección MAC y DNS en intervalos definidos por el usuario. Este script es ideal para entornos de prueba donde se necesite variar la configuración de red de forma controlada.

## Características

- Cambia automáticamente la IP, DNS y dirección MAC en intervalos personalizados.
- Genera listas aleatorias de direcciones IP y MAC.
- Selecciona DNS de una lista configurable de servidores públicos de alta disponibilidad.
- Guarda un registro detallado de los cambios en un archivo de log.
- Detecta automáticamente la puerta de enlace (gateway) y utiliza esta configuración para las nuevas IPs.
- Validación de privilegios administrativos y manejo de errores robusto.

## Requisitos

- **Windows PowerShell** 5.1 o superior (recomendado PowerShell 7.1+)
- **Permisos de administrador**: el script requiere ser ejecutado con privilegios de administrador para modificar configuraciones de red.

## Instalación

1. Clona este repositorio o descarga el archivo `Win-NetChanger.ps1`:
   ```bash
   git clone https://github.com/espinozan/win-netchanger.git
   ```

2. Asegúrate de que tu PowerShell está configurado para permitir la ejecución de scripts:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. Ejecuta el script con permisos de administrador:
   ```powershell
   .\Win-NetChanger.ps1
   ```

## Uso

El script se puede configurar para cambiar la IP, DNS y MAC automáticamente en intervalos de tiempo personalizados. Los pasos para usar el script son los siguientes:

1. **Definir el Intervalo de Cambio**: Configura el parámetro `$intervalSeconds` para definir el tiempo de espera entre cada cambio de red en segundos. Por ejemplo, para cambiar cada hora, establece `$intervalSeconds = 3600`.

2. **Personalización Opcional**: El script contiene listas predefinidas de IPs, DNS y MACs que se generan automáticamente, pero puedes personalizar la lista de DNS en la variable `$dnsList`.

3. **Ejecutar el Script**: Al iniciar el script, este cambiará la configuración de red en intervalos definidos y registrará cada cambio en un archivo de log llamado `NetworkChangeLog.txt`.

### Ejemplo de Ejecución

Para cambiar la configuración de red cada 30 minutos, ajusta `$intervalSeconds` en el script de la siguiente forma:
```powershell
$intervalSeconds = 1800
```

Luego ejecuta el script con permisos de administrador.

## Variables de Configuración

- **$dnsList**: Lista de servidores DNS públicos de alta disponibilidad que el script utilizará al cambiar la configuración de red.
- **$intervalSeconds**: Tiempo en segundos que el script espera antes de realizar otro cambio en la red.
- **$ipList** y **$macList**: Listas generadas automáticamente de IPs y MACs aleatorias.

## Ejemplo de Código

```powershell
# Lista de servidores DNS
$dnsList = @(
    "8.8.8.8", "8.8.4.4", "1.1.1.1", "1.0.0.1", "9.9.9.9", "149.112.112.112",
    "208.67.222.222", "208.67.220.220", "84.200.69.80", "84.200.70.40"
)

# Configuración del intervalo de tiempo (en segundos)
$intervalSeconds = 3600  # Cambia cada hora
```

## Detalles Técnicos

El script se basa en dos funciones principales:

1. **Set-NetworkConfig**: Cambia la configuración de red, estableciendo una nueva IP, DNS y dirección MAC. Maneja los errores individualmente para cada componente de red.
   
2. **Start-NetworkChanger**: Ejecuta `Set-NetworkConfig` en intervalos regulares definidos por `$intervalSeconds`.

### Log de Cambios

Cada vez que se realiza un cambio de configuración, el script registra la operación en un archivo `NetworkChangeLog.txt`, que incluye la fecha, hora, IP, DNS y MAC asignados. Esto permite una trazabilidad completa de las modificaciones realizadas.

## Ejemplo de Log

```plaintext
[2023-10-28 12:00:00] IP: 192.168.1.50, DNS: 8.8.8.8, MAC: 02-15-3F-4B-7A-CE
[2023-10-28 13:00:00] IP: 192.168.1.87, DNS: 1.1.1.1, MAC: 02-42-6C-8A-92-BF
```

## Advertencias y Limitaciones

1. **Dirección MAC**: Cambiar la dirección MAC es una operación sensible y puede que no funcione en todos los adaptadores de red. Si tienes problemas con el cambio de MAC, asegúrate de que tu adaptador permite cambios de dirección MAC.
2. **Conexión de Red**: Cambiar la IP y MAC repetidamente puede afectar la conectividad de red. Usa el script con precaución en entornos críticos.
3. **Pruebas Recomendadas**: Realiza pruebas en un entorno controlado antes de implementar el script en una red de producción.

## Contribuciones

Las contribuciones son bienvenidas. Si encuentras algún problema o tienes una sugerencia de mejora, por favor abre un **Issue** o crea un **Pull Request**.

## Licencia

Este proyecto está licenciado bajo la **MIT License**. Puedes ver más detalles en el archivo `LICENSE`.

## Autor

Este proyecto fue desarrollado por [espinozan](https://github.com/espinozan).

## Contacto

Para cualquier duda o sugerencia, puedes contactarme en [GitHub](https://github.com/espinozan).

---
