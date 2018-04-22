<template lang="html">
  <v-container>
    <v-tabs icons-and-text centered dark>
      <v-tabs-slider color="yellow"></v-tabs-slider>
      <v-tab v-for="tab in tabs" :key="`#tab-${tab.name}`" :href="`#tab-${tab.name}`">
        {{ tab.title }}
        <v-icon>{{tab.icon}}</v-icon>
      </v-tab>
      <v-tab-item
      v-for="tab in tabs"
      :key="`tab-${tab.name}`"
      :id="`tab-${tab.name}`"
      >
        <v-card flat>
          <component :is="tab.component" :key="tab.name"/>
        </v-card>
      </v-tab-item>
    </v-tabs>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
import Buildings from './Buildings'
import Resources from './Resources'
import Shipyard from './Shipyard'
import Defenses from './Defenses'

export default {
  data() {
    return {
      tabs: [
        {
          name: 'buildings',
          title: 'Buildings',
          icon: 'store',
          component: Buildings
        },
        {
          name: 'resources',
          title: 'Resources',
          icon: 'polymer',
          component: Resources
        },
        {
          name: 'shipyard',
          title: 'Shipyard',
          icon: 'send',
          component: Shipyard
        },
        {
          name: 'defenses',
          title: 'Defenses',
          icon: 'security',
          component: Defenses
        }
      ]
    }
  },
  computed: {
    ...mapGetters([
      'planet',
      'user',
      'buildings',
      'cryptoPlanets'
    ])
  },
  methods: {
  },
  components: {
    Buildings,
    Resources,
    Shipyard,
    Defenses
  }
}
</script>

<style lang="css">
</style>
