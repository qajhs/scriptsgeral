X=1
Y=2
Z=5

Pergunta="""
1) Considerando que X, Y e Z são variáveis de memória utilizadas em um algoritmo e que possuem os seguintes
valores: X = 1, Y = 2 e Z = 5
Desenvolva os seguintes cálculos, utilizando os operadores Aritméticos.
"""
Alterantivas="""
a) Z % Y / Y
b) X + Y + Z / 3
c) Z / Y + pow(X ,Y)
"""

print(Pergunta,Alterantivas)
print('Respostas:\n\na)',Z%Y/Y,"\nb)",X+Y+Z/3,"\nc)", Z/Y + pow(X,Y),"\n\n---------------------------------------------")

Pergunta="""
2) Considerando a precedências em expressões de atribuição em programação, escreva o valor que será
atribuído a cada uma das variáveis após a realização de cada cálculo:
"""
Alterantivas="""
a= 3 + 4 * 5                            b= 8 / 4 + 2 * 3
c= 2 * (10 – 3 * 3) – 1                 d= 5 * (3 + (2 + 3)) / 2 + 1
e= 1 + 12 / ((7 + 2) / 3) + (6 - 2)     f= 3 + 15 / 2 + 5
g= 21 / 4 – 2                           j= 21 / 4 / 2
"""


print(Pergunta,Alterantivas)
print("Respostas:")
print('a)',3+4*5)
print('b)',int(8/4+2*3))
print('c)',2*(10-3*3)-1)
print('d)',int(5*(3+(2+3))/2+1))
print('e)',int(1+12/((7+2)/3) + (6-2)))
print('f)',3+15/2+5,'ou de forma inteira',int(3+15/2+5))
print('g)',21/4-2,'ou de forma inteira',int(21/4-2))
print('j)',21/4/2,'ou de forma inteira',int(21/4/2))





print('\n\n---------------------------------------------\n\nQuestão 3 dos exercícios')
def inputNumber(message):
    while True:
        try:
            userInput = int(input(message))
        except ValueError:
            print("[!] Número informado não é inteiro")
            continue
        else:
            return userInput
            break

valorA = inputNumber("[+] Insira o valor número 1 ")

valorB = inputNumber("[+] Insira o valor número 2 ")

print('[+] Resultado =>',valorA+valorB)
