### Lista de Exercícios IV
### Guilherme Cadori
### 06/04/2023

# Configurando diretório de trabalho
setwd("C:/Guilherme/MSc/Disciplinas/2023-03 MÉTODOS COMPUTACIONAIS EM ESTATÍSTICA E OTIMIZAÇÃO/Aula 4")

# Carregando bibliotecas de trabalho
library(bench)
library(Rcpp)
library(tidyverse)

## Q1) Média harmônica. Implemente uma função R para o seu cálculo usando a estrutura de repetição for. 
# Não use nenhum recurso do R que use vetorização. Gere uma amostra de tamanho 100 com o seguinte código:
#
#      set.seed(123)
#      y <- rpois(100, lambda = 10)
#
# Baseado nesta amostra calcule a média harmonica usando a sua função.

# Criando função simples para cálculo da Média Harmônica
medHarmonica <- function(x) {
  n <- length(x)
  invSoma <- 0
  
  for(i in 1:n) {
    invSoma <- invSoma + (1/x[i])
  }
  
  medHarmonica <- n/invSoma
  return(medHarmonica)
}

# Calculando a média harmônica das observações abaixo e testando a função
set.seed(123)

y <- rpois(100, lambda = 10)

medHarmonica(y)

# Output:
# [1] 8.743717


## Q2) Reimplemente a função do exercício 1, porém agora usando tudo que conseguir de recursos de vetorização
# já disponíveis no R. Faça uma comparação do tempo computacional necessário por cada uma das abordagens. 
# Use o package bench.

# Criando nova função utilizando elementos de vetorização
medHarmonicaVetor <- function(x) {
  n <- length(x)
  inv_x <- 1/x
  
  medHarmonicaVetor <- n/sum(inv_x)
  return(medHarmonicaVetor)
}

# Calculando a média harmônica das observações abaixo e testando a função
set.seed(123)

y <- rpois(100, lambda = 10)

medHarmonicaVetor(y)

# Comparando as funções utlizando pacote bench
bench::mark(
  medHarmonica(y), 
  medHarmonicaVetor(y)
)[c("expression", "min", "median", "itr/sec", "n_gc")]

# Output:
# expression                  min   median `itr/sec`  n_gc
# <bch:expr>             <bch:tm> <bch:tm>     <dbl> <dbl>
# 1 medHarmonica(y)         4.5µs    5.6µs   102678.     0
# 2 medHarmonicaVetor(y)    1.3µs    2.2µs   247401.     1

# CONCLUSÃO: Utilizando recursos de vetorização com a nova função, medHarmonicaVetor(), foi possível realizar
#            o mesmo procedimento, porém apróximadamente 60% mais rápido e realizando 2,4 vezes mais 
#            iterações por segundo.


## Q3) Reimplemente a função do exercício 1, porém agora usando C++ e o pacote Rcpp.
# Novamente compare o tempo computacional entre as três abordagens usando o pacote bench.

# Implementado a função em C++
medHarmonica_Cpp <-
'double medHarmonica_Cpp(NumericVector x) {
  int n = x.length();
  double invSoma = 0;
  
  for(int i = 0; i < n; i++) {
    invSoma += (1/x[i]);
  }
  
  double medHarmonica_Cpp = n/invSoma;
  return medHarmonica_Cpp;
}'

## Chamando a nova função escrita em C++ para o ambiente global em R
cppFunction(medHarmonica_Cpp)

# Calculando a média harmônica das observações abaixo e testando a função
set.seed(123)

y <- rpois(100, lambda = 10)

medHarmonica_Cpp(y)

# Comparando as funções utlizando pacote bench
bench::mark(
  medHarmonica(y), 
  medHarmonicaVetor(y),
  medHarmonica_Cpp(y)
)[c("expression", "min", "median", "itr/sec", "n_gc")]

# Output:
# expression                  min   median `itr/sec`  n_gc
# <bch:expr>              <bch:tm> <bch:tm>     <dbl> <dbl>
# 1 medHarmonica(y)         4.5µs    6.1µs   107200.     0
# 2 medHarmonicaVetor(y)    1.3µs    1.7µs   295742.     0
# 3 medHarmonica_Cpp(y)     1.4µs      2µs   190434.     1

# CONCLUSÃO: A função medHarmonica(), que utiliza o for-loop como elemento de iteração e escrita em R 
#            foi a função de inferior perfomance, dado o tempo computacional necessário para realizar operações
#            elemento-a-elemento e a capacidade de execução de iterações por segundo. Já a função vetorizada, 
#            medHarmonicaVetor(), também escrita em R, embora apenas marginalmente superior à função
#            medHarmonica_Cpp, escrita em C++, foi a função que apresentou o melhor desempenho entre todas
#            em termos de tempo computacional e execução de iterações por segundo. 
#            Contudo, vale ressaltar que nem sempre é possível realizar operações de forma vetorial, e, nesses casos,
#            levando-se em conta que será necessária a construção de um loop para realização de ações iterativas, 
#            o código escrito em C++ pode ser uma alternativa viável para aumentar a velocidade de processamento,
#            uma vez que, conforme demonstrado pela comparação das funções que utilizam o loop for,
#            a função escrita em C++ apresentou uma performance 3x superior à função com loop escrito em R
#            em termos de tempo computacional e foi capaz de realizar aproximandamente o dobro de iterações por segundo.
      

## Q4) Em estatística testes qui-quadrado são muito populares. O R tem uma função para 
# realizar tal teste para diversas situações. Uma situação comum é para verificar 
# a associação em tabelas de contingência. O exemplo abaixo retirado da documentação 
# tem o objetivo de avaliar a associação entre genero e perfil político.

# Dados para o exercício
M <- as.table(rbind(c(762, 327, 468), c(484, 239, 477)))

dimnames(M) <- list(gender = c("F", "M"),
                    party = c("Democrat","Independent", "Republican"))

# Imprimindo os dados
M

# Output:
#        party
# gender Democrat Independent Republican
#      F      762         327        468
#      M      484         239        477

# Teste do Qui-quadrado
chisq.test(M)

#Output: 
#       Pearson's Chi-squared test
# data:  M
# X-squared = 30.07, df = 2, p-value = 2.954e-07

# Q4) CONTINUAÇÃO:
# Use uma ferramenta de debug para investigar como a estatística de teste é calculada. Reimplemente apenas
# a estatística de teste em uma função própria. Compare a sua função com a do R em termos de tempo
# computacional. Suponha que o interesse é apenas obter a estatística de teste.

# Utilizando a função debug() para investigar como o teste é calculado
debug(chisq.test)

chisq.test(M)

undebug(chisq.test)

# Método de cálculo da estatística do teste de Qui-quadrado pela função chisq.test()
'
x <- as.matrix(x)
n <- sum(x)
sr <- rowSums(x)
sc <- colSums(x)
E <- outer(sr, sc)/n
v <- function(r, c, n) c * r * (n - r) * (n - c)/n^3
V <- outer(sr, sc, v, n)
  STATISTIC <- sum(sort((x - E)^2/E, decreasing = TRUE))
'

# Reimplementando a função R apenas para fins de comparação de tempo computacional
STATISTIC_ChiSq <- function(M){
  x <- as.matrix(M)
  n <- sum(x)
  sr <- rowSums(x)
  sc <- colSums(x)
  E <- outer(sr, sc)/n
  STATISTIC_ChiSq <- sum(sort((x - E)^2/E, decreasing = TRUE))
  
  return(round(STATISTIC_ChiSq, 2))
}

# Testando a implementação de uma função para executar o cáculo da da estatística do teste
# de Qui-quadrado utilizado pela função chisq.test()
STATISTIC_ChiSq(M)

# Output: 
# [1] 30.07

# Reimplementando o cáculo da estatística do teste em uma nova função vetorizada
testeQuiQuadrado <- function(M) {
  O <- as.vector(M) # Criando uma variável para os valores observados
  E <- outer(rowSums(M), colSums(M)) / sum(M) # Criando uma variável para os valores esperados
  
  testeQuiQuadrado <- sum((O - E)^2 / E) # Calculando a estatística do teste do Qui-quadrado
  
  return(round(testeQuiQuadrado,2))
}

# Testando a nova função
testeQuiQuadrado(M)

# Output:
# [1] 30.07

# Comparando a nova função com a função R
bench::mark(
  STATISTIC_ChiSq(M),
  testeQuiQuadrado(M)
)[c("expression", "min", "median", "itr/sec", "n_gc")]

# Output:
#   expression               min   median `itr/sec`  n_gc
#   <bch:expr>          <bch:tm> <bch:tm>     <dbl> <dbl>
# 1 STATISTIC_ChiSq(M)    62.2µs   86.8µs     9435.     2
# 2 testeQuiQuadrado(M)   15.3µs   23.1µs    38302.     1

# CONCLUSÃO: A função reimplementada, testeQuiQuadrado(), apresentou desempenho superior à função de cálculo 
#            da estatística do teste de Qui-quadrado utilizada pela função chisq.test(). A nova função realiza
#            menos operações para calcular a mesma estatística, sendo assim, é capaz de calcular 
#            a mesma em 1/4 do tempo e realiza aproximadamente 3x mais iterações por segundo.

# Q5) Comparar dois grupos é uma atividade popular em estatística. Considere o conjunto de dados iris
# disponível no R. Suponha que desejamos testar se a variável Sepal.Length é em média diferente entre
# as espécies setosa e versicolor. Para isso vamos usar um teste de aleatorização. Sob a hipótese nula o
# tamanho médio das sepalas é igual. Isso significa que tanto faz o grupo ao qual a flor pertence. Para
# simular esta situação é suficiente juntarmos os dados das duas espécies e sortear aleatóriamente a
# qual espécie a flor pertence. Para medir a diferença calculamos a média de cada espécie e fazemos
# a diferença. Vamos repetir esse processo um grande número de vezes e ver como é a distribuição da
# estatística diferença. Após isso, basta calcular a diferença observada na amostra e identificar qual o
# percentual de vezes que ocorreu ela ou uma estatística mais extrema para obter o chamado p-valor.
# Implemente esse procedimento de forma sequencial e em paralelo. Compare o tempo computacional.

# Carregando pacotes adicionais
library(foreach)
library(doParallel)

# Carregando a base de dados "iris"
data(iris)

# Conferindo dados importatdos
head(iris)

## Criando uma função sequencial utilizando for-loop

# Função para teste de aleatorização

teste_aleatorizacao <- function(dados, especie1, especie2, variavel, n_repeticoes = 10000) {
  # Separando as observações das espécies
  dados_especie1 <- dados[dados$Species == especie1, ]
  dados_especie2 <- dados[dados$Species == especie2, ]
  
  # Calculando a diferença de médias observada na amostra
  media_amostra_especie1 <- mean(dados_especie1[, variavel])
  media_amostra_especie2 <- mean(dados_especie2[, variavel])
  diferenca_amostra <- media_amostra_especie1 - media_amostra_especie2
  
  # Juntando as observações das duas espécies
  dados_juntos <- rbind(dados_especie1, dados_especie2)
  n_obs <- nrow(dados_juntos)
  
  # Repetindo o processo de aleatorização
  diferenca_aleatoria <- numeric(n_repeticoes)
  for (i in 1:n_repeticoes) {
    # Embaralhando as observações e dividindo em dois grupos
    dados_aleatorios <- dados_juntos[sample(n_obs), ]
    grupo1 <- dados_aleatorios[1:nrow(dados_especie1), ]
    grupo2 <- dados_aleatorios[(nrow(dados_especie1) + 1):n_obs, ]
    
    # Calculando a diferença das médias
    media_grupo1 <- mean(grupo1[, variavel])
    media_grupo2 <- mean(grupo2[, variavel])
    diferenca_aleatoria[i] <- media_grupo1 - media_grupo2
  }
  
  # Calculando o p-valor
  p_valor <- sum(abs(diferenca_aleatoria) >= abs(diferenca_amostra)) / n_repeticoes
  
  # Criando o histograma
  hist_dif <- hist(diferenca_aleatoria, breaks = 30,
                   main = "Histograma das diferenças de médias",
                   xlab = "Diferença de médias")
  
  # Criando lista com as informações
  resultado <- list(diferenca_amostra = diferenca_amostra, p_valor = p_valor, hist_dif = hist_dif)
  
  return(resultado)
}

# Testando a função sequencial e atribuindo os resultados a uma nova variável 
# para comparar o desemepenho de diferentes funções

aleatorizacaoFuncaoSequencial <-
  teste_aleatorizacao(dados = iris, 
                    especie1 = "setosa", 
                    especie2 = "versicolor", 
                    variavel = "Sepal.Length",
                    n_repeticoes = 10000)


## Criando uma função paralelizada para execução do for-loop

# Função para teste de aleatorização em paralelo

teste_aleatorizacao_paralelo <- function(dados, especie1, especie2, variavel, n_repeticoes = 10000, n_cores = NULL) {
  # Separando as observações das espécies
  dados_especie1 <- dados[dados$Species == especie1, ]
  dados_especie2 <- dados[dados$Species == especie2, ]
  
  # Calculando a diferença de médias observada na amostra
  media_amostra_especie1 <- mean(dados_especie1[, variavel])
  media_amostra_especie2 <- mean(dados_especie2[, variavel])
  diferenca_amostra <- media_amostra_especie1 - media_amostra_especie2
  
  # Juntando as observações das duas espécies
  dados_juntos <- rbind(dados_especie1, dados_especie2)
  n_obs <- nrow(dados_juntos)
  
  # Configurando o cluster de processamento paralelo
  if (!is.null(n_cores)) {
    cl <- makeCluster(n_cores)
    registerDoParallel(cl)
  }
  
  # Loop de aleatorização em paralelo
  diferenca_aleatoria <- foreach(i = 1:n_repeticoes, .combine = "c") %dopar% {
    # Embaralhando as observações e dividindo em dois grupos
    dados_aleatorios <- dados_juntos[sample(n_obs), ]
    grupo1 <- dados_aleatorios[1:nrow(dados_especie1), ]
    grupo2 <- dados_aleatorios[(nrow(dados_especie1) + 1):n_obs, ]
    
    # Calculando a diferença das médias
    media_grupo1 <- mean(grupo1[, variavel])
    media_grupo2 <- mean(grupo2[, variavel])
    diferenca <- media_grupo1 - media_grupo2
    
    return(diferenca)
  }
  
  # Fechando o cluster de processamento paralelo
  if (!is.null(n_cores)) {
    stopCluster(cl)
  }
  
  # Calculando o p-valor
  p_valor <- sum(abs(diferenca_aleatoria) >= abs(diferenca_amostra)) / n_repeticoes
  
  # Criando o histograma
  hist_dif <- hist(diferenca_aleatoria, breaks = 30, 
                   main = "Histograma das diferenças de médias", 
                   xlab = "Diferença de médias")
  
  # Criando lista com as informações
  resultado <- list(diferenca_amostra = diferenca_amostra, p_valor = p_valor, hist_dif = hist_dif)
  
  return(resultado)
}

# Testando a função paralelizada e atribuindo os resultados a uma nova variável 
# para comparar o desemepenho de diferentes funções

aleatorizacaoFuncaoParalelo <-
  teste_aleatorizacao_paralelo(dados = iris, 
                    especie1 = "setosa", 
                    especie2 = "versicolor", 
                    variavel = "Sepal.Length",
                    n_repeticoes = 10000,
                    n_cores = 2)

# Testando as funções e medindo o desempenho
resultadoSequencial <- bench::mark(aleatorizacaoFuncaoSequencial, iterations = 10, check = FALSE)

resultadoParalelizado <- bench::mark(aleatorizacaoFuncaoParalelo, iterations = 10, check = FALSE)

# Comparando o resultado das funções considerando n_repeticoes = 10000 para ambas funções 
# e 2 cores para o a função paralelizada
resultadoSequencial[, c("expression", "min", "median", "itr/sec", "n_gc")]

resultadoParalelizado[, c("expression", "min", "median", "itr/sec", "n_gc")]

# Output:
# Função Sequencial:
# > resultadoSequencial[, c("expression", "min", "median", "itr/sec", "n_gc")]
#   expression                         min   median `itr/sec`  n_gc
#   <bch:expr>                    <bch:tm> <bch:tm>     <dbl> <dbl>
# 1 aleatorizacaoFuncaoSequencial    200ns    300ns  1470588.     0

# Função Paralelizada:
# > resultadoParalelizado[, c("expression", "min", "median", "itr/sec", "n_gc")]
#   expression                       min   median `itr/sec`  n_gc
#   <bch:expr>                  <bch:tm> <bch:tm>     <dbl> <dbl>
# 1 aleatorizacaoFuncaoParalelo    100ns    150ns  3703704.     0

# CONCLUSÃO: A função paralelizada utilizando 2 cores foi capaz de realizar o mesmo processo da
#            da função sequêncial em aproximadamente metade do tempo e executando aproximadamente
#            o dobro de iterações por segundo.


