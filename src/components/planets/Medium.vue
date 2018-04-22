<template lang="html">
  <v-list-tile avatar @click="">
    <v-list-tile-avatar>
      <v-badge right>
        <span v-if="false" slot="badge">!</span>
        <v-avatar>
          <img :src="`public/assets/planets/small/${planet.id % 10}.jpg`">
        </v-avatar>
      </v-badge>
    </v-list-tile-avatar>
    <v-list-tile-content>
      <v-list-tile-title v-html="planet.name"></v-list-tile-title>
      <v-list-tile-sub-title>
        position : {{ planet.position }}
      </v-list-tile-sub-title>
    </v-list-tile-content>
    <v-list-tile-action>
      <v-btn
        icon
        large
        @click="$emit('edit')">
        <v-icon
          color="grey lighten-1">
          edit
        </v-icon>
      </v-btn>
    </v-list-tile-action>
  </v-list-tile>
</template>

<script>
export default {
  props: {
    planet: {
      type: Object,
      required: true
    }
  },
  mounted () {
    console.log(this.planet);
  }
}
</script>

<style lang="css">
</style>
