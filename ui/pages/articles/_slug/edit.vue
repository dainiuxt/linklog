<template>
  <v-container v-if="!loading">
    <v-row>
      <v-col :cols="10">
        <h1 class="mb-8">Article edit</h1>
      </v-col>
      <v-col :cols="2" align="right">
        <v-btn icon @click="showDeleteConfirmation = true">
          <v-icon>mdi-delete</v-icon>
        </v-btn>
      </v-col>
    </v-row>
    <article-form :article="article" :error="error" :progress="saveInProgress" @save="save" />

    <confirmation-dialog
      v-if="showDeleteConfirmation"
      :visible.sync="showDeleteConfirmation"
      title="Delete article"
      :text="`Are you sure you want to delete article '${originalArticle.title}'`"
      :progress="deleteInProgress"
      @cancel="showDeleteConfirmation = false"
      @confirm="deleteArticle"
    />
  </v-container>
</template>

<script>
import { mapMutations, mapActions } from 'vuex'
import ConfirmationDialog from '~/components/ConfirmationDialog'
import ArticleForm from '~/components/ArticleForm'
import * as ErrorUtils from '~/lib/utils/error-utils'

export default {
  components: {
    ArticleForm,
    ConfirmationDialog
  },
  data() {
    return {
      originalArticle: null,
      article: null,
      loading: true,
      deleteInProgress: false,
      saveInProgress: false,
      showDeleteConfirmation: false,
      error: null
    }
  },

  async created() {
    this.originalArticle = await this.GET_ARTICLE(this.$route.params.slug, true)
    this.article = { ...this.originalArticle }
    this.loading = false
  },

  methods: {
    ...mapMutations('notifications', ['SHOW_NOTIFICATON']),
    ...mapActions('articles', ['UPDATE_ARTICLE', 'GET_ARTICLE', 'DELETE_ARTICLE']),
    async save() {
      this.saveInProgress = true
      try {
        await this.UPDATE_ARTICLE(this.article)
        this.SHOW_NOTIFICATON(`Article "${this.article.title}" successfully updated`)
        this.saveInProgress = false
        this.$router.push(`/`)
      } catch (e) {
        this.SHOW_NOTIFICATON('Something went wrong during save')
        this.error = ErrorUtils.calculateErrorMessage(e)
        this.saveInProgress = false
      }
    },
    async deleteArticle() {
      this.deleteInProgress = true
      await this.DELETE_ARTICLE(this.article.id)
      this.SHOW_NOTIFICATON(`Article "${this.originalArticle.title}" successfully deleted`)
      this.deleteInProgress = false
      this.$router.push(`/`)
    }
  }
}
</script>
