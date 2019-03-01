import React from "react";
import "./Form.css";

// Using the datalist element we can create autofill suggestions based on the props.breeds array
const Form = props => (
<form>

         <input
    //   value={props.search}
        onChange={props.handleInputChange}
        name="text"
        type="text"
        className="form-control"
        placeholder="Insert Text to Begin"
        id="text"
      />

       <button
        type="submit"
        onClick={props.handleFormSubmit}
        className="btn btn-success"
      >
        Submit
      </button>
</form>
);

export default Form;