# Sessões bloqueadas

## Sintoma

Use quando uma transação ou operação está aguardando um lock e as sessões parecem não progredir.

## Arquivo e pré-requisitos

- SQL: [`blocked_sessions.sql`](../../sql/locks/blocked_sessions.sql)
- PostgreSQL 15–18; pode ser executado no primário ou em um standby.
- Não requer extensão.
- Detalhes de outras sessões podem exigir `pg_monitor` ou `pg_read_all_stats`; sem esses privilégios, os dados do bloqueador podem estar incompletos.

## Execução

No `psql`, execute `\i sql/locks/blocked_sessions.sql`; em pgAdmin ou outro cliente, abra o arquivo e execute a consulta.

## Interpretação

Cada linha representa uma combinação de sessão bloqueada (`blocked_pid`) e um de seus bloqueadores (`blocking_pid`); uma sessão pode aparecer em várias linhas se houver mais de um bloqueador. `blocked_for` mede o tempo da consulta bloqueada. `blocking_pid` igual a `0` identifica um bloqueador que é uma transação preparada, sem sessão correspondente em `pg_stat_activity`; nesse caso, os detalhes da sessão ficam nulos. `blocking_transaction_age` também pode ser nulo quando não há início de transação visível para o bloqueador. `wait_event` descreve a espera reportada naquele instante.

O estado pode mudar enquanto a consulta roda: ausência de linhas significa que ela não observou pares bloqueados naquele instante. Aplicações e endereços podem identificar sistemas internos; sanitize a saída antes de compartilhá-la. A consulta não mostra texto SQL nem encerra sessões.

## Próximos passos seguros

Compare as sessões com a duração da transação e o serviço de origem. Consulte o runbook de [transações longas](../connections/long_running_transactions.md) para avaliar sessões com transação aberta. Não cancele nem encerre sessões com base apenas neste resultado; investigue o impacto e obtenha autorização operacional.
