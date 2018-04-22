<template lang="html">
  <v-card color="blue-grey darken-2" class="white--text">
    <v-card-title primary-title>
      <div class="headline">{{ planet.name }}</div>
      <div>Listen to your favorite artists and albums whenever and wherever, online and offline.</div>
    </v-card-title>
    <v-card-actions>
      <v-btn flat dark @click="$emit('action')">Manage</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: {
    planet: {
      type: Object,
      required: true
    }
  }
}
</script>

<style lang="css">
</style>
