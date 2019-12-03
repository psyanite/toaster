import React from 'react';

class Home extends React.Component {
  render() {
    const style = {
      position: "fixed",
      bottom: 0,
    };
    return (
      <img src="./meow.png" alt="meow" style={style}/>
    );
  }
}

async function action({ fetch }) {
  return {
    title: 'Meow',
    component: (
      <Home fetch={fetch} />
    ),
  };
}

export default action;
