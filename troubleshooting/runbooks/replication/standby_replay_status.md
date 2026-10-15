# Recebimento e replay no standby

## Sintoma

Use quando for preciso verificar se o standby está recebendo WAL do servidor de origem e comparar o último WAL recebido com o último replay aplicado.

## Arquivo e pré-requisitos

- SQL: [`standby_replay_status.sql`](../../sql/replication/standby_replay_status.sql)
- PostgreSQL 15–18; execute no standby em recuperação.
- Não requer extensão.
- Sem `pg_monitor` ou `pg_read_all_stats`, detalhes do WAL receiver podem aparecer nulos ou incompletos; confirme a visibilidade antes de concluir que faltam WAL recebido ou replay.

## Execução

No `psql`, execute `\i sql/replication/standby_replay_status.sql`; em pgAdmin ou outro cliente, abra o arquivo e execute a consulta.

## Interpretação

A consulta mostra o estado do receiver, host e porta de origem, a posição de WAL persistida (`flushed_lsn`), a última posição informada ao sender (`latest_end_lsn`) e o horário da última mensagem. `time_since_last_message` é calculado para o instante da consulta. `received_not_replayed_bytes` compara o último WAL recebido e persistido com o último WAL aplicado pela recuperação; é uma diferença instantânea em bytes, não uma estimativa de tempo para alcançar o primário.

Nenhuma linha pode significar que o servidor não está em recuperação (por exemplo, foi promovido), que não há um WAL receiver ativo ou que a configuração usa outra origem de WAL. Um valor nulo para as posições pode ocorrer antes de haver WAL recebido ou replayado, ou quando os detalhes estão ocultos pelas permissões do usuário. Host e porta podem revelar detalhes de infraestrutura; não compartilhe a saída sem sanitização.

## Próximos passos seguros

Compare o status, o horário da mensagem e as posições em amostras sucessivas. Correlacione o resultado com logs do PostgreSQL, conectividade e o estado do primário; use também o runbook de [replicação no primário](primary_replication_status.md). Não altere configuração nem reinicie processos com base apenas nesta amostra.

## Referências

- [Documentação PostgreSQL: `pg_stat_wal_receiver`](https://www.postgresql.org/docs/18/monitoring-stats.html#MONITORING-PG-STAT-WAL-RECEIVER)
- [Documentação PostgreSQL: `pg_wal_lsn_diff`](https://www.postgresql.org/docs/18/functions-admin.html#FUNCTIONS-ADMIN-BACKUP)
