<template lang="html">
  <v-container>
     <v-layout row wrap>
       <v-list two-line>
           <Planet
            v-for="(planet, index) in planets"
            :key="planet.id"
            :planet="planet"
            @click.native="$emit('changePlanet', planet.id)"
            @edit="$emit('edit')"/>
      </v-list>
     </v-layout>
  </v-container>
</template>

<script>
  import Planet from './Medium'
  export default {
    props: {
      planets: {
        type: Array,
        required: true
      }
    },
    components: {
      Planet
    }
  }
</script>
