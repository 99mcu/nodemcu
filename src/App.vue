<template>
  <div>
    <x-header :left-options="{showBack: false}">NodeMcu controls</x-header>
    <group>
      <x-switch title="title" v-model="value"></x-switch>
    </group>
  </div>
</template>

<script>
// import Hello from './components/Hello'
import { Group, XHeader, XSwitch } from 'vux'

export default {
  name: 'app',
  components: {
    Group,
    XHeader,
    XSwitch
  }
}
</script>

<style lang="less">
  @import '~vux/src/styles/reset.less';
</style>
