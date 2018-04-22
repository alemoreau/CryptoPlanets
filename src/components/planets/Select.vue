<template lang="html">
  <v-select
      label="My planets"
      :items="planets"
      :value="planet"
      item-value="id"
      @input="$emit('input', $event)"
      max-height="auto"
      :no-data-text="null"
      solo
    >
      <template slot="selection" slot-scope="data">
        <MiniPlanet :planet="data.item" />
      </template>
      <template slot="item" slot-scope="data">
        <MiniPlanet :planet="data.item" />
      </template>
  </v-select>
</template>

<script>
import MiniPlanet from './Mini'
import ChipPlanet from './Chip'

export default {
  props: {
    planets: {
      type: Array,
      required: true
    },
    planet: {
      type: Number
    }
  },
  components: {
    MiniPlanet,
    ChipPlanet
  }
}
</script>

<style lang="css">
</style>
