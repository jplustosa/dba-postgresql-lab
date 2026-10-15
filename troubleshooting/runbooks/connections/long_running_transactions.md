# Transações longas

## Sintoma

Use este diagnóstico quando sessões parecem manter locks, impedir manutenção ou permanecer em `idle in transaction` por tempo incomum.

## Arquivo e pré-requisitos

- SQL: [`long_running_transactions.sql`](../../sql/connections/long_running_transactions.sql)
- PostgreSQL 15–18; pode ser executado no primário ou em um standby.
- Não requer extensão.
- Para ver detalhes de sessões de outros usuários, use uma função de monitoramento apropriada, como `pg_monitor` ou `pg_read_all_stats`.

## Execução

No `psql`, execute `\i sql/connections/long_running_transactions.sql`; em pgAdmin ou outro cliente, abra o arquivo e execute a consulta.

## Interpretação

A consulta mostra sessões de cliente com `xact_start` definido, ordenadas da transação mais antiga para a mais recente. `transaction_age` mede desde o início da transação; `active_query_age` mede a duração da consulta atual e fica nulo quando a sessão não está ativa; assim, uma sessão ociosa não aparenta ter uma consulta ainda em execução. `state` ajuda a distinguir trabalho ativo de uma sessão ociosa que ainda mantém transação aberta. `wait_event_type` e `wait_event` descrevem uma espera atual, se houver. O SQL da sessão não é retornado.

`application_name` e `client_addr` ajudam a localizar a origem, mas podem revelar detalhes internos. Com visibilidade restrita, os resultados podem estar incompletos.

## Próximos passos seguros

Verifique o serviço de origem, a duração esperada da operação e se a aplicação deixou uma transação aberta. Correlacione o PID com o runbook de [sessões bloqueadas](../locks/blocked_sessions.md). Não encerre sessões sem avaliar rollback, impacto na aplicação e autorização do responsável.
