#---------------TEAM MEMBERS: -------#
#NAFISA MARYAM
#CHARLIE CIRALO
#CALUM SEIMER
#EVAN AIREY
#-----------CODE START -----------------#
.data
string0: .asciiz "Select Operation Mode [0=ASCII to MC, 1=MC to ASCII]:"
string1: .asciiz "Enter a Character: "
string2: .asciiz "Enter a Pattern: "
string3: .asciiz "Morse Code: "
string4: .asciiz "ASCII: "
string5: .asciiz "End of Program\n"
string6: .asciiz "[Error] no ASCII2MC!\n"
string7: .asciiz "[Error] no MC2ASCII!\n"
string8: .asciiz "[Error] Invalid combination!\n"

endLine: .asciiz "\n"

buffer: .space 7

dict: .word 0x55700030, 0x95700031, 0xA5700032, 0xA9700033, 0xAA700034, 0xAAB00035, 0x6AB00036, 0x5AB00037, 0x56B00038, 0x55B00039, 0x9C000041, 0x6AC00042, 0x66C00043, 0x6B000044, 0xB0000045, 0xA6C00046, 0x5B000047, 0xAAC00048, 0xAC000049, 0x95C0004A, 0x6700004B, 0x9AC0004C, 0x5C00004D, 0x6C00004E, 0x5700004F, 0x96C00050, 0x59C00051, 0x9B000052, 0xAB000053, 0x70000054, 0xA7000055, 0xA9C00056, 0x97000057, 0x69C00058, 0x65C00059, 0x5AC0005A
s_dsh: .byte '-'
s_dot: .byte '.'
s_spc: .byte ' '

.text
main:

  li $v0, 4                 # print "Select Operation Mode [0=ASCII to MC, 1=MC to ASCII]:"
  la $a0, string0
  syscall                   # syscall print string0

  li $v0, 5
  syscall                   # syscall Read int

  bne $v0, $0, MC2A

A2MC:
  li $v0, 4                 # print "Enter a Letter:"
  la $a0, string1
  syscall                   # syscall print string1

  li $t0, 1                 # Define length
  li $v0, 12                # Read character
  syscall                   # syscall Read character
  move $t0,$v0              # Transfer the char entered to the temporary value

  li $t2, 1                 # Define length
  li $v0, 12                # Read NULL character
  syscall                   # syscall Read character

  la $t2, dict              # Load address of dir
  li $t3, 0                 # Initialize index
  li $t4, 36                # Initialize boundary

LoopA2MC:
  lb $t5, ($t2)             # Load value to be compared
  beq $t0, $t5, FndA2MC     # Compare values
  addi $t2, $t2, 4          # Next symbol
  addi $t3, $t3, 1          # Next index
  blt $t3, $t4, LoopA2MC    # Evaluate index condition
  j ErrorA2MC

FndA2MC:
  li $v0, 4                 # print "MorseCode:" ,4 is sys call for print_String
  la $a0, string3
  syscall                   # syscall print string3

  lw $t3, ($t2)             # Load value to be printed
  li $t4, 0x80000000        # Load bitmask
snext:
  and $t5, $t3, $t4         # Apply bitmask
  beq $t5, $0, caseZ        # Zero Found

caseO:
  sll $t3, $t3, 1           # Shift Left
  and $t5, $t3, $t4         # Apply bitmask
  sll $t3, $t3, 1           # Shift Left
  beq $t5, $0, pdot         # 10 Found

caseE:
  li $v0, 4                 # Print string code
  la $a0, endLine           # Print NewLine
  syscall                   # syscall print value
  j EXIT                    # End

caseZ:
  sll $t3, $t3, 1           # Shift Left
  and $t5, $t3, $t4         # Apply bitmask
  sll $t3, $t3, 1           # Shift Left
  beq $t5, $0, caseN        # 00 Found
pdash:
  li $v0, 11                # Print char
  lb $a0, s_dsh             # Load value to be printed
  syscall                   # Print value
  j snext

pdot:
  li $v0, 11                # Print char
  lb $a0, s_dot             # Load value to be printed
  syscall                   # Print value
  j snext

caseN:
  li $v0, 4                 # print "Error, Invalid combination!"
  la $a0, string8
  syscall                   # syscall print string
  j EXIT

ErrorA2MC:
  li $v0 , 4                # print "Error no ASCII2MC!"
  la $a0 , string6
  syscall                   # syscall print string6

  j EXIT
MC2A:
  li $v0 , 4
  la $a0 , string2
  syscall

#--------------------------------------------------------------#
#-------------------- Write your code Here --------------------#
#--------------------------------------------------------------#
        #--- code for asking user input --------#

  li $v0 , 8                # Read_string -- i/p
  la $a0, buffer            # load byte space into address
  li $a1, 7                 # length for i/p buffer
  syscall
  move $t0, $a0             # save string to t0
  li  $t7, 0x00000000       # register used to store binary value of string

        #-------Code for handling enter  ----------#
#  li $t2, 1
#  li $v0,12
#  syscall

        #--------Code for  handling string  to binary --#
  lb $t6, endLine
  li $t1, 0                # indexer for strLoop
  add $s1, $t0, $t1      # s1 = string[0]

StrLoop:
  lb  $t2, ($s1)             # loading the character to compare
  lb  $t5, s_dsh
  beq $t2, $t5, sDashCalc    # if input_string[i]=='-'
  lb  $t5, s_dot
  beq $t2, $t5, sDotCalc     # if ip_string[i]==  "."
  beq $t2, $t6, sNullCalc    # once  string ends add  11 to  $t7
  j ErrorMC2A

sDashCalc:
  sll  $t3, $t1, 1           #  multiply index value by 2  and store in $t3
  li   $t4 ,30
  sub  $t3, $t4, $t3
  li   $t5, 0x00000001       #  - is  00 01
  sll  $t5, $t5, $t3                 #  shift 01 to right by  (30 - 2(t1) ) bits
  or   $t7, $t7, $t5           #  add the value to that specific position
  addi $t1, $t1, 1
  addi $s1, $s1, 1
  j StrLoop

sDotCalc:
  sll  $t3, $t1, 1           #  t1 *2
  li   $t4, 30
  sub  $t3, $t4, $t3
  li   $t5, 0x00000002       #  .  is 10
  sll  $t5, $t5, $t3
  or   $t7, $t7, $t5
  addi $s1, $s1, 1
  addi $t1, $t1 ,1
  j StrLoop

sNullCalc:
 sll  $t3, $t1, 1
 li   $t4, 30
 sub  $t3, $t4, $t3
 li   $t5, 0x00000003
 sll  $t5, $t5 ,$t3
 or   $t7, $t7, $t5
 addi $t1, $t1, 1

LoadDict:
        #----------Loading Dictionary -------------#
  la $t2, dict             # address of dictionary
  li $t3, 0                # intialize index to 0
  li $t4, 36               # index boundary  to 36


LoopMC2A:
  lw   $t5,0($t2)                  #loading value to be compared  --32 bits
  li   $t6, 0xFFFF0000             #load bitmask to register $t6
  and  $t5, $t6, $t5               #sets ascii part to 00 and morsecode part same as how it's supposed to be
  beq  $t7, $t5,FindMC2A
  addi $t2, $t2, 4
  addi $t3, $t3, 1
  blt  $t3, $t4, LoopMC2A
  j ErrorMC2A
# j EXIT
FindMC2A:
  li $v0, 4
  la $a0, string4
  syscall
#-----------------------printing the  aSCII value ----------------------#


CharLoadDcit:
#----------------------Loading the character from dictionary---#
  lb $t6, ($t2)
  li $v0, 11                     #print _char
  la $a0 ,($t6)
  syscall



#--------------------------------------------------------------#

  li $v0 , 4                # Print string code
  la $a0 , endLine          # Print NewLine
  syscall                   # syscall print value
  j EXIT

ErrorMC2A:
  li $v0 , 4                # print "Error no MC2ASCII!"
  la $a0 , string7
  syscall                   # syscall print string7

  j EXIT

EXIT:
  li $v0, 4
  la $a0, string5
  syscall

  li $a0, 0
  li $v0, 17              #exit
  syscall

