-- Objetivo: comparar envio, gravação, flush e replay de WAL nos standbys diretos.
-- Compatibilidade: PostgreSQL 15–18; usa pg_stat_replication e pg_wal_lsn_diff.
-- Contexto: execute no servidor primário; a view lista somente standbys diretamente conectados.
-- Permissões: pg_monitor ou pg_read_all_stats para detalhes completos dos WAL senders.
-- Extensões: nenhuma.
-- Segurança: somente leitura; application_name e client_addr podem identificar sistemas internos.

SELECT
    pid,
    application_name,
    client_addr,
    state AS sender_state,
    sync_state,
    sent_lsn,
    write_lsn,
    flush_lsn,
    replay_lsn,
    pg_wal_lsn_diff(sent_lsn, write_lsn) AS sent_not_written_bytes,
    pg_wal_lsn_diff(sent_lsn, flush_lsn) AS sent_not_flushed_bytes,
    pg_wal_lsn_diff(sent_lsn, replay_lsn) AS sent_not_replayed_bytes,
    write_lag,
    flush_lag,
    replay_lag,
    reply_time
FROM pg_stat_replication
ORDER BY application_name, client_addr NULLS FIRST, pid;
