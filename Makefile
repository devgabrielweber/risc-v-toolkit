include .env
export

.PHONY: help setup build shell clean run compile compile-and-run
FILE  ?= main
SIM   ?= sim

GEM5_DIR := ./gem5

help:
	@echo ""
	@echo "Uso: make <target> [FILE=nome_sem_extensao] [SIM=arquivo_simulacao_sem_extensao]"
	@echo ""
	@echo "!Arquivos devem estar na pasta /workloads no vscode"
	@echo ""
	@echo "Default file names:"
	@echo "FILE = main.s"
	@echo "SIM = sim.s"
	@echo "Targets:"
	@echo "  setup             Clona o repositório do gem5"
	@echo "  build             Builda a imagem Docker do gem5"
	@echo "  shell             Abre um shell dentro do container em /workloads"
	@echo "  clean             Remove a imagem Docker e o diretório do gem5"
	@echo "  compile           Compila FILE.s para FILE.riscv.   ex: make compile FILE=codigo"
	@echo "  run               Roda FILE.riscv no gem5 com o simulador SIM.            ex: make run FILE=codigo SIM=sim"
	@echo "  compile-and-run   Compila e roda                    ex: make compile-and-run FILE=codigo SIM=sim"
	@echo ""

setup: $(GEM5_DIR)/SConstruct

$(GEM5_DIR)/SConstruct:
	git clone https://github.com/gem5/gem5.git $(GEM5_DIR)

build: setup
	@echo "Buildando imagem com $(CPUS) CPUs e $(MEMORY) de RAM..."
	docker compose build --build-arg JOBS=$(GEM5_JOBS)
	@echo "Imagem pronta!"

shell:
	docker compose run --rm -w /workloads gem5

clean:
	docker compose down --rmi local
	rm -rf $(GEM5_DIR)

compile:
	docker compose run --rm -w /workloads gem5 \
		bash -c "riscv64-linux-gnu-gcc -static /workloads/$(FILE).s -o /workloads/$(FILE).riscv -march=rv64g -mabi=lp64d"

run:
	docker compose run --rm -w /workloads gem5 \
		bash -c "/gem5/build/RISCV/gem5.opt --outdir=/results /workloads/$(SIM).py --binary /workloads/$(FILE).riscv"
		
compile-and-run:
	$(MAKE) compile FILE=$(FILE)
	$(MAKE) run FILE=$(FILE) SIM=$(SIM)