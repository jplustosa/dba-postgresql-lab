-- Objetivo: priorizar padrões de consulta pelo tempo acumulado de execução.
-- Compatibilidade: PostgreSQL 15–18 e versão correspondente de pg_stat_statements.
-- Contexto: primário ou standby; execute em uma base onde a view esteja instalada.
-- Permissões: as estatísticas podem ser visíveis; pg_read_all_stats ou pg_monitor permite ver queryid de outros usuários.
-- Extensão: pg_stat_statements deve já estar carregada e instalada; este arquivo não a habilita.
-- Segurança: somente leitura; não seleciona texto SQL, que pode conter informação sensível.

SELECT
    database.datname AS database_name,
    pg_get_userbyid(statements.userid) AS role_name,
    statements.queryid,
    statements.toplevel,
    statements.calls,
    round(statements.total_exec_time::numeric, 2) AS total_exec_time_ms,
    round(statements.mean_exec_time::numeric, 2) AS mean_exec_time_ms,
    statements.rows AS rows_processed,
    statements.shared_blks_hit AS shared_blocks_hit,
    statements.shared_blks_read AS shared_blocks_read
FROM pg_stat_statements AS statements
LEFT JOIN pg_database AS database
    ON database.oid = statements.dbid
WHERE statements.calls > 0
ORDER BY statements.total_exec_time DESC
LIMIT 25;
