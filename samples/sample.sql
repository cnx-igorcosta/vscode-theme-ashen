-- Migration: adiciona indice de busca por desfecho
CREATE TABLE IF NOT EXISTS atendimento_desfecho (
    id           BIGINT        NOT NULL AUTO_INCREMENT,
    atendimento_id BIGINT      NOT NULL,
    desfecho     VARCHAR(60)   NOT NULL DEFAULT 'PENDENTE',
    alterado_em  DATETIME      NOT NULL,
    alterado_por VARCHAR(255)  NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_desfecho_atendimento FOREIGN KEY (atendimento_id)
        REFERENCES atendimento (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX idx_desfecho_periodo ON atendimento_desfecho (desfecho, alterado_em);

SELECT p.nome,
       COUNT(DISTINCT a.id)                      AS total,
       SUM(CASE WHEN d.desfecho = 'REALIZADO' THEN 1 ELSE 0 END) AS realizados,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, a.inicio, a.fim)), 2)     AS duracao_media
  FROM atendimento a
  INNER JOIN profissional p ON p.id = a.profissional_id
  LEFT  JOIN atendimento_desfecho d ON d.atendimento_id = a.id
 WHERE a.criado_em BETWEEN '2026-10-01' AND '2026-10-21'
   AND p.ativo = 1
 GROUP BY p.id, p.nome
HAVING total > 10
 ORDER BY realizados DESC
 LIMIT 50;
