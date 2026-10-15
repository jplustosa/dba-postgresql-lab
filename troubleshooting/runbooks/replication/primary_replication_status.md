# Estado de replicação no primário

## Sintoma

Use quando for preciso verificar o estado do envio de WAL para standbys diretamente conectados ou comparar as posições de envio, gravação, flush e replay.

## Arquivo e pré-requisitos

- SQL: [`primary_replication_status.sql`](../../sql/replication/primary_replication_status.sql)
- PostgreSQL 15–18; execute no servidor primário.
- Não requer extensão.
- Sem `pg_monitor` ou `pg_read_all_stats`, detalhes dos WAL senders podem aparecer nulos ou incompletos; confirme a visibilidade antes de interpretar campos ausentes.

## Execução

No `psql`, execute `\i sql/replication/primary_replication_status.sql`; em pgAdmin ou outro cliente, abra o arquivo e execute a consulta.

## Interpretação

Cada linha representa um WAL sender e seu standby diretamente conectado; standbys em cascata não aparecem nessa view. `sender_state` indica o estado do envio e `sync_state` informa o papel síncrono reportado pelo primário. As diferenças em bytes comparam `sent_lsn` com as posições de escrita, flush e replay reportadas pelo standby.

`write_lag`, `flush_lag` e `replay_lag` medem atrasos recentes de propagação para os níveis correspondentes; não são previsões de quanto tempo o standby levará para alcançar o primário. Em uma réplica totalmente atualizada e sem atividade recente, esses campos podem ficar nulos depois de um intervalo. Nenhum valor isolado define um limite universal de saúde.

## Próximos passos seguros

Compare posições e estado em amostras sucessivas e correlacione com o volume de WAL e o ambiente de rede. Se necessário, confira o receptor no próprio standby com o runbook de [replay na réplica](standby_replay_status.md). `application_name` e `client_addr` podem revelar topologia interna; sanitize antes de compartilhar.

## Referência

[Documentação PostgreSQL: `pg_stat_replication`](https://www.postgresql.org/docs/18/monitoring-stats.html#MONITORING-PG-STAT-REPLICATION)
