import Vue from 'vue'
import App from './App.vue'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.css'
import VueMoment from 'vue-moment'
import Eth from 'ethjs'
import store from './store'
import router from './router'
import CryptoPlanets from '../build/contracts/PlanetCore.json'

Vue.use(VueMoment)
Vue.use(Vuetify)

new Vue({
  el: '#app',
  render: h => h(App),
  store,
  router,
  mounted () {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    let provider;
    if (typeof web3 !== 'undefined' && false) { // not using metamask for now
      provider = web3.currentProvider;
      console.log('using metamask')
    } else {
      // If no injected web3 instance is detected, fallback to Ganache.
      provider = new web3.providers.HttpProvider('http://127.0.0.1:7545');
    }
    const eth = new Eth(provider);
    const contract = new eth.contract(CryptoPlanets.abi, CryptoPlanets.bytecode);

    this.$store.commit('setEth', eth);
    const address = prompt('Please enter the contract address', '0x1551528fa317c20dcb4442dbe14ad7d9a314d55e')
    // ropsten 0x1551528fa317c20dcb4442dbe14ad7d9a314d55e
    this.$store.commit('setContract', contract.at(address));
    eth.accounts().then((accounts) => {
      this.$store.dispatch('updateUser', accounts[0]);
      // contract.new({from: accounts[0], gas: 4653035}, (error, result) => {
      //   console.log(result);
      //   console.error(error);
      // })
    })
  }
})
