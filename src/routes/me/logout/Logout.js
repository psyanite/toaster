import React from 'react';
import { clearTokens } from '../../../utils/AuthService';

class Logout extends React.Component {
  componentDidMount() {
    clearTokens();
    window.location.href = '/';
  }

  render() {
    return null;
  }
}

export default Logout;
