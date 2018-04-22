<template lang="html">
  <v-list-tile v-if="planet">
    <v-list-tile-avatar>
      <img :src="`public/assets/planets/small/${planet.id % 10}.jpg`">
    </v-list-tile-avatar>
    <v-list-tile-content>
      <v-list-tile-title v-html="planet.name"></v-list-tile-title>
      <v-list-tile-sub-title v-html="planet.description"></v-list-tile-sub-title>
    </v-list-tile-content>
  </v-list-tile>
</template>

<script>
export default {
  props: {
    planet: {
      type: Object
    }
  },
  mounted () {
    console.log(this.planet)
  }
}
</script>

<style lang="css">
</style>
