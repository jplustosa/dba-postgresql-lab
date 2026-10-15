# Consultas com maior custo acumulado

## Sintoma

Investigue quando há suspeita de consultas que consomem muito tempo total ou quando é necessário comparar padrões de uso ao longo de uma janela de observação.

## Arquivo e pré-requisitos

- SQL: [`top_statements.sql`](../../sql/performance/top_statements.sql)
- PostgreSQL 15–18; pode ser executado no primário ou standby, em uma base na qual a view `pg_stat_statements` esteja instalada.
- A extensão precisa já estar carregada e configurada pelo responsável do ambiente. Este kit não instala, ativa nem altera configurações.
- As estatísticas de outras funções podem ser visíveis; `pg_read_all_stats` ou `pg_monitor` é necessário para ver o `queryid` dessas funções.

## Execução

No `psql`, execute `\i sql/performance/top_statements.sql`; em pgAdmin ou outro cliente, abra o arquivo e execute a consulta. Se a relação não existir, confirme a disponibilidade da extensão com o DBA responsável; não tente ativá-la como parte deste diagnóstico.

## Interpretação

A consulta retorna até 25 padrões ordenados por `total_exec_time_ms`, o tempo total acumulado em milissegundos. `mean_exec_time_ms` é a média por chamada, `calls` é a contagem acumulada e `rows_processed` indica linhas processadas conforme o módulo. `shared_blocks_hit` e `shared_blocks_read` ajudam a comparar acertos e leituras para os buffers compartilhados; não medem isoladamente a leitura física no storage.

Os números são acumulados desde a última reinicialização das estatísticas, não representam uma janela fixa nem necessariamente uma consulta ainda em execução. `queryid` identifica a estrutura do padrão, mas fica nulo para consultas de outras funções sem os privilégios necessários; o SQL não é exibido para reduzir exposição de dados. `toplevel` distingue comandos enviados pelo cliente de comandos aninhados quando `pg_stat_statements.track = all`.

## Próximos passos seguros

Compare custo total, média e chamadas na mesma janela de observação. Correlacione com métricas da aplicação e investigue o padrão por `queryid` nos meios autorizados da equipe. Não redefina estatísticas nem altere a configuração da extensão para executar este runbook. Sanitize nomes de bases e funções antes de compartilhar resultados.
