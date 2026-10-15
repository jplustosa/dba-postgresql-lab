-- Objetivo: ver progresso de vacuum em execução e estimativas de manutenção por tabela.
-- Compatibilidade: PostgreSQL 15–18; usa pg_stat_progress_vacuum e pg_stat_user_tables.
-- Contexto: conecte-se ao banco alvo no primário; numa standby, os resultados descrevem somente o estado local.
-- Permissões: pg_monitor ou pg_read_all_stats para detalhes completos de outros processos.
-- Extensões: nenhuma.
-- Segurança: somente leitura; estatísticas de linhas mortas são estimativas, não medição de bloat.

-- Resultado 1: operações VACUUM atualmente em andamento.
SELECT
    activity.datname AS database_name,
    progress.pid,
    progress.relid::regclass AS relation_name,
    progress.phase,
    clock_timestamp() - activity.query_start AS operation_age,
    progress.heap_blks_total,
    progress.heap_blks_scanned,
    progress.heap_blks_vacuumed,
    progress.index_vacuum_count
FROM pg_stat_progress_vacuum AS progress
JOIN pg_database AS target_database
    ON target_database.oid = progress.datid
   AND target_database.datname = current_database()
JOIN pg_stat_activity AS activity
    ON activity.pid = progress.pid
ORDER BY activity.query_start ASC NULLS LAST;

-- Resultado 2: tabelas com maior estimativa atual de tuplas mortas.
SELECT
    schemaname AS schema_name,
    relname AS relation_name,
    n_live_tup AS estimated_live_rows,
    n_dead_tup AS estimated_dead_rows,
    last_vacuum,
    last_autovacuum,
    vacuum_count,
    autovacuum_count
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC NULLS LAST, schemaname, relname
LIMIT 25;
