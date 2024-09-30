<h1 align="center">SERVICEORDER APP</h1>

<div align="center">

[![Licença](https://img.shields.io/badge/Licença-MIT-green?style=for-the-badge)](LICENSE)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![MySQL](https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white)

![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

</div>

Um aplicativo super simples feito com Flutter e MySQL para gerenciar ordem de serviço, clientes e serviços.

Criado para a presentar em um trabalho de faculdade.

## Como rodar o projeto
Para conseguir rodar o projeto, faça um clone do repositório com:
`git clone https://github.com/andreschenato/serviceorder.git`

Após isso, execute o script `database_script.sql`. 

#### Opcional
Caso queira ter certeza de que todas as regras, views, functions, procedures e triggers estão funcionando, você pode executar o script `database_rules_etc.sql`.

Com o banco de dados rodando, agora você deve fazer uma cópia do arquivo `.env.example` e renomear o mesmo para `.env`, insira os dados do seu banco conforme solicitado no arquivo, abaixo segue um exemplo:
> .env
``` bash
DB_HOST='localhost'
DB_PORT='3306'
DB_USER='root'
DB_PASS='senha'
DB_SCHEMA='serviceorder'
```

Com essas configurações feitas, rode o comando `flutter pub get` para instalar as dependências e então o aplicativo estará pronto para ser usado. Basta compilar ou executar ele que o mesmo já estará funcionando.