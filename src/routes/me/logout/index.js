import React from 'react';
import Logout from './Logout';

function action() {
  return {
    chunks: ['logout'],
    component: <Logout />,
  };
}

export default action;
