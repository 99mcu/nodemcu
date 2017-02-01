<template>
  <div>
    <x-header :left-options="{showBack: false}">NodeMcu controls</x-header>
    <!-- <div> {{ outputs }} </div> -->
    <group>
      <x-switch
        v-for="o, key in outputs"
        :title="title(key)"
        :value="o > 0"
        @on-change="update(key)">
      </x-switch>
    </group>
  </div>
</template>

<script>
// import Hello from './components/Hello'
import { Group, XHeader, XSwitch } from 'vux'
import http from 'axios'
export default {
  name: 'app',
  components: {
    Group,
    XHeader,
    XSwitch
  },
  data: () => ({
    outputs: {}
  }),
  methods: {
    title: num => 'Output' + num,
    update (num) {
      let newV = this.outputs[num] = this.outputs[num] > 0 ? 0 : 1
      console.log(num, this.outputs[num])
      http.post('/ajax', {
        [num]: newV
      })
    }
  },
  async mounted () {
    let { data } = await http.post('/ajax', {})
    this.outputs = data
  }
}
</script>

<style lang="less">
  @import '~vux/src/styles/reset.less';
</style>
