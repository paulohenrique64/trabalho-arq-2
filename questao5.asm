.data
	pedirTamanho: .asciiz "Forneça o tamanho dos Vetores X e Y: "
	valoresX: .asciiz "Entre com os valores do vetor X: "
	valoresY: .asciiz "Entre com os valores do vetor Y: "
	resultado: .asciiz "O produto escalar entre os vetores X e Y é: "
	quebraLinha: "\n"
	zero_double: .double 0.0
	
	
.text
.global main
main:
	#imprimir mensagem pedindo o tamanho dos vetores e lendo o tamanho dos vetores
	li $v0, 4
	la $a0, pedirTamanho
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0 # guardando o tamanho dos vetores em $t1
	move $t2, $v0 #guardando tamanho original em $t2 para resetar depois
	
	#Alocar espaço para os dois vetores dinamicamente
	li $v0, 9 #comando para alocar memória dinamicamente
	move $a0, $t1
	mul $a0, $a0, 8 # calcula o tamanho em bytes
	syscall
	move $t3, $v0 # guarda o endereço do vetor X
	move $t4, $t3 #joga o endereço do vetorX para $t4 para usar no loop
	
	#receber elementos do vetor x
	li $v0, 4
	la $a0, valoresX
	syscall
	
	li $v0, 4
	la $a0, quebraLinha
	syscall
	
	
	loop_x:
		beq $t1, $zero, saida1
		li $v0, 7
		syscall
		s.d $f0 0($t4) #armazena no vetor
		addi $t4, $t4, 8 #incrementa a posição do vetor
		subi $t1, $t1, 1
		j loop_x
		
	saida1:
		move $t1, $t2 # reseta o tamanho original do vetor
	
		#Alocar memoria para o vetor y
		li $v0, 9
		move $a0, $t1
		mul $a0, $a0, 8
		syscall
		move $t5, $v0
		move $t6, $t5
	
	
		#receber elementos do vetor y
		li $v0, 4
		la $a0, valoresY
		syscall
	
		li $v0, 4
		la $a0, quebraLinha
		syscall
	
	loop_y:
		beq $t1, $zero, saida2
		li $v0, 7
		syscall
		s.d $f0, 0($t6)
		addi $t6, $t6, 8
		subi $t1, $t1, 1
		j loop_y
	
	
	#reposicionando os ponteiros para o inicio dos vetores
	saida2:
		
		move $t1, $t2
		move $t4, $t3
		move $t6, $t5
		l.d $f8, zero_double #registrador para guardar o produto escalar
	
		
		
	#Loop para iterar os valores 
	loop_produtoEscalar:
		beq $t1, $zero, saida
		l.d $f2, 0($t4)
		l.d $f4, 0($t6)
		mul.d $f6, $f2, $f4
		add.d $f8, $f8, $f6
		addi $t4, $t4, 8 
		addi $t6, $t6, 8
		subi $t1, $t1, 1
		j loop_produtoEscalar
		
	#Imprimir o resultado do produto escalar 	
	saida:
		li $v0, 4
		la $a0, resultado
		syscall
	 	
	 	li $v0, 3
	 	mov.d $f12, $f8
	 	syscall
	 	
	#Terminar o programa
	li $v0, 10
	syscall