.data
float0:  .float 0.0   # Armazena 0.0
float4:  .float 4.0   # Armazena 4.0

imprime_a: .asciiz "Digite o valor de a: "
imprime_b: .asciiz "Digite o valor de b: "
imprime_c: .asciiz "Digite o valor de c: "
saida_raiz1: .asciiz "A primeira raiz e: "
saida_raiz2: .asciiz "A segunda raiz e: "
delta_negativo: .asciiz "Nao existe raizes reais\n"
quebra_linha: .asciiz "\n"

.text
.globl main

main:
    jal entrada
    jal delta
    jal bhaskara
    jal saida
    jal fim

entrada:
    # Leitura de a, b, c
    li $v0, 4             # printar string
    la $a0, imprime_a
    syscall

    li $v0, 6             # ler float
    syscall
    mov.s $f4, $f0        # $f4 = a

    li $v0, 4
    la $a0, imprime_b
    syscall

    li $v0, 6 
    syscall
    mov.s $f5, $f0        # $f5 = b

    li $v0, 4
    la $a0, imprime_c
    syscall

    li $v0, 6 
    syscall
    mov.s $f6, $f0        # $f6 = c
    
    jr $ra
    
delta:
    # Calcular delta = b² - 4ac
    mul.s $f7, $f5, $f5   # $f7 = b²
    mul.s $f8, $f4, $f6   # $f8 = ac
    l.s   $f0, float4
    mul.s $f8, $f8, $f0   # $f8 = 4ac
    sub.s $f7, $f7, $f8   # $f7 = b² - 4ac
    
    jr $ra
    
bhaskara:
    l.s  $f11, float0
    c.lt.s $f7, $f11    # delta < 0
    bc1t nao_ha_raizes    # Salta para 'nao_ha_raizes'
    
    # Calcular raiz de delta
    sqrt.s $f12, $f7

    # Calcular -b
    neg.s $f13, $f5

    # Calcular 2a
    add.s $f14, $f4, $f4

    # Calcular x1
    add.s $f15, $f13, $f12
    div.s $f15, $f15, $f14  # x1 = (-b + sqrt(delta)) / (2 * a)

    # Calcular x2 
    sub.s $f16, $f13, $f12
    div.s $f16, $f16, $f14  # x2 = (-b - sqrt(delta)) / (2 * a)
    
    jr $ra

saida:
    # Exibir a primeira raiz
    li $v0, 4
    la $a0, saida_raiz1
    syscall

    li $v0, 2
    mov.s $f12, $f15
    syscall

    # Quebra de linha
    li $v0, 4
    la $a0, quebra_linha
    syscall

    # Exibir a segunda raiz
    li $v0, 4
    la $a0, saida_raiz2
    syscall

    li $v0, 2
    mov.s $f12, $f16
    syscall
    
    jr $ra

nao_ha_raizes:
    # Mensagem para caso delta < 0
    li $v0, 4
    la $a0, delta_negativo
    syscall

fim:
    li $v0, 10
    syscall
