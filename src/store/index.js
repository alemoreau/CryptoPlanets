import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const state = {
  eth: null,
  user: null,
  contract: null,
  galaxy: [],
  planets: {},
  planet: null
}

const mutations = {
  setEth (state, eth) {
    state.eth = eth;
  },
  setUser (state, address) {
    state.user = address;
  },
  setContract (state, contract) {
    state.contract = contract;
  },
  setPlanet (state, {planetId, planet}) {
    Vue.set(state.planets, planetId, planet);
  },
  setCurrentPlanet (state, planetId) {
    state.planet = planetId;
  },
  setPlanetPosition (state, {planetId, position}) {
    Vue.set(state.planets[planetId], 'position', position);
  },
  setPlanetResource (state, {planetId, resourceId, quantity, income}) {
    Vue.set(state.planets[planetId].resources, resourceId, {quantity, income});
  },
  setPlanetEnergy (state, {planetId, energyConsumption, totalEnergy}) {
    Vue.set(state.planets[planetId].energy, 'consumption', energyConsumption);
    Vue.set(state.planets[planetId].energy, 'total', totalEnergy);
  },
  setPlanetBuilding (state, {planetId, buildingId, level, timestamp}) {
    Vue.set(state.planets[planetId].buildings, buildingId, {level, timestamp});
  },
  setPlanetName (state, {planetId, name}) {
    Vue.set(state.planets[planetId], 'name', name);
  }
}

const actions = {
  updateUser ({ commit, dispatch, state, getters }, address) {
    commit('setUser', address)
    dispatch('fetchPlanets')
  },
  fetchPlanets ({ commit, state, dispatch }) {
    if (!state.contract) return;
    return state.contract.getPlanetsByOwner(state.user, (error, result) => {
      console.log(error);
      console.log(result);
      if (result && result[0]) {
        for (const r of result[0]) {
          const id = r.toNumber();
          dispatch('fetchPlanet', id);
        }
      }
    })
  },
  fetchPlanet ({ commit, state, dispatch }, planetId) {
    if (!state.contract) return;
    // state.contract.getPlanet(planetId)
    //   .then((result) => {
    //     console.log(result)
    //   })
    //   .catch((error) => {
    //     console.error(error);
    //   })
    const planet = {id: planetId, resources: [], energy: {total: 0, consumption: 0}, buildings: [], ships: [], defenses: []};
    commit('setPlanet', {planetId, planet});
    if (!state.planet) {
      commit('setCurrentPlanet', planetId);
    }
    state.contract.getPlanetName(planetId)
      .then(result => {
        commit('setPlanetName', {planetId, name: result[0]});
      })
      .catch(error => {
        console.error(error);
      })
    dispatch('fetchPosition', planetId);
    dispatch('fetchResources', planetId);
    dispatch('fetchBuildings', planetId);
  },
  fetchPosition({ commit, state }, planetId) {
    state.contract.getPlanetPosition(planetId)
      .then(result => {
        commit('setPlanetPosition', {planetId, position: result[0].toNumber()})
      })
      .catch(error => {
        console.error(error);
      })
  },
  fetchEnergy({ commit, state }, planetId) {
    state.contract.getPlanetTotalEnergy(planetId)
      .then((result) => {
        const totalEnergy = result[0].toNumber();
        state.contract.getPlanetEnergyConsumption(planetId)
          .then((result) => {
            const energyConsumption = result[0].toNumber();
            commit('setPlanetEnergy', {planetId, totalEnergy, energyConsumption});
          })
          .catch((error) => {
            console.error(error);
          })
      })
      .catch((error) => {
        console.error(error);
      })
  },
  fetchResources({ dispatch }, planetId) {
    for (let resourceId = 0; resourceId < 3; resourceId++) {
      dispatch('fetchResource', { planetId, resourceId })
    }
  },
  fetchResource({ commit, state }, { planetId, resourceId }) {
    state.contract.getPlanetResource(planetId, resourceId)
      .then(result => {
        const quantity = result[0].toNumber();
        state.contract.getPlanetResourceIncome(planetId, resourceId)
          .then((result) => {
            const income = result[0].toNumber();
            commit('setPlanetResource', {planetId, resourceId, quantity, income});
          })
          .catch((error) => {
            console.error(error);
          })
      })
      .catch(error => {
        console.error(error);
      })
  },
  fetchBuildings({ dispatch }, planetId) {
    for (let buildingId = 0; buildingId < 7; buildingId++) {
      dispatch('fetchBuilding', { planetId, buildingId });
    }
  },
  fetchBuilding({ commit, state }, { planetId, buildingId }) {
    state.contract.getPlanetBuildingLevel(planetId, buildingId)
      .then(result => {
        const level = result[0].toNumber();
        state.contract.getPlanetBuildingTimestamp(planetId, buildingId)
          .then((result) => {
            const timestamp = result[0].toNumber() * 1000;
            commit('setPlanetBuilding', {planetId, buildingId, level, timestamp});
          })
          .catch((error) => {
            console.error(error);
          })
      })
      .catch(error => {
        console.error(error);
      })
  }
}

const getters = {
  eth: state => state.eth,
  user: state => state.user,
  galaxy: state => state.galaxy,
  planets: state => Object.keys(state.planets).map(id => state.planets[id]),
  planet: state => state.planets[state.planet],
  resources: (state, getters) => state.planets[state.planet] ? state.planets[state.planet].resources: [],
  buildings: (state, getters) => state.planets[state.planet] ? state.planets[state.planet].buildings: [],
  cryptoPlanets: state => state.contract
}

export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations
})
