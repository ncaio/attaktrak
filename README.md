# [- attaktrak -]

# [- introdução -]

# [- INSTALAÇÃO -]

Este é o processo de instalação primitivo para o (nome temporário).  É composto por passos que, em um futuro não tão distante,  serão integrados a um processo simplificado. Atualmente, o projeto usa um repositório temporário para armazenar informações relevantes ao assunto.
Para transformar um RaspberryPi, Laptop, Desktop ou Virtual Machine em um laboratório para prática de Wireless Phishing, os seguintes passos irão te auxiliar. Mas antes disso, é importante que os pré-requisitos sejam respeitados e implementados por você, exigindo alguns conhecimentos prévios em areas como Linux e Wifi, por exemplo.

O guia mental é uma sequência de tarefas que incluem:
- Instalação do SO/OS;
- Pós-instalação;
- Pacotes / dependências;
- Testes de compatibilidade (Meu adaptador Wireless proporciona isso ?);
- Criação das configurações via scripts (hostapd, dhcpd, interfaces ...);
- Teste e Validação.

## HARDWARE

A peça principal da engrenagem é o cartão/adaptador Wireless (USB ou não). Tudo vai depender do seu cenário e de quais equipamentos você tem a disposição. Basicamente, um computador com uma placa Wifi que permita o modo de operação ACCESS POINT(AP) e múltiplos (B)SSIDs. 
P: Como sei se meu adaptador suporta modo AP e múltiplos SSIDs ? 
Bem, existem ‘n’ formas de descobrir isso. Pesquisar sobre o modelo/chipset do equipamento em sites de busca na Internet é uma delas. No entanto, se você tiver em mãos um cartão/adaptador Wireless + (Linux OS), seja ele integrado a placa mãe ou externo, você pode utilizar o script interface.sh para detectar os requisitos.

```sh
bash interface.sh
--------------------------------------
INTERFACE phy#38 is wlan2 with MAC ADDRESS 00:1d:0f:a5:4d:3c - MAC ADDRESS will be: 02:1d:0f:a5:4d:30
Multiple SSIDs: 4
--------------------------------------
INTERFACE phy#0 is wlan0 with MAC ADDRESS e4:a7:a0:51:e0:24 - MAC ADDRESS will be: e2:a7:a0:51:e0:20
Multiple SSIDs: 3
--------------------------------------
```

OBS: Se o seu adaptador suportar 2 ou mais SSIDs, você pode continuar com o processo de instalação. 

## INSTALAÇÃO RASPIAN 9 / RapsberryPi

Os scripts e procedimentos foram homologados no Raspian 9, para ser mais exato: Versão setembro de 2017, R.D.: 2017-09-07, Kernel 4.9. Que pode ser obtido em https://www.raspberrypi.org/downloads/raspbian/ e o procedimento de instalação, em: https://www.raspberrypi.org/documentation/installation/installing-images/README.md

### PACOTES

Os seguintes pacotes são necessários. Além da instalação, é preciso ativar o bind9 no processo de inicialização e retirar o isc-dhcp-server:

```sh
apt-get update
apt-get install isc-dhcp-server hostapd git nginx bind9
update-rc.d bin9 enable
update-rc.d isc-dhcp-server disable
```
Baixando os arquivos deste repositório para /opt/attaktrak

```sh
git clone https://github.com/ncaio/attaktrak.git /opt/attaktrak
```

### INTERFACE WIRELESS E COMPATIBILIDADE

Existe um script de nome interface localizado em /opt/attaktrak/scripts, que é responsável por detectar interfaces Wireless e apresentar uma saída informativa. Três campos são importantes neste momento, o campo 4 (interface), 12 (Mac Address Modificado) e a quantidade de multíplos SSID.

```sh
cd /opt/attaktrak/scripts
```

Executando o script:

```sh
bash interface.sh
--------------------------------------
INTERFACE phy#38 is wlan2 with MAC ADDRESS 00:1d:0f:a5:4d:3c - MAC ADDRESS will be: 02:1d:0f:a5:4d:30
Multiple SSIDs: 4
--------------------------------------
INTERFACE phy#0 is wlan0 with MAC ADDRESS e4:a7:a0:51:e0:24 - MAC ADDRESS will be: e2:a7:a0:51:e0:20
Multiple SSIDs: 3
--------------------------------------
```
Para dar continuidade no processo de instalação, é preciso que você seja capaz de identificar os campos acima citados.

### HOSTAPD

Para a criação de um arquivo de configuração para o hostapd de acordo com a interface escolhida, utiliza-se o script hostapd-gen.sh que também está localizado em /opt/attaktrak/scripts

A sintaxe do comando é:

```sh
bash hostapd-gen.sh interface  macaddressmodificado numerodessids > /etc/hostapd/hostapd.conf
```

Observando a saída do script interface executado anteriormente, teremos como exemplo a criação a partir dos dados da interface wlan0 (phy#0)


```sh
bash hostapd-gen.sh wlan0  e2:a7:a0:51:e0:20 3 > /etc/hostapd/hostapd.conf
```
Informando o caminho do arquivo de configuração do hostadp ao processo de inicialização.

```sh
echo "DAEMON_CONF="/etc/hostapd/hostapd.conf"" >> /etc/default/hostapd
```

Aplicar o patch no /etc/init.d/hostapd

```ssh
patch /etc/init.d/hostapd < /opt/attaktrak/templates/hostapd.patch
```

### NETWORKING

O processo de configuração das interfaces de rede também é realizado por um script em /opt/attaktrak/scripts. O script interface-gen.sh recebe como parâmetros a interface, Mac Address modificado e quantidade de ssids possíveis. Todas essas informações foram obtidas na execução do script interface.sh

```sh
bash interface-gen.sh wlan0  e2:a7:a0:51:e0:20 3 >> /etc/network/interfaces
```

### DHCP SERVER

Também encontrado no /opt/attaktrak/scripts, o gerador de configuração do dhcp server precisa de um único parâmetro, quantidade de SIDDS encontrados na execução do script interface.sh

```sh
bash dhcpd-gen.sh 3 > /etc/dhcp/dhcpd.conf
```
A execução do dhcpd será por último no processo de inicialização, no arquivo rc.local.

```sh
echo “/usr/sbin/dhcpd -cf /etc/dhcp/dhcpd.conf” >> /etc/rc.local
```

Realizar o processo de restart (shutdown -r now)

## INSTALAÇÃO DEBIAN

O procedimento de instalação no Debian é bastante similar ao do RasPian. Esta sessão apresenta apenas as mudanças entre os tópicos de instalação RasPian vs Debian.

### Pacotes
Para a instalação de pacotes no Debian, é preciso modificar o /etc/apt/sources.list e adicionar o repositório de pacotes non-free. Nele estão os drivers proprietário para adaptadores Wireless, por exemplo.

Exemplo de configuração /etc/apt/sources.list:

```
deb http://ftp.de.debian.org/debian stretch main non-free
```

A lista de pacotes a serem instalados, são?

```sh
apt-get update
apt-get install isc-dhcp-server hostapd git nginx bind9 iw net-tools wireless-tools firmware-misc-nonfree
```

Baixando os arquivos deste repositório para /opt/attaktrak

```sh
git clone https://github.com/ncaio/attaktrak.git /opt/attaktrak
```

### DHCP SERVER

A execução do dhcpd será por último no processo de inicialização, no arquivo rc.local. Assim como no processo de instalação no RasPian. Mudando apenas a forma de criação do rc.local

```sh
chmod +x /etc/rc.local
```

Exemplo de rc.local para Debian

```sh
#!/bin/bash
#
# rc.local
#
sleep 5
echo "dhcpd starting"
/usr/sbin/dhcpd -cf /etc/dhcp/dhcpd.conf
```

## INSTALAÇÃO DEBIAN / VIRTUALBOX

Procedimento bastante similar a instalação no Debian descrita neste documento. A principal diferença é o fato do mapeamento USB do seu adaptador Wireless. Esta configuração é bastante simples e deve ser realizada antes do início do processo de configuração. Na aba DEVICES, selecione USB. Identifique e selecione o seu adaptador Wifi na lista.

![](http://8bit.academy/attaktrak/vb-usb.png)
