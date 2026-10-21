//! Processa ausencias de profissionais.

use std::collections::HashMap;
use std::fmt;

use serde::{Deserialize, Serialize};

const LIMITE_PADRAO: usize = 50;

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub enum Perfil {
    ProfissionalSaude,
    Clinica,
    Admin,
}

#[derive(Debug, Default)]
pub struct Filtro<'a> {
    pub nome: Option<&'a str>,
    pub cpf: Option<&'a str>,
    pub perfil: Option<Perfil>,
}

pub trait Validavel {
    fn validar(&self) -> Result<(), String>;
}

impl<'a> Validavel for Filtro<'a> {
    fn validar(&self) -> Result<(), String> {
        match &self.perfil {
            Some(Perfil::ProfissionalSaude) if self.nome.is_none() && self.cpf.is_none() => {
                Err(String::from("informe nome ou cpf"))
            }
            Some(_) => Ok(()),
            None => Err("perfil obrigatorio".to_owned()),
        }
    }
}

impl fmt::Display for Perfil {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", match self {
            Perfil::ProfissionalSaude => "PROFISSIONAL_SAUDE",
            Perfil::Clinica => "CLINICA",
            Perfil::Admin => "ADMIN",
        })
    }
}

pub fn agrupar(itens: &[Atendimento]) -> HashMap<u64, Vec<&Atendimento>> {
    let mut mapa: HashMap<u64, Vec<&Atendimento>> = HashMap::with_capacity(LIMITE_PADRAO);
    for item in itens.iter().filter(|a| a.ativo) {
        mapa.entry(item.profissional_id).or_default().push(item);
    }
    mapa
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn filtro_sem_perfil_eh_invalido() {
        assert!(Filtro::default().validar().is_err());
    }
}
