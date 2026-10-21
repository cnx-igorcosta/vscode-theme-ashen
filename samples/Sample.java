package br.com.conexa.backoffice.filtro;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.google.common.annotations.VisibleForTesting;

/**
 * Avalia filtros de atendimento do backoffice.
 *
 * @param filtroBackoffice criterios informados pela tela
 * @deprecated usar {@link FiltroV2} no lugar
 */
@Service
public class FiltroAtendimentoService extends AbstractFiltro implements Validavel {

    private static final int LIMITE_PADRAO = 50;
    private static final String PREFIXO = "atendimento:";

    private final AtendimentoRepository repository;

    public FiltroAtendimentoService(AtendimentoRepository repository) {
        this.repository = repository;
    }

    @VisibleForTesting
    public boolean isFiltroAtendimentoComDadosDeProfissional(
            FiltroAtendimentoBackoffice filtroBackoffice) {
        if (!PerfilUsuario.PROFISSIONAL_SAUDE.equals(filtroBackoffice.getPerfil())) {
            return false;
        }
        return isNotBlank(filtroBackoffice.getNome())
                || isNotBlank(filtroBackoffice.getEmail())
                || isNotBlank(filtroBackoffice.getCpf())
                || nonNull(filtroBackoffice.getTipoProfissional());
    }

    @Override
    public List<Atendimento> buscar(FiltroAtendimentoBackoffice filtro, int pagina) {
        LocalDateTime inicio = Optional.ofNullable(filtro.getDataInicio())
                .orElse(LocalDateTime.now().minusDays(30L));

        return repository.findByPeriodo(inicio, filtro.getDataFim(), pagina, LIMITE_PADRAO)
                .stream()
                .filter(a -> a.getStatus() != StatusAtendimento.CANCELADO)
                .map(this::enriquecer)
                .toList();
    }

    private Atendimento enriquecer(Atendimento atendimento) {
        atendimento.setChave(PREFIXO + atendimento.getId());
        return atendimento; // chave usada no cache
    }
}
