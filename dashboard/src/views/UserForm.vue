<template>
  <ResourceForm resource="user" apiGet="getUser" apiCreate="createUser" apiUpdate="updateUser" backTo="/users" />
</template>

<script>
import ResourceForm from '../components/ResourceForm.vue'
export default {
  components: { ResourceForm }
}
</script>
