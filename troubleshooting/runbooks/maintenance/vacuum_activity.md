# Atividade de vacuum

## Sintoma

Use quando houver suspeita de vacuum/autovacuum atrasado, quando uma manutenção estiver em execução por muito tempo ou quando as estimativas de tuplas mortas crescerem.

## Arquivo e pré-requisitos

- SQL: [`vacuum_activity.sql`](../../sql/maintenance/vacuum_activity.sql)
- PostgreSQL 15–18; execute no banco alvo do primário. Em uma standby, os resultados descrevem somente o estado local, não o progresso de vacuum no primário.
- Não requer extensão.
- Sem `pg_monitor` ou `pg_read_all_stats`, detalhes e estatísticas de outros processos podem aparecer nulos ou incompletos; confirme a visibilidade antes de concluir que não há progresso ou atividade.

## Execução

No `psql`, execute `\i sql/maintenance/vacuum_activity.sql`; em pgAdmin ou outro cliente, abra o arquivo e execute as duas consultas.

## Interpretação

As consultas analisam o banco conectado. O primeiro resultado lista apenas operações VACUUM observadas em andamento e a fase reportada por `pg_stat_progress_vacuum`; `VACUUM FULL` não aparece nessa view e pode ser acompanhado por `pg_stat_progress_cluster`. Sem visibilidade suficiente, campos de outros processos também podem estar nulos ou incompletos. Ausência de linhas significa que nenhuma operação foi observada naquele instante, dentro desse escopo.

O segundo resultado ordena tabelas por `estimated_dead_rows`. `n_live_tup` e `n_dead_tup` são estimativas de estatísticas, podem ficar desatualizadas e não medem diretamente bloat. Datas de último vacuum e contadores ajudam a entender o histórico observado; os contadores podem ser reiniciados.

## Próximos passos seguros

Correlacione progresso e estimativas com atividade de escrita, tamanho, configuração vigente e duração esperada da tabela. Consulte métricas históricas antes de ajustar parâmetros ou iniciar manutenção. O kit não dispara vacuum nem altera configurações.
