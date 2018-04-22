<template>
  <v-app dark>
    <v-toolbar fixed app>
      <v-toolbar-title @click.native="$router.push({name: 'Galaxy'})" v-text="title"></v-toolbar-title>
      <v-spacer />
      <Planet :planet="planet" style="cursor: pointer;" @click.native="$router.push('/')" />
      <v-spacer />
      <ResourceSummary :resources="planetResources" :energy="planet ? planet.energy: null"/>
      <v-btn icon @click.stop="rightDrawer = !rightDrawer">
        <v-icon>menu</v-icon>
      </v-btn>
    </v-toolbar>
    <v-content>
      <v-container fluid v-if="planet">
        <v-subheader>{{ planet.name }} </v-subheader>
        <v-layout row wrap>
          <v-flex xs9>
            <router-view />
          </v-flex>
          <v-flex xs3>
            <PlanetList :planets="planets" @changePlanet="setCurrentPlanet($event)"/>
          </v-flex>
        </v-layout>
      </v-container>
      <Intro v-else />
    </v-content>
    <v-navigation-drawer
      temporary
      right
      :value="rightDrawer || (user && planets.length === 0)"
      @input="rightDrawer = $event"
      width="600"
      fixed
    >
    <v-toolbar>
      <v-toolbar-title>
        Galaxy
      </v-toolbar-title>
    </v-toolbar>
    <Galaxy @colonized="rightDrawer = false" />
    </v-navigation-drawer>
    <v-footer :fixed="fixed" app>
      <span>Welcome {{ user }}</span>
    </v-footer>
  </v-app>
</template>

<script>
  import {mapGetters} from 'vuex'
  import Galaxy from './pages/Galaxy'
  import Intro from './pages/Intro'
  import Planet from './components/planets/Mini'
  import PlanetList from './components/planets/List'
  import ResourceSummary from './components/resources/Summary'

  export default {
    data () {
      return {
        clipped: false,
        drawer: true,
        fixed: false,
        items: [
          { icon: 'bubble_chart', title: 'Inspire' }
        ],
        miniVariant: false,
        right: true,
        rightDrawer: false,
        title: 'CryptoPlanets',
        position: null
      }
    },
    mounted () {
      this.$store.dispatch('fetchPlanets');
    },
    computed: {
      ...mapGetters([
        'user',
        'eth',
        'cryptoPlanets',
        'planets',
        'planet',
        'resources'
      ]),
      planetResources() {
        return this.resources.map(({quantity, income}, id) => {
          let icon;
          let color;
          switch (id) {
            case 0:
              color = "gray"
              icon = "terrain";
              break;
            case 1:
              color = "teal"
              icon = "change_history";
              break;
            case 2:
              color = "blue"
              icon = "opacity";
              break;
            default:
              icon = "more_horiz";
          }
          return {
            id,
            quantity,
            income,
            icon,
            color
          }
        })
      }
    },
    watch: {
      contract(c) {
        this.$store.dispatch('fetchPlanets');
      },
      user(u) {
        this.$store.dispatch('fetchPlanets');
      }
    },
    methods: {
      setCurrentPlanet(planetId) {
        this.$store.commit('setCurrentPlanet', planetId)
      }
    },
    components: {
      Planet,
      Galaxy,
      Intro,
      PlanetList,
      ResourceSummary
    }
  }
</script>
