-- Objetivo: mostrar pares de sessões bloqueadas e bloqueadoras.
-- Compatibilidade: PostgreSQL 15–18; usa pg_blocking_pids e pg_stat_activity.
-- Contexto: qualquer instância PostgreSQL (primário ou standby).
-- Permissões: detalhes completos de outras sessões podem exigir pg_monitor
-- ou pg_read_all_stats; sem isso, os dados da sessão bloqueadora podem ser parciais.
-- Extensões: nenhuma.
-- Segurança: somente leitura; lista um resultado por bloqueador e não encerra sessões.

SELECT
    blocked.pid AS blocked_pid,
    blocked.datname AS database_name,
    blocked.usename AS blocked_role,
    blocked.application_name AS blocked_application,
    clock_timestamp() - blocked.query_start AS blocked_for,
    blocked.wait_event_type,
    blocked.wait_event,
    waiting_on.blocker_pid AS blocking_pid,
    blocker.usename AS blocking_role,
    blocker.application_name AS blocking_application,
    blocker.state AS blocking_session_state,
    clock_timestamp() - blocker.xact_start AS blocking_transaction_age
FROM pg_stat_activity AS blocked
CROSS JOIN LATERAL unnest(pg_blocking_pids(blocked.pid)) AS waiting_on(blocker_pid)
LEFT JOIN pg_stat_activity AS blocker
    ON blocker.pid = waiting_on.blocker_pid
WHERE blocked.pid <> pg_backend_pid()
ORDER BY blocked.query_start ASC NULLS LAST, blocked.pid, waiting_on.blocker_pid;
