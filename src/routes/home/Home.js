import React from 'react';
import graphqlify from 'graphqlify';
import withStyles from 'isomorphic-style-loader/lib/withStyles';
import { getUserAccountId } from '../../utils/AuthService';
import s from './Home.css';

class Home extends React.Component {
  state = {
    profile: null,
  };

  async componentWillMount() {
    const meId = getUserAccountId();
    if (meId) {
      const meQuery = graphqlify({
        profileByUserAccountId: {
          params: { userAccountId: 22 },
          fields: {
            username: {},
            display_name: {},
            profile_picture: {},
          },
        },
      });
      const resp = await this.props.fetch('/graphql', {
        body: JSON.stringify({ query: meQuery }),
      });

      const { data } = await resp.json();
      const profile = data ? data.profileByUserAccountId.pop() : null;
      this.setState({ profile });
    }
  }

  render() {
    const { profile } = this.state;
    return (
      <div className={s.root}>
        <div className={s.container}>
          {profile ? (
            <div>
              <h1>Welcome {profile.display_name}</h1>
              <img src={profile.profile_picture} alt="meow" />
            </div>
          ) : (
            <div>
              <h1>Welcome Guest</h1>
            </div>
          )}
        </div>
      </div>
    );
  }
}

export default withStyles(s)(Home);
