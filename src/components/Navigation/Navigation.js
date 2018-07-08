import React from 'react';
import withStyles from 'isomorphic-style-loader/lib/withStyles';
import { isLoggedIn } from '../../utils/AuthService';
import s from './Navigation.css';
import Link from '../Link';

class Navigation extends React.Component {
  state = {
    isLoggedIn: false,
  };

  async componentWillMount() {
    const resp = await isLoggedIn();
    this.setState({ isLoggedIn: resp });
  }

  render() {
    // console.log(localStorage);
    return (
      <div className={s.root} role="navigation">
        <Link className={s.link} to="/about">
          About
        </Link>
        <Link className={s.link} to="/contact">
          Contact
        </Link>
        <span className={s.spacer}> | </span>
        {this.state.isLoggedIn ? (
          <Link className={s.link} to="/logout">
            Log out
          </Link>
        ) : (
          <Link className={s.link} to="/login">
            Log in
          </Link>
        )}
      </div>
    );
  }
}

export default withStyles(s)(Navigation);
