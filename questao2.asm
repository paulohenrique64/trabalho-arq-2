.data
double_one:  .double 1.0 
double_zero: .double 0.0
pedirNumeroInteiroPositivo: .asciiz "Digite um número inteiro positivo: "

.text
main:
    # imprimindo mensagem 
    li $v0, 4
    la $a0, pedirNumeroInteiroPositivo
    syscall
	
    # lê n
    li $v0, 5
    syscall
    move $s0, $v0

    # Carrega o valor 0.0 (soma inicial) para o registrador $f0
    la $a0, double_zero
    l.d $f0, 0($a0)

    li $s1, 1           # inicializa o contador com 1

loop:
    bgt $s1, $s0, print   # se i > n, sai do loop e vai imprimir


    # Passo 1: Carrega 1.0 em double precision em $f4
    la $a0, double_one
    l.d $f4, 0($a0) 

    # Passo 2: Armazenar i em double precision em $f6
    mtc1 $s1, $f6
    cvt.d.w $f6, $f6     # converte o valor de $f6 para double precision

    # Passo 3: Calcular (n - i + 1)
    sub $t1, $s0, $s1 
    addi $t1, $t1, 1
    mtc1 $t1, $f8 
    cvt.d.w $f8, $f8     # converte o valor de $f8 para double precision

    # Passo 4: Dividir (1.0 * i) por (n - i + 1)
    div.d $f10, $f6, $f8 

    # Passo 5: Somar o resultado com a soma
    add.d $f0, $f0, $f10

    addi $s1, $s1, 1
    j loop

print:
    li $v0, 3
    mov.d $f12, $f0
    syscall