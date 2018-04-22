<template lang="html">
   <div class="text-xs-center">
     <v-tooltip
      bottom
      v-for="resource in resources"
      v-if="resource"
      :key="resource.text">
      <v-chip
       slot="activator"
       :color="resource.color"
       :text-color="resource.text">
        <v-avatar :class="resource.class"><v-icon>{{ resource.icon }}</v-icon></v-avatar>
        {{ resource.quantity }}
      </v-chip>
      <span>{{ resource.income }} / hour</span>
   </v-tooltip>
    <v-chip v-if="energy" :color="(energy.total - energy.consumption) < 0 ? 'red': 'yellow' ">
        <v-avatar><v-icon>battery_charging_full</v-icon></v-avatar>
      {{ energy.total - energy.consumption }} / {{ energy.total }}
    </v-chip>
   </div>
</template>

<script>
export default {
  props: {
    resources: {
      type: Array,
      required: true
    },
    energy: {
      type: Object
    }
  }
}
</script>

<style lang="css">
</style>
