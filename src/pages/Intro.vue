<template lang="html">
  <v-container fluid>
    <v-subheader>Welcome {{user}} </v-subheader>
      You are ready to colonize your first planet.
      Use the drawer on the right to pick one.
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  computed: {
    ...mapGetters([
      'user'
    ])
  }
}
</script>

<style lang="css">
</style>
