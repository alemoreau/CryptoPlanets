<template lang="html">
  <v-container fluid>
    <v-data-table
      v-if="cryptoPlanets"
     :headers="headers"
     :items="items"
     :search="search"
     :loading="loading"
     :pagination.sync="pagination"
     hide-actions
     class="elevation-1"
   >
     <template slot="headerCell" slot-scope="props">
       <v-tooltip bottom>
         <span slot="activator">
           {{ props.header.text }}
         </span>
         <span>
           {{ props.header.text }}
         </span>
       </v-tooltip>
     </template>
     <template slot="items" slot-scope="props">
       <td class="text-xs-center">{{ props.item.position }}</td>
       <td class="text-xs-center">
         <v-avatar small>
           <img :src="`public/assets/planets/small/${props.item.position % 10}.jpg`">
         </v-avatar>
       </td>
       <td class="text-xs-center">{{ props.item.name }}</td>
       <td class="text-xs-center">{{ props.item.owner == user ? 'You' : props.item.owner}}</td>
       <td class="text-xs-center layout">
        <v-btn icon class="" @click="colonizePlanet(props.item.position)">
          <v-icon v-if="props.item.owner.length === 0" color="teal">shop</v-icon>
        </v-btn>
      </td>
     </template>
   </v-data-table>
   <div class="text-xs-center pt-2">
     <v-pagination v-model="page" :total-visible="9" :length="500"></v-pagination>
   </div>

  </v-container>
</template>

<script>
import { mapGetters } from 'vuex';
import Eth from 'ethjs';

export default {
  data () {
    return {
      position: null,
      page: 1,
      pagination: {
        page: 1,
        rowsPerPage: 15,
        totalItems: 500 * 15
      },
      search: '',
      items: [],
      loading: false,
      headers: [{
          text: 'position',
          align: 'center',
          sortable: false,
          class: 'text-xs-center',
          value: 'position'
        },
        {
          text: 'planet',
          sortable: false,
          class: 'text-xs-center',
          value: 'id'
        }, {
          text: 'Name',
          sortable: false,
          class: 'text-xs-center',
          value: 'name'
        }, {
          text: 'Owner',
          sortable: false,
          class: 'text-xs-center',
          value: 'owner'
        }, {
          text: 'actions',
          sortable: false,
          value: 'name'
        }
      ]
    }
  },
  computed: {
    ...mapGetters([
      'user',
      'planets',
      'galaxy',
      'cryptoPlanets',
    ])
  },
  mounted () {
    this.fetchSolarSystem(0);
  },
  watch: {
    page(p) {
      this.fetchSolarSystem(p-1);
    },
    planet(p) {
      if (p) {
        if (this.page == p.position / 15 + 1) {
          this.fetchSolarSystem(this.page - 1);
        } else {
          this.page = p.position / 15 + 1
        }
      }
    }
  },
  methods: {
    fetchSolarSystem(id) {
      console.log(id)
      this.items = []
      let fetched = 0;
      for (let i = 0; i < 15; i++) {
        const pos = 15 * id + i;
        const p = i;
        this.items.push({
          position: pos,
          name: '',
          id: '',
          owner: ''
        })
        if (this.cryptoPlanets) {
          this.cryptoPlanets.positionIsEmpty(pos)
            .then(result => {
              if (result[0]) {
                this.items[p].name = '';
                fetched += 1;
                this.loading = fetched < 15;
              } else {
                this.cryptoPlanets.getPlanetByPosition(pos)
                  .then(result => {
                    this.items[p].id = result[0].toNumber();
                    this.cryptoPlanets.ownerOf(result[0].toNumber())
                      .then((result) => {
                        this.items[p].owner = result[0];
                      })
                      .catch((error) => {
                        console.error(error);
                      })
                    this.cryptoPlanets.getPlanetName(result[0].toNumber())
                      .then(result => {
                        this.items[p].name = result[0];
                        fetched += 1;
                        this.loading = fetched < 15;
                      })
                      .catch(error => {
                        console.error(error);
                      })
                  })
                  .catch(error => {
                    console.error(error);
                  })
              }
            })
            .catch(error => {
              console.error(error);
            })
        }
      }
    },
    colonizePlanet(position) {
      console.log(position);
      const page = this.page;
      this.cryptoPlanets.colonizePlanet(position, {from: this.user, gas: 600000, gasPrice: Eth.toWei(1, 'Gwei'), value: Eth.toWei(1, 'finney')})
        .then(txHash => {
          this.cryptoPlanets.getPlanetByPosition(position)
            .then((result) => {
              this.$store.dispatch('fetchPlanet', result[0].toNumber())
              if (this.page == page) {
                this.$set(this.items, position % 15, {
                  position,
                  name: 'Planet',
                  owner: 'You'
                })
              }
              this.$emit('colonized');
            })

        })
        .catch((error) => {
          console.error(error);
        })
    }
  }
}
</script>

<style lang="css">
</style>
