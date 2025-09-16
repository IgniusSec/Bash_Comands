# Bash_Comands

## Exemplos

### 1. Geração de combinações de parâmetros

```bash
$ gen-grid.sh A=1,2 B=x,y
```

Output:
A B
1 x
1 y
2 x
2 y

### 2. Replicação de linhas

```bash
$ gen-grid.sh A=1,2 B=x,y \
  | replicate.sh --n 2
```

Output:
A B rep
1 x 1
1 x 2
1 y 1
1 y 2
2 x 1
2 x 2
2 y 1
2 y 2

### 3. Embaralhamento com semente fixa

```bash
$ gen-grid.sh A=1,2 B=x,y \
  | replicate.sh --n 2 \
  | shuffle.sh --seed 7
```

Output:
A B rep
2 y 2
1 y 1
2 x 1
1 x 2
...
