package carga

import (
	"context"
	"errors"
	"fmt"
	"time"
)

const limitePadrao = 50

var ErrPerfilInvalido = errors.New("carga: perfil invalido")

type Perfil string

const (
	PerfilProfissional Perfil = "PROFISSIONAL_SAUDE"
	PerfilClinica      Perfil = "CLINICA"
)

type Filtro struct {
	Nome       string    `json:"nome,omitempty"`
	CPF        string    `json:"cpf,omitempty"`
	Perfil     Perfil    `json:"perfil"`
	DataInicio time.Time `json:"dataInicio"`
}

type Repositorio interface {
	Buscar(ctx context.Context, f Filtro, pagina int) ([]Atendimento, error)
}

func (f Filtro) TemDadosProfissional() bool {
	return f.Perfil == PerfilProfissional && (f.Nome != "" || f.CPF != "")
}

func Processar(ctx context.Context, repo Repositorio, f Filtro) (int, error) {
	if f.Perfil == "" {
		return 0, fmt.Errorf("processar: %w", ErrPerfilInvalido)
	}

	total := 0
	for pagina := 0; ; pagina++ {
		lote, err := repo.Buscar(ctx, f, pagina)
		if err != nil {
			return total, fmt.Errorf("buscar pagina %d: %w", pagina, err)
		}
		if len(lote) == 0 {
			break
		}
		total += len(lote)
	}
	return total, nil
}
