# Python 3.14 - Containers COM e SEM GIL

Este projeto cria dois containers Docker com Python 3.14 compilado:
- **Python 3.14 COM GIL** (versão padrão)
- **Python 3.14 SEM GIL** (freethreading, com `--disable-gil`)

## Pré-requisitos

- Docker
- Docker Compose (opcional)

## Estrutura do Projeto

```
.
├── Dockerfile.python314-gil      # Container Python 3.14 COM GIL
├── Dockerfile.python314-nogil    # Container Python 3.14 SEM GIL (freethreading)
└── docker-compose.yml            # Orquestração dos containers
```

## Como Funciona

Cada Dockerfile:
1. Baixa Python 3.14.0rc3 do site oficial
2. Instala todas as dependências necessárias
3. Compila Python 3.14:
   - **COM GIL**: `./configure --prefix=/usr/local --enable-optimizations --with-ensurepip=install`
   - **SEM GIL**: `./configure --prefix=/usr/local --disable-gil --enable-optimizations --with-ensurepip=install`
4. Instala o Python compilado
5. Configura aliases e variáveis de ambiente

## Uso

### Construir todas as imagens

```bash
docker-compose build
```

### Executar os containers

```bash
# Executar ambos
docker-compose up -d

# Executar apenas um
docker-compose up -d python314-gil
docker-compose up -d python314-nogil
```

### Acessar os containers

```bash
# Acessar container COM GIL
docker exec -it python314-gil bash

# Acessar container SEM GIL
docker exec -it python314-nogil bash
```

### Verificar o Python

Dentro do container, você pode verificar:

```bash
# Ver versão e informações
python3.14 -VV

# Verificar status do GIL
python3.14 -c "import sys; print('GIL enabled:', sys._is_gil_enabled())"

# Usar aliases
python --version
pip --version
```

### Usando Docker diretamente

```bash
# Construir imagem COM GIL
docker build -f Dockerfile.python314-gil -t python314-gil .

# Construir imagem SEM GIL
docker build -f Dockerfile.python314-nogil -t python314-nogil .

# Executar e acessar
docker run -it python314-gil bash
docker run -it python314-nogil bash
```

## Verificação do GIL

Para verificar se o GIL está habilitado ou não:

```python
import sys
print(sys._is_gil_enabled())  # False para freethreading, True para GIL
```

## Notas Importantes

### Compilação do Python

A compilação do Python 3.14 pode demorar bastante tempo (30-60 minutos ou mais, dependendo do hardware). Isso é normal, pois o Python está sendo compilado do código fonte com otimizações (`--enable-optimizations`).

### Diferenças entre as versões

- **COM GIL**: Versão padrão do Python, com Global Interpreter Lock habilitado
- **SEM GIL (freethreading)**: Versão experimental que permite verdadeiro paralelismo em threads Python, compilada com a flag `--disable-gil`

### Variáveis de Ambiente

- `PYTHON_GIL=1` - Container COM GIL
- `PYTHON_GIL=0` - Container SEM GIL (freethreading)
- `PYTHON_BIN=/usr/local/bin/python3.14` - Caminho do Python compilado
- `PATH=/usr/local/bin:${PATH}` - Python no PATH

### Aliases Configurados

Os seguintes aliases estão configurados no `.bashrc`:
- `python` → `python3.14`
- `python3` → `python3.14`
- `pip` → `pip3.14`

### Troubleshooting

**Erro ao baixar Python:**
- Verifique sua conexão com a internet
- O arquivo Python-3.14.0rc3.tgz deve estar disponível no site oficial

**Erro ao compilar:**
- Verifique se há espaço suficiente em disco (a compilação requer vários GB)
- Aumente a memória disponível para o Docker se necessário

**Ver logs de build:**
```bash
docker-compose build --progress=plain
```

## Licença

Este projeto compila Python 3.14 a partir do código fonte oficial.
