## Lista VI
## Guilherme Cadori
## 15/04

## Configurando diretório de trabalho
setwd("C:/Guilherme/MSc/Disciplinas/2023-03 MÉTODOS COMPUTACIONAIS EM ESTATÍSTICA E OTIMIZAÇÃO/Aula 6")

## Ex 1)
'
        Considere o método regula-falsi para a solução de uma equação não linear. Forneça uma implementação
        em R deste método e use sua implementação para resolver a seguinte equação não linear
'

# Criando a função
regula_falsi <- function(f, a, b, tol = 1e-6, maxiter = 1000) {
  
  # Funções 'a' e 'b' a serem utilizadas
  fa <- f(a)
  fb <- f(b)
  
  # Testando se o intervalo da função é válido
  if (fa * fb > 0) {
    stop("Intervalo inválido")
  }
  
  # Iterando para encontrar um valor para a função 'c'
  sucesso = FALSE
  for (i in 1:maxiter) {
    c <- (a * fb - b * fa) / (fb - fa)
    fc <- f(c)
    
    if (abs(fc) < tol) {
      sucesso = TRUE
      break
      
    }
    
    if (fa * fc < 0) {
      b <- c
      fb <- fc
    } else {
      a <- c
      fa <- fc
    }
  }
  
  if (sucesso == TRUE) {
    
    # Indicação da raiz aproximada
    retorno <- c
  } else {
    retorno <- NULL
    message("O método não convergiu")
  }
  return(retorno)
}


# Criando uma função re-escrita

D <- function(theta, n, ybar, that) {
  2 * n * (log(that / theta) + ybar * (theta - that))
}

# Testando a função

n <- 6 # Quantidade de de observações
ybar <- 3.5 # Média das observações
that <- 2.8 # Estimativa inicial de theta


# Resolvendo a equação

f <- function(theta) {
  D(theta, n, ybar, that) - 3.84  
}

# Encontrando a raiz de f
theta <- regula_falsi(f, 0.001, 10)  

# Resultado
theta  

# Output:
# [1] 2.901614



## Ex 2)
'
        Use o método de Newton para resolver o seguinte sistema de equações não lineares.
        Forneça a implementação do método de Newton e a aplicação ao sistema dado. Use para comparação as
        rotinas prontas do pacote rootSolve.
'

# Criando as funções do sistema de equações

f1 <- function(x, y) {y - cos(x)}

f2 <- function(x, y) {x - sin(y)}

# Criando objetos para as derivadas parciais de f1 e f2

df1_dx <- function(x, y) {sin(x)}

df1_dy <- function(x, y) {1}

df2_dx <- function(x, y) {1}

df2_dy <- function(x, y) {-cos(y)}


# Criando a matriz Jacobiana

J <- function(x, y) {
  matrix(c(df1_dx(x, y), 
           df1_dy(x, y), 
           df2_dx(x, y), 
           df2_dy(x, y)), 
           nrow = 2)
}

# Criando o vetor de funções F

F <- function(x, y){
  c(f1(x, y), 
    f2(x, y))
}

# Configurando tolerância e máximo número de iterações
tol <- 1e-10
max_iter <- 1000

# Atrbuindo valores iniciais a 'x' e 'y'
x <- 1
y <- 1


# Implementação do Método de Newton
for (i in 1:max_iter) {
  
  # Calculando a matriz Jacobiana e o vetor de funções para os valores atuais de x e y
  Jk <- J(x, y)
  Fk <- F(x, y)
  
  # Calcula a solução do sistema linear Jk * delta = -Fk
  delta <- solve(Jk, -Fk)
  
  # Atualiza os valores de x e y
  x <- x + delta[1]
  y <- y + delta[2]
  
  # Verifica a condição de parada
  if (max(abs(delta)) < tol) {
    break
  }
}

# Solução
cat("Solução: x = ", x, "; y = ", y, sep="")

# Output:
# Solução: x = 0.6948197; y = 0.7681692


## Comparando resultados utilizando o pacote rootSolve
library(rootSolve)

# Criando uma função para a equação
eq <- function(xy){
  
  x <- xy[1]
  y <- xy[2]
  eq1 <- cos(x) - y
  eq2 <- x - sin(y)
  
  return(c(eq1, eq2))
}


# Utilizando a função multiroot()
# COnfigurando a estimativa inicial de 'x' e 'y'
xy <- c(1,1)

# Solução
solution <- multiroot(eq, start=xy)

cat("Solução: x = ", solution$root[1], "; y = ", solution$root[2], sep = "")

# Output:
# Solução: x = 0.6948197; y = 0.7681692



## Ex 3)
'
        Implemente o método quasi-Newton BFGS. Use a sua implementação para otimizar a seguinte função
        perda __. Considere o seguinte código para gerar yi. O parâmetro deve ser especificado como uma reta __.
        Note que você deverá otimizar os parâmetros Beta0 e Beta1 que na simulação foram fixados em Beta0 = 5 e 
        Beta1 = 3.
'

# Simulação
set.seed(123)
x1 <- rnorm(100)
mu <- 5 + 3*x1
y <- rt(n = 100, df = 3) + mu

# Função Perda
loss <- function(beta, x, y) {
  
  mu <- beta[1] + beta[2]*x
 
  return(sum(log(cosh(mu - y))))
}


# Função Gradiente
gradLoss <- function(beta, x, y) {
  
  mu <- beta[1] + beta[2]*x
  d1 <- -sum(sinh(mu - y)/cosh(mu - y))
  d2 <- -sum(x*sinh(mu - y)/cosh(mu - y))
  
  return(c(d1, d2))
}

# Método quasi-newton BFGS.
# Configurando valores iniciais para os parâmetros - Beta
betaParmInit <- c(0, 0)

# Otimizando a Função Perda - Método BFGS
solution <- optim(par = betaParmInit, 
                fn = loss, 
                gr = gradLoss, 
                x = x1, 
                y = y, 
                method = "BFGS")

# Solução
cat("Beta0 e Beta1:", solution$par)
cat("Solução Função Perda:", solution$value)

# Output:
# Beta0 e Beta1: -2.961059e-16 -7.003695e-17
# Solução da Função Perda: 489.1202


## Ex 4)
'
        Escolha um destes canais e otimize o modelo logístico para predizer qual será o número acumulado de 
        inscritos para os próximos 365 dias. Ao apresentar sua solução computacional faça o máximo para explicar 
        as suas decisões e estratégias de implementação. Tome o máximo de cuidado para que a sua análise seja 
        reproduzível.
'

par(mfrow = c(1,1), mar=c(2.6, 3, 1.2, 0.5), mgp = c(1.6, 0.6, 0))
f_log <- function(DIAS, L, beta, beta0) {
  out <- L/(1+ exp(-beta*(DIAS - beta0)))
  return(out)
}
DIAS <- 1:800
plot(f_log(DIAS = DIAS, L = 90, beta = 0.01, beta0 = 400) ~ DIAS,
     ylab = "Número de inscritos", xlab = "Dias da abertura",
     type = "l", ylim = c(0,95))
abline(h = 90)
text(x = 800, y = 93, label = "L")
text(x = 425, y = f_log(DIAS = 400, L = 90, beta = 0.01, beta0 = 400),
     label = expression(beta))
points(x = 400, pch = 19, col = "red",
       y = f_log(DIAS = 400, L = 90, beta = 0.01, beta0 = 400))

# Note que o modelo representa a intuição de como o número acumulado de inscritos em um canal deve se
# comportar. No Código abaixo a base de dados é carregada e organizada por canal.
url <- "http://leg.ufpr.br/~wagner/data/youtube.txt"
dados <- read.table(url, header = TRUE)
dados_canal <- split(dados, dados$CANAL)
dados1 <- dados_canal[[1]]
dados2 <- dados_canal[[2]]
dados1$INSCRITOS <- dados1$INSCRITOS/100000
dados1$Y <- cumsum(dados1$INSCRITOS)
dados2$INSCRITOS <- dados2$INSCRITOS/100000
dados2$Y <- cumsum(dados2$INSCRITOS)

# Podemos fazer o gráfico dos dados observados para explicitar o objetivo de predizer o número de inscritos 
# acumulado para os próximos 365 dias.
par(mfrow = c(1,2), mar=c(2.6, 3, 1.2, 0.5), mgp = c(1.6, 0.6, 0))
plot(dados1$Y ~ dados1$DIAS, xlim = c(0, 1215), ylim = c(0, 25),
     ylab = "Número de inscritos*100000", main = "Canal 1",
     xlab = "Dias", type = "o", cex = 0.1)
abline(v = 850)
plot(dados2$Y ~ dados2$DIAS, ylab = "Número de inscritos*100000", main = "Canal 2",
     xlab = "Dias", ylim = c(0, 50), xlim = c(0, 980), type = "p", cex = 0.1)
abline(v = 607)


## Otimização do modelo logístico para predizer qual será o número acumulado de inscritos do canal 2
#  para os próximos 365 dias.

# Função para o modelo logístico 
f_log <- function(DIAS, L, beta, beta0) {
  
  out <- L/(1+ exp(-beta*(DIAS - beta0)))
  
  return(out)
}

# Preparação dos dados
library(tidyverse)

dadosModelo <- dados %>%
  filter(CANAL== 'vocesabia') %>%
  select(DIAS,INSCRITOS)

# Criando o modelo
model <- nls(
  INSCRITOS ~ f_log(DIAS, L, beta, beta0),
  data = dadosModelo,
  start = list(L = max(dados$INSCRITOS), beta = 1, beta0 = mean(dados$DIAS))
)

# Ajuste do modelo e resultados
summary(model)

# Output:
# Parameters:
#   Estimate Std. Error t value Pr(>|t|)    
#   L     8.860e+03  6.976e+02   12.70   <2e-16 ***
#   beta  8.298e-03  5.528e-04   15.01   <2e-16 ***
#   beta0 4.693e+02  2.163e+01   21.69   <2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# Residual standard error: 958.7 on 604 degrees of freedom
# Number of iterations to convergence: 20 
# Achieved convergence tolerance: 6.097e-06


# Previsão 365 dias
apartir_de <- max(dadosModelo$DIAS)
ate_dia <- apartir_de+364
dados_previstos <- data.frame(DIAS = apartir_de:ate_dia)

# Previsões
previsoes <- predict(model, newdata = dados_previstos)

dados_previstos$INSCRITOS <- round(previsoes)

# Resultado - Número total de inscritos nos próximos 365 dias
Inscritos365dias <- max(dados_previstos$INSCRITOS)

cat("O número acumulado de inscritos para os próximos 365 dias será de", Inscritos365dias, "inscritos")

# Output:
# O número acumulado de inscritos para os próximos 365 dias será de 8724 inscritos


# Plotando previsões
library(ggplot2)
options(dplyr.summarise.inform = FALSE)

# Preparando dados em novos dataframes
dataModelo2 <- dadosModelo
dados_previstos2 <- dados_previstos

dataModelo2$INSCRITOS <- dadosModelo$INSCRITOS / 1000
dados_previstos2$INSCRITOS <- dados_previstos$INSCRITOS /1000

dadosAll <- rbind(dataModelo2, dados_previstos2)

# Gerando gráfico de dados históricos e previsões
ggplot(data = dadosAll, 
       mapping = aes(x = DIAS, 
                     y = INSCRITOS)) +
  geom_point(data = dataModelo2, 
            size = 2,
            alpha = 0.3) +
  geom_line(data = dadosAll, 
            aes(y = ifelse(DIAS > max(dadosModelo$DIAS), INSCRITOS, NA)), 
             color = "red", 
           linewidth = 1) +
  guides() +
  labs(title = "Previsão de Inscritos no Canal nos Próximos 365 dias",
       x = "Dias decorridos desde a criação do canal",
       y = "Número de Inscritos (n/1000)") +
       theme_light()

################################### FIM ###################################

