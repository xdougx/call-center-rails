## Problema

1. Imagine que você tem um call center com três níveis de funcionários: atendente, líder técnico, gerente de projetos. 

2. Podem existir vários atendentes, mas apenas um líder técnico e um gerente. Uma chamada telefônica devem ser alocada para um atendente disponível.

3. Caso nenhum atendente estiver disponível, a ligação deve ser redirecionada para o líder técnico. 

4. Se o líder técnico não estiver disponível, a ligação deve ser redirecionada para o gerente de projetos. 

5. Como você projetaria as classes e implementaria uma solução para o redirecionamento de chamadas.

===============================

## Solução

A solução segue de forma bem simple e direta aonde as responsabilidades foram:

##### Central

1. Adicionar funcionário

2. Receber chamada

3. Selecionar funcionário livre para o atendimento da chamada conforme segue hierarquia e disponibilidade

4. Verificar se há alguma chamada em 'aguardo' e redirecionar para algum funcionário que terminou seu chamado

##### Funcionario

1. Atender Chamada

2. Finalizar Chamada

##### Chamada

1. Ser Atendida

```$ rspec --color --format documentation ```

Exceptions::Model
  building a model exception
    should have a message
    should build a model error
    should have the model name

Funcionario
  answering a call and finishing
    when receives a call
      should answer the call
      finishing a call
        should finish and get another call
        should finish and get status waiting
  creating a new employee
    validating the necessary attributes and creating
      when has no errors
        should be created when save
        nome
          should be present
      when has some errors
        should not be valid
        should require nome to be set
        should raise Exception

Exceptions::Base
  building an error exception
    shouls check if is a model error
    should respond to build

Central
  adding a new employee
    should be kind of Gerente
    should be kind of Atendente
    should raise an Exceptions::Model
    should set the new employee to be ready for a new call
    should add a new employee
    should be kind of Lider
  creating a central
    validating the required fields
      when is valid
        should persist a new central into DB
        localizacao
          should be present
        nome
          should be present
      when is not valid
        should require localizacao to be set
        should require nome to be set
        should raise Exceptions::Model
        should not be valid
  receiving a call
    receiving the call
      should receive true if its all ok
      should receive a call and change count
      should put the call in the wait queue
      should have at least one employee in busy status
    selecting a free employee
      should select an Lider if doesn't any Atendente free
      should select an Antendente if has any one free
      should select an Gerente if doesn't have Antendente and Lider free
    checking if has any call in the wait queue
      should redirect a call to an Atendente if have any waiting call

Finished in 0.82173 seconds (files took 1.67 seconds to load)
34 examples, 0 failures

========================