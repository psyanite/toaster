import React from 'react';
import Me from './Me';

async function action({ query }) {
  return {
    component: <Me params={query} />,
  };
}

export default action;
