<template>
  <v-menu v-model="menu" :close-on-content-click="false">
    <template v-slot:activator="{ props }">
      <v-text-field
        :model-value="displayValue"
        v-bind="props"
        :label="label"
        variant="outlined"
        density="compact"
        hide-details
        readonly
        clearable
        prepend-inner-icon="mdi-calendar"
        :style="style"
        @click:clear="clear"
      />
    </template>
    <v-date-picker
      :model-value="pickerValue"
      @update:model-value="onPick"
      color="primary"
      hide-header
    />
  </v-menu>
</template>

<script>
import { ref, computed, watch } from 'vue'
import { useSiteSettings } from '../composables/useSiteSettings'

export default {
  props: {
    modelValue: { type: String, default: '' },
    label: { type: String, default: 'Date' },
    style: { type: String, default: 'min-width:180px;max-width:220px' },
  },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const { settings } = useSiteSettings()
    const menu = ref(false)

    const pickerValue = computed(() => {
      if (!props.modelValue) return undefined
      return new Date(props.modelValue + 'T00:00:00')
    })

    const displayValue = computed(() => {
      if (!props.modelValue) return ''
      const parts = props.modelValue.split('-')
      if (parts.length !== 3) return props.modelValue
      const [Y, M, D] = parts
      const fmt = settings.date_format || 'YYYY-MM-DD'
      return fmt.replace('YYYY', Y).replace('MM', M).replace('DD', D)
    })

    const onPick = (val) => {
      if (!val) return
      const d = new Date(val)
      const iso = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0')
      emit('update:modelValue', iso)
      menu.value = false
    }

    const clear = () => {
      emit('update:modelValue', '')
    }

    return { menu, pickerValue, displayValue, onPick, clear }
  }
}
</script>
