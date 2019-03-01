import React from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import textInput from "./pages/textInput";

const App = () => (
  <Router>
        <Route exact path="/" component={textInput} />
  </Router>
);

export default App;
