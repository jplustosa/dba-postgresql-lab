# Como contribuir

Contribuições são bem-vindas quando ajudam a diagnosticar um problema operacional de PostgreSQL com uma consulta clara e um guia prático correspondente.

## Organização dos arquivos

Mantenha SQL e runbook na mesma categoria e com o mesmo nome-base:

```text
sql/<categoria>/<nome>.sql
runbooks/<categoria>/<nome>.md
```

Categorias atuais: `connections`, `locks`, `performance`, `capacity`, `maintenance` e `replication`.

## Cabeçalho obrigatório da consulta

Cada arquivo SQL deve começar com comentários que informem:

- objetivo da consulta;
- versões PostgreSQL consideradas (15–18) e qualquer diferença relevante;
- contexto de execução (`primary`, `standby` ou ambos);
- permissões necessárias e limitações de visibilidade;
- extensão opcional, se houver;
- confirmação de que a consulta é diagnóstica e somente de leitura.

Não adicione comandos que alterem dados ou configurações. Não instale nem ative extensões. Evite selecionar texto SQL, identificadores de aplicação ou outros campos sensíveis quando não forem necessários para a investigação.

## Estrutura do runbook

O arquivo Markdown correspondente deve explicar:

1. sintomas que justificam a consulta;
2. pré-requisitos de versão, função do servidor, permissões e extensões;
3. como abrir e executar manualmente o arquivo SQL;
4. como interpretar as colunas e reconhecer limitações de visibilidade;
5. próximos passos seguros para investigar, sem executar remediações automaticamente.

Mantenha cada descrição alinhada aos nomes e resultados realmente apresentados pela consulta. Use apenas dados fictícios se um exemplo de saída for indispensável.

## Revisão antes de enviar

- Confirme que o SQL é somente de leitura.
- Revise nomes de colunas, joins, filtros e compatibilidade com PostgreSQL 15–18.
- Confira se o runbook aponta para o arquivo correto e explica todas as pré-condições.
- Remova credenciais, connection strings, dados de produção e saídas sensíveis.
- Atualize o índice de runbooks no `README.md` ao criar uma nova categoria ou guia.
