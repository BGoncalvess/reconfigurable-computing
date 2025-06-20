# Reconfigurable Computing

Este repositório contém os projetos desenvolvidos para a unidade curricular de Computação Reconfigurável, utilizando VHDL e ModelSim para simulação e validação dos sistemas digitais.

## Requisitos

- ModelSim (Intel FPGA Edition)

## Projetos

### [TP1](TP1/)
**Tema:** Introdução ao VHDL e primeiros circuitos  
**Descrição:**  
Implementação de circuitos digitais básicos em VHDL, incluindo simulação e validação funcional.  
**Principais ficheiros:**  
- `tp1.vhd`: Descrição do circuito principal  
- `tp1-tb.vhd`: Testbench para simulação

---

### [TP2](TP2/)
**Tema:** LFSR e Cifra de Fluxo  
**Descrição:**  
Desenvolvimento de um registrador de deslocamento com realimentação linear (LFSR) e aplicação em cifra de fluxo para encriptação de dados.  
**Principais ficheiros:**  
- `tp2-lfsr.vhd`: Implementação do LFSR  
- `tp2-decrypt.vhd`: Módulo de desencriptação  
- `tb-tp2.vhd`: Testbench

---

### [TP3](TP3/)
**Tema:** Filtro Digital FIR  
**Descrição:**  
Implementação de um filtro FIR digital para remoção de ruído de sinais, utilizando ROMs para coeficientes e dados de entrada.  
**Principais ficheiros:**  
- `filter.vhd`: Lógica principal do filtro FIR  
- `filter_rom.vhd`: ROM de coeficientes  
- `signal_rom.vhd`: ROM de dados de entrada  
- `tb.vhd`: Testbench  
- `signal_plotter.vhd`: Escrita dos resultados para análise gráfica

---

### [TP4](TP4/)
**Tema:** Comunicação UART  
**Descrição:**  
Desenvolvimento de um módulo UART em VHDL para transmissão e receção de dados seriais, incluindo testbench para validação.  
**Principais ficheiros:**  
- `uart.vhd`: Implementação do protocolo UART  
- `tb.vhd`: Testbench

---

### [TP5](TP5/)
**Tema:** Projeto Final – Sistema Completo  
**Descrição:**  
Integração dos módulos desenvolvidos nos TPs anteriores: leitura de dados de ROM, encriptação com LFSR, transmissão UART, desencriptação e filtragem FIR, com gravação dos resultados em ficheiro.  
**Principais ficheiros:**  
- `controller_in.vhd`, `controller_out.vhd`: Controladores principais  
- `cypher.vhd`, `lfsr.vhd`: Encriptação/Desencriptação  
- `uart.vhd`: Comunicação UART  
- `filter.vhd`, `rom_filter.vhd`, `rom_signal.vhd`: Filtro FIR e memórias  
- `tb.vhd`: Testbench do sistema final

---

## Organização

- Cada pasta TPx contém o código-fonte, testbenches e documentação específica.
- Documentação adicional encontra-se em `Documentos/` e `Material Aulas/`.

## Execução

1. Abra o projeto desejado no ModelSim.
2. Compile todos os ficheiros VHDL listados acima.
3. Execute o testbench correspondente para validar o funcionamento.
4. Analise os resultados gerados (ficheiros de texto/imagens).

---

## Autor

Bruno Gonçalves
