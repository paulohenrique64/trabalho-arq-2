.data
promptNumAlunos: .asciiz "Informe o numero de alunos: "
promptNota: .asciiz "Informe a nota: "
mediaAluno: .asciiz "Media do aluno: "
mediaTurma: .asciiz "Media da turma: "
numAprovados: .asciiz "Numero de alunos aprovados: "
numReprovados: .asciiz "Numero de alunos reprovados: "
saltaLinha: .asciiz "\n\n"

numAlunos: .word 0
nota: .float 0.0
acumuladoraAluno: .float 0.0
acumuladoraTurma: .float 0.0
aprovados: .word 0
reprovados: .word 0
zero: .float 0.0
tres: .float 3.0
cinco: .float 5.0

.text
.globl main
main:
    # entrada do num de alunos
    li $v0, 4
    la $a0, promptNumAlunos
    syscall
    li $v0, 5
    syscall
    sw $v0, numAlunos
    
    # acumuladoraTurma += 0
    lwc1 $f4, zero
    swc1 $f4, acumuladoraTurma
    
    # aprovados += 0 e reprovados += 0
    li $t0, 0
    sw $t0, aprovados
    sw $t0, reprovados
    
    # i = 0 ($t1)
    li $t1, 0
    
loopExterno:
    # se i >= n, sai do loop
    lw $t2, numAlunos
    bge $t1, $t2, calcMediaTurma
    
    # acumuladoraAluno += 0
    lwc1 $f4, zero
    swc1 $f4, acumuladoraAluno
    
    # j = 0 ($t3)
    li $t3, 0

loopInterno:
    # se j >= 3, sai do loop
    li $t4, 3
    bge $t3, $t4, calcMediaAluno
    
    # entrada da nota
    li $v0, 4
    la $a0, promptNota
    syscall
    li $v0, 6
    syscall
    swc1 $f0, nota
    
    # acumuladoraAluno += nota
    lwc1 $f4, acumuladoraAluno
    lwc1 $f6, nota
    add.s $f4, $f4, $f6
    swc1 $f4, acumuladoraAluno
    
    # j += 1
    addi $t3, $t3, 1
    j loopInterno
    
calcMediaAluno:
    # mediaAluno = acumuladoraAluno / 3.0
    lwc1 $f4, acumuladoraAluno
    lwc1 $f8, tres
    div.s $f4, $f4, $f8
    mov.s $f10, $f4
    
    # acumuladoraTurma += mediaAluno
    lwc1 $f12, acumuladoraTurma
    add.s $f12, $f12, $f10
    swc1 $f12, acumuladoraTurma
    
    # verifica para ver se o aluno foi reprovado ou aprovado
    lwc1 $f14, cinco
    c.lt.s $f10, $f14    
    bc1t alunoReprovado

alunoAprovado:
    # aprovados += 1
    lw $t5, aprovados
    addi $t5, $t5, 1
    sw $t5, aprovados
    j fimVerificacao

alunoReprovado:
    # reprovados += 1
    lw $t6, reprovados
    addi $t6, $t6, 1
    sw $t6, reprovados

fimVerificacao:
    # imprime a média do aluno
    li $v0, 4
    la $a0, mediaAluno
    syscall   
    li $v0, 2
    mov.s $f12, $f10  
    syscall
    
    # salta 1 linha
    li $v0, 4
    la $a0, saltaLinha
    syscall
    
    # i += 1
    addi $t1, $t1, 1
    j loopExterno
    
calcMediaTurma:
    # mediaTurma = acumuladoraTurma / numAlunos
    lwc1 $f12, acumuladoraTurma
    lw $t1, numAlunos
    mtc1 $t1, $f16             # move de um registrador inteiro para um registrador ponto flutuante
    cvt.s.w $f16, $f16         # converte de inteiro para float
    div.s $f12, $f12, $f16
    
    # imprime a média da turma
    li $v0, 4
    la $a0, mediaTurma
    syscall
    li $v0, 2
    mov.s $f12, $f12  
    syscall
    
    # salta 1 linha
    li $v0, 4
    la $a0, saltaLinha
    syscall
    
    # imprime o número de aprovados
    li $v0, 4
    la $a0, numAprovados
    syscall
    li $v0, 1
    lw $a0, aprovados
    syscall
    
    # salta 1 linha
    li $v0, 4
    la $a0, saltaLinha
    syscall
    
    # imprime o número de reprovados
    li $v0, 4
    la $a0, numReprovados
    syscall
    li $v0, 1
    lw $a0, reprovados
    syscall
    
    # termina o programa
    li $v0, 10
    syscall
    

