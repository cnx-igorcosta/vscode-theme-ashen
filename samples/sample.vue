<template>
  <div class="recorrencias">
    <h2 class="titulo">{{ titulo }}</h2>
    <el-table v-loading="carregando" :data="recorrencias" stripe>
      <el-table-column prop="profissional" label="Profissional" />
      <el-table-column prop="diaSemana" label="Dia" width="120" />
      <el-table-column label="Ações" width="80">
        <template slot-scope="{ row }">
          <action-menu :acoes="acoesDe(row)" @selecionar="executar(row, $event)" />
        </template>
      </el-table-column>
    </el-table>
    <p v-if="!recorrencias.length" class="vazio">Nenhuma recorrência ativa.</p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
  name: 'ListaRecorrencias',
  props: {
    clinicaId: { type: Number, required: true },
  },
  data() {
    return { recorrencias: [], carregando: false };
  },
  computed: {
    ...mapGetters('auth', ['perfil']),
    titulo() {
      return `Recorrências (${this.recorrencias.length})`;
    },
  },
  async mounted() {
    this.carregando = true;
    const { data } = await this.$http.get(`/clinica/admin/ativas`);
    this.recorrencias = data.filter((r) => r.ativa);
    this.carregando = false;
  },
};
</script>

<style scoped lang="scss">
.recorrencias {
  display: flex;
  flex-direction: column;
  gap: 1rem;

  .titulo { font-weight: 600; color: var(--cor-texto); }
  .vazio  { opacity: 0.6; font-style: italic; }
}
</style>
