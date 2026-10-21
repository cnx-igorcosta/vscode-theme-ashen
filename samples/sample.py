"""Extrai ausencias do Mongo e cruza com o Aurora."""

from __future__ import annotations

import os
from dataclasses import dataclass, field
from datetime import date, timedelta
from typing import Iterator

import pymongo

LIMITE_PADRAO: int = 50
COLECAO = "absence_reschedule_log"


@dataclass(frozen=True, slots=True)
class Ausencia:
    profissional_id: int
    paciente_id: int
    motivo: str | None = None
    tags: list[str] = field(default_factory=list)

    @property
    def tem_motivo(self) -> bool:
        return bool(self.motivo and self.motivo.strip())

    def __repr__(self) -> str:
        return f"<Ausencia prof={self.profissional_id} motivo={self.motivo!r}>"


def extrair(inicio: date, fim: date | None = None) -> Iterator[Ausencia]:
    fim = fim or inicio + timedelta(days=1)
    client = pymongo.MongoClient(os.environ["MONGO_URI"])
    cursor = client["doutor-virtual-producao"][COLECAO].find(
        {"createdAt": {"$gte": inicio.isoformat(), "$lt": fim.isoformat()}},
        projection={"_id": 0},
    )
    for doc in cursor:
        yield Ausencia(
            profissional_id=int(doc["professionalId"]),
            paciente_id=int(doc["patientId"]),
            motivo=doc.get("reason"),
        )


if __name__ == "__main__":
    total = sum(1 for a in extrair(date(2026, 10, 1)) if a.tem_motivo)
    print(f"Total com motivo: {total:,}")
