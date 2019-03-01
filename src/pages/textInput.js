import React, { Component } from "react";
import Form from "../components/Form"
import API from "../utils/API";

class Sentiment extends Component {
  state = {
    text: "",
    search: "",
    results: "RESULTS",
    error: ""
  };

  handleFormSubmit = event => {
    event.preventDefault();
    API.sentimentInput(this.state.search)
      .then(res => {
        if (res.data.status === "error") {
          throw new Error(res.data.message);
        }
        this.setState({ results: res.data.message, error: "" });
      })
      .catch(err => this.setState({ error: err.message }));
  };

  handleInputChange = event => {
    this.setState({ search: event.target.value });
  };

render() {
return(
<div>
  

  <Form handleFormSubmit = {this.handlFormSubmit}
        handleInputChange={this.handleInputChange} />

  <div>
    {this.state.results}
  </div>

</div>
)
}

}

export default Sentiment;
