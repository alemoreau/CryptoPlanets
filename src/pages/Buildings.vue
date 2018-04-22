<template lang="html">
  <v-container>
    <v-subheader>Buildings </v-subheader>
     <v-layout row wrap>
       <v-flex xs6>
         <v-list three-line>
             <Building
              v-for="(building, index) in buildings"
              :type="index"
              :key="index"
              v-if="building"
              :building="building"
              @click.native="selected=index"
              @upgrade="upgradeBuilding(index)"
              @complete="upgradeComplete(index)"/>
        </v-list>
      </v-flex>
      <v-flex xs6>
        <v-card v-if="selected !== undefined">
          <v-card-title>
            {{ names[selected] }}
          </v-card-title>
          <v-card-text>
            {{ descriptions[selected] }}
          </v-card-text>
        </v-card>
      </v-flex>
     </v-layout>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex';
import Building from '../components/buildings/Building'
import Eth from 'ethjs'

export default {
  data () {
    return {
      selected: null,
      names: ['Metal Mine', 'Crystal Mine', 'Deuterium Synthetizer', 'Solar Plant', 'Robot Factory', 'Shipyard', 'Research Laboratory'],
      descriptions: [
        'Principale ressource pour la construction de bâtiments et de vaisseaux. Le métal est la matière première la moins chère, mais c`est la plus importante. La production du métal consomme moins d`énergie que la production des autres ressources. Plus les mines sont développées, plus elles sont profondes. Les réserves minérales sont situées en profondeur sur la majorité des planètes. Les mines les plus profondes permettent d`extraire plus de métal, ce qui augment leur rendement. Cependant, les mines les plus développées consomment aussi plus d`énergie.',
        'Le cristal est la principale ressource pour l`électronique et pour les alliages et son exploitation consomme environ une fois et demi plus d`énergie que celle du métal, le cristal est donc plus précieux. Tous les vaisseaux et bâtiments ont besoin de cristal. Malheureusement, la plupart des cristaux nécessaires pour la construction de vaisseaux sont très rares et se trouvent en grande profondeur, comme le métal. La production augmente avec le développement des mines car on atteint des gisement plus grands et plus purs.',
        'Le deutérium est produit à partir d`hydrogène lourd qu`on trouve principalement sur les fonds marins. Le développement du bâtiment permet d`accéder à des réserves de deutérium à de plus grandes profondeurs et de concentrer ce deutérium. Le deutérium sert de carburant pour les vaisseaux et il est nécessaire pour presque toutes les recherches. Il est également utilisé pour l`observation de galaxies ou les scanners à l`aide d`une phalange de capteur.',
        'Pour assurer l`alimentation des mines et des synthétiseurs en énergie, des centrales électriques solaires géantes sont nécessaires. Plus ces installations sont développées, plus la surface de la planète est recouverte de cellules photovoltaïques qui transforment les rayons de soleil en énergie électrique. Les centrales électriques solaires sont la base de l`alimentation énergétique d`une planète.',
        'Les usines de robots produisent des robots ouvriers qui servent à la construction de l`infrastructure planétaire. Chaque niveau augmente la vitesse de construction des différents bâtiments.',
        'Le chantier spatial permet de construire les vaisseaux et les installations de défense. Plus le chantier est grand, plus la construction de vaisseaux et des installations de défense est rapide. La construction d`une usine de nanites permet la production de robots minuscules qui aident les robots ouvriers à travailler plus rapidement.',
        'Le laboratoire de recherche est nécessaire pour développer de nouvelles technologies. Le niveau du laboratoire détermine la vitesse de la recherche. Pour accélérer la recherche, tous les chercheurs de votre empire sont rassemblés dans le laboratoire de la planète sur laquelle se fait la recherche. Ces chercheurs ne peuvent donc plus faire de recherches sur une autre planète. Dès qu`une nouvelle technologie est développée, les chercheurs retournent à leurs planètes d`origine et emmènent le savoir. Par conséquent, toutes les technologies recherchées peuvent être utilisées sur toutes les planètes.'
      ]
    }
  },
  computed: {
    ...mapGetters([
      'eth',
      'user',
      'buildings',
      'planet',
      'cryptoPlanets'
    ])
  },
  methods: {
    upgradeBuilding(buildingId) {
      this.cryptoPlanets.upgradeBuilding(this.planet.id, buildingId, {from: this.user, gas: 1000000, gasPrice: Eth.toWei(1, 'Gwei')})
        .then(txHash => {
          this.eth.getTransactionReceipt(txHash)
               .then((result) => {
                 console.log(result);
                 this.$store.dispatch('fetchBuilding', {planetId: this.planet.id, buildingId});
                 this.$store.dispatch('fetchResources', this.planet.id)
               })
               .catch((error) => {
                    alert(error.message);
               });
        })
        .catch(error => {
          console.error(error);
        })
    },
    upgradeComplete(buildingId) {
      this.$store.dispatch('fetchBuilding', {planetId: this.planet.id, buildingId});
      this.$store.dispatch('fetchResources', this.planet.id)
      this.$store.dispatch('fetchEnergy', this.planet.id)
    }
  },
  components: {
    Building
  }
}
</script>

<style lang="css">
</style>
