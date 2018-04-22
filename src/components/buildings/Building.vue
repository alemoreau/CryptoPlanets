<template lang="html">
  <v-list-tile avatar @click="">
    <v-list-tile-avatar>
      <v-badge right>
        <span slot="badge">{{ building.level }}</span>
        <v-avatar>
          <img :src="`public/assets/buildings/${type}.gif`">
        </v-avatar>
      </v-badge>
    </v-list-tile-avatar>
    <v-list-tile-content>
      <v-list-tile-title v-html="this.name"></v-list-tile-title>
      <v-list-tile-sub-title>
        <VueCountdown v-if="upgrading" :time="timeLeft" :interval="100">
          <template slot-scope="props"> {{ 24 * parseInt(props.days) + parseInt(props.hours) }} hours, {{ props.minutes }} minutes, {{ props.seconds }} seconds.</template>
        </VueCountdown>
        <template v-else>
          <v-layout row wrap>
            <v-flex xs3>
            {{ cost.metal }}
            <v-icon>terrain</v-icon>
            </v-flex>
            <v-flex xs3>
            {{ cost.crystal }}
            <v-icon>change_history</v-icon>
            </v-flex>
            <v-flex xs3>
            {{ cost.deut }}
            <v-icon>opacity</v-icon>
            </v-flex>
            <v-flex xs3>
            {{ cost.energy }}
            <v-icon>battery_charging_full</v-icon>
            </v-flex>
          </v-layout>
        </template>
      </v-list-tile-sub-title>
    </v-list-tile-content>
    <v-list-tile-action>
      <v-btn
        :disabled="upgrading"
        icon
        large
        @click="$emit('upgrade')">
        <v-icon
          color="grey lighten-1">
          file_upload
        </v-icon>
      </v-btn>
    </v-list-tile-action>
  </v-list-tile>
</template>

<script>
import VueCountdown from '@xkeshi/vue-countdown'

export default {
  props: {
    building: {
      type: Object,
      required: true
    },
    type: {
      type: Number,
      required: true
    }
  },
  data () {
    return {
      now: 0
    }
  },
  created () {
    setInterval(() => {
      this.now = Date.now()
    }, 200);
  },
  watch: {
    upgrading (is_upgrading, was_upgrading) {
      if (was_upgrading && !is_upgrading) {
        this.$emit('complete', this.type);
      }
    }
  },
  computed: {
    cost () {
      let factor = 2;
      let energy_factor = 0;
      let cost = {
        metal: 0,
        crystal: 0,
        deut: 0,
        energy: 0
      };
      switch (this.type) {
        case 0:
          factor=1.5;
          cost['metal'] = 60;
          cost['crystal'] = 15;
          energy_factor = 10;
          break;
        case 1:
          factor=1.6;
          cost['metal'] = 48;
          cost['crystal'] = 24;
          energy_factor = 10;
          break;
        case 2:
          factor=1.5;
          cost['metal'] = 225;
          cost['crystal'] = 75;
          energy_factor = 20;
          break;
        case 3:
          factor=1.5;
          cost['metal'] = 75;
          cost['crystal'] = 30;
          break;
        case 4:
          factor=2;
          cost['metal'] = 400;
          cost['crystal'] = 120;
          cost['deut'] = 200;
          break;
        case 5:
          factor=2;
          cost['metal'] = 400;
          cost['crystal'] = 200;
          cost['deut'] = 100
          break;
        case 6:
          factor=2;
          cost['metal'] = 200;
          cost['crystal'] = 400;
          cost['deut'] = 200;
          break;
        default:
          break;
        }

        cost['metal'] = Math.floor(cost['metal'] * (factor ** this.building.level))
        cost['crystal'] = Math.floor(cost['crystal'] * (factor ** this.building.level))
        cost['deut'] = Math.floor(cost['deut'] * (factor ** this.building.level))
        cost['energy'] = Math.floor(energy_factor * (this.building.level + 1) * (1.1 ** (this.building.level + 1)))
        return cost;
    },
    upgrading () {
      return this.building.timestamp > this.now
    },
    timeLeft () {
      return Math.max(0, this.building.timestamp - Date.now());
    },
    date () {
      return new Date(this.building.timestamp)
    },
    name () {
      switch (this.type) {
        case 0:
          return "Metal mine";
        case 1:
          return "Crystal mine";
        case 2:
          return "Deuterium synthetizer";
        case 3:
          return "Solar plant";
        case 4:
          return "Robot factory";
        case 5:
          return "Shipyard";
        case 6:
          return "Research laboratory";
        default:
          return "Not implemented";
      }
    },
    avatar () {
      switch (this.type) {
        case 0:
          return "Metal mine";
        case 1:
          return "Crystal mine";
        case 2:
          return "Deuterium synthetizer";
        case 3:
          return "Solar plant";
        case 4:
          return "Robot factory";
        case 5:
          return "Shipyard";
        case 6:
          return "Research laboratory";
        default:
          return "Not implemented";
      }
    }
  },
  components: {
    VueCountdown
  }
}
</script>

<style lang="css">
</style>
