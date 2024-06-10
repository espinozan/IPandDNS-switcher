# IPandDNS-switcher
IPandDNS-switcher es un script en Batch que permite cambiar la configuración de la dirección IP y los servidores DNS en sistemas Windows. Con esta herramienta, puedes alternar entre configuraciones manuales y DHCP, así como establecer la frecuencia de tiempo de cambio de IP según tus necesidades.


# IPandDNS-switcher

## Descripción

IPandDNS-switcher es un script en Batch diseñado para sistemas Windows que facilita el cambio de configuración de dirección IP y servidores DNS. Este script permite al usuario elegir entre configurar la dirección IP manualmente o utilizar DHCP. Además, proporciona la opción de establecer una frecuencia de cambio de IP, permitiendo una gestión flexible de la red.

## Cómo Funciona

El script consta de dos funciones principales:

1. **Cambio de Configuración de IP y DNS**: Esta función permite al usuario elegir entre configurar la dirección IP manualmente o utilizar DHCP. En caso de elegir configuración manual, se solicitan la dirección IP, máscara de subred, puerta de enlace y servidores DNS. Luego, se aplican los cambios utilizando los comandos `netsh` de Windows.

2. **Configuración de la Frecuencia de Cambio de IP**: Esta función permite al usuario elegir si desea configurar una frecuencia de cambio de IP. En caso afirmativo, se ofrece una serie de opciones predefinidas de frecuencia (como cada 5 minutos, cada 10 minutos, etc.), así como la posibilidad de ingresar una frecuencia personalizada en minutos. El script utiliza el comando `timeout` de Windows para esperar el tiempo especificado antes de ejecutar nuevamente la función de cambio de IP.

## Cómo Usar

1. **Clonar el Repositorio**: Clona este repositorio en tu máquina local utilizando el siguiente comando:

   ```bash
   git clone https://github.com/espinozan/IPandDNS-switcher.git
