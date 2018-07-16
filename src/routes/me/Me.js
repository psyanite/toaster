import React from 'react';
import { setIdToken, setUserAccountId } from '../../utils/SessionService';

class Me extends React.Component {
  componentDidMount() {
    setIdToken(this.props.params.id_token);
    setUserAccountId(this.props.params.user_account_id);
    window.location.href = '/';
  }

  render() {
    return null;
  }
}

export default Me;
