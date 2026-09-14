# Mini-Projeto BPS - Banco de Preços em Saúde (2020-2026)

**Aluno:** Isaac Trenard  
**Turma:** Visualização de Dados e Business Intelligence [T2]  
**Módulo:** 2 - Semana 06  

---

## 🎯 Objetivo do Projeto

Desenvolver um dashboard analítico para acompanhar as compras de medicamentos e dispositivos médicos registradas no Banco de Preços em Saúde (BPS) entre 2020 e 2026, permitindo a exploração dos dados e respondendo a questões sobre:

- Evolução dos valores registrados ao longo do tempo
- Estados, municípios e instituições com maior volume financeiro
- Medicamentos e dispositivos médicos mais adquiridos
- Fornecedores e fabricantes com maior participação
- Variação dos preços unitários
- Modalidades de compra mais utilizadas
- Identificação de oportunidades de investigação sobre diferenças relevantes de preços

---

## 📦 Estrutura do Projeto

## 🔄 Processo de tratamento e transformação dos dados

O projeto foi desenvolvido em duas principais etapas de processamento.

### 1. Preparação e análise dos dados — Visual Studio Code

Inicialmente, as bases anuais do Banco de Preços em Saúde (BPS), referentes
ao período de 2020 a 2026, foram extraídas, exploradas, tratadas e consolidadas.

Nesta etapa foram realizadas atividades de ETL e Análise Exploratória de
Dados (EDA), incluindo:

- Extração das bases anuais;
- Exploração e diagnóstico dos dados;
- Identificação de inconsistências;
- Tratamento e padronização das variáveis;
- Limpeza dos dados;
- Consolidação das bases;
- Criação de variáveis derivadas;
- Validação da base;
- Exportação da base consolidada para utilização no BigQuery.

### 2. Refinamento e modelagem — Google BigQuery

Após a preparação inicial, a base consolidada foi carregada no Google
BigQuery, onde foram realizadas novas etapas de transformação e tratamento
por meio de consultas SQL.

Nesta etapa foram desenvolvidos:

- Tabelas tratadas;
- Views analíticas;
- KPIs;
- Indicadores por período;
- Ranking de fornecedores;
- Benchmark de preços;
- Estruturas utilizadas posteriormente no dashboard.

Dessa forma, o projeto utiliza um fluxo híbrido de **ETL + ELT**, combinando
o processamento inicial realizado no Visual Studio Code com o refinamento
e a transformação dos dados diretamente no BigQuery.

---

## 🔄 SPRINT 1: Entendimento do problema e dos dados

**Checklist:**

- [x] Ler o desafio proposto
- [x] Acessar o Portal Brasileiro de Dados Abertos
- [x] Localizar os arquivos do Banco de Preços em Saúde
- [x] Baixar os arquivos .csv dos anos de 2020 a 2026
- [x] Consultar o dicionário de dados oficial
- [x] Identificar as colunas disponíveis em cada arquivo
- [x] Verificar diferenças de nomes, formatos ou estruturas entre os anos
- [x] Definir as perguntas de negócio

**Perguntas de negócio definidas:**

## 🎯 Perguntas de negócio

A análise foi orientada pelas seguintes perguntas de negócio:

1. **Como evoluíram os gastos registrados no BPS ao longo do período analisado e como essa evolução se relaciona com o preço unitário médio ponderado?**

2. **Quais fornecedores concentram a maior participação financeira nas compras registradas e qual é a concentração dos gastos entre as Unidades da Federação?**

3. **Quais produtos apresentam maior dispersão de preços entre diferentes compras e onde existem potenciais oportunidades de economia?**

4. **Qual é a participação dos medicamentos genéricos nas compras e qual é a diferença de preço médio entre produtos genéricos e não genéricos?**

5. **Como se distribuem os processos de compra segundo as diferentes faixas de valor?** da Federação (UF)?

---

## 🔄 SPRINT 2: Preparação e concatenação das bases

**Checklist:**

- [x] Importar os arquivos anuais
- [x] Padronizar os nomes das colunas
- [x] Verificar e corrigir os tipos de dados
- [x] Padronizar os campos de data
- [x] Ajustar a formatação de valores monetários e quantidades
- [x] Corrigir problemas de codificação de caracteres
- [x] Verificar valores nulos, vazios ou inconsistentes
- [x] Avaliar a existência de registros duplicados
- [x] Concatenar as bases de 2020 a 2026 em um único arquivo
- [x] Manter uma identificação do ano da compra

**TRATAMENTOS REALIZADOS NO VISUAL STUDIO CODE:**

1. **Conversão de datas:** colunas `compra` e `insercao` convertidas para datetime.
2. **Imputação da coluna `generico`:** preenchimento de nulos com a moda do grupo (descrição_catmat + unidade_fornecimento + fornecedor).
3. **Remoção de colunas:** `capacidade`, `unidade_medida` e `unidade_fornecimento_capacidade` (baixa relevância).
4. **Conversão de códigos:** `codigo_br` e `anvisa` convertidos para string.
5. **Categoria "Não Informado":** nulos restantes em `generico` convertidos para esta categoria.

**Resultado:**
- Total de registros: 342.716
- Total de colunas: 22
- Distribuição de `generico`: S (34,90%), N (28,21%), Não Informado (36,89%)

---

## 🔄 SPRINT 3: Definição das métricas e dos KPIs

**Checklist:**

- [X] Definir os indicadores principais do dashboard
- [X] Criar os campos calculados necessários
- [X] Validar as fórmulas e os resultados
- [X] Definir quando utilizar soma, média, mediana, contagem ou contagem distinta
- [X] Conferir se os campos numéricos estão sendo agregados corretamente
- [X] Evitar a soma de preços unitários quando essa operação não representar uma informação válida
- [X] Definir os critérios utilizados para comparação de preços entre produtos

---
** TRATAMENTOS REALIZADADOS NO GOOGLE BIGQUERY: ** 

## ✅ Definir os indicadores principais do dashboard

### 📊 7 KPIs definidos

| # | Indicador | Fórmula | Tipo |
|---|-----------|---------|------|
| 1 | Valor Total Registrado | `SUM(preco_total)` | SOMA |
| 2 | Quantidade Total de Itens | `SUM(qtd_itens_comprados)` | SOMA |
| 3 | Nº de Itens Registrados | `COUNT(*)` | CONTAGEM |
| 4 | Nº de Processos de Compra | `COUNT(DISTINCT codigo_br)` | CONTAGEM DISTINTA |
| 5 | Instituições Compradoras | `COUNT(DISTINCT cnpj_instituicao)` | CONTAGEM DISTINTA |
| 6 | Fornecedores | `COUNT(DISTINCT cnpj_fornecedor)` | CONTAGEM DISTINTA |
| 7 | Preço Unitário Médio Ponderado | `SUM(preco_total) / SUM(qtd_itens_comprados)` | RAZÃO |

---

## ✅ Criar os campos calculados necessários

### 🧮 Campos criados na VIEW `visualizacao_compras_tratadas`

**Campos temporais:**
- `ano_mes` → formato `2020-01`, `2020-02`, ...
- `trimestre` → `T1`, `T2`, `T3`, `T4`
- `semestre` → `S1`, `S2`

**Campos de preço:**
- `gasto_total` → cópia de `preco_total`
- `preco_unitario_calculado` → `preco_total / qtd_itens_comprados`
- `preco_por_unidade` → `preco_unitario / capacidade`

**Campos de classificação:**
- `faixa_gasto` → `≤1k`, `1k-10k`, `10k-100k`, `100k-1M`, `>1M`
- `porte_compra` → `Pequena`, `Média`, `Grande`, `Muito Grande`
- `faixa_preco` → `≤10`, `10-100`, `100-1k`, `1k-10k`, `>10k`

**Campos de genérico:**
- `generico_original` → valor bruto do CSV
- `generico_ajustado` → após inferências (S / N / NULL)
- `generico_fonte` → origem da classificação
- `is_generico` → booleano (TRUE / FALSE / NULL)
- `generico_categoria` → categoria final consolidada
- `tipo_item` → natureza do produto

**Chaves padronizadas:**
- `chave_produto` → produto + unidade de fornecimento
- `chave_fornecedor` → CNPJ ou `SEM_CNPJ`
- `chave_instituicao` → CNPJ ou `SEM_CNPJ`

---

## ✅ Validar as fórmulas e os resultados

### 🧪 Validação dos KPIs (resultado real)

| KPI | Valor calculado |
|-----|-----------------|
| Nº de Itens Registrados | **342.047** |
| Nº de Processos de Compra | **12.993** |
| Instituições Compradoras | **831** |
| Fornecedores | **3.502** |
| Valor Total Registrado | **R$ 78.482.430.587,26** |
| Quantidade Total de Itens | **57.087.395.530** |
| Preço Unitário Médio Ponderado | **R$ 1,37** |

### 🧪 Validação do preço unitário calculado

| Total | Idênticos | Divergentes | Diferença média |
|-------|-----------|-------------|-----------------|
| 342.047 | 342.047 (100%) | 0 | 0,00 |

**Conclusão:** `preco_unitario_calculado` bate 100% com `preco_unitario` original — sem arredondamento ou divergência.

### 🧪 Validação da coluna `generico` — recuperação de dados

| Métrica | Antes | Depois | Evolução |
|---------|-------|--------|----------|
| Registros classificados | 196.968 (57,6%) | 224.959 (65,8%) | **+27.991** |
| "Não Informado" | 145.079 (42,4%) | 75.486 (22,1%) | **−48%** |

### 🧪 Distribuição `generico_categoria`

| Categoria | Ocorrências | % |
|-----------|-------------|---|
| Generico | 124.348 | 36,35% |
| Nao_Generico | 100.611 | 29,41% |
| Nao_Informado | 75.486 | 22,07% |
| Nao_Aplicavel | 41.602 | 12,16% |

### 🧪 Distribuição `tipo_item`

| Tipo | Ocorrências | % |
|------|-------------|---|
| Medicamento | 258.662 | 75,62% |
| Indefinido | 44.789 | 13,09% |
| Material_Hospitalar | 34.264 | 10,02% |
| Commodity_Hospitalar | 4.332 | 1,27% |

---

## ✅ Definir quando utilizar soma, média, mediana, contagem ou contagem distinta

### 📏 Regras de agregação por tipo de campo

| Tipo de campo | Agregação correta | Proibido |
|---------------|-------------------|----------|
| Valores monetários totais (`preco_total`, `gasto_total`) | `SUM` | — |
| Quantidades (`qtd_itens_comprados`) | `SUM` | — |
| Preços unitários (`preco_unitario`) | `AVG`, `MEDIAN`, `MIN`, `MAX` | ❌ `SUM` |
| Capacidade (`capacidade`) | `AVG`, `MEDIAN` | ❌ `SUM` |
| Identificadores (`cnpj_*`, `codigo_br`) | `COUNT DISTINCT` | ❌ `SUM` |
| Textos e categorias | `COUNT`, `COUNT DISTINCT` | ❌ `SUM` |
| Booleanos (`is_generico`) | `COUNTIF` | ❌ `SUM` |
| Razões (% genéricos, ticket médio) | `SAFE_DIVIDE` | — |

### 🎯 Justificativa resumida

- **SUM** → apenas para valores aditivos (dinheiro total, quantidade total).
- **AVG / MEDIAN** → para preços unitários e capacidades (comparações entre itens).
- **COUNT / COUNT DISTINCT** → para frequência e entidades únicas.
- **COUNTIF** → para proporções de booleanos.
- **SAFE_DIVIDE** → para indicadores derivados (evita divisão por zero).

---

## ✅ Conferir se os campos numéricos estão sendo agregados corretamente

### 🔍 Verificações de integridade da base

| Verificação | Resultado | Esperado | Status |
|-------------|-----------|----------|--------|
| Total de registros | **342.047** | 342.047 | ✅ |
| Registros com `preco_total` NULL | 0 | 0 | ✅ |
| Registros com `preco_unitario` NULL | 0 | 0 | ✅ |
| Registros com `preco_total` negativo | 0 | 0 | ✅ |
| Registros com `preco_unitario` negativo | 0 | 0 | ✅ |
| Registros com `qtd_itens_comprados = 0` | 0 | 0 | ✅ |
| Registros com `preco_unitario = 0` | 0 | 0 | ✅ |

**Conclusão:** a base consolidada não possui valores nulos, negativos ou zerados nos campos numéricos críticos. 
*Os dados estão íntegros e prontos para agregação.*

---

## ✅ Evitar a soma de preços unitários quando essa operação não representar uma informação válida

### ❌ Comprovação do erro

| Métrica | Valor | Veredito |
|---------|-------|----------|
| `SUM(preco_unitario)` | **R$ 58.464.853,19** | ❌ Sem significado |
| `AVG(preco_unitario)` | R$ 170,93 | ✅ Média simples |
| `MEDIAN(preco_unitario)` | R$ 1,85 | ✅ Robusta a outliers |
| Preço ponderado (`SUM(preco_total) / SUM(qtd)`) | R$ 1,37 | ✅ Preço real pago |
| `SUM(preco_total)` | **R$ 78.482.430.587,26** | 💰 Gasto real |

### 💡 Interpretação

Somar preços unitários gera **R$ 58 milhões** — um número sem qualquer significado, porque cada linha tem uma quantidade diferente. Um item de R$ 0,02 (×1000 unidades) e outro de R$ 900 (×1 unidade) somariam R$ 900,02 — absurdo.

**O preço correto para análise é o ponderado (R$ 1,37)**, que representa o valor real pago por unidade, considerando o volume de cada compra.

**Regra fixada:** para preços unitários, usar sempre `AVG`, `MEDIAN` ou `SAFE_DIVIDE(SUM(preco_total), SUM(qtd_itens_comprados))`. **Nunca `SUM`.**

---

## ✅ Definir os critérios utilizados para comparação de preços entre produtos

### 🎯 Critérios obrigatórios (todos devem ser atendidos)

| # | Critério | Regra |
|---|----------|-------|
| 1 | **Mesmo produto** | `chave_produto` idêntica (produto + unidade de fornecimento) |
| 2 | **Mesmo ano** | `ano_compra` idêntico (evita distorção por inflação) |
| 3 | **Mesma unidade** | Já embutida na `chave_produto` (FRASCO ≠ AMPOLA ≠ CAIXA) |
| 4 | **Mínimo de ocorrências** | ≥ 3 registros no grupo |
| 5 | **Preços válidos** | `preco_unitario > 0` |

### 📊 Métricas de benchmark por grupo

- `preco_min`, `preco_max` → extremos
- `preco_mediano` → referência robusta
- `coef_variacao` (CV) → dispersão relativa = `STDDEV / AVG`
- `amplitude_pct` → variação percentual = `(MAX - MIN) / MIN × 100`

### 🚨 Critérios de interpretação

| CV | Interpretação |
|-----|---------------|
| 0 – 0,10 | Preços homogêneos (pouca variação) |
| **0,10 – 0,50** | **Oportunidade real de economia** |
| 0,50 – 1,00 | Alta dispersão (investigar) |
| > 1,00 | **Provável erro de dados** (unidade, digitação) |

### 📋 Exemplo — top 3 maiores dispersões identificadas

| Produto | Ano | CV | Amplitude |
|---------|-----|-----|-----------|
| AZITROMICINA 40mg/mL FRASCO | 2023 | 8,32 | 697.300% |
| DIPIRONA 500mg COMPRIMIDO | 2025 | 7,78 | 476.900% |
| AMOXICILINA 500mg CÁPSULA | 2024 | 7,72 | 536.175% |

> ⚠️ **Interpretação:** amplitudes acima de 1.000% não representam oportunidade real de economia — indicam **erro de unidade de fornecimento ou digitação** na fonte dos dados. 
> Para o dashboard, apenas produtos com **CV ≤ 0,5** serão exibidos como "oportunidades de economia".

---

## 📌 Fórmula correta para o KPI de genéricos
% Genéricos = COUNTIF(is_generico = TRUE) / COUNTIF(is_generico IS NOT NULL)

## 🔄 SPRINT 4: Construção do dashboard

**Checklist:**

- [X] Conectar a base consolidada ao Looker Studio
- [X] Criar os cartões dos KPIs
- [X] Desenvolver os visuais e gráficos
- [X] Adicionar filtros interativos
- [X] Organizar a hierarquia visual da página
- [X] Utilizar títulos, subtítulos e legendas compreensíveis
- [X] Aplicar cores coerentes com o tema da saúde e da gestão pública
- [X] Garantir legibilidade e consistência visual
- [X] Evitar excesso de elementos que prejudiquem a interpretação dos dados

**Visuais obrigatórios (mínimo 5):**

📊 Página 1 — Visão Macro
Evolução do Gasto Total por Ano
Nº de Compras por Faixa de Gasto
📊 Página 2 — Preços
Evolução do Preço Ponderado (2020–2025)
Oportunidades de Economia — Produtos com Maior Dispersão de Preço
📊 Página 3 — Entidades
Top 10 Fornecedores por Valor Total
Distribuição do Gasto por UF (R$) — Ranking por UF

Além desses gráficos, a página apresenta os KPIs:

Nº de Processos de Compra
Instituições Compradoras
Fornecedores

📊 Página 4 — Genéricos
Composição do Gasto por Tipo de Item

E também os KPIs:

% Genéricos
Preço Médio Não Genérico
Preço Médio Genéric

**Filtros interativos:**
- [X] Ano
- [X] UF (Estado)
- [X] Item

---
## 📊 Sprint 4: Construção do Dashboard

### 📄 Páginas implementadas

#### 1. Visão Macro
- KPIs: Valor Total, Quantidade Total, Nº de Itens
- Visuais: Evolução temporal, Distribuição por faixa de gasto

#### 2. Entidades
- KPIs: Nº de Processos, Instituições, Fornecedores
- Visuais: Top 10 Fornecedores, Mapa por UF, Ranking de UF

#### 3. Eficiência
- KPIs: Preço Unitário Ponderado
- Visuais: Evolução do preço, Tabela de oportunidades

#### 4. Genéricos
- KPIs: % Genéricos, Preço Genérico vs Não Genérico
- Visuais: Composição por tipo de item

### 🎛️ Filtros interativos
- Ano da Compra (dropdown)
- UF (dropdown)
- Tipo de Item (botões de seleção múltipla)

### 📌 Insights principais
- SP e PR concentram 58% do gasto nacional
- Genéricos são 20x mais baratos que não genéricos
- 90,2% do gasto é em medicamentos
- 1,4% dos registros concentram 89% do valor (Pareto)
- 55,28% dos medicamentos classificados são genéricos

### ⚠️ Limitações documentadas
- 8 registros anômalos excluídos (erros de digitação)
- AM, AP e DF não reportaram dados ao sistema federal
- 2023 com dados incompletos
- 34,2% dos registros sem classificação de genérico

## 🔄 SPRINT 5: Análise dos resultados

**Checklist:**

- [X] Interpretar os principais indicadores
- [X] Identificar estados, municípios e instituições com maior relevância
- [X] Analisar os produtos com maior valor total e quantidade adquirida
- [X] Comparar fornecedores e fabricantes
- [X] Avaliar a evolução anual dos valores registrados
- [X] Investigar diferenças de preços unitários para produtos comparáveis
- [X] Elaborar recomendações fundamentadas nos dados
- [X] Registrar as limitações da análise

**Interpretar os principais indicadores:**

### 📊 1.1 — Valor Total Registrado: R$ 48,88 bilhões

O setor público de saúde brasileiro registrou **R$ 48,88 bilhões** em compras no período de 2020 a 2026 (parcial).
Esse valor representa o total efetivamente pago, distribuído entre 24 Unidades Federativas.

**Interpretação:** O montante é expressivo e compatível com o porte do SUS, mas está **abaixo do valor real** de gasto público em saúde,
pois nem todos os entes federativos reportam suas compras ao sistema federal. A ausência de estados como Amazonas, Amapá e Distrito Federal
no dataset reforça essa limitação.

### 📊 1.2 — Quantidade Total de Itens: 57,1 bilhões de unidades

Foram adquiridas **57,1 bilhões de unidades** (comprimidos, frascos, ampolas, luvas, seringas etc.) ao longo do período.

**Interpretação:** A razão entre valor total e quantidade (**R$ 0,86 por unidade**) revela que **a maior parte das unidades compradas é
de itens de baixo custo** — como medicamentos básicos, materiais de consumo e insumos hospitalares. Poucas compras de alto valor concentram
a maior parte do orçamento.

### 📊 1.3 — Nº de Itens Registrados: 342.039

A base final possui **342.039 registros** de itens individuais (cada linha = 1 produto comprado).

**Interpretação:** A base original tinha 342.047 registros. Foram removidos **8 outliers** identificados como erros de digitação 
(ex.: Penicilamina a R$ 294.400/cápsula). Após a limpeza, **342.039 registros** foram considerados válidos.

### 📊 1.4 — Nº de Processos de Compra: 12.992

Foram executados **12.992 processos de compra únicos** (identificados por `codigo_br`).

**Interpretação:** A razão **26,3 itens por processo** indica compras **relativamente consolidadas** — cada processo adquire, em média, 
26 produtos diferentes. Processos muito fragmentados (1 item por processo) seriam ineficientes; 26 itens sugere boa consolidação.

### 📊 1.5 — Instituições Compradoras: 831

**831 instituições públicas distintas** (municipais, estaduais e federais) realizaram compras no período.

**Interpretação:** Distribuídas por **24 UFs**, isso dá uma média de ~35 instituições por estado. A concentração é alta: 
**SP e PR concentram 33% das instituições**, refletindo a maior infraestrutura de saúde nessas regiões.

### 📊 1.6 — Fornecedores: 3.502

Foram registrados **3.502 fornecedores únicos** (por CNPJ) no período.

**Interpretação:** A razão **1 fornecedor para cada 4,2 instituições** mostra que **há razoável competição**, mas com 
concentração significativa: **os 10 maiores fornecedores respondem por 52% do valor total** (R$ 25,4 bi de R$ 48,88 bi). Isso indica
**alta concentração de mercado** — especialmente nas compras de medicamentos oncológicos e de alto custo.

### 📊 1.7 — Preço Unitário Médio Ponderado: R$ 0,86

O preço médio real pago por unidade comprada foi **R$ 0,86**.

**Interpretação:** Esse valor é **muito inferior à média simples (R$ 170,93)**, porque **a maioria absoluta das unidades adquiridas são
itens de baixíssimo custo**. Um único medicamento oncológico de R$ 50.000 pesa o mesmo que 58 mil comprimidos de R$ 0,86 na média simples,
mas **apenas 1/58.000** no ponderado. **O ponderado é o indicador correto** para refletir o preço real por unidade.

### 2 — Estados, municípios e instituições de maior relevância

A distribuição dos valores registrados apresenta forte concentração entre algumas Unidades Federativas. Entre os estados com dados disponíveis,
São Paulo (SP) apresenta o maior valor registrado, com **R$ 21,62 bilhões e 62.915 registros de compras**, seguido pelo Paraná (PR), com
**R$ 6,35 bilhões e 76.216 registros**, e Ceará (CE), com **R$ 5,40 bilhões e 5.060 registros**.

Na sequência aparecem Rio de Janeiro (RJ), com **R$ 2,13 bilhões**, Santa Catarina (SC), com **R$ 1,94 bilhão**, Rio Grande do Sul (RS), com
**R$ 1,83 bilhão**, Alagoas (AL), com **R$ 1,52 bilhão**, e Espírito Santo (ES), com **R$ 1,36 bilhão**.
A base possui **831 instituições públicas compradoras**, distribuídas entre 24 Unidades Federativas. Entretanto, o material analisado não apresenta
informações suficientes para estabelecer um ranking confiável dos municípios e das instituições individualmente.
A concentração estadual demonstra que São Paulo possui papel de destaque na movimentação financeira registrada na base. Apenas SP representa
aproximadamente **44% do valor total registrado**.

### 3 — Produtos com maior valor total e quantidade adquirida

A análise da base demonstra uma característica importante: **valor financeiro e quantidade adquirida não necessariamente estão relacionados**.
Foram registradas **57,1 bilhões de unidades**, enquanto o valor total das compras alcançou **R$ 48,88 bilhões**. A grande quantidade de unidades
é explicada principalmente pela aquisição de produtos de baixo custo, como medicamentos básicos, materiais de consumo e insumos hospitalares.
Por outro lado, produtos de maior complexidade e maior preço unitário podem representar valores financeiros elevados mesmo quando adquiridos em
quantidades relativamente menores.
O material analisado não apresenta um ranking completo dos produtos por **valor total acumulado** e por **quantidade adquirida**. Dessa forma,
não é possível apontar, com segurança, quais são os produtos líderes nessas duas dimensões sem acessar os dados detalhados da base.

### 4 - Comparação entre fornecedores e fabricantes

Foram identificados **3.502 fornecedores únicos**, responsáveis pelo fornecimento dos produtos registrados na base.
O ranking dos 10 maiores fornecedores por valor total apresenta forte presença de empresas do setor farmacêutico e hospitalar. Entre os principais
fornecedores estão **Onco Prod Distribuidora de Produtos Hospitalares e Oncológicos Ltda., Novartis Biociências S.A., Janssen-Cilag Farmacêutica
Ltda., AstraZeneca do Brasil Ltda., Cristália Produtos Químicos Farmacêuticos Ltda., CM Hospitalar S.A., Sulmedic Comércio de Medicamentos Ltda.,
Elfa Medicamentos S.A., Ativa Comercial Hospitalar Ltda. e Sanofi Medley Farmacêutica Ltda.**

Os 10 maiores fornecedores concentram aproximadamente **52% do valor total registrado**, indicando uma **elevada concentração do mercado**.
Essa concentração é especialmente relevante porque parte significativa dos fornecedores de maior valor está relacionada à comercialização de medica
mentos de alto custo e produtos especializados. Assim, a competição em número de empresas não significa necessariamente uma distribuição equilibrada
do valor financeiro.

A comparação entre fornecedores e fabricantes também deve considerar que **fornecedor e fabricante são dimensões diferentes**: uma empresa pode 
atuar como distribuidora de produtos fabricados por outras empresas. Por isso, uma análise de concentração por fabricante poderia apresentar
resultados diferentes do ranking por fornecedor.

### 5 — Evolução anual dos valores registrados

A base apresenta a evolução do gasto total entre **2020 e 2025**, permitindo observar a variação dos valores registrados ao longo do período.
O painel também apresenta a evolução do preço unitário médio ponderado para o mesmo intervalo.
A análise temporal deve ser interpretada considerando que os dados de **2026 são parciais**. Portanto, o ano de 2026 não deve ser comparado 
diretamente com anos completos.
O preço unitário médio ponderado registrado na base é de **R$ 0,86**, indicador que representa melhor o preço efetivamente pago por unidade,
considerando o peso da quantidade adquirida.

### 6 — Diferenças de preços unitários entre produtos comparáveis

A análise de dispersão de preços identificou diferenças relevantes nos preços unitários de determinados produtos, mesmo quando se trata do mesmo
produto e do mesmo ano.

Entre os casos destacados estão:

* **Alteplase**, em 2022: preço mínimo de **R$ 2.230,13** e máximo de **R$ 3.273**, com amplitude de **46,8%**;
* **Omalizumabe**, em 2022: preço mínimo de **R$ 1.504,85** e máximo de **R$ 2.593,41**, com amplitude de **72,3%**;
* **Tiotrópio brometo**, em 2025: preço mínimo de **R$ 281,30** e máximo de **R$ 364,99**, com amplitude de **29,8%**;
* **Cefalotina sódica**, em 2025: preço mínimo de **R$ 3,65** e máximo de **R$ 5,15**, com amplitude de **41,1%**;
* **Cianocobalamina**, em 2021: preço mínimo de **R$ 1,38** e máximo de **R$ 1,87**, com amplitude de **35,5%**.

Essas diferenças indicam **oportunidades potenciais de economia**, principalmente nos produtos que apresentam maior dispersão de preços.

Entretanto, a diferença de preço não deve ser interpretada automaticamente como sobrepreço. Características como fabricante, apresentação, 
quantidade adquirida, condições de contratação, região, fornecedor e período da compra podem justificar parte da variação observada.

### 7 — Recomendações fundamentadas nos dados

Com base nos resultados encontrados, são recomendadas as seguintes ações:

1. **Aumentar o monitoramento dos produtos com maior dispersão de preços**, priorizando aqueles que apresentam grandes diferenças entre preço
mínimo e máximo.
2. **Utilizar referências de preço nas compras públicas**, permitindo comparar novas aquisições com valores historicamente praticados para produtos
equivalentes.
3. **Investigar os produtos de alto valor financeiro**, principalmente medicamentos de alto custo e medicamentos oncológicos, devido ao impacto 
que pequenas variações de preço podem produzir no orçamento.
4. **Avaliar a concentração entre fornecedores**, especialmente porque os 10 maiores fornecedores representam aproximadamente 52% do valor 
registrado.
5. **Aprimorar a padronização dos dados**, principalmente nos campos relacionados a produto, fabricante, apresentação e unidade de medida, para 
facilitar comparações entre compras.
6. **Monitorar a evolução dos preços ao longo dos anos**, identificando produtos que apresentam aumentos persistentes ou variações atípicas.
7. **Priorizar análises por quantidade e valor simultaneamente**, evitando conclusões baseadas apenas no número de unidades adquiridas ou apenas 
no valor financeiro.

### 8 — Limitações da análise

A análise apresenta algumas limitações que devem ser consideradas na interpretação dos resultados:

* A base analisada possui dados de **24 Unidades Federativas**, não contemplando todas as UFs. O painel identifica **Amazonas, Amapá e Distrito 
Federal como unidades sem dados**.
* Os dados de **2026 são parciais**, portanto não representam um ano completo.
* O valor de **R$ 48,88 bilhões** representa os registros presentes na base e não necessariamente o total de todas as compras públicas de saúde 
realizadas no Brasil.
* A ausência de determinados entes federativos pode provocar **viés de representatividade**.
* Diferenças de preços entre compras não significam necessariamente sobrepreço, pois podem existir diferenças de fabricante, apresentação, 
quantidade, condições de contratação e outros fatores.
* A análise de municípios e instituições individuais não pode ser completamente detalhada com os dados apresentados no relatório visualizado.
* A identificação de fornecedores não deve ser confundida automaticamente com a identificação dos fabricantes dos produtos.
* A quantidade total de unidades pode reunir diferentes tipos de produtos e unidades de medida, o que exige cautela em comparações diretas.
* O preço unitário médio ponderado é mais representativo para avaliar o custo médio por unidade do conjunto, mas pode ocultar diferenças 
importantes entre categorias específicas de produtos.

## Síntese dos resultados

De forma geral, os dados revelam um mercado de compras públicas de saúde de **grande escala financeira e operacional**, com **R$ 48,88 bilhões 
registrados, 57,1 bilhões de unidades adquiridas, 342.039 registros, 12.992 processos de compra, 831 instituições compradoras e 3.502 fornecedores**.
Os resultados também indicam **concentração geográfica e econômica**, com São Paulo apresentando o maior valor registrado entre as UFs disponíveis 
e os 10 maiores fornecedores concentrando aproximadamente 52% do valor total.
Ao mesmo tempo, foram identificadas **diferenças relevantes nos preços unitários de produtos comparáveis**, criando oportunidades para utilização 
de dados históricos como instrumento de apoio à tomada de decisão e à busca por maior eficiência nas compras públicas.

---

## 🔄 SPRINT 6: Organização e publicação

**Checklist:**

- [X] Organizar os arquivos do projeto
- [X] Criar e revisar o arquivo README.md
- [X] Inserir imagens ou capturas do dashboard
- [ ] Publicar o projeto na Pasta Oficial de Projetos da Turma no GitHub
- [ ] Conferir se os arquivos e links estão acessíveis
- [ ] Gravar o vídeo de apresentação (até 5 minutos)
- [ ] Submeter o link do projeto e o vídeo na tarefa correspondente do AVA


---

## 📹 Roteiro do Vídeo (5 minutos)

1. **Objetivo do dashboard** (30s)
2. **Problema de gestão pública** (30s)
3. **Obtenção e consolidação dos dados** (1min)
4. **Tratamentos realizados na base** (1min)
5. **Como utilizar os filtros e visuais** (30s)
6. **KPIs desenvolvidos** (30s)
7. **Principais resultados encontrados** (1min)
8. **Recomendações** (30s)

---

## 📌 Limitações identificadas

1. **Alta proporção de "Não Informado" em `generico` (36,89%)** – isso afeta análises que dependem dessa classificação.
2. **Dados de 2026 incompletos** – o ano ainda não terminou.
3. **Colunas com muitos nulos** (`capacidade`, `unidade_medida`) foram removidas, limitando análises mais granulares.
4. **Possíveis variações de preço não capturadas** – não há informação sobre qualidade do produto ou condições de pagamento.
5. **Falta de dados de benchmark externo** – não foi possível comparar com preços de mercado.

---

## 🚀 Como reproduzir o projeto

### Pré-requisitos
- Python 3.8+
- Bibliotecas: pandas, unicodedata, warnings

### Passos
1. Clone o repositório
2. Instale as dependências: `pip install -r requirements.txt`
3. Execute o notebook `analise_bps_2020_2026_isaac_trenard.ipynb`
4. O arquivo `bps_consolidado_2020_2026.csv` será gerado na pasta `outputs/`
5. Abra o link do BigQuery para entender os tratamentos feitos ao longo da consolidacao das tabelas

---

**📅 Data de Entrega:** 14/09/2026 às 22:00 hrs
**🐙 Repositório:** [link do GitHub]
** BigQuery (consultas SQL e historico de jobs): [https://console.cloud.google.com/bigquery?ws=!1m4!1m3!3m2!1smini-projeto-bps-2020-a-2026!2smini_projeto_bps_saude]
**📊 Dashboard Visuais:** [https://datastudio.google.com/s/om1LVw3-Zz0]
