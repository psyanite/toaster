import React from 'react';
import Home from './Home';
import Layout from '../../components/Layout';

async function action({ fetch }) {
  return {
    title: 'Meow',
    component: (
      <Layout>
        <Home fetch={fetch} />
      </Layout>
    ),
  };
}

export default action;
