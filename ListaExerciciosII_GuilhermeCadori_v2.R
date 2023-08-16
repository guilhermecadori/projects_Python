## Lista de Exercícios II
## Guilherme Cadori
## 20/03/2023

## Carregando pacote tidyverse
library(tidyverse)

## Importando dados
#url <- "https://sistemas.anac.gov.br/dadosabertos/Voos%20e%20opera%C3%A7%C3%B5es%20a%C3%A9reas/Dados%20Estat%C3%ADsticos%20do%20Transporte%20A%C3%A9reo/Dados_Estatisticos.csv"
#dados <- read.csv(url, skip = 1, col.names = TRUE)
#head(dados)
## GC: Estou tendo um erro de timeout ao tentar ler os dados diretamente do link e mesmo tentando ajustar o timeout, o erro persiste


## GC: Irei utilizar os dados em minha máquina local após salvar o arquivo obtido pelo link fornecido
## GC: Dados foram atualizados em 24/03/2023
setwd("C:/Users/gcadori/OneDrive - Resource Management Service, LLC/Área de Trabalho")
dadosLocal <- "Dados_Estatisticos.csv" ## Salvos no diretório de trabalho local
dados <- read.csv2(dadosLocal, skip = 1)

## Conferindo os dados importados
view(head(dados))

view(colnames(dados))

str(dados)



## Ex 1) Quantas empresas nacionais e internacionais operam no mercado brasileiro?

# Conferindo quantos nomes ÚNICOS de empresas existem E quantas empresas operam no Brasil
view(unique(dados$EMPRESA_NOME))

# Agrupando os nomes por pais
grupoPais <- group_by(dados, EMPRESA_NACIONALIDADE, EMPRESA_NOME)

# Contando os nomes por pais, omitindo registros com NA
grupoPais2 <- summarize(grupoPais, QtEmpresas = n()) 


# Calculando o total de empresas que operaram e sumarizando a quantidades de empresa por país
summaryTable <- summarize(grupoPais2, QtEmpresas = n())

summaryTotal <- sum(summaryTable$QtEmpresas)

# Total de empresas e total por nacionalidade
view(summaryTotal)

view(summaryTable)

# Output: 
# Tabela indicando que há 299 atuando no mercado brasieliro.
# Tabela indicando que 59 empresas são brasileiras e 240 empresas são de origem interncaional.

# [1] 299

# EMPRESA_NACIONALIDADE QtEmpresas
# <chr>                      <int>
# 1 BRASILEIRA                    59
# 2 ESTRANGEIRA                  240



## Ex 2) Considerando apenas empresas nacionais e o ano de 2020. Qual é a região de origem com maior número
##       de decolagens? Apresente o resultado em uma tabela ordenada do maior para o menor.

# Criando um subset dos dados
dadosSub <- subset(dados, EMPRESA_NACIONALIDADE == "BRASILEIRA" & ANO == 2020)

# Conferindo quantas nacionalidades do subset
unique(dadosSub$EMPRESA_NACIONALIDADE)

# Conferindo anos do subset
unique(dadosSub$ANO)

# Agrupando os dados para identificar regiões de origem com maior número de decolagens
view(dadosSub %>%
  group_by(AEROPORTO_DE_ORIGEM_REGIAO) %>% 
           summarize(QtDecolagens = sum(na.omit(DECOLAGENS))) %>% 
           arrange(desc(QtDecolagens)))
          
# Output: 
# A região de origem com maior número de descolagens é a região Sudeste. 
# A tabela de output indica quais são as regiões com maior quantidade de decolagens, ordenada da maior para a menor quantidade.

# AEROPORTO_DE_ORIGEM_REGIAO QtDecolagens
# <chr>                             <int>
# 1 "SUDESTE"                        208678
# 2 "NORDESTE"                        77268
# 3 "CENTRO-OESTE"                    51461
# 4 "SUL"                             48840
# 5 "NORTE"                           31719
# 6 ""                                 9788



## Ex 3) Considerando apenas empresas nacionais. Faça uma tabela comparando o número de decolagens de
##       acordo com a região de origem para cada ano. Organize a tabela resultante no formato wide com regiões
##       lado a lado e ANO nas linhas.

# Produzindo um subset dos dados
dadosSub_Q3 <- subset(dados, EMPRESA_NACIONALIDADE == "BRASILEIRA" & AEROPORTO_DE_ORIGEM_REGIAO != "")
dadosSub_Q3_Clean <- subset(dadosSub_Q3, !is.na(AEROPORTO_DE_ORIGEM_REGIAO))

# Conferindo subset
unique(dadosSub_Q3_Clean$EMPRESA_NACIONALIDADE)
unique(dadosSub_Q3_Clean$AEROPORTO_DE_ORIGEM_REGIAO)
unique(dadosSub_Q3_Clean$ANO)

# Criando uma variável para a tabela agrupada que será re-arranjada em formato wide abaixo
dadosSub_Q3_NEW <- dadosSub_Q3_Clean %>%
                   group_by(ANO, AEROPORTO_DE_ORIGEM_REGIAO) %>% 
                   summarise(DecolagensTotal = sum(na.omit(DECOLAGENS)))

# Re-arranjando a tabelo em formato wide
ArrangedDados_Q3 <- dadosSub_Q3_NEW %>%
                    pivot_wider(names_from = AEROPORTO_DE_ORIGEM_REGIAO , values_from = DecolagensTotal)

# Conferindo a tabela ajustada
view(ArrangedDados_Q3)

# Output: 
## Tabela indicando a quantidade de decolagens em cada ano (linhas) para cada região (colunas)

# ANO `CENTRO-OESTE` NORDESTE NORTE SUDESTE    SUL
# <int>          <int>    <int> <int>   <int>  <int>
# 1  2000          77567   127957 72759  332422 108386
# 2  2001          78618   140684 72698  352550 113148
# 3  2002          81633   119631 69021  335966  93443
# 4  2003          68511    94912 61163  260122  72276
# 5  2004          66684    99503 52237  255666  69383
# 6  2005          73647    97691 54205  277931  75070
# 7  2006          74801   110823 57934  283542  77631
# 8  2007          82788   114789 65952  304544  89904
# 9  2008          90823   112979 66405  316750  94063
# 10 2009         103880   124451 64281  354896 108209



## Ex 4) Considerando empresas nacionais e internacionais. Quais são as cinco empresas que mais voaram em
##       termos de horas de voo no ano de 2020? 
dadosSub_Q4 <- subset(dados, ANO == 2020)

# Conferindo anos do subset
unique(dadosSub_Q4$ANO)

# Agrupando dados e exibindo a tabela-alvo
view(dadosSub_Q4 %>%
  group_by(EMPRESA_NOME) %>% 
  summarize(HorasDeVoo = sum(na.omit(HORAS_VOADAS))) %>% 
  arrange(desc(HorasDeVoo)) %>%
  top_n(5))

# Output: 
# A tabela de output indica quais são as empresas que mais voaram em termos de horas em 2020.

# EMPRESA_NOME                                        HorasDeVoo
# <chr>                                                    <dbl>
# 1 AZUL LINHAS A�REAS BRASILEIRAS S/A                    1468553.
# 2 GOL LINHAS A�REAS S.A. (EX- VRG LINHAS A�REAS S.A.)   1176063.
# 3 TAM LINHAS A�REAS S.A.                                 914176.
# 4 AZUL CONECTA LTDA. (EX TWO TAXI AEREO LTDA)            307808.
# 5 ABSA - AEROLINHAS BRASILEIRAS S.A.                     191868.



## Ex 5) Considerando apenas empresas internacionais. Para o ano de 2022, quais são as cinco empresas que
##       mais carregaram passageiros de forma gratuita?
dadosSub_Q5 <- subset(dados, EMPRESA_NACIONALIDADE == "ESTRANGEIRA" & ANO == 2022)

# Conferindo nacionalidade
unique(dadosSub_Q5$EMPRESA_NACIONALIDADE)

# Conferindo ano
unique(dadosSub_Q5$ANO)

# Agrupudando e exbibindo a tabela-alvo
view(dadosSub_Q5 %>%
  group_by(EMPRESA_NOME) %>% 
  summarize(PassageirosGratis = sum(na.omit(PASSAGEIROS_GRATIS))) %>% ## utilizei a função summariZe(), com "Z"
  arrange(desc(PassageirosGratis)) %>%
  top_n(5))

# Output: 
# A tabela de output indica quais são as cinco empresas que mais carregaram passageiros de forma gratuita em 2022.

# EMPRESA_NOME                                       Passageiro…¹
# <chr>                                                     <int>
# 1 AMERICAN AIRLINES, INC.                                   32039
# 2 LATAM AIRLINES GROUP (EX - LAN AIRLINES S/A)              26457
# 3 UNITED AIRLINES, INC                                      23248
# 4 TAP - TRANSPORTES A�REOS PORTUGUESES S/A                  16491
# 5 COMPA�IA PANAME�A DE AVIACION S.A. (COPA AIRLINES)        10871



## Ex 6) Considerando o consumo de combustível por distancia voada em km. Qual empresa nacional tem a menor
##       taxa média de consumo, considerando o ano de 2022? Considere o consumo como a distancia/combustivel
##       e ignore voos com NA.

dados_Q6 <- subset(dados, EMPRESA_NACIONALIDADE != "ESTRANGEIRA" & ANO == 2022)

# Calculando consumo em km/L
dados_Q6$TaxaMdCons <- dados_Q6$DISTANCIA_VOADA_KM / dados_Q6$COMBUSTIVEL_LITROS

# Conferindo cálculos
head(dados_Q6$TaxaMdCons)

# Ajustando subconjunto de dados para não conter NA nem divisões por 0
dados_Q6_Adj <- subset(dados_Q6, !is.na(TaxaMdCons))
dados_Q6_Clean <- subset(dados_Q6_Adj, !is.infinite(TaxaMdCons))

# Agrupando dados por empresa e calculando a MÉDIA do consumo em km/L, 
# indicando qual empresa na média apresentou a menor taxa de consumo
view(dados_Q6_Clean %>%
  group_by(EMPRESA_NOME) %>% 
  summarise(TxMdConsCalc = mean(TaxaMdCons)) %>% ## utilizei a função summariSe(), com "S"
  slice_tail(n = 1))

# Output: "TOTAL LINHAS AÉREAS S.A." é a empresa com o menor consumo médio de combustível (km/L)        

# EMPRESA_NOME             TxMdConsCalc
# <chr>                           <dbl>
# 1 TOTAL LINHAS A�REAS S.A.        0.162



## Ex 7) Considere voos saindo do sudeste. Ordene as UFs de destino de acordo com sua frequência (linhas na
##       base de dados).
dados_Q7 <- subset(dados, AEROPORTO_DE_ORIGEM_REGIAO == "SUDESTE" & AEROPORTO_DE_DESTINO_UF != "")
dados_Q7_Clean <- subset(dados_Q7, !is.na(AEROPORTO_DE_DESTINO_UF))


unique(dados_Q7_Clean$AEROPORTO_DE_ORIGEM_REGIAO) # conferindo subset
unique(dados_Q7_Clean$AEROPORTO_DE_DESTINO_UF) # conferindo subset
str(dados_Q7_Clean) # conferindo subset

# Tabela agrupando e ordenado aeroportos de destino com maior frequência de pousos
view(dados_Q7_Clean %>%
       group_by(AEROPORTO_DE_DESTINO_UF) %>% 
       summarize(FreqDest = na.omit(n())) %>% ## utilizei a função summariZe(), com "Z"
       arrange(desc(FreqDest)))

# Output: Tabela com UF destinos ordenados em função da frequência de ocorrência, para voo saindo do sudest

# AEROPORTO_DE_DESTINO_UF FreqDest
# <chr>                      <int>
# 1 SP                         63043
# 2 MG                         31590
# 3 RJ                         26117
# 4 BA                         22619
# 5 PR                         17171
# 6 DF                         11606
# 7 SC                         10749
# 8 RS                         10101
# 9 PE                          8813
# 10 CE                          7713



## Ex 8) Qual é o aeroporto de origem mais frequente de voos NÃO REGULARES (veja a coluna GRUPO DE VOO)?
unique(dados$GRUPO_DE_VOO) # conferindo subset

dados_Q8 <- subset(dados, 
                   GRUPO_DE_VOO != "REGULAR" & 
                   GRUPO_DE_VOO != "IMPRODUTIVO" &
                   !is.na(GRUPO_DE_VOO) &
                   grepl("IDENTIFICADO",GRUPO_DE_VOO) != TRUE)

unique(dados_Q8$GRUPO_DE_VOO) # conferindo subset

view(dados_Q8 %>%
       group_by(AEROPORTO_DE_ORIGEM_NOME) %>% 
       summarize(FreqOrigem = na.omit(n())) %>% ## utilizei a função summariZe(), com "Z"
       arrange(desc(FreqOrigem)) %>%
       top_n(1))

# Output: Tabela de um único registro indicando Guarulhos como aeroporto de origem mais frequente de vôo não regulares.

# AEROPORTO_DE_ORIGEM_NOME FreqOrigem
# <chr>                         <int>
# 1 GUARULHOS                     20920



## Ex 9) Considere os voos DOMESTICOS e a proporção de voos NÃO REGULAR. Quais são os 10 aeroportos
##       de destino mais frequente?
dados_Q9 <- dados_Q8

unique(dados_Q9$NATUREZA) # conferindo subset

dados_Q9_Clean <- subset(dados_Q9, NATUREZA != "INTERNACIONAL")

unique(dados_Q9_Clean$NATUREZA) # conferindo subset
unique(dados_Q9_Clean$GRUPO_DE_VOO) # conferindo subset

view(dados_Q9_Clean %>%
       group_by(AEROPORTO_DE_DESTINO_NOME) %>% 
       summarize(AeroportoDestFreq = na.omit(n())) %>% ## utilizei a função summariZe(), com "Z"
       arrange(desc(AeroportoDestFreq)) %>%
       top_n(10))

# Output: Tabela com 10 registros indicando os aeroportos mais frequentes como destino.

# AEROPORTO_DE_DESTINO_NOME AeroportoDestFreq
# <chr>                                 <int>
# 1 GUARULHOS                             15772
# 2 RIO DE JANEIRO                        12243
# 3 S�O PAULO                              9404
# 4 BRAS�LIA                               8043
# 5 CAMPINAS                               7761
# 6 SALVADOR                               7455
# 7 CONFINS                                7322
# 8 MANAUS                                 6870
# 9 RECIFE                                 6255
# 10 FORTALEZA                              6074



## Ex 10) Considere todas as combinações de aeroportos de origem e destino. Quais são as dez combinações mais
##        frequentes em termos de total de decolagens?
dados_Q10 <- dados

dados_Q10$CombOrigDest <- paste(dados_Q10$AEROPORTO_DE_ORIGEM_SIGLA, 
                                dados_Q10$AEROPORTO_DE_DESTINO_SIGLA, 
                                sep = "-")

head(dados_Q10$CombOrigDest)

view(dados_Q10 %>%
       group_by(CombOrigDest) %>% 
       summarize(CombOrigDestFreq = na.omit(n())) %>% ## utilizei a função summariZe(), com "Z"
       arrange(desc(CombOrigDestFreq)) %>%
       top_n(10))

# Output: Tabela indicando as 10 combinações de origem-destino mais frequentes em termos totais.

# CombOrigDest CombOrigDestFreq
# <chr>                   <int>
# 1 SBGL-SBGR                4473
# 2 SBGR-SBGL                3973
# 3 SBPA-SBGR                2610
# 4 KMIA-SBKP                2598
# 5 SBSV-SBGR                2573
# 6 SBGR-SAEZ                2527
# 7 SBBR-SBGR                2507
# 8 SAEZ-SBGR                2418
# 9 SBCT-SBGR                2395
# 10 SBGR-SBSV                2375









