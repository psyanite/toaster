import UserAccountType from '../types/User/UserAccountType';

const me = {
  type: UserAccountType,
  resolve({ request }) {
    return (
      request.user && {
        id: request.user.id,
        email: request.user.email,
      }
    );
  },
};

export default me;
