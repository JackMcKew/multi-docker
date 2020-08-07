<template>
  <div>
    <form @submit.prevent="handleSubmit">
      <label>Enter your index:</label>
      <input
        v-model="inputValue"
        onfocus="if(this.value == 'Enter a value') { this.value = ''; }"
      />
      <button type="submit">Submit</button>
    </form>

    <!-- <ul> -->
    <ul v-if="seenIndexes && seenIndexes.length">
      <h3>Indexes I have seen:</h3>

      <p>{{ seenIndexes.map(x => x.number).join(", ") }}</p>
    </ul>

    <ul>
      <!-- <ul v-if="values && values.length"> -->
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
