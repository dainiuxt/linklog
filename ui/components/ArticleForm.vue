<template>
  <v-form v-model="valid" @submit.prevent="$emit('save')">
    <div v-if="error" class="error-message">{{ error }}</div>
    <div>
      <v-text-field ref="title-input" v-model="article.title" label="Title" :rules="[rules.required]" />
    </div>
    <div>
      <v-textarea
        ref="content-input"
        v-model="article.content"
        label="Content"
        :rules="[rules.required, rules.minLength5]"
        auto-grow
        :rows="1"
      />
    </div>
    <div class="text-right mt-5">
      <v-btn ref="cancel-button" to="/" class="mr-3">Cancel</v-btn>
      <v-btn ref="save-button" :disabled="!valid" type="submit" color="primary" :loading="progress">Save</v-btn>
    </div>
  </v-form>
</template>

<script>
import * as ValidationUtils from '~/lib/utils/validation-utils'

export default {
  name: 'ArticleForm',
  props: {
    article: {
      type: Object,
      default: null
    },
    progress: {
      type: Boolean,
      default: false
    },
    error: {
      type: String,
      default: null
    }
  },
  data() {
    return {
      rules: {
        required: (v) => ValidationUtils.isNotEmpty(v) || 'This field is required',
        minLength5: (v) => v.length > 5 || 'This field need to have at least 5 characters'
      },
      valid: false
    }
  }
}
</script>

<style lang="scss" scoped>
.error-message {
  color: red;
  margin-top: 15px;
  margin-bottom: 45px;
}
</style>
