## Lista V
## Guilherme Cadori 
## 15/04/2023

# Configurando o diretório de trabalho
setwd("C:/Guilherme/MSc/Disciplinas/2023-03 MÉTODOS COMPUTACIONAIS EM ESTATÍSTICA E OTIMIZAÇÃO/Aula 5")

# Carregando biblioteca de trabalho
library(tidyverse)

## Q1)
'
    A decomposição de Cholesky de uma matriz simétrica e definida positiva é muito popular em estatística.
    Para você ter uma ideia do algoritmo consulte. Use três diferentes abordagens para obter a decomposição
    de Cholesky de uma matriz positiva definida em R e/ou C++. As abordagens podem ser diferentes
    pacotes, diferentes classes ou mesmo diferentes linguagens. Se você conhece outras linguagens pode usar
    se julgar adequado. Para criar uma matriz positiva definida use o seguinte código. Tome cuidado com a
    classe das matrizes que você vai utilizar para comparar as diferentes abordagens. Considere matrizes
    de diferentes dimensões e use o pacote bench para a comparação em termos de tempo computacional.
    Importante explique cuidadosamente a diferença entre as abordagens e qual você julga ser a mais
    eficiente antes e após realizar o experimento computacional.
'

# Cálculo da matriz DD_positiva
x1 <- runif(30)
x2 <- runif(30)
grid <- expand.grid(x1, x2)
DD <- dist(grid, diag = TRUE, upper = TRUE)

DD_positiva <- exp(as.matrix(-DD, 100, 100)/0.3)


# Abordagem 1: Função Própria
# Definindo uma função própria para calcular a decompisição de Cholesky
decompCholesky <- function(x) {
  n <- nrow(x)
  L <- matrix(0, n, n)
  for (j in 1:n) {
    for (i in j:n) {
      if (i == j) {
        L[i, j] <- sqrt(x[i, i] - sum(L[i, 1:(j - 1)]^2))
      } else {
        L[i, j] <- (1 / L[j, j]) * (x[i, j] - sum(L[i, 1:(j - 1)] * L[j, 1:(j - 1)]))
      }
    }
  }
  return(L)
}

# Testando a função
decompCholesky_obj <- decompCholesky(DD_positiva)

# Visualizando a matriz inferior decomposta "L"
view(head(decompCholesky_obj))


# Abordagem 2: Definindo uma função que utilize pacotes em R
library(Matrix)

# Implementando a função
decompCholesky_R <- function(x) {
  A <- Matrix(x, sparse = TRUE) # Converte a matriz x para a classe dsCMatrix da biblioteca Matrix
  L <- chol(t(A), pivot = TRUE) # Realiza a decomposição de Cholesky da transposta de A
  U <- t(as.matrix(L)) # Converte a matriz triangular inferior L para a matriz triangular superior U
  return(U) # Retorna a matriz triangular superior U
}

# Testando a função
decompCholesky_R_obj <- decompCholesky_R(DD_positiva)

# Visualizando a matriz inferior decomposta "L"
view(head(decompCholesky_R_obj))


# Abordagem 3: Criando um função própria que utilize a linguagem C++ pelo pacote Rcpp
library(Rcpp)

# Implementando a função em C++
decompCholesky_Cpp <-
'
  NumericMatrix decompCholesky_Cpp(NumericMatrix x) {
  int n = x.nrow();
  NumericMatrix L(n, n);

  for (int j = 0; j < n; j++) {
    for (int i = j; i < n; i++) {
      double s = 0;
      for (int k = 0; k < j; k++) {
        s += L(i, k) * L(j, k);
      }
      if (i == j) {
        L(i, j) = sqrt(x(i, i) - s);
      } else {
        L(i, j) = (x(i, j) - s) / L(j, j);
      }
    }
  }
  return L;
}
'

# Chamando a nova função escrita em C++ para o ambiente global em R
cppFunction(decompCholesky_Cpp)

# Testando a função
decompCholesky_Cpp_obj <- decompCholesky_Cpp(DD_positiva)

# Visualizando a matriz inferior decomposta "L"
view(head(decompCholesky_Cpp_obj))

# Comparando as abordagens
library(bench)

bench::mark(
  decompCholesky(DD_positiva)
)[c("expression", "min", "median", "itr/sec", "n_gc")]

bench::mark(
  decompCholesky_R(DD_positiva)
)[c("expression", "min", "median", "itr/sec", "n_gc")]

bench::mark(
  decompCholesky_Cpp(DD_positiva)
)[c("expression", "min", "median", "itr/sec", "n_gc")]

# Output:
'
Função: decompCholesky(DD_positiva)
  expression                       min   median `itr/sec`  n_gc
  <bch:expr>                  <bch:tm> <bch:tm>     <dbl> <dbl>
1 decompCholesky(DD_positiva)    3.52s    3.52s     0.284    18

Função: decompCholesky_R(DD_positiva)
  expression                         min   median `itr/sec`  n_gc
  <bch:expr>                    <bch:tm> <bch:tm>     <dbl> <dbl>
1 decompCholesky_R(DD_positiva)    113ms    115ms      8.23     1

Função: decompCholesky_Cpp(DD_positiva)
  expression                           min   median `itr/sec`  n_gc
  <bch:expr>                      <bch:tm> <bch:tm>     <dbl> <dbl>
1 decompCholesky_Cpp(DD_positiva)    112ms    113ms      8.78     0

'

# Importante explique cuidadosamente a diferença entre as abordagens e qual você julga ser a mais
# eficiente antes e após realizar o experimento computacional

# CONCLUSÃO:
'
  A análise se deu a partir da premissa de que o código escrito em C++ (abordagem 3) seria o mais eficiente em termos
  de desempenho computacional para o processamento da descomposição de Cholesky, seguido pela função
  escrita utilizando pacotes em R (abordagem 2), seguida, por fim, pela função nativa em R (abordagem 1).
  
  Os resultados observados seguiram a tendência das premissas, contudo, não se esperava que o desempenho
  da função escrita em C++ e da função utilizando pacotes em R fossem tão semelhantes. Ambas apresentaram desempenhos próximos, sendo 
  a função em C++ apenas 2ms mais rápida que a abordagem 2. 
  
  No entanto, a diferença de desempenho das abordagens 3 e 2 foi substancialmente superior ao desepenho da função
  escrita de forma nativa em R, abordagem 1, demonstrando assim a superioridade das metodologias anteriores à 
  utilização de for-loops para o desenvolvimento de funções para a aplicação da decomposição do Cholesky, nesse caso especificamente.
'


## Q2) 
'
  Nas mesmas condições do exercício 1. Considere que é de interesse obter a decomposição em autovalores
  e autovetores. Novamente forneça três alternativas e compare os tempos computacionais.
'

# Abordagem 1: Utilizando a função eigen()
eig1 <- eigen(DD_positiva)

# Inspecionando resultados
glimpse(eig1)

# Testanto a função
system.time(eigen(DD_positiva))

# Output:
# usuário   sistema decorrido 
#    0.81      0.00      0.82


# Abordagem 2: Utilizando a função svd()
svd1 <- svd(DD_positiva)

# Inspecionando resultados
glimpse(svd1)

# Testanto a função
system.time(svd(DD_positiva))

# Output:
# usuário   sistema decorrido 
#    1.67      0.03      1.73


# Abordagem 3: Utilizando biblioteca Rcpp e escrevendo o código em C++

library(Rcpp)

# Script em C++ utilizado:

eigen_decomp <-
'
// [[Rcpp::depends(RcppEigen)]]
  #include <RcppEigen.h>

// [[Rcpp::export]]
Rcpp::List eigen_decomp(const Eigen::MatrixXd& M) {
  Eigen::SelfAdjointEigenSolver<Eigen::MatrixXd> eigensolver(M);
  
  if (eigensolver.info() != Eigen::Success) {
    Rcpp::stop("Error in eigen decomposition.");
  }
  
  Eigen::VectorXd eigenvalues = eigensolver.eigenvalues();
  Eigen::MatrixXd eigenvectors = eigensolver.eigenvectors();
  
  Rcpp::List output;
  output["eigenvalues"] = eigenvalues;
  output["eigenvectors"] = eigenvectors;
  
  return output;
}
'

# Chamando a função em C++ para o ambiente R
Rcpp::sourceCpp(code = eigen_decomp)

eigen_Cpp <- eigen_decomp(DD_positiva)

# Inspecionando resultados
glimpse(eigen_Cpp)

# Testanto a função
system.time(eigen_decomp(DD_positiva))

# Output:
# usuário   sistema decorrido 
#    0.61      0.02      0.63 

# Comparando abordagens:
system.time(eigen(DD_positiva)) ## Tempo decorrido: 0.80 s
system.time(svd(DD_positiva)) ## Tempo decorrido: 1.65 s
system.time(eigen_decomp(DD_positiva)) ## Tempo decorrido: 0.60 s
 
# CONCLUSÃO:
'
  A abordagem 3 utilizando a linguagem C++ e o pacote RcppEigen foi a mais eficiente das três abordagens. A mesma foi 25% mais rápida
  que a aboradgem 1, utilizando a função eigen() em R e também foi aproximadamente 64% sueprior à função apresentada na abordagem 2, 
  utilizando a função svd().
'


## Q3)
'
  Considere um modelo linear de covariancia com matriz de covariância descrita por dois componentes
  conforme código abaixo.
  Proponha três estratégias para obter a matriz de sensitivade. 
  Compare suas propostas pelo tempo computacional.
  Avalie matrizes de diferentes tamanhos. 
  Considere que a matriz Z é bloco diagonal com estrutura dada pelo código abaixo.
'

library(Matrix)

Z_temp <- rep(1, 5)%*%t(rep(1, 5))
Z_lista <- list()
for(i in 1:10) {Z_lista[[i]] <- Z_temp}
Z <- Matrix::bdiag(Z_lista)
C <- 5*Diagonal(50, 1) + 3*Z
W1 <- Matrix::bdiag(Diagonal(50, 1))
W2 <- Z # atribuindo Z a um novo objeto


## Abordagem 1: Método utilizando multplicação matricial - Operador %*%

multMatrizes <- function(W1, W2, C){
  
  A <- matrix(0, 2, 2)
  
  A[1, 1] <- -sum(diag(W1 %*% C %*% W1 %*% C))
  A[2, 1] <- -sum(diag(W2 %*% C %*% W1 %*% C))
  A[1, 2] <- -sum(diag(W1 %*% C %*% W2 %*% C))
  A[2, 2] <- -sum(diag(W2 %*% C %*% W2 %*% C))
  
  return(A)
}

# Testando a função e imprimindo resultados
multMatrizes_Test <- multMatrizes(W1, W2, C)

multMatrizes_Test

# Output:
#        [,1]   [,2]
# [1,]  -5000 -2e+04
# [2,] -20000 -1e+05


## Abordagem 2: Utilizando multplicação de matrizes (%*%) e o a função de produto cruzado (crossprod())

multMatCrossProd <- function(W1, W2, C){
  
  A <- matrix(0, 2, 2)
  
  A[1, 1] <- -sum(diag(crossprod(W1, C)%*%crossprod(W1, C)))
  A[2, 1] <- -sum(diag(crossprod(W2, C)%*%crossprod(W1, C)))
  A[1, 2] <- -sum(diag(crossprod(W1, C)%*%crossprod(W2, C)))
  A[2, 2] <- -sum(diag(crossprod(W2, C)%*%crossprod(W2, C)))
  
  return(A)
}

# Testando a função e imprimindo resultados
multMatCrossProd_Test <- multMatCrossProd(W1, W2, C)

multMatCrossProd_Test

# Output:
#        [,1]   [,2]
# [1,]  -5000 -2e+04
# [2,] -20000 -1e+05


# Abordagem 3: Utilizando o produto cruzado - função crossprod()

matCrossProd <- function(W1, W2, C){
  
  A <- matrix(0, 2, 2)
  
  A[1, 1] <- -sum(diag(crossprod(crossprod(W1, C),crossprod(W1, C))))
  A[2, 1] <- -sum(diag(crossprod(crossprod(W2, C),crossprod(W1, C))))
  A[1, 2] <- -sum(diag(crossprod(crossprod(W1, C),crossprod(W2, C))))
  A[2, 2] <- -sum(diag(crossprod(crossprod(W2, C),crossprod(W2, C))))
  
  return(A)
}

# Testando a função e imprimindo resultados
matCrossProd_Test <- matCrossProd(W1, W2, C)

matCrossProd_Test

# Output:
#        [,1]   [,2]
# [1,]  -5000 -2e+04
# [2,] -20000 -1e+05


## Criando uma nova matriz para testar as funções

Z_temp <- rep(1, 40) %*% t(rep(1, 40))
Z_lista <- list()
for(i in 1:40) {Z_lista[[i]] <- Z_temp}
Z <- Matrix::bdiag(Z_lista)
C <- 5 * Diagonal(1600, 1) + 3 * Z
W1 <- Matrix::bdiag(Diagonal(1600, 1))
W2 <- Z

## Comparando as abordagens utilizando uma matriz de maior dimensões
bench::mark(multMatrizes(W1, W2, C),
            multMatCrossProd(W1, W2, C),
            matCrossProd(W1, W2, C),
            iterations = 100) [c("expression", "min", "median", "itr/sec", "n_gc")]

# Output:
#   expression                       min   median `itr/sec`  n_gc
# 1 multMatrizes(W1, W2, C)       49.2ms     87ms      9.28    30
# 2 multMatCrossProd(W1, W2, C)  109.4ms    246ms      4.16    28
# 3 matCrossProd(W1, W2, C)      180.9ms    268ms      3.39    32

# CONCLUSÃO:
'
  A abordagem 1, utilizando apenas multiplicação de matrizes foi a mais eficiente para executar o processo proposto. 
  Percebe-se também que a utilização do produto cruzado, através da função crossprod(), aumenta consideravelmente o
  tempo commputacional para executar a mesma tarefa. A aboradem de desempenho superior utiliza apenas a multiplicação
  de matrizes é aproxidamente 3x mais rápida que as funções apresentadas pelas abordagens 2 e 3.
'


## Q4)
'
  A distribuição Normal multivariada tem uma ampla gama de aplicações em estatística.
  Implemente esta função usando pelo menos três diferentes abordagens de álgebra linear.
  Você pode usar qualquer estratégia que achar conveniente relacionado a propriedades de matrizes 
  e/ou resolução de sistemas lineares. Você precisará especificar o vetor μ para o qual sugiro usar 
  um vetor de zeros e para a matriz que deve ser positiva definida. Considere vetores de tamanho 
  entre 10 e 100. O pacote mvtnorm do software R forcene uma implementação de tal distribuição através
  da função dmvnorm(). Use esta implementação como base de comparação e faça com que sua função seja 
  mais rápida. O código abaixo ilustra o uso do pacote para avaliar a distribuição normal multivariada - pacote "mvtnorm".
'

# Instalando biblioteca adidional
install.packages("mvtnorm")

# Carregando biblioteca de trabalho
library(mvtnorm)

# Criando variáveis de entrada
mu <- c(0,0)
Sigma <- matrix(c(1,0.8,0.8,1),2,2)
x = c(0,0)

# Testando a função fornecida pelo pacote "mvtnorm"
dmvnorm(x = c(0,0), mean = mu, sigma = Sigma)

# Output:
# [1] 0.2652582


# Abordagem 1: Utilizando a função solve() do R base para resolver um sistema linear
dmvnorm_Solve <- function(x, mean, sigma) {
  n <- length(x)
  det_sigma <- det(sigma)
  inv_sigma <- solve(sigma)
  const <- 1 / ((2 * pi)^(n/2) * sqrt(det_sigma))
  exp_term <- -0.5 * t(x - mean) %*% inv_sigma %*% (x - mean)
  result <- const * exp(exp_term)
  return(result)
}

# Testando a função
dmvnorm_Solve(x, mu, Sigma)

# Output:
#           [,1]
# [1,] 0.2652582


# Abordagem 2: Descomposição LU
library(Matrix)

# Criando a função
dmvnorm_decompLU <- function(x, mean, sigma) {
  n <- length(x)
  const <- -n/2*log(2*pi) - sum(log(diag(chol(sigma))))
  Q <- chol2inv(chol(sigma))
  res <- x - mean
  expon <- -0.5 * (res %*% Q %*% res)
  result <- const + expon
  return(exp(result))
}

# Testando a função
dmvnorm_decompLU(x, mu, Sigma)

# Output:
#           [,1]
# [1,] 0.2652582


# Abordagem 3: Decomposição de Cholesky
dmvnorm_Cholesky <- function(x, mean, sigma) {
  n <- length(x)
  det_sigma <- det(sigma)
  L <- chol(sigma)
  const <- 1 / ((2 * pi)^(n/2) * prod(diag(L)))
  y <- solve(t(L), x - mean)
  exp_term <- -0.5 * t(y) %*% y
  result <- const * exp(exp_term)
  return(result)
}

# Testando a função
dmvnorm_Cholesky(x, mu, Sigma)

# Output:
#           [,1]
# [1,] 0.2652582

###########################
#### Teste Alternativo ####
####### IMPORTANTE ########

# A função a seguir foi retirada da fonte abaixo exclusivamente para fins de comparação de desempenho em relação à função dmvnorm()
# Fonte: http://www.leg.ufpr.br/~wagner/MCIE/Tutorial/TutorialIII.html

my_dmvnorm5 <- function(x, mean, sigma) {
  n <- length(x)
  c1 <- -(n/2)*log(2*pi) 
  L <- chol(sigma)
  c2 <- -0.5*sum(log(diag(L)^2))
  res <- x - mean
  tt <- solve(L, res)
  c3 <- -0.5*t(tt)%*%tt
  return(exp(c1+c2+c3)) # GC: Modifiquei a função adicionando a função exp() para que o mesmo valor fosse retornado
}

# Verificando
my_dmvnorm5(x = c(0,0), mean = mu, sigma = Sigma)

# Output:
#           [,1]
# [1,] 0.2652582

####################

# O pacote mvtnorm do software R forcene uma implementação de tal distribuição através da função dmvnorm().
# Use esta implementação como base de comparação e faça com que sua função seja mais rápida.

# Comparando abordagens
# Instalando e carregando pacote para comparações
install.packages("rbenchmark")

library(rbenchmark)

# Criando uma matriz grande para realizar as comparações
# Referência utilizada para criação do teste: http://www.leg.ufpr.br/~wagner/MCIE/Tutorial/TutorialIII.html
x <- 1:30
grid <- expand.grid(x,x)
DD <- as.matrix(dist(grid, diag = TRUE, upper = TRUE))
Sigma <- exp(-DD)
mean <- rep(0, dim(Sigma)[1])
x <- rep(0, dim(Sigma)[1])

# Testando funções com nova matriz
dmvnorm(x, mean, Sigma)
dmvnorm_Solve(x, mean, Sigma)
dmvnorm_decompLU(x, mean, Sigma)
dmvnorm_Cholesky(x, mean, Sigma)
my_dmvnorm5(x, mean, Sigma)

# Comparando as funções para diferentes abordagens
benchmark("dmvnorm" = {dmvnorm(x, mean, Sigma)},
          "Solve" = {dmvnorm_Solve(x, mean, Sigma)},
          "LU" = {dmvnorm_decompLU(x, mean, Sigma)},
          "Cholesky" = {dmvnorm_Cholesky(x, mean, Sigma)},
          "my_dmvnorm5_Cholesky" = {my_dmvnorm5(x, mean, Sigma)},
          replications = 10,
          columns = c("test", "replications", "elapsed", "relative", "user.self", "sys.self"))


# Output:
#                    test replications elapsed relative user.self sys.self
# 4              Cholesky           10    3.30    2.705      3.26     0.01
# 1               dmvnorm           10    1.22    1.000      1.16     0.07
# 3                    LU           10    3.31    2.713      3.30     0.02
# 5  my_dmvnorm5_Cholesky           10    2.18    1.787      2.15     0.03
# 2                 Solve           10    4.90    4.016      4.80     0.06

# CONCLUSÃO:
'
   Entre todas as abordagens utilizadas para calcular a densidade de probabilidade da distribuição normal multivariada,
   a função que apresentou superior desempenho foi a função dmvnorm() do pacote "mvtnorm". As abordagens apresentadas 
   visavam otimizar o processo de cálculo, no entanto, a segunda melhor função do grupo de teste, demonstrada na seção
   Teste Alternativo, apresentou um desempenho aproximadamente mais lento que a função dmvnorm().
'


## Q5)
'
  O seguinte post clique aqui apresenta várias considerações relacionadas a performance computacional
  de cálculos matriciais envolvendo matrizes esparsas com o Rcpp e Armadillo. Leia o artigo, reproduza o
  código e faça um resumo do que o post apresenta.
'

library(Rcpp)
library(RcppArmadillo)
library(Matrix)


## Bloco 1:

ArtigoSparseMatrices <-
'
  // [[Rcpp::depends(RcppArmadillo)]]
  #include <RcppArmadillo.h>

  // [[Rcpp::export]]
  arma::sp_mat mult_sp_sp_to_sp(const arma::sp_mat& a, const arma::sp_mat& b) {
    // sparse x sparse -> sparse
    arma::sp_mat result(a * b);
    return result;
  }
  
  // [[Rcpp::export]]
  arma::sp_mat mult_sp_den_to_sp(const arma::sp_mat& a, const arma::mat& b) {
    // sparse x dense -> sparse
    arma::sp_mat result(a * b);
    return result;
  }
  
  // [[Rcpp::export]]
  arma::sp_mat mult_den_sp_to_sp(const arma::mat& a, const arma::sp_mat& b) {
    // dense x sparse -> sparse
    arma::sp_mat result(a * b);
    return result;
}
'

Rcpp::sourceCpp(code = ArtigoSparseMatrices)

library(Matrix)

set.seed(98765)
n <- 5e3

# 5000 x 5000 matrices, 99% sparse
a <- rsparsematrix(n, n, 0.01, rand.x=function(n) rpois(n, 1) + 1)
b <- rsparsematrix(n, n, 0.01, rand.x=function(n) rpois(n, 1) + 1)

a_den <- as.matrix(a)
b_den <- as.matrix(b)

system.time(m0 <- a %*% b)
# Output:
# usuário   sistema decorrido 
#    0.17      0.11      0.28 

system.time(m1 <- mult_sp_sp_to_sp(a, b))
# Output:
# usuário   sistema decorrido 
#    0.45      0.00      0.45 

system.time(m2 <- mult_sp_den_to_sp(a, b_den))
# Output:
# usuário   sistema decorrido 
# 1.13      0.14      1.30 

system.time(m3 <- mult_den_sp_to_sp(a_den, b))
# Output:
# usuário   sistema decorrido 
#    1.08      0.04      1.13

all(identical(m0, m1), identical(m0, m2), identical(m0, m3))
# Output:
# [1] TRUE



## Bloco 2:

ArtigoSparseMatrices_2 <-
'
  // [[Rcpp::depends(RcppArmadillo)]]
  #include <RcppArmadillo.h>
  
  // [[Rcpp::export]]
  arma::sp_mat mult_sp_den_to_sp2(const arma::sp_mat& a, const arma::mat& b) {
    // sparse x dense -> sparse
    // copy dense to sparse, then multiply
    arma::sp_mat temp(b);
    arma::sp_mat result(a * temp);
    return result;
}
'

Rcpp::sourceCpp(code = ArtigoSparseMatrices_2)

system.time(m4 <- mult_sp_den_to_sp2(a, b_den))
# Output:
# usuário   sistema decorrido 
#    0.45      0.05      0.50

identical(m0, m4)
# Output:
# [1] TRUE



## Bloco 3:
ArtigoSparseMatrices_3 <- 
'
  // [[Rcpp::depends(RcppArmadillo)]]
  #include <RcppArmadillo.h>

  // [[Rcpp::export]]
  arma::sp_mat row_slice(const arma::sp_mat& x, const int n) {
    return x.row(n - 1);
}
'

Rcpp::sourceCpp(code = ArtigoSparseMatrices_3)

system.time({
  result <- sapply(1:nrow(a),
                   function(i) i * sum(row_slice(a, i)))
  print(sum(result))
})

# Output:
# [1] 1250269015
# usuário   sistema decorrido 
#    3.42      2.06      5.52



## Bloco 4:

ArtigoSparseMatrices_4 <-
'
  // [[Rcpp::depends(RcppArmadillo)]]
  #include <RcppArmadillo.h>

  // [[Rcpp::export]]
  arma::sp_mat col_slice(const arma::sp_mat& x, const int n) {
  return x.col(n - 1);
}
'  

Rcpp::sourceCpp(code = ArtigoSparseMatrices_4)

a_t <- t(a)
system.time({
  result <- sapply(1:nrow(a_t),
                   function(i) i * sum(col_slice(a_t, i)))
  print(sum(result))
})

# Output:
# [1] 1250269015
# usuário   sistema decorrido 
#    1.95      1.84      3.83 



## Bloco 5:

ArtigoSparseMatrices_5 <- 
'
    // [[Rcpp::depends(RcppArmadillo)]]
  #include <RcppArmadillo.h>
  
  // [[Rcpp::export]]
  double sum_by_row(const arma::sp_mat& x) {
    double result = 0;
    for (size_t i = 0; i < x.n_rows; i++) {
      arma::sp_mat row(x.row(i));
      for (arma::sp_mat::iterator j = row.begin(); j != row.end(); ++j) {
        result += *j * (i + 1);
      }
    }
    return result;
  }
'

Rcpp::sourceCpp(code = ArtigoSparseMatrices_5)

system.time(print(sum_by_row(a)))

# Output:
# [1] 1250269015
# usuário   sistema decorrido 
#    2.03      0.02      4.09


## Bloco 6:
ArtigoSparseMatrices_6 <-
'
    // [[Rcpp::depends(RcppArmadillo)]]
  #include <RcppArmadillo.h>
  
  // [[Rcpp::export]]
  double sum_by_col(const arma::sp_mat& x) {
      double result = 0;
      for (size_t i = 0; i < x.n_cols; i++) {
          arma::sp_mat col(x.col(i));
          for (arma::sp_mat::iterator j = col.begin(); j != col.end(); ++j) {
              result += *j * (i + 1);
          }
      }
      return result;
}
'

Rcpp::sourceCpp(code = ArtigoSparseMatrices_6)

system.time(print(sum_by_col(a_t)))

# Output:
# [1] 1250269015
# usuário   sistema decorrido 
#    0.02      0.00      0.02



## Bloco 7:

ArtigoSparseMatrices_7 <-
'
    // [[Rcpp::depends(RcppArmadillo)]]
  #include <RcppArmadillo.h>
  
  // [[Rcpp::export]]
  double sum_by_element(const arma::sp_mat& x) {
      double result = 0;
      // loop over columns, then rows: see comments at the start of this article
      for (size_t j = 0; j < x.n_cols; j++) {
          for (size_t i = 0; i < x.n_rows; i++) {
              result += x(i, j) * (i + 1);
          }
      }
      return result;
  }
'

Rcpp::sourceCpp(code = ArtigoSparseMatrices_7)

system.time(print(sum_by_element(a)))

# Output:
# [1] 1250269015
# usuário   sistema decorrido 
#    0.16      0.00      0.16



# Bloco 8:
ArtigoSparseMatrices_8 <-
'
  // [[Rcpp::depends(RcppArmadillo)]]
  #include <RcppArmadillo.h>
  
  // [[Rcpp::export]]
  double sum_by_iterator(const arma::sp_mat& x) {
      double result = 0;
      for (arma::sp_mat::const_iterator i = x.begin(); i != x.end(); ++i) {
          result += *i * (i.row() + 1);
      }
      return result;
}
'

Rcpp::sourceCpp(code = ArtigoSparseMatrices_8)

system.time(print(sum_by_iterator(a)))

# Output:
# [1] 1250269015
# usuário   sistema decorrido 
#    0.00      0.02      0.02 


# Comparando funções
install.packages("microbenchmark")

library(microbenchmark)

microbenchmark(col=sum_by_col(a_t), 
               elem=sum_by_element(a), 
               iter=sum_by_iterator(a),
               times=20)

# Output:
# Unit: microseconds
# expr      min        lq      mean    median        uq      max neval
# col    3076.7   3223.65   3505.90   3289.05   3579.35   4843.7    20
# elem 160543.3 163298.80 165255.55 164611.30 167002.95 174101.5    20
# iter    921.1    978.75   1175.84   1047.50   1238.20   2318.6    20


# CONCLUSÃO:
'
  O artigo apresenta uma análise comparativa de desempenho entre métodos para manipulação de matrizes esparsas em C++, 
  utilizando a biblioteca Armadillo (versão 8.500). Essa biblioteca apresenta diversas otimizações de processamento que 
  melhoram o desepenho do código ao lidar com matrizes esparsas.
  
  Além disso, o artigo também destaca que diferentes técnicas de acesso dos elementos de matrizes esparsas pode resultar em 
  ganhos significativos de desempenho. Para demonstrar isso, o autor apresenta um caso de uso envolvendo a resolução de um 
  sistema de equações lineares com uma matriz esparsa de grande dimensão.
  
  Recomenda-se manter apenas um tipo de matriz para os objetvos utilizados - esparsa ou densa. Se for necessário 
  utilizar os dois tipos em conjunto, deve-se testar e avaliar o profile do código. Outra recomendação importante é tentar
  manter-se em um único ambiente o máximo possível, ao invés de alternar entre R e C++. Recomenda-se utilizar funções em C++
  e salvar os resultados em um objeto R para melhorar a performance do código.
  
  Em conclusão, o artigo destaca a importância da escolha das técnicas e a biblioteca de álgebra linear apropriadas para a 
  manipulação de matrizes esparsas, bem como o potencial ganho de desempenho com a utilização das técnicas adequadas.

'





