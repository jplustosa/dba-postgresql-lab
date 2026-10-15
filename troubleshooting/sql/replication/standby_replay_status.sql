-- Objetivo: conferir o WAL recebido pelo standby e a distância para o replay aplicado.
-- Compatibilidade: PostgreSQL 15–18; usa pg_stat_wal_receiver e funções WAL.
-- Contexto: execute no standby em recuperação; não leia conninfo, que pode expor configuração.
-- Permissões: pg_monitor ou pg_read_all_stats para detalhes completos do WAL receiver.
-- Extensões: nenhuma.
-- Segurança: somente leitura; host/porta do primário podem identificar infraestrutura.

SELECT
    receiver.status AS receiver_status,
    receiver.sender_host,
    receiver.sender_port,
    receiver.receive_start_lsn,
    receiver.flushed_lsn,
    receiver.latest_end_lsn,
    receiver.last_msg_receipt_time,
    clock_timestamp() - receiver.last_msg_receipt_time AS time_since_last_message,
    pg_last_wal_replay_lsn() AS latest_replayed_lsn,
    CASE
        WHEN receiver.flushed_lsn IS NOT NULL
         AND pg_last_wal_replay_lsn() IS NOT NULL
        THEN pg_wal_lsn_diff(receiver.flushed_lsn, pg_last_wal_replay_lsn())
    END AS received_not_replayed_bytes
FROM pg_stat_wal_receiver AS receiver
WHERE pg_is_in_recovery();
