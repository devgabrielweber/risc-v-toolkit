# RODAR GEM5 PARA ORG

### Pré-requisitos

- Docker instalado e rodando
- `make` disponível no sistema (sudo apt-get install make)

---

### Para rodar, siga os passos:

1. Clone o Repo
2. Ajuste as variáveis de ambiente em `.env`, sendo elas:
   - **CPUS**: quantidade de CPUs disponibilizadas para o container durante a simulação
   - **MEMORY**: quantidade de memória disponibilizada para o container durante a simulação
   - **GEM5_JOBS**: quantidade de threads disponibilizadas para a _compilação do gem5 apenas_
3. `make build` no terminal — isso vai clonar o gem5 e compilar a imagem Docker
4. Coloque seu arquivo `.s` (assembly RISC-V) e o script Python de simulação na pasta `./workloads`
5. Para compilar e rodar:

```bash
make compile-and-run FILE=nome_do_arquivo        # usa sim.py por padrão
make compile-and-run FILE=nome_do_arquivo SIM=outro_sim  # usa outro script
```

---

### Comandos disponíveis

| Comando                                    | Descrição                                    |
| ------------------------------------------ | -------------------------------------------- |
| `make build`                               | Clona o gem5 e builda a imagem Docker        |
| `make shell`                               | Abre o terminal do container em `/workloads` |
| `make compile FILE=nome`                   | Compila `nome.s` → `nome.riscv`              |
| `make run FILE=nome`                       | Roda `nome.riscv` com `sim.py`               |
| `make run FILE=nome SIM=outro`             | Roda `nome.riscv` com `outro.py`             |
| `make compile-and-run FILE=nome`           | Compila e roda em sequência                  |
| `make compile-and-run FILE=nome SIM=outro` | Compila e roda com script customizado        |
| `make clean`                               | Remove a imagem Docker e o diretório do gem5 |

---

### IMPORTANTE

- **Compilação pode demorar de 30 min a 2 horas** dependendo dos JOBS disponibilizados. Uma regra simples: `RAM livre no sistema / 2`. Recomenda-se fechar todas as outras aplicações antes de rodar `make build`.
- O binário gerado (`nome.riscv`) fica salvo em `./workloads` — se já existir, o `compile-and-run` **sempre recompila** por padrão.
- Os resultados da simulação são salvos em `./results`.
- Para sair do shell, digite `exit` — o container fecha automaticamente.
- Para limpar tudo e recomeçar do zero, rode `make clean` seguido de `make build`.
