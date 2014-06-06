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