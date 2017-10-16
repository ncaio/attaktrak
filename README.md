# [- attaktrak -]

# [- introdução -]

# [- INSTALAÇÃO -]

Este é o processo de instalação primitivo para o RaspCatchPi(nome temporário).  É composto por passos que, em um futuro não tão distante,  serão integrados a um processo simplificado. Um único script de instalação, para ser bem direto. Atualmente o projeto usa um repositório temporário onde já eram armazenadas informações relevantes ao assunto.
	Para transformar um RaspberryPi, Laptop, Desktop ou Virtual Machine em um laboratório para prática de Wireless Phishing, os seguintes passos irão te auxiliar. Mas antes disso, é importante que os pré-requisitos sejam respeitados e implementados por você, exigindo alguns conhecimentos prévios em areas como Linux e Wifi, por exemplo.

O guia mental é uma sequência de tarefas que incluem:
- Instalação do SO/OS;
- Pós-instalação;
- Pacotes / dependências;
- Testes de compatibilidade (Meu adaptador Wireless proporciona isso ?);
- Criação das configurações via scripts (hostapd, dhcpd, interfaces ...);
- Teste e Validação.

## HARDWARE

A peça principal da engrenagem é o cartão adaptador Wireless (USB ou não). Tudo vai depender do seu cenário e de quais equipamentos você tem a disposição. Basicamente um computador com uma placa Wifi que permita o modo de operação ACCESS POINT(AP) e múltiplos (B)SSIDs. Como sei se meu adaptador suporta modo AP e múltiplos SSIDs ? Bem, existem ‘n’ formas de descobrir isso. Pesquisar sobre o modelo/chipset do equipamento em sites de busca na Internet é uma delas. No entanto, se você tiver disponível um cartão, seja ele integrado a placa mãe ou externo, você pode utilizar o script interface.sh para detectar os requisitos.

```sh
# bash interface.sh
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

Os scripts e procedimentos foram realizados e homologados no Raspian 9, para ser mais exato, versão setembro de 2017, R.D.: 2017-09-07, Kernel 4.9. Que pode ser obtido em https://www.raspberrypi.org/downloads/raspbian/ e o procedimento de instalação, em: https://www.raspberrypi.org/documentation/installation/installing-images/README.md

## PACOTES

```sh
# apt-get update
# apt-get install isc-dhcp-server hostapd git nginx bind9
# update-rc.d bin9 enable
# update-rc.d isc-dhcp-server disable
```
```sh
# git clone https://github.com/ncaio/attaktrak.git /opt/attaktrak
# cd /opt/attaktrak/scripts
```
## INTERFACE WIRELESS E COMPATIBILIDADE

```sh
# bash interface.sh
--------------------------------------
INTERFACE phy#38 is wlan2 with MAC ADDRESS 00:1d:0f:a5:4d:3c - MAC ADDRESS will be: 02:1d:0f:a5:4d:30
Multiple SSIDs: 4
--------------------------------------
INTERFACE phy#0 is wlan0 with MAC ADDRESS e4:a7:a0:51:e0:24 - MAC ADDRESS will be: e2:a7:a0:51:e0:20
Multiple SSIDs: 3
--------------------------------------
```

## HOSTAPD
```sh
# bash hostapd-gen.sh wlan0  e2:a7:a0:51:e0:20 3 > /etc/hostapd/hostapd.conf
# echo "DAEMON_CONF="/etc/hostapd/hostapd.conf"" >> /etc/default/hostapd
```

## NETWORKING

```sh
# bash interface-gen.sh wlan0  e2:a7:a0:51:e0:20 3 >> /etc/network/interfaces
```

# DHCP SERVER

```sh
# bash dhcpd-gen.sh 3 > /etc/dhcp/dhcpd.conf
# echo “/usr/sbin/dhcpd -cf /etc/dhcp/dhcpd.conf” >> /etc/rc.local
```

## INSTALAÇÃO DEBIAN

## INSTALAÇÃO DEBIAN / VIRTUALBOX

Procedimento bastante similar a instalação no Debian descrita neste documento. A principal diferença é o fato do mapeamento USB do seu adaptador Wireless. Esta configuração é bastante simples e deve ser realizada antes do início do processo de configuração. Na aba DEVICES, selecione USB. Identifique e selecione o seu adaptador Wifi na lista.

![](http://8bit.academy/attaktrak/vb-usb.png)
