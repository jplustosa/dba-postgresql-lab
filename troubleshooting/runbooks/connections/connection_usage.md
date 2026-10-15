# Uso de conexões

## Sintoma

Investigue quando aplicações relatam falhas para abrir conexões, quando o número de sessões cresce, ou quando é necessário entender quais bancos, funções e estados concentram sessões.

## Arquivo e pré-requisitos

- SQL: [`connection_usage.sql`](../../sql/connections/connection_usage.sql)
- PostgreSQL 15–18; pode ser executado no primário ou em um standby.
- Não requer extensão.
- Um usuário sem `pg_monitor` ou `pg_read_all_stats` pode ver apenas parte dos detalhes de outras sessões.

## Execução

No `psql`, execute `\i sql/connections/connection_usage.sql`; em pgAdmin ou outro cliente, abra o arquivo e execute a consulta. Ela exclui o PID da própria sessão de diagnóstico.

## Interpretação

Cada linha agrupa sessões de cliente pelo banco (`database_name`), função (`role_name`) e estado (`session_state`). `session_count` é a quantidade observada naquele instante; não é um histórico nem necessariamente inclui a sessão que executou a consulta. `active`, `idle` e `idle in transaction` indicam estados diferentes, e devem ser avaliados junto ao comportamento da aplicação.

## Próximos passos seguros

Compare os maiores grupos com os pools de conexão e o padrão de carga esperado. Para investigar sessões que mantêm transações abertas, use o runbook de [transações longas](long_running_transactions.md). Confirme tendências com métricas históricas antes de alterar limites ou configurações. Nomes de bancos e funções podem ser sensíveis; sanitize a saída antes de compartilhá-la.
