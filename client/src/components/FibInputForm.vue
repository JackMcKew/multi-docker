<template>
  <div class="box">
    <div class="columns is-centered">
      <form @submit.prevent="handleSubmit">
        <div class="field has-addons">
          <div class="control">
            <input
              v-model="inputValue"
              onfocus="if(this.value == 'Enter a value') { this.value = ''; }"
              class="input is-primary"
              type="text"
            />
          </div>
          <div class="control">
            <button class="button is-primary" type="submit">Submit</button>
          </div>
        </div>
      </form>
    </div>

    <ul v-if="seenIndexes && seenIndexes.length">
      <h3>Indexes I have seen:</h3>

      <p>{{ seenIndexes.map((x) => x.number).join(", ") }}</p>
    </ul>

    <ul>
      <h3>Calculated Values:</h3>

      <li v-for="(value, name) in values" :key="name">
        <p>For index {{ name }}, I calculated {{ value }}</p>
      </li>
    </ul>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "FibInput",
  data() {
    return {
      seenIndexes: [],
      values: {},
      index: "",
      inputValue: "Enter a value"
    };
  },

  // // Fetches posts when the component is created.
  async created() {
    try {
      const values = await axios.get("/api/values/current");
      this.values = values.data;
      // this.values = await axios.get("/api/values/current");
      const indexes = await axios.get("/api/values/all");
      this.seenIndexes = indexes.data;
    } catch (e) {
      this.errors.push(e);
    }
  },

  methods: {
    async handleSubmit() {
      await axios.post("/api/values", {
        index: this.inputValue
      });

      this.index = "";

      window.location.reload();
    }
  }
};
</script>
