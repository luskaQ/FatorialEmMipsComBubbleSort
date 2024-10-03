#Feito por Lucas Polidorio, Giulia Mezaroba e Marcos França
.data
	newLine: .asciiz "\n"

.text
	j main
	
	factorial:
		li $s1, 1
		li $s2, 0
		for:
		beq $s2, $s0, continue
			mul $s3, $s1, $s2
			add $s1, $s1, $s3
			addi $s2, $s2, 1
		j for
		continue:
			jr $ra
			
	bubbleSort:
		move $t2, $sp # $t2 recebe o topo da minha pilha
		li $t1, 1 # j = 1 -> vai rodar até eu ter certeza que todos os números foram comparados
		loopTillNoChanges:
			beq $t1, $t0, endBubbleSort # se analisou todos os números
			
			loopComparation:
				
				lw $t3, 0($t2) # valor do topo
				lw $t4, 4($t2) # segundo valor do topo: como se fosse i + 1
				ble $t3, $t4, noSwap # se valor do topo for menor ou igual ao próximo valor, não precisa trocar
					sw $t3, 4($t2)
					sw $t4, 0($t2)
			j loopComparation 
			noSwap:
				addi $t2, $t2, 4 # atual = atual + 1
				addi $t1, $t1, 1
				j loopTillNoChanges
	endBubbleSort:
		addi $t5, $t5, 1
		blt $t5, $t0, bubbleSort #segundo loop para ter certeza que a pilha sera ordenada
		jr $ra
	
	main:
		#leitura de num
		
		whileLength:
			li $v0, 5 #t0 tem a quantidade de números que quero ler
			syscall
			move $t0, $v0
		ble $t0, 0, whileLength #só aceita quantidades maior que 0
		
		li $t1, 0
		
		readValue:
			beq $t1, $t0, endReader
			
				whileValue:
					li $v0, 5
					syscall
					move $s0, $v0
				bltz $s0, whileValue #só fatorial maior ou igual a zero
			jal factorial
			move $v0, $s1
			
			sw $s1, 0($sp) #armazena valor na stack
			 
			addi $sp, $sp, -4 #muda posição na stack
			
			addi $t1, $t1, 1
		j readValue
		endReader:
	
		addi $sp, $sp, 4 #somar +4 para voltar para posiçcao que tem valor
		li $t5, 0 #i = 0
		jal bubbleSort
		
		move $t1, $sp #$t1 recebe o ultima posiçao da pilha que a gente colocou alguma coisa
		li $t2, 0
		print:
		beq $t2, $t0, EOF
			lw $t3, 0($t1) #$t3 recebe o valor do endereço que ficou em $t1
			li $v0, 1
			move $a0, $t3
			syscall
			
			li $v0, 4
			la $a0, newLine
			syscall
			
			addi $t1, $t1, 4 #move o endereço que esta em t1 em +1, indo para cima na pilha
			
		addi $t2, $t2, 1
		j print
		
		EOF:
		li $v0, 10
		syscall
