# Catalago de Dados da camada Gold

## Geral
A camada gold é a camada que contem dados para usos analiticos e para a criação de relatorios. Consiste em **Tabelas de Dimenções** e **Tabela de fatos**

--- 
### **gold.dim_clientes**
- Objetivo: Armazenar detalhes dos clientes
- **Colunas:**

  |  Nome da coluna   | Tipo de dado     | Descrição                                                                                 |
  |------------------|---------------|-----------------------------------------------------------------------------------------------|
  | cliente_chave    | INT          | Chave substituta que identifica cada registro de clientes na tabela de dimenções               |
  | client_id        | INT                | Numero unico de cada cliente                                                             |
  | numero_cliente   | NVARCHAR(50)  |Identificador alfanumerico que representa o cliente                                            |
  | primeiro_nome    | NVARCHAR(50)  | Primeiro nome do cliente                                                                      |
  | segundo_nome     | NVARCHAR(50)  | Segundo nome do cliente                                                                       |
  | pais             | NVARCHAR(50)  | Pais que o cliente reside                                                                     |
  | estado_civil     | NVARCHAR(50)  | Estado civil do cliente (ex: 'casado', 'solteiro')                                            |
  | sexo             | NVARCHAR(50)  | Sexo do cliente (ex: 'masculino', 'femenino')                                                 |
  | data_de_nascimento  | DATE       | Data de nacimento do cliente (ex: 1971-10-06).                                                |
  | data_de_criacao  | DATE          | Data da crição do registro do cliente                                                         |


  ---

  ### **gold.dim_produtos**
  - Objetivo: Armazenar dados dos produtos
  - **Colunas:**
  
  | Nome da coluna    | Tipo de dado    | Descrição                                                                                     |
  |---------------------|---------------|-----------------------------------------------------------------------------------------------|
  | chave_produto       | INT           | Chave substituta que identifica cada registro de produtos na tabela dimenções                 |
  | id_produto          | INT           | Numero unico de cada produto                                                                  |
  | numero_produto      | NVARCHAR(50)  | Codigo alfanumerico que representa o produto                                                  |
  | nome_produto        | NVARCHAR(50)  | Nome do produto com uma breve descrição                                                       |
  | id_categoria        | NVARCHAR(50)  | Identificador da categoria do produto                                                         |
  | categoria           | NVARCHAR(50)  | Classificação mais ampla do produto (ex: bikes, components)                                   |
  | subcategoria        | NVARCHAR(50)  | Clasificação mais detalhada do produto, tipo do produto                                       |
  | manutencao          | NVARCHAR(50)  | Indicador de se o produto esta na manutenção ou nao (ex: 'sim', 'não')                        |
  | custo               | INT           | Custo do produto                                                                              |
  | linha               | NVARCHAR(50)  | Linha ou serie especifica que o produto pertence, (ex: 'estrada', 'montanha')                 |
  | data_inicial        | DATE          | Data eum que o produto ficou disponivel para venda ou uso                                     |


---

### **gold.fato_vendas**
- Objetivo: Armazenar dados de transições de vendas para analises
- **Colunas:**

  | Nome da coluna    | Tipo de dado     | Descrição                                                                                 |
  |------------------|---------------|-----------------------------------------------------------------------------------------------|
  | numero_pedido    | NVARCHAR(50)  | identificar unico alfanumerico para cade venda                                                |
  | chave_produto    | INT           | Chave substituta que vincula o produto a tabela de dimenções do produto                       |
  | chave_cliente    | INT           | Chave substituta que vincula o cliente a tabela de dimenções do cliente                       |
  | data_pedido      | DATE          | Data em que o pedido foi feito                                                                |
  | data_envio       | DATE          | Data em que o pedido foi enviado                                                              |
  | data_vencimento  | DATE          | Data de vencimento para o pagamento                                                           |
  | valor_vendas     | INT           | Valor total monetario da venda do item                                                        |
  | quantidade       | INT           | O numero de produto pedidos                                                                   |
  | preco            | INT           | Valor total do pedido                                                                         |
