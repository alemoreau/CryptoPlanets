import Vue from 'vue'
import Router from 'vue-router'
import Planets from './pages/Planets'
import Planet from './pages/Planet'
import Galaxy from './pages/Galaxy'
import Buildings from './pages/Buildings'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Planet
    }, {
      path: '/planets/:id',
      name: 'Planet',
      component: Planet
    }, {
      path: '/galaxy',
      name: 'Galaxy',
      component: Galaxy
    }, {
      path: '/planets/:id/buildings',
      name: 'Buildings',
      component: Buildings
    }
  ]
})
