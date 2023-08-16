#### Lista de Exercícios 1
#### Guilherme Cadori
#### 15/03/2023


#------------------------------#
### Exercício 1)

# Criar vetor para estados "no":
# PS. Adicionei o estado do Paraná nessa lista
# Acre, Alagoas, Amapá, Amazonas, Ceará, Espírito Santo, Maranhão Mato Grosso, Mato Grosso
# do Sul, Pará, Rio de Janeiro, Rio Grande do Norte, Rio Grande do Sul, Tocantins, Distrito Federal
estadosNo <- c('Acre', 'Alagoas', 'Amapá', 'Amazonas', 'Ceará', 'Espírito Santo', 
               'Maranhão', 'Mato Grosso', 'Mato Grosso do Sul', 'Pará', 'Paraná', 'Rio de Janeiro', 
               'Rio Grande do Norte', 'Rio Grande do Sul', 'Tocantins', 'Distrito Federal')

# Criar vetor para estados "na":
# Bahia, Paraíba
estadosNa <- c('Bahia', 'Paraíba')

# Criar vetor para estados "em":
# Goiás, Minas Gerais, Rondônia, Roraima, Santa Catarina, São Paulo, Sergipe
estadosEm <- c('Goiás', 'Minas Gerais', 'Rondônia', 'Roraima', 'Santa Catarina', 'São Paulo', 'Sergipe')


# Definindo a função para abertura do email
AberturaEmail <- function(estado){
  
  mensagem <- 'Estamos com uma super promoção para você que mora'
  
  if (estado %in% estadosNo) {
    paste(mensagem, 'no', estado)
  } else if (estado %in% estadosNa) {
    paste(mensagem, 'na', estado)
  } else if (estado %in% estadosEm){
    paste(mensagem, 'em', estado)
  } else print('Por favor indique um estado válido')
}


# Testando a função e Outputs:
AberturaEmail('Acre')
# Out: [1] "Estamos com uma super promoção para você que mora no Acre"

AberturaEmail('Bahia')
# Out: [1] "Estamos com uma super promoção para você que mora na Bahia"

AberturaEmail('Maranhão')
# Out: [1] "Estamos com uma super promoção para você que mora no Maranhão"

AberturaEmail('xx')
# Out: [1] "Por favor indique um estado válido"



#------------------------------#
### Exercício 2)

# Criar uma função para jogar Bozó
JogarBozo <- function() {
  
  # Possíveis resultados
  ResultadosPossiveis <- 6^5
  
  # Criar um vetor com cinco dados aleatórios
  dados <- sample(1:6, 5, replace = TRUE)
  
  # Contar frequência de cada número
  frequencias <- table(dados)
  
  # Verificar se há um full house
  fullHouse <- length(frequencias) == 2 && all(frequencias == c(2, 3))
  
  # Verificar se há uma sequência
  sequencia <- length(unique(dados)) == 5 && (max(dados) - min(dados) == 4 || max(dados) == 6 && min(dados) == 2)
  
  # Verificar se há uma quadra
  quadra <- any(frequencias >= 4)
  
  # Verificar se há um General
  general <- any(frequencias == 5)
  
  # Retornar os resultados em um vetor
  return(c(fullHouse, sequencia, quadra, general))
}


# Rodar 50.000 simulações e guardar os resultados
resultados <- t(replicate(50000, JogarBozo()))


# Calcular as probabilidades dos resultados desejados
probFullHouse <- mean(resultados[, 1])

probSequencia <- mean(resultados[, 2])

probQuadra <- mean(resultados[, 3])

probGeneral <- mean(resultados[, 4])

# Outputs:
# Indicação das probabilidades
paste("Probabilidade de se obter um Full house:", probFullHouse)
# Out: [1] "Probabilidade de se obter um Full house: 0.01978"

paste("Probabilidade de se obter uma Sequência:", probSequencia)
# Out: [1] "Probabilidade de se obter uma Sequência: 0.03112"

paste("Probabilidade de se obter uma Quadra:", probQuadra)
# Out: [1] "Probabilidade de se obter uma Quadra: 0.01948"


paste("Probabilidade de se obter um General:", probGeneral)
# Out: [1] "Probabilidade de se obter um General: 0.00076"



#------------------------------#
### Exercício 3)
# Criando a função para calcular o custo com chuveiro
gastoChuveiro <- function(consumo_hora, duracao_uso_h, valor_kwh) {
  
  if(consumo_hora <= 0 | duracao_uso_h < 0 | duracao_uso_h > (24*7) | valor_kwh <= 0) {
    print('As entradas devem ser maiores que zero e a quantidade de horas não pode ser superior à 168h/semana.')
  } else 
      return(paste("R$",consumo_hora * duracao_uso_h * valor_kwh))
}

# Testando a função e Outputs:
# Exemplo utilização correta
gastoChuveiro(5, 10, 0.8)
# Out: [1] R$ 40

# Exemplo utilização inadequada - uso em horas negativas
gastoChuveiro(5, -5, 0.8)
# Out: [1] "As entradas devem ser maiores que zero e a quantidade de horas não pode ser superior à 168h/semana."

# Exemplo utilização inadequada - uso em horas superior à 168h/semana
gastoChuveiro(5, 200, 0.8)
# Out: [1] "As entradas devem ser maiores que zero e a quantidade de horas não pode ser superior à 168h/semana."



#------------------------------#
## Exercício 4)
# Calcular Valor Futuro
CalcValorFuturo <- function(capital, taxaMensal, periodoMeses){
  
  if (capital < 0 | taxaMensal < 0 | periodoMeses < 0) {
    ("Valores de entrada precisam ser superiores a zero")
  } else
      return(paste("R$", round((vf = capital * (1 + (taxaMensal/100))^periodoMeses), 2)))
}


# Testar a função e tratamento de exceções e apresentando Outputs
CalcValorFuturo(10000,0.88,120)
# Out: [1] "R$ 28615.99"

CalcValorFuturo(10000,-5,5)
# Out: [1] "Valores de entrada precisam ser superiores a zero"

CalcValorFuturo(10000,1,120)
# Out: [1] "R$ 33003.87"



#------------------------------#
## Exercício 5)
# Percentual de gordura corporal do paciente do sexo masculino ou feminino

PercentGorduraCorporal <- function(sexo, tricep, subescap, peitoral
                                   , supraili, abdom, coxa, perna, idade){
  
  msgErro <- "Por favor indique o sexo do paciente ('M' ou 'F') e uitilize parâmetros númericos superiores a zero."
  somaMedidas <- sum(tricep, subescap, peitoral, supraili, abdom, coxa, perna)

  if (is.character(sexo) == FALSE | tricep < 0 | subescap  < 0 | peitoral  < 0 | supraili  < 0
      | abdom < 0 |coxa  < 0 | perna < 0 | idade < 0){
    return (msgErro)
  } else if(sexo == "M"){
      DensidadeM = 
        1.112 - (0.00043499 * somaMedidas) 
      + (0.00000055 * somaMedidas^2)
      - (0.00028826 * idade)
      PercenGord <- ((4.95 / DensidadeM) - 4.5) * 100
      if (PercenGord < 0){
        return(print("Por favor revise as medidas indicadas."))
      }
      return(paste("Percentual de gordura: ", round(PercenGord, 2), "%",sep=""))
  } else if(sexo == "F"){
      DensidadeF = 
          1.0970 - (0.00046971 * somaMedidas) 
          + (0.00000056 * somaMedidas^2)
          - (0.00012828 * idade)
      PercenGord <- ((4.95 / DensidadeF) - 4.5) * 100
      if (PercenGord < 0){
        return(print("Por favor revise as medidas indicadas."))
      }
      return(paste("Percentual de gordura: ", round(PercenGord, 2), "%",sep=""))
  } else
      return(msgErro)
}


# Testando função
# Teste 1: sexo="M", tricep=15, subescap=15, peitoral=15
# , supraili=5, abdom=5, coxa=25, perna=15, idade=20
PercentGorduraCorporal(sexo="M", tricep=15, subescap=15, peitoral=15
                       , supraili=5, abdom=5, coxa=25, perna=15, idade=20)
# Out: [1] "Percentual de gordura: 12.32%"


# Teste 2: sexo="F", tricep=20, subescap=25, peitoral=50
# , supraili=25, abdom=15, coxa=25, perna=50, idade=20
PercentGorduraCorporal(sexo="F", tricep=10, subescap=5, peitoral=30
                       , supraili=5, abdom=15, coxa=20, perna=20, idade=20)
# Out: [1] "Percentual de gordura: 22.47%"


# Teste 3: sexo="XX", tricep=20, subescap=25, peitoral=50
# , supraili=25, abdom=15, coxa=25, perna=50, idade=20
PercentGorduraCorporal(sexo="XX", tricep=10, subescap=5, peitoral=30
                       , supraili=5, abdom=15, coxa=20, perna=20, idade=20)
# Out: [1] "Por favor indique o sexo do paciente ('M' ou 'F') e uitilize parâmetros númericos superiores a zero."


# Teste 4: sexo="F", tricep=-1, subescap=25, peitoral=50
# , supraili=25, abdom=15, coxa=25, perna=50, idade=20
PercentGorduraCorporal(sexo="F", tricep=-1, subescap=5, peitoral=30
                       , supraili=5, abdom=15, coxa=20, perna=20, idade=20)
# Out: [1] "Por favor indique o sexo do paciente ('M' ou 'F') e uitilize parâmetros númericos superiores a zero."

