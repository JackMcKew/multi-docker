<template>
  <section class="section">
    <div class="container">
      <div class="columns is-centered">
        <div class="column is-half">
          <FibInputForm />
        </div>
      </div>
    </div>
  </section>
</template>

<script>
// @ is an alias to /src
import FibInputForm from "@/components/FibInputForm.vue";

export default {
  name: "Fib",
  components: {
    FibInputForm,
  },
};
</script>
