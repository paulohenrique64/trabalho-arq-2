.data
enunciadoExercicio: .asciiz "Exercicio 7 - Dado um natural n, determine o número harmônico Hn"
pedirNumeroNatural: .asciiz "Digite o número natural: " 
quebraDeLinha: .asciiz "\n\n"
mensagemResultado: .asciiz "O número harmônico é: "
numero0Double: .double 0.0
numero1Double: .double 1.0
	
.text
	l.d $f0, numero1Double
	l.d $f2, numero1Double 
	l.d $f4, numero0Double # reg $f4 guarda o somatorio harmonico (double)
	
	li $t1, 0 # reg $t1 guarda o contador de controle do loop (int)
	
	# imprimindo mensagem 
	li $v0, 4
	la $a0, enunciadoExercicio
	syscall
	
	# imprimindo quebra de linha 
	la $a0, quebraDeLinha
	syscall
	
	# imprimindo mensagem 
	la $a0, pedirNumeroNatural
	syscall
	
	# lendo numero natural da entrada padrao
	li $v0, 5
	syscall

	# reg $t2 agora guarda o numero natural lido da entrada padrao
	move $t2, $v0
	
	# loop "while" que realiza a sequencia de somas e divisoes para gerar o numero harmonico
	while:
		bge $t1, $t2, imprimirResultado 
		
		# 1 / 1, prox interacao 1 / 2, prox interacao 1 / 3 ...
		div.d $f6, $f0, $f2 # $f6 = 1.0 / f2
		add.d $f2, $f2, $f0 # $f2 = f2 + 1.0
		
		# somando o resultado de 1 / x ao somatorio
		add.d $f4, $f4, $f6 # $f4 = f4 + f6
		
		# atualizando o indice de controle do loop while
		addi $t1, $t1, 1 # $t1 = $t1 + 1
		
		j while
		
	# saida do loop "while"
	imprimirResultado:
		# imprimindo mensagem 
		li $v0, 4
		la $a0, mensagemResultado
		syscall
		
		# imprimindo o resultado 
		li $v0, 3
		mov.d $f12, $f4
		syscall
	
			
	# terminando o programa
	li $v0, 10
	syscall
