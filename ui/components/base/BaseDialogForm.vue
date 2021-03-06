<template>
  <div>
    <v-dialog width="500" :value="visible" @input="$emit('hide')">
      <v-card>
        <v-card-title class="headline grey lighten-2" primary-title>
          {{ title }}
        </v-card-title>

        <v-form ref="form" v-model="valid" @submit.prevent="handleSubmit">
          <v-card-text class="pt-4">
            <slot name="header"></slot>
            <div v-if="errorMessage" class="error-message">
              {{ errorMessage }}
            </div>
            <slot></slot>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn ref="submit-button" color="primary" :disabled="!valid" type="submit" :loading="submitting">
              {{ submitTitle }}
            </v-btn>
          </v-card-actions>
          <div v-if="$slots.footer" class="dialog-footer">
            <slot name="footer"></slot>
          </div>
        </v-form>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  name: 'BaseDialogForm',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    title: {
      type: String,
      default: null
    },
    submitTitle: {
      type: String,
      default: null
    },
    submit: {
      type: Function,
      default: () => {}
    }
  },
  data() {
    return {
      valid: false,
      errorMessage: null,
      submitting: false
    }
  },
  watch: {
    visible() {
      this.$refs.form && this.$refs.form.resetValidation()
      this.errorMessage = null
    }
  },
  methods: {
    async handleSubmit() {
      try {
        this.submitting = true
        await this.submit()
        this.submitting = false
        this.$emit('hide')
      } catch (e) {
        const error = e.response.data.errors[0]
        this.errorMessage = `${error.title} - ${error.detail}`
        this.submitting = false
      }
    }
  }
}
</script>

<style scoped>
.error-message {
  color: red;
  margin-top: 14px;
  margin-bottom: 14px;
}

.dialog-footer {
  text-align: center;
  padding-bottom: 20px;
}
</style>
