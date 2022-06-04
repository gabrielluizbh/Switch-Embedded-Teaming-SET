## Script Switch Embedded Teaming (SET) - Simulação de um cenário real de uso do SET em Cluster de Failover - NÓ2 - Créditos Gabriel Luiz - www.gabrielluiz.com ##


# Verfica todos os adaptadores de rede disponíveis.

Get-NetAdapter

# No exemplo a seguir, um switch virtual Hyper-V chamado SETteam com quatro adaptadores de redes será criado.

New-VMSwitch -Name SETteam -NetAdapterName "Ethernet","Ethernet 2","Ethernet 3","Ethernet 4" -EnableEmbeddedTeaming $true -MinimumBandwidthMode Weight


# No exemplo a seguir verificamos a criação do switch virtual Hyper-V chamado SETteam.


Get-VMSwitch


# O exemplo a seguir obter informações do switch virtual Hyper-V chamado SETteam.

Get-VMSwitchTeam -Name "SETteam" | fl


# No exemplo a seguir, o VMSwitch chamado SETteam usa o algoritmo de balanceamento de carga Dinâmico (Dynamic).

Set-VMSwitchTeam -Name "SETteam" -LoadBalancingAlgorithm Dynamic


# Nos exemplos a seguir, criamos as redes e adiconamos ao VMSwitch chamado SETteam. Redes essas que serão utilizada pelo Cluster de Failover.

Get-VMNetworkAdapter -SwitchName "SETteam" -ManagementOS | Rename-VMNetworkAdapter -NewName "Tráfego da VM"

Add-VMNetworkAdapter -ManagementOS -SwitchName "SETteam" -Name "Migração ao vivo"

Add-VMNetworkAdapter -ManagementOS -SwitchName "SETteam" -Name "Gerenciamento-Cluster"


# Nos exemplos a seguir, definimos o peso que cada rede.

Get-VMNetworkAdapter -Name "Tráfego da VM" -ManagementOS | Set-VMNetworkAdapter -MinimumBandwidthWeight 50
Get-VMNetworkAdapter -Name "Migração ao vivo" -ManagementOS | Set-VMNetworkAdapter -MinimumBandwidthWeight 40
Get-VMNetworkAdapter -Name "Gerenciamento-Cluster" -ManagementOS | Set-VMNetworkAdapter -MinimumBandwidthWeight 10


# Recebe os adaptadores de rede virtual do sistema operacional de gerenciamento (ou seja, o sistema operacional de host de máquina virtual.)

Get-VMNetworkAdapter -ManagementOS

# Neste exemplos abaixo, você também pode configurar VLANs para utilização de cada rede.


Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "Tráfego da VM" -Access -VlanId 10

Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "Migração ao vivo" -Access -VlanId 40

Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "Gerenciamento-Cluster" -Access -VlanId 10


# Neste exemplo abaixo, verifica todas as VLANs atribuidas.

Get-VMNetworkAdapterVlan -ManagementOS


# Neste exemplos abaixo, você também pode definir força a anfinidade de uma adaptadores de rede virtual a uma adaptadores de rede físico.

Set-VMNetworkAdapterTeamMapping -VMNetworkAdapterName "Tráfego da VM" -PhysicalNetAdapterName "Ethernet” -SwitchName SETteam -ManagementOS | Out-Null

Set-VMNetworkAdapterTeamMapping -VMNetworkAdapterName "Migração ao vivo" -PhysicalNetAdapterName "Ethernet 2” -SwitchName SETteam -ManagementOS | Out-Null

Set-VMNetworkAdapterTeamMapping -VMNetworkAdapterName "Migração ao vivo" -PhysicalNetAdapterName "Ethernet 3” -SwitchName SETteam -ManagementOS | Out-Null

Set-VMNetworkAdapterTeamMapping -VMNetworkAdapterName "Gerenciamento-Cluster" -PhysicalNetAdapterName "Ethernet 4” -SwitchName SETteam -ManagementOS | Out-Null


# Neste exemplos abaixo, inserimos os IPs, Máscara de rede, DNS e Gateway nos adaptadores de rede virtual.


New-NetIPAddress -InterfaceAlias "vEthernet (Gerenciamento-Cluster)" -IPAddress 10.61.55.62 -PrefixLength 24 -Type Unicast | Out-Null

New-NetIPAddress -InterfaceAlias "vEthernet (Tráfego da VM)" -IPAddress 10.101.0.62 -PrefixLength 24 -Type Unicast -DefaultGateway 10.101.0.200 | Out-Null

Set-DnsClientServerAddress -InterfaceAlias "vEthernet (Tráfego da VM)" -ServerAddresses 10.101.0.100, 10.101.1.100 | Out-Null

New-NetIPAddress -InterfaceAlias "vEthernet (Migração ao vivo)" -IPAddress 10.60.55.62 -PrefixLength 24 -Type Unicast | Out-Null


# Neste exemplos abaixo, desabilita o IPV6 nos adaptadores de rede virtual.


Disable-NetAdapterBinding -Name "vEthernet (Migração ao vivo)" -ComponentID ms_tcpip6 -PassThru
Disable-NetAdapterBinding -Name "vEthernet (Tráfego da VM)" -ComponentID ms_tcpip6 -PassThru
Disable-NetAdapterBinding -Name "vEthernet (Gerenciamento-Cluster)" -ComponentID ms_tcpip6 -PassThru

# Neste exemplo abaixo remover o SET.

Remove-VMSwitch SETteam


<#

Referências:

https://docs.microsoft.com/en-us/previous-versions/windows/server/mt403349(v=ws.12)?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/netadapter/get-netadapter?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/new-vmswitch?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/get-vmswitch?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/get-vmswitchteam?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/set-vmswitchteam?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/get-vmnetworkadapter?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/rename-vmnetworkadapter?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/add-vmnetworkadapter?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/set-vmnetworkadapter?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/set-vmnetworkadaptervlan?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/get-vmnetworkadaptervlan?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/set-vmnetworkadapterteammapping?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/nettcpip/new-netipaddress?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/dnsclient/set-dnsclientserveraddress?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/netadapter/disable-netadapterbinding?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/remove-vmswitch?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

#>