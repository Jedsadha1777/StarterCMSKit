<template>
  <ResourceForm resource="admin" apiGet="getAdmin" apiCreate="createAdmin" apiUpdate="updateAdmin" backTo="/admins" :onSelfEdit="true" />
</template>

<script>
import ResourceForm from '../components/ResourceForm.vue'
export default {
  components: { ResourceForm }
}
</script>
