import sys

if len(sys. argv) > 1 and sys.argv[1] == 'debug':
    debug = True
else:
    debug = False

with open('asm.txt', 'r') as f:
    lines = f.readlines()

r = [-6]*12
instructions = []

for line in lines:
    l = line.strip().split(' ')
    instructions.append(l)

i = 0
while i < len(instructions):
    asm = instructions[i]
    try:
        arg1 = int(asm[1])
        arg2 = int(asm[2])
        arg3 = int(asm[3])
    except ValueError:
        #print(f"i:{i}")
        pass
    
    #ADD (1)
    if asm[0] == '1':
        if debug:
            print(r)
            print(f"[ADD] @{arg1} <- {r[arg2]} + {r[arg3]}")
        r[arg1] = r[arg2] + r[arg3]
    
    #MUL (2)
    elif asm[0] == '2':
        if debug:
            print(r)
            print(f"[MUL] @{arg1} <- {r[arg2]} * {r[arg3]}")
        r[arg1] = r[arg2] * r[arg3]

    #SOU (3)
    elif asm[0] == '3':
        if debug:
            print(r)
            print(f"[SOU] @{arg1} <- {r[arg2]} - {r[arg3]}")
        r[arg1] = r[arg2] - r[arg3]
    
    #DIV (4)
    elif asm[0] == '4':
        if debug:
            print(r)
            print(f"[DIV] @{arg1} <- {r[arg2]} / {r[arg3]}")
        r[arg1] = r[arg2] / r[arg3]
    
    #COP (5)
    elif asm[0] == '5':
        if debug:
            print(r)
            print(f"[COP] @{arg1} <- @{arg2}")
        r[arg1] = r[arg2]
    
    #AFC (6)
    elif asm[0] == '6':
        if debug:
            print(r)
            print(f"[AFC] @{arg1} <- {arg2}")
        r[arg1] = arg2
    
    #JMP (7)
    elif asm[0] == '7':
        if debug:
            print(r)
            print(f"JUMP TO {arg1}")
        i = arg1
    
    #JMF (8)
    elif asm[0] == '8':
        if not r[arg1]:
            if debug:
                print(r)
                print(f"JUMP TO {arg2}")
            i = arg2
            
    #INF (9)
    elif asm[0] == '9':
        if debug:
            print(r)
            print(f"[INF] @{arg1} <- {r[arg2] < r[arg3]}")
        if r[arg2] < r[arg3]:
            r[arg1] = 1
        else:
            r[arg1] = 0
    
    #SUP (A)
    elif asm[0] == 'A':
        if debug:
            print(r)
            print(f"[SUP] @{arg1} <- {r[arg2] > r[arg3]}")
        if r[arg2] > r[arg3]:
            r[arg1] = 1
        else:
            r[arg1] = 0
    
    #EQU (B)
    elif asm[0] == 'B':
        if debug:
            print(r)
            print(f"[EQU] @{arg1} <- @{arg2} == @{arg3}")
        if r[arg2] == r[arg3]:
            r[arg1] = 1
        else:
            r[arg1] = 0
    
    #PRI (C)
    elif asm[0] == 'C':
        if debug:
            print(r)
            print(f"PRINT : @{arg1}")
        else:
            print(r[arg1])
    
    #AND (D)
    elif asm[0] == 'D':
        if debug:
            print(r)
            print(f"[AND] : @{arg1} <- @{arg2} && @{arg3}")
        r[arg1] = int(r[arg2] and r[arg3])
    
    #OR (E)
    elif asm[0] == 'E':
        if debug:
            print(r)
            print(f"[OR] : @{arg1} <- @{arg2} || @{arg3}")
        r[arg1] = int(r[arg2] or r[arg3])
    
    #NOT (F)
    elif asm[0] == 'F':
        if debug:
            print(r)
            print(f"[NOT] : @{arg1} <- !@{arg2}")
        r[arg1] = int(not r[arg2])
    
    i += 1
