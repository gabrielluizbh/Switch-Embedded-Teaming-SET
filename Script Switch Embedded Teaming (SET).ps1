## Script Switch Embedded Teaming (SET)  - Créditos Gabriel Luiz - www.gabrielluiz.com ##


# Verfica todos os adaptadores de rede disponíveis.

Get-NetAdapter


# Você deve criar uma equipe SET ao mesmo tempo em que você cria o Switch Virtual Hyper-V com o comando New-VMSwitch no Powershell.

# Ao criar o Switch Virtual Hyper-V, você deve incluir o novo parâmetro EnableEmbeddedTeaming na sintaxe de comando.



# No exemplo a seguir, um switch virtual Hyper-V chamado SETteam com dois adaptadores de redes será criado.

New-VMSwitch -Name SETteam -NetAdapterName “Ethernet”,”Ethernet 2” -EnableEmbeddedTeaming $true


# No exemplo a seguir um switch virtual Hyper-V chamado SETteam com apenas um adaptador de rede será criado. Ideal quando se tem apenas uma adaptador de rede, mas deseja adicionar outro futuramente.

New-VMSwitch -Name SETteam -NetAdapterName “Ethernet”  -EnableEmbeddedTeaming $true


# O comando Set-VMSwitchTeam inclui a opção NetAdapterName. Para alterar os membros da equipe em uma equipe SET, digite a lista desejada de adapatadores de redes de membros da equipe após a opção NetAdapterName.

# Se o SETteam foi originalmente criado com Ethernet 1 e Ethernet 2, então o comando de exemplo a seguir exclui o membro da equipe SET "Ethernet 2" e adiciona o novo membro da equipe SET "Ethernet 3".


Set-VMSwitchTeam -Name "SETteam" -NetAdapterName "Ethernet", “Ethernet 3”


# No exemplo a seguir, um switch virtual Hyper-V chamado SETteam com dois adaptadores de redes será criado e com a observações "Rede de máquinas virtuais".

New-VMSwitch -Name SETteam -NetAdapterName “Ethernet”,”Ethernet 2” -EnableEmbeddedTeaming $true -Notes "Rede de máquinas virtuais"


# No exemplo a seguir, um switch virtual Hyper-V chamado SETteam com dois adaptadores de redes será criado com a virtualização E/S de Raiz Única habilitada (SR-IOV) no switch virtual a ser criado.

New-VMSwitch -Name SETteam -NetAdapterName “Ethernet”,”Ethernet 2” -EnableEmbeddedTeaming $true -EnableIov $true


# No exemplo a seguir, um switch virtual Hyper-V chamado SETteam com dois adaptadores de redes será criado utilizando a especificação a descrição da interface do adaptador de rede a ser vinculado ao switch a ser criado.
# Você pode usar o cmdlet Get-NetAdapter para obter a descrição da interface de um adaptador de rede.

New-VMSwitch -Name SETteam -NetAdapterInterfaceDescription "Microsoft Hyper-V Network Adapter", "Microsoft Hyper-V Network Adapter #2"  -EnableEmbeddedTeaming $true


# O exemplo a seguir remove um Switch Virtual chamado SETteam.

Remove-VMSwitch SETteam


# Alterando o algoritmo de distribuição de carga para uma equipe SET.


# O cmdlet Set-VMSwitchTeam tem uma opção LoadBalancingAlgorithm. Esta opção leva um dos dois valores possíveis: HyperVPort ou Dynamic. 

# Para definir ou alterar o algoritmo de distribuição de carga para uma equipe incorporada ao switch, use esta opção.



# No exemplo a seguir, o VMSwitch chamado SETteam usa o algoritmo de balanceamento de carga Dinâmico (Dynamic).

Set-VMSwitchTeam -Name "SETteam" -LoadBalancingAlgorithm Dynamic


# O exemplo a seguir alterar o algoritmo de balanceamento de carga para HyperVPort.

Set-VMSwitchTeam -Name "SETteam" -LoadBalancingAlgorithm HyperVPort


# O exemplo a seguir obter informações do switch virtual Hyper-V chamado SETteam.

Get-VMSwitchTeam -Name "SETteam" | fl


<#

Referências:

https://docs.microsoft.com/en-us/previous-versions/windows/server/mt403349(v=ws.12)?WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/netadapter/get-netadapter?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/new-vmswitch?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/get-vmswitchteam?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815

https://docs.microsoft.com/en-us/powershell/module/hyper-v/remove-vmswitch?view=windowsserver2022-ps&WT.mc_id=WDIT-MVP-5003815


#>
