<template lang="html">
  <v-chip
    close
    @input="emit('input')"
    :selected="selected"
    class="chip--select-multi"
    :key="planet.id"
  >
    <v-avatar>
      <img :src="planet.avatar">
    </v-avatar>
    {{ data.item.name }}
  </v-chip>
</template>

<script>
export default {
  props: {
    planet: {
      type: Object,
      required: true
    },
    selected: {
      type: Boolean,
      required: true
    }
  },

  mounted () {
    console.log(this.planet)
    console.log(this.selected)
  }
}
</script>

<style lang="css">
</style>
