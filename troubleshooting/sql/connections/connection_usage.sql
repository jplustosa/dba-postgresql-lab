-- Objetivo: resumir sessões de clientes por banco, função e estado.
-- Compatibilidade: PostgreSQL 15–18; usa pg_stat_activity e backend_type.
-- Contexto: qualquer instância PostgreSQL (primário ou standby).
-- Permissões: detalhes completos de outras sessões podem exigir pg_monitor
-- ou pg_read_all_stats; sem isso, a visibilidade pode ser parcial.
-- Extensões: nenhuma.
-- Segurança: somente leitura; exclui esta própria sessão de diagnóstico e não
-- seleciona texto SQL.

SELECT
    datname AS database_name,
    usename AS role_name,
    state AS session_state,
    count(*) AS session_count
FROM pg_stat_activity
WHERE backend_type = 'client backend'
  AND pid <> pg_backend_pid()
GROUP BY datname, usename, state
ORDER BY session_count DESC, datname NULLS FIRST, usename NULLS FIRST, state NULLS FIRST;
