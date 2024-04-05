<template>
  <TheNavigation/>
  <div class="flex justify-content-center mt-5">
    <router-view/>
  </div>
</template>

<script>
import TheNavigation from "@/components/TheNavigation";

export default {
  name: 'App',
  components: {
    TheNavigation
  },
}
</script>

<style>
body {
  background-color: var(--surface-c);
}
</style>
