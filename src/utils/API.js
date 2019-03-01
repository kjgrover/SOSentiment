import axios from "axios";

// Export an object containing methods we'll use for accessing the Dog.Ceo API

export default {
  sentimentInput: function(text) {
    return axios.get("INSERT API HERE?input=" + text);
  }
};
