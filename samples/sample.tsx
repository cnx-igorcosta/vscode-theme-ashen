import { useCallback, useEffect, useMemo, useState } from 'react';
import { coreApi } from '@/services/api';

type Perfil = 'PROFISSIONAL_SAUDE' | 'CLINICA' | 'ADMIN';

interface FiltroAtendimento {
  nome?: string;
  email?: string;
  cpf?: string;
  perfil: Perfil;
  dataInicio: Date | null;
}

const LIMITE_PADRAO = 50;

export function useAtendimentos(filtro: FiltroAtendimento) {
  const [dados, setDados] = useState<Atendimento[]>([]);
  const [carregando, setCarregando] = useState(false);

  const temDadosProfissional = useMemo(
    () => filtro.perfil === 'PROFISSIONAL_SAUDE' && Boolean(filtro.nome ?? filtro.cpf),
    [filtro.perfil, filtro.nome, filtro.cpf],
  );

  const buscar = useCallback(async (pagina = 0) => {
    setCarregando(true);
    try {
      const { data } = await coreApi.get(`/atendimento/admin/buscar`, {
        params: { ...filtro, pagina, limite: LIMITE_PADRAO },
      });
      setDados(data.content);
    } catch (erro) {
      console.error('Falha ao buscar atendimentos', erro);
      throw new Error(`Busca falhou: ${(erro as Error).message}`);
    } finally {
      setCarregando(false);
    }
  }, [filtro]);

  useEffect(() => { void buscar(); }, [buscar]);

  return { dados, carregando, temDadosProfissional, buscar } as const;
}

export const Lista = ({ filtro }: { filtro: FiltroAtendimento }) => {
  const { dados, carregando } = useAtendimentos(filtro);
  if (carregando) return <Spinner size="sm" />;
  return (
    <ul className="lista-atendimentos">
      {dados.map((item) => (
        <li key={item.id} data-status={item.status}>
          {item.nome} — <strong>{item.status}</strong>
        </li>
      ))}
    </ul>
  );
};
