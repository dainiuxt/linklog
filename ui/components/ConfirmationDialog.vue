<template>
  <div>
    <v-dialog width="500" :value="visible" @input="$emit('update:visible', false)">
      <v-card>
        <v-card-title class="headline grey lighten-2" primary-title>
          {{ title }}
        </v-card-title>

        <v-card-text class="pt-4">{{ text }}</v-card-text>
        <v-divider />
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn ref="cancel-button" @click="$emit('cancel')">Cancel</v-btn>
          <v-btn ref="confirm-button" color="primary" :loading="progress" @click="$emit('confirm')">Yes</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  name: 'ConfirmationDialog',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    progress: {
      type: Boolean,
      default: false
    },
    title: {
      type: String,
      default: null
    },
    text: {
      type: String,
      default: null
    }
  }
}
</script>

<style scoped></style>
