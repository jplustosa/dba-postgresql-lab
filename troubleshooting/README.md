# PostgreSQL DBA Troubleshooting Kit

Consultas SQL e runbooks curtos para investigar problemas comuns no dia a dia de quem administra PostgreSQL.

O kit ajuda a encontrar sessões longas, bloqueios, consultas com maior tempo acumulado, sinais de uso de espaço, atividade de vacuum e estado da replicação. Cada consulta é independente e vem acompanhada de um guia com pré-requisitos, leitura dos resultados e próximos passos de investigação.

## Compatibilidade

O escopo inicial documentado é PostgreSQL 15 a 18. Consulte o cabeçalho de cada arquivo e o runbook correspondente: algumas consultas dependem da função do servidor, de permissões de monitoramento ou de extensões opcionais.

## Como usar

1. Escolha um sintoma no [índice de runbooks](#runbooks).
2. Leia os pré-requisitos e confirme a versão, a função do servidor e as permissões.
3. Abra o arquivo SQL indicado no seu cliente PostgreSQL, como `psql`, pgAdmin ou DBeaver, e execute manualmente.
4. Compare o resultado com a explicação do runbook e investigue antes de fazer qualquer alteração no ambiente.

O repositório não instala dependências, não se conecta ao banco e não executa ações por conta própria. As consultas incluídas são somente de leitura. Ainda assim, diagnósticos podem acessar catálogos e estatísticas; revise o contexto e a carga do ambiente antes de executar em produção.

## Permissões e visibilidade

O PostgreSQL pode ocultar detalhes de outras sessões para usuários sem privilégios de monitoramento. Cada guia indica as permissões relevantes; algumas consultas podem exigir uma função como `pg_monitor` ou `pg_read_all_stats`. Com visibilidade restrita, resultados podem ser parciais.

A consulta de desempenho depende da extensão opcional `pg_stat_statements`. O kit não instala nem ativa extensões: siga o guia e confirme com o responsável pelo ambiente se ela já está disponível.

## Runbooks

| Área | Sintoma | Guia |
| --- | --- | --- |
| Conexões | Uso de conexões por banco, usuário e estado | [uso de conexões](runbooks/connections/connection_usage.md) |
| Conexões | Transações abertas por muito tempo | [transações longas](runbooks/connections/long_running_transactions.md) |
| Bloqueios | Sessões bloqueadas e bloqueadoras | [sessões bloqueadas](runbooks/locks/blocked_sessions.md) |
| Desempenho | Consultas com maior custo acumulado | [consultas de maior custo](runbooks/performance/top_statements.md) |
| Capacidade | Tamanho de bancos e relações | [tamanho de bancos e relações](runbooks/capacity/database_relation_sizes.md) |
| Manutenção | Atividade e estatísticas de vacuum | [atividade de vacuum](runbooks/maintenance/vacuum_activity.md) |
| Replicação | WAL enviado a standbys diretamente conectados | [status no primário](runbooks/replication/primary_replication_status.md) |
| Replicação | WAL recebido e aplicado pelo standby | [recebimento e replay no standby](runbooks/replication/standby_replay_status.md) |

## Cuidados ao compartilhar resultados

Resultados podem conter nomes de bancos, usuários, aplicações ou trechos de SQL. Remova informações sensíveis antes de enviar saídas para issues, chats ou outros canais públicos. O projeto não inclui exemplos com dados reais.

## Contribuições

Consulte [CONTRIBUTING.md](CONTRIBUTING.md) para adicionar uma consulta e seu runbook correspondente.
