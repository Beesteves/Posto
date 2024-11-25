# Gestão de Veículos e Abastecimentos #
Este projeto é uma aplicação Flutter com integração ao Firebase para gestão de veículos e seus abastecimentos, possibilitando que usuários adicionem, visualizem, editem e gerenciem informações pessoais e de seus carros de maneira eficiente e organizada.

# Recursos Implementados #
- Autenticação Firebase: Os usuários podem fazer login e suas informações são vinculadas ao UID.
- Gestão de Veículos:
  - Listar veículos cadastrados.
  - Adicionar novos veículos.
  - Editar informações dos veículos (nome, modelo, ano, consumo etc.).
  - Excluir veículos.
- Gestão de Abastecimentos:
  - Vincular abastecimentos a um veículo específico.
  - Calcular consumo médio por veículo.
  - Gerenciar histórico de abastecimentos.
- Perfil do Usuário:
  - Exibir informações do usuário.
  - Atualizar dados do perfil.

# Estrutura do Projeto #

# Modelos (Models)
- Carro: Representa um veículo e contém informações como nome, modelo, ano, placa, consumo médio e último KM registrado.

- Abastecimento: Representa um registro de abastecimento, contendo informações como KM rodados, litros abastecidos, data, e o veículo ao qual pertence.

# Controladores (Controllers)
- DaoCarro: Gerencia as operações de CRUD (Create, Read, Update, Delete) dos carros no Firebase Firestore.

- DaoAbastecimento: Gerencia os abastecimentos vinculados aos carros, incluindo cálculo de consumo médio.

# Telas (Screens)
- Tela de Login: Permite que o usuário faça login no aplicativo.
- Tela de Perfil: Exibe informações pessoais do usuário, permitindo atualizações.
- Tela de Listagem de Veículos: Mostra os veículos cadastrados pelo usuário e permite edição e exclusão.
- Tela de Edição de Veículo: Permite alterar as informações de um veículo selecionado.
- Tela de Abastecimentos: Lista e gerencia os abastecimentos vinculados aos veículos.


# Clone o repositório: #
````bash
    git clone https://github.com/Beesteves/Posto.git
    cd Posto
````
# Autor #

Beatriz Esteves Gonçalves

GitHub: Beesteves
Email: bestevesgoncalves@gmail.com
