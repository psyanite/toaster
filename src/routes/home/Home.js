import React from 'react';
import withStyles from 'isomorphic-style-loader/lib/withStyles';
import s from './Home.css';

class Home extends React.Component {

  render() {
    return (
      <div className={s.container}>
        <img src="./meow.png" alt="meow" />
      </div>
    );
  }
}

export default withStyles(s)(Home);
