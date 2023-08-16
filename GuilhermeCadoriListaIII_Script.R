### Lista de Exercícios III
### Guilherme Cadori
### 28/03/2023

# Carregando biblioteca de trabalho
library(tidyverse)

setwd("C:/Guilherme/MSc/Disciplinas/2023-03 MÉTODOS COMPUTACIONAIS EM ESTATÍSTICA E OTIMIZAÇÃO/Aula 3")

dados3 <- read.csv2("Dados_Estatisticos.csv", skip = 1)

# Conferindo os dados importados
view(head(dados3))

str(dados3)


### Q1) Considere que é de interesse visualizar a série temporal (anual) do número de decolagens para as 10
#     empresas nacionais que mais decolaram no período disponível de dados. Faça duas visualizações uma
#     para enfatizar a comparação entre as empresas e outra para enfatizar a visualização da série de cada
#     empresa. Considere apenas os registros que tenham o número de decolagens.

# Agrupando dados: 10 empresas nacionais que mais decolaram durante todo o período, DESCONSIDERANDO NAs

# Criando subset das empresas de interesse
dadosSub_Q1 <- subset(dados3, EMPRESA_NACIONALIDADE == "BRASILEIRA" & EMPRESA_SIGLA != "")

dadosSub_Q1Viz <- dadosSub_Q1 %>%
                    group_by(EMPRESA_SIGLA) %>%
                    summarise(DecolagensTotal = sum(DECOLAGENS, na.rm = TRUE)) %>%
                    arrange(desc(DecolagensTotal)) %>%
                    top_n(DecolagensTotal, n=10)

view(dadosSub_Q1Viz) # Visualizando seleção ordenada

# Output: 10 empresas ordenadas que mais decolaram no período
# EMPRESA_SIGLA DecolagensTotal
# <chr>                   <int>
# 1 TAM                   5270737
# 2 GLO                   4619696
# 3 AZU                   2817845
# 4 VRG                    995185
# 5 ONE                    773653
# 6 TIB                    639868
# 7 VSP                    382575
# 8 RSL                    335479
# 9 PTB                    297413
# 10 TTL                    20558

# Criando um vetor para extrair apenas as empreasas de interesse da base de dados
dadosSub_Q1Vec <- c(dadosSub_Q1Viz$EMPRESA_SIGLA)

# Conferindo vetor criado
dadosSub_Q1Vec 

# Utilizando o vetor para criar um subset com empresas-alvo e anos do período de avaliação
dadosSub_Q1_vecSec <- subset(dados3, EMPRESA_SIGLA %in% dadosSub_Q1Vec)

# Agrupando dados por ano e por empresa e oerdenando por ano
dadosSub_vecSecViz <- dadosSub_Q1_vecSec %>%
                        group_by(ANO, EMPRESA_SIGLA) %>%
                        summarize(DecolagensTotal = sum(DECOLAGENS, na.rm = TRUE)) %>%
                        arrange(ANO) %>%
                        top_n(10)

# Plotando gráfico 1: 
# Série temporal comparando a quantidade de decolagens para as 10 empresas que mais decolaram no período
ggplot(data = dadosSub_vecSecViz,
       mapping = aes(x = ANO,
                     y = DecolagensTotal,
                     color = EMPRESA_SIGLA)) +
       geom_point() +
       geom_line()


# Plotando gráfico 2:
# Série temporal individualizada para cada empresa
ggplot(dadosSub_vecSecViz,
       mapping = aes(x = ANO,
                     y = DecolagensTotal,
                     color = EMPRESA_SIGLA)) +
  geom_point() +
  geom_line() +
  facet_wrap(~ EMPRESA_SIGLA)



### Q2) Faça uma visualização de dados comparar o número de passageiros pagantes entre empresas nacionais e
# estrangeiras ao longo dos anos.

# Criando subset para criação dos gráficos
dadosSub_Q2 <- subset(dados3, EMPRESA_SIGLA != "")

# Agrupando dados de passageiros pagantes por nacionalidade da compania aérea por ano
dadosSub_Q2Viz <- dadosSub_Q2 %>%
  group_by(ANO, EMPRESA_NACIONALIDADE) %>%
  summarise(PassageirosPagantesTotal = sum(PASSAGEIROS_PAGOS, na.rm = TRUE)) %>%
  arrange(ANO)

# Conferindo agrupamento
view(dadosSub_Q2Viz)

# Plotando gráfico de passageiros pagantes por nacionalidade da compania aérea ao longo do tempo 
ggplot(data = dadosSub_Q2Viz,
       mapping = aes(x = ANO,
                     y = PassageirosPagantesTotal,
                     fill = EMPRESA_NACIONALIDADE)) +
  geom_col(position = "dodge")



## 3) Faça uma visualização de dados comparar o número de passageiros pagantes 
##    entre empresas nacionais e estrangeiras de acordo com o grupo de voo.

# Conferindo valores únicos para grupo de voo
colnames(dados3)

unique(dados3$GRUPO_DE_VOO)

# Criando subset de dados para manipulação
dados3_fix <- subset(dados3, GRUPO_DE_VOO != "" & EMPRESA_SIGLA != "")

# Conferindo subset
unique(dados3_fix$GRUPO_DE_VOO)

unique(dados3_fix$EMPRESA_SIGLA)

# Ajustando valores na variável "GRUPO_DE_VOO"
dados3_fix$GRUPO_DE_VOO <- ifelse(dados3_fix$GRUPO_DE_VOO == "N\xc3O REGULAR", "NÃO REGULAR",
                          ifelse(dados3_fix$GRUPO_DE_VOO == "N\xc3O IDENTIFICADO", "NÃO IDENTIFICADO",
                                 dados3_fix$GRUPO_DE_VOO))

# Conferindo ajustes
unique(dados3_fix$GRUPO_DE_VOO)

# Agrupando a quantidade de passageiros pagantes por empresas nacionais e internacionais
# de acordo com seu grupo de voo
dados3_fix_Viz <- dados3_fix %>%
  group_by(EMPRESA_NACIONALIDADE, GRUPO_DE_VOO) %>%
  summarise(QtPassageirosPagantes = sum(PASSAGEIROS_PAGOS, na.rm = TRUE))

# Conferindo agrupamento
dados3_fix_Viz

# Output:
# Groups:   EMPRESA_NACIONALIDADE [2]
# EMPRESA_NACIONALIDADE GRUPO_DE_VOO     QtPassageirosPagantes
# <chr>                 <chr>                            <int>
# 1 BRASILEIRA            IMPRODUTIVO                     360220
# 2 BRASILEIRA            NÃO IDENTIFICADO                     0
# 3 BRASILEIRA            NÃO REGULAR                   64015112
# 4 BRASILEIRA            REGULAR                     1536110010
# 5 ESTRANGEIRA           IMPRODUTIVO                      17820
# 6 ESTRANGEIRA           NÃO REGULAR                    6432065
# 7 ESTRANGEIRA           REGULAR                      211668460

# Plotando gráfico
ggplot(data = dados3_fix_Viz,
       mapping = aes(x = EMPRESA_NACIONALIDADE,
                     y = QtPassageirosPagantes,
                     fill = GRUPO_DE_VOO)) +
  geom_col(position = "stack")


# Se preferir, plote o gráfico abaixo com o eixo y transformado utilizando o log na base 10
# Dessa forma é possível visualizar de forma mais distinta os grupos de voo dentro do total
# de passargeiro pagantes
ggplot(data = dados3_fix_Viz,
       mapping = aes(x = EMPRESA_NACIONALIDADE,
                     y = QtPassageirosPagantes,
                     fill = GRUPO_DE_VOO)) +
  scale_y_log10() +
  geom_col(position = "stack")


## Q4) Faça uma visualização para enfatizar a distribuição da variável número de passageiros 
#      pagantes de acordo com a região de origem e natureza do voo. Enfatize a comparação entre
#      DOMÉSTICA e INTERNACIONAL para cada região de origem. 
#      Para criar o gráfico use o log10 da variável PASSAGEIROS_PAGOS.

# Craindo subset de dados
dadosSub_Q4 <- dados3_fix

# Conferindo variáveis que serão utilizadas
str(dadosSub_Q4)

# Conferindo valores únicos da variável NATUREZA
unique(dadosSub_Q4$NATUREZA)
unique(dadosSub_Q4$AEROPORTO_DE_ORIGEM_REGIAO)

# Ajustando valores da variável NATUREZA
dadosSub_Q4$NATUREZA<- ifelse(dadosSub_Q4$NATUREZA == "DOM\xc9STICA", "DOMÉSTICA", dadosSub_Q4$NATUREZA)

# Agrupando a quantidade de passageiros pagantes por região de origem e para empresas domésticas e internacionais
# de acordo com a natureza do vôo
dados4_Viz <- dadosSub_Q4 %>%
  group_by(AEROPORTO_DE_ORIGEM_REGIAO, NATUREZA, EMPRESA_NACIONALIDADE) %>%
  summarise(QtPassageirosPagantes = sum(PASSAGEIROS_PAGOS, na.rm = TRUE))

# Conferindo agrupamento
dados4_Viz

## Removendo valores faltantes em AEROPORTO_DE_ORIGEM_REGIAO
dados4_VizFix <- subset(dados4_Viz, AEROPORTO_DE_ORIGEM_REGIAO != "" & AEROPORTO_DE_ORIGEM_REGIAO != " ")

# Conferindo dados
dados4_VizFix

# Output:
# Groups:   AEROPORTO_DE_ORIGEM_REGIAO, NATUREZA [10]
# AEROPORTO_DE_ORIGEM_REGIAO NATUREZA      EMPRESA_NACIONALIDADE QtPassageirosPagantes
# <chr>                      <chr>         <chr>                                 <int>
# 1 CENTRO-OESTE               DOMÉSTICA     BRASILEIRA                        197828398
# 2 CENTRO-OESTE               INTERNACIONAL BRASILEIRA                           990540
# 3 CENTRO-OESTE               INTERNACIONAL ESTRANGEIRA                         2337837
# 4 NORDESTE                   DOMÉSTICA     BRASILEIRA                        281572659
# 5 NORDESTE                   INTERNACIONAL BRASILEIRA                          1437363
# 6 NORDESTE                   INTERNACIONAL ESTRANGEIRA                         7300091
# 7 NORTE                      DOMÉSTICA     BRASILEIRA                         90084771
# 8 NORTE                      INTERNACIONAL BRASILEIRA                           898732
# 9 NORTE                      INTERNACIONAL ESTRANGEIRA                         1073650
# 10 SUDESTE                    DOMÉSTICA     BRASILEIRA                        723986931
# 11 SUDESTE                    INTERNACIONAL BRASILEIRA                         51437024
# 12 SUDESTE                    INTERNACIONAL ESTRANGEIRA                        91736771
# 13 SUL                        DOMÉSTICA     BRASILEIRA                        189469779
# 14 SUL                        INTERNACIONAL BRASILEIRA                          3103096
# 15 SUL                        INTERNACIONAL ESTRANGEIRA                         3308953


# Plotando gráfico para o agrupamento realizado
ggplot(data = dados4_VizFix,
       mapping = aes(x = AEROPORTO_DE_ORIGEM_REGIAO,
                     y = QtPassageirosPagantes,
                     fill = NATUREZA)) +
  scale_y_log10() +
  geom_col(position = "stack")



## Q5) Crie uma variável que indique a eficiencia no uso do combustível como sendo a razão entre o DISTANCIA_VOADA_KM
#     e COMBUSTIVEL_LITROS. Compare as empresas de acordo com a região de origem e destino.
#     Use a escala y em log10 para facilitar a comparação das regiões.

# Craindo subset de trabalho
dadosSub_Q5 <- dadosSub_Q4

dadosSub_Q5 <- subset(dadosSub_Q5,
                      AEROPORTO_DE_ORIGEM_SIGLA != "" &
                      AEROPORTO_DE_ORIGEM_REGIAO != "" & 
                      AEROPORTO_DE_ORIGEM_REGIAO != " " &
                      AEROPORTO_DE_DESTINO_REGIAO != "" & 
                      AEROPORTO_DE_DESTINO_REGIAO != " " &
                      !is.na(DISTANCIA_VOADA_KM) &
                      !is.na(COMBUSTIVEL_LITROS))


# Conferindo variáveis a serem utilizadas no cálculo da eficiência
str(dadosSub_Q5)

# Criando variável de eficiência de vôo (km/L) e adicionado à base de dados
dadosSub_Q5$EficienciaVoo <- dadosSub_Q5$DISTANCIA_VOADA_KM / dadosSub_Q5$COMBUSTIVEL_LITROS

# Removendo registror com valores nulos
dadosSub_Q5_fix <- subset(dadosSub_Q5, EficienciaVoo != "")

# Conferindo subset corrigido
view(head(dadosSub_Q5_fix))

# Criando variável combinando região de origem e reigão de destino para agrupamento das empresas 
dadosSub_Q5_fix$Combincao_OrigDest <- paste(dadosSub_Q5_fix$AEROPORTO_DE_ORIGEM_REGIAO, 
                                            dadosSub_Q5_fix$AEROPORTO_DE_DESTINO_REGIAO, 
                                            sep = "-")

# Conferindo nova variável criada
head(dadosSub_Q5_fix)

# Agrupando empresas por grupo ORIGEM-DESTINO e calculando a média da efiência de cada empresa dentro do mesmo grupo
dadosSub_Q5_Viz <- dadosSub_Q5_fix %>%
  group_by(Combincao_OrigDest, EMPRESA_SIGLA) %>%
  summarise(EficienciaMediaVoo = mean(EficienciaVoo, na.rm = TRUE))

# Conferindo grupos criados
head(dadosSub_Q5_Viz)

# Limpando valores de média com problemas
dadosSub_Q5_VizFix <- subset(dadosSub_Q5_Viz,
                             EficienciaMediaVoo != Inf &
                             !is.nan(EficienciaMediaVoo) &
                             EficienciaMediaVoo != 0)
# Conferindo dados limpos
dadosSub_Q5_VizFix

# Plotando gráfico de eficiência de voo das empresas agrupadas por região de origem e destino 
# e utilizando o eixo y (eficiência de voo) na escala log10 para facilitar a comparação das regiões
ggplot(data = dadosSub_Q5_VizFix,
       mapping = aes(x = Combincao_OrigDest,
                     y = EficienciaMediaVoo,
                     fill = EMPRESA_SIGLA)) +
  labs(x = "Trecho de Vôo: Origem-Destino", y = "Eficiência Média de Vôo (km/L)",
       title = "Efiência Média de Vôo por Empresa por Trechos de Vôo") +
  scale_y_log10() +
  geom_col(position = "dodge") +
  facet_wrap(~ Combincao_OrigDest, scales = "free") +
  theme(strip.text.x = element_blank())
# GC: Utilizei o facet wrap para deixar a visualização mais limpa
#     e possibilitar a comparação em cada combinição de regiões   



## Q6) 
### Faça uma visualização para mostrar a relação entre o consumo de combustível e a distância voada. 
### Considere empresas nacionais e internacionais e os diferentes anos para enriquecer a visualização. 
### Considere transformar as variáveis e use alguma forma estatística para enfatizar a forma do relacionamento 

# Criando subset de dados
dadossub_q6 <- dados3 %>%
  filter() %>%
  drop_na(COMBUSTIVEL_LITROS) %>%
  drop_na(DISTANCIA_VOADA_KM) %>%
  group_by(ANO, EMPRESA_NACIONALIDADE, EMPRESA_NOME) %>%
  summarise(total_comb = sum(COMBUSTIVEL_LITROS), total_dist = sum(DISTANCIA_VOADA_KM)) %>%
  mutate(consumo = total_dist/total_comb) %>%
  arrange(consumo) %>%
  head(10)

# Criando variável de consumo médio de combustível
dadossub_q6New <- transform(dados3,DISTANCIA_VOADA_KM = as.integer(DISTANCIA_VOADA_KM))

dadossub_q6New["Média de Consumo"] <- dados3$COMBUSTIVEL_LITROS / dados3$DISTANCIA_VOADA_KM

ggplot(data = dadossub_q6New, 
       mapping = aes(x = COMBUSTIVEL_LITROS, 
                     y = DISTANCIA_VOADA_KM,
                     color = ANO,
                     shape = EMPRESA_NACIONALIDADE)) +
  labs(x = "Consumo de Combustível (L)",
       y = "Distância Voada (km)") +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm")


### Questão 7
# Há sim incosistência com os dados. Tal fato fica evidentemente claro quando
# observamos os registros plotados ao longo do eixo de Distância Voada (eixo y).
# Esse comportamento indica a possibilidade de os dados de Consumo de Combustível (eixo x)
# terem sido registrados na unidade errada ou até mesmo não terem sido registrados. 
# Além disso, a presença de outliers na porção inferior do gráfico pode indicar a falha
# no registro da distância voada ou do consumo de combustível, umas vez que tais observações
# fogem do padrão esperando de comportamento.


# Questão 8
subsSet_Q8 <-  dados3 %>%
  filter(EMPRESA_NACIONALIDADE == "BRASILEIRA", COMBUSTIVEL_LITROS > 0,
         DISTANCIA_VOADA_KM>0,AEROPORTO_DE_ORIGEM_REGIAO!= "")

ggplot(data = subsSet_Q8, 
       mapping = aes(x = COMBUSTIVEL_LITROS, 
                     y = DISTANCIA_VOADA_KM, 
                     color = AEROPORTO_DE_ORIGEM_REGIAO)) +
  labs(x = "Consumo de Combustível (L)",
       y = "Distância Voada (km)") +
  geom_point(alpha = 0.1) +
  geom_smooth(method = "lm")


# Questão 9
# O indicador RTK (Revenue tonne kilometer) refere-se ao volume de toneladas quilômetros transportada.
# Faça uma visualização da relação deste indicador com o consumo de combustível. Filtre apenas
# observações com ambas variáveis maiores que zero. Considere também que é de interesse comparar essa
# relação entre os diferentes anos. Considere incluir alguma camada estatística para enfatizar o formato
# do relacionamento entre as variáveis.

subSet_Q9 <- dados3 %>% 
  filter(RTK > 0, COMBUSTIVEL_LITROS > 0) %>%
  select(ANO, RTK, COMBUSTIVEL_LITROS) %>%
  group_by(ANO) %>%
  summarise (RTK_MediaAno = mean(RTK), ConsumoCombustivelMediAno = mean(COMBUSTIVEL_LITROS))

ggplot(data = subSet_Q9, 
       mapping = aes(x = RTK_MediaAno, 
                     y = ConsumoCombustivelMediAno,
                     color = ANO)) +
       labs(x = "RTK Médio por Ano",
            y = "Consumo Médio Combustível (L/ano)") +
       geom_point() +
       geom_line() +
       geom_smooth(method = "lm")



# 10)
# O indicador ATK (Available tonne kilometer) refere-se ao volume de tonelada quilômetro oferecida pela
# companhia. Crie uma visualização para explorar a relação entre estes indicadores. Considere aspectos
# como GRUPO_DE_VOO e NATUREZA além do anos.

# Criando subset de trabalho
subSet_Q10 <- dados3


# Ajustando valores NA
subSet_Q10New <- subSet_Q10 %>% replace_na(list(PASSAGEIROS_PAGOS = 0,PASSAGEIROS_GRATIS = 0,
                                                CARGA_PAGA_KG = 0, CARGA_GRATIS_KG = 0,
                                                CORREIO_KG = 0,ASK = 0, RPK = 0, ATK = 0,
                                                RTK =0,COMBUSTIVEL_LITROS = 0,
                                                DISTANCIA_VOADA_KM = 0, DECOLAGENS = 0,
                                                CARGA_PAGA_KM = 0,CARGA_GRATIS_KM = 0, 
                                                CORREIO_KM = 0, ASSENTOS = 0, PAYLOAD = 0,
                                                HORAS_VOADAS = 0,BAGAGEM_KG = 0))

# Ajustando valores em Grupo de Vôo
unique(subSet_Q10New$GRUPO_DE_VOO)

subSet_Q10New <- subSet_Q10New %>%
                  mutate(GRUPO_DE_VOO = case_when(
                    GRUPO_DE_VOO == "N\xc3O REGULAR" ~ "NÃO REGULAR",
                    GRUPO_DE_VOO == "N\xc3O IDENTIFICADO" ~ "NÃO IDENTIFICADO",
                    TRUE ~ GRUPO_DE_VOO
                  ))

# Ajustando valores em Natureza
unique(subSet_Q10New$NATUREZA)

subSet_Q10New <- subSet_Q10New %>%
  mutate(NATUREZA = case_when(
    NATUREZA == "DOM\xc9STICA" ~ "DOMÉSTICA",
    TRUE ~ NATUREZA
  ))

# Criando grupos
subSet_Q10New_fix <- subSet_Q10New %>%
                      select(ANO, ATK, GRUPO_DE_VOO, NATUREZA) %>%
                      filter(GRUPO_DE_VOO != "", NATUREZA != "") %>%
                      group_by(ANO, GRUPO_DE_VOO, NATUREZA) %>%
                      summarise(ATKMedio_Grupo = mean(ATK))

# Criando gráfico
ggplot(data = subSet_Q10New_fix,
       mapping = aes(x = ANO,
                     y = ATKMedio_Grupo,
                     color = GRUPO_DE_VOO,
                     shape = NATUREZA)) +
       labs(x = "Ano",
            y = "ATK Médio por Grupo de Vôo") +
  geom_point(alpha = 0.8) +
  geom_smooth(method = "loess", span = 100)


