# Tamanho de banco e relações

## Sintoma

Use quando for preciso identificar o tamanho atual do banco conectado e localizar relações que representam maior parte do espaço de dados.

## Arquivo e pré-requisitos

- SQL: [`database_relation_sizes.sql`](../../sql/capacity/database_relation_sizes.sql)
- PostgreSQL 15–18; execute no banco que deseja analisar, no primário ou standby.
- Não requer extensão.
- A conexão já pressupõe `CONNECT` ao banco atual. Se permissões de objeto ou política local limitarem o inventário, peça ao responsável do ambiente a permissão de leitura necessária.

## Execução

No `psql`, execute `\i sql/capacity/database_relation_sizes.sql`; em pgAdmin ou outro cliente, abra o arquivo e execute as duas consultas do arquivo. Elas analisam apenas `current_database()`.

## Interpretação

O primeiro resultado mostra o tamanho total do banco atual em bytes e em formato legível. O segundo lista até 25 tabelas e views materializadas de schemas de usuário, ordenadas por `total_size_bytes`; esse total inclui índices e dados TOAST. `relation_size_bytes` mede o tamanho principal da relação. Partições físicas aparecem individualmente; a tabela particionada pai não armazena os dados das partições.

Essas medidas descrevem objetos PostgreSQL, não espaço livre do disco do servidor. A consulta também não inclui outros bancos do cluster na lista de relações.

## Próximos passos seguros

Compare os tamanhos em diferentes datas para entender crescimento. Para verificar espaço livre e capacidade do volume, consulte monitoramento do sistema operacional ou da plataforma gerenciada. Não remova objetos com base somente no tamanho retornado.
