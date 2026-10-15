-- Objetivo: localizar transações de clientes que permanecem abertas há mais tempo.
-- Compatibilidade: PostgreSQL 15–18; usa pg_stat_activity.backend_type.
-- Contexto: qualquer instância PostgreSQL (primário ou standby).
-- Permissões: detalhes completos de outras sessões podem exigir pg_monitor
-- ou pg_read_all_stats; sem isso, a visibilidade pode ser parcial.
-- Extensões: nenhuma.
-- Segurança: somente leitura; não seleciona texto SQL. application_name e
-- client_addr podem identificar sistemas internos; sanitize antes de compartilhar.

SELECT
    pid,
    datname AS database_name,
    usename AS role_name,
    application_name,
    client_addr,
    state AS session_state,
    clock_timestamp() - xact_start AS transaction_age,
    CASE WHEN state = 'active' THEN clock_timestamp() - query_start END AS active_query_age,
    wait_event_type,
    wait_event
FROM pg_stat_activity
WHERE backend_type = 'client backend'
  AND pid <> pg_backend_pid()
  AND xact_start IS NOT NULL
ORDER BY xact_start ASC;
