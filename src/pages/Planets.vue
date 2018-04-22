<template lang="html">
  <v-container
    fluid
    style="min-height: 0;"
    grid-list-lg>
     <v-layout row wrap>
       <v-flex v-for="planet in planets" :key="planet.id" xs12 sm12 md6 lg4 xl3>
         <PlanetLarge
          :planet="planet"
          style="cursor: pointer;"
          @action="setCurrentPlanet(planet.id)"/>
       </v-flex>
     </v-layout>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import PlanetLarge from '../components/planets/Large'

export default {
  computed: {
    ...mapGetters([
      'planets'
    ])
  },
  methods: {
    setCurrentPlanet(id) {
      this.$store.commit('setCurrentPlanet', id);
      this.$router.push({name: 'Planet', params: {id}});
    }
  },
  components: {
    PlanetLarge
  }
}
</script>

<style lang="css">
</style>
