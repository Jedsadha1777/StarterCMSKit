<template>
  <v-dialog :model-value="visible" persistent max-width="420">
    <v-card class="text-center pa-4">
      <v-icon size="64" color="warning" class="mb-4">mdi-alert-circle</v-icon>
      <v-card-title class="text-h6">Session Replaced</v-card-title>
      <v-card-text>
        <p>{{ message }}</p>
        <v-chip v-if="ip" prepend-icon="mdi-ip-network" class="mt-2">{{ ip }}</v-chip>
        <p class="text-primary text-h6 mt-4">{{ countdown }}s</p>
      </v-card-text>
      <v-card-actions class="justify-center">
        <v-btn color="primary" variant="flat" block @click="goToLogin">Go to Login</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { ref, watch, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'

export default {
  props: {
    visible: { type: Boolean, default: false },
    message: { type: String, default: '' },
    ip: { type: String, default: '' },
    graceSeconds: { type: Number, default: 30 },
  },
  emits: ['expired'],
  setup(props, { emit }) {
    const router = useRouter()
    const countdown = ref(props.graceSeconds)
    let timer = null

    const startCountdown = () => {
      stopCountdown()
      countdown.value = props.graceSeconds
      timer = setInterval(() => {
        countdown.value--
        if (countdown.value <= 0) goToLogin()
      }, 1000)
    }

    const stopCountdown = () => {
      if (timer) { clearInterval(timer); timer = null }
    }

    const goToLogin = () => {
      stopCountdown()
      emit('expired')
      router.push('/login')
    }

    watch(() => props.visible, (val) => {
      if (val) startCountdown()
      else stopCountdown()
    })

    onBeforeUnmount(stopCountdown)

    return { countdown, goToLogin }
  }
}
</script>
