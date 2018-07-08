import decode from 'jwt-decode';

const USER_ACCOUNT_ID_KEY = 'user_account_id';
const ID_TOKEN_KEY = 'id_token';

export function getIdToken() {
  return localStorage.getItem(ID_TOKEN_KEY);
}

export function setIdToken(value) {
  localStorage.setItem(ID_TOKEN_KEY, value);
}

export function getUserAccountId() {
  return localStorage.getItem(USER_ACCOUNT_ID_KEY);
}

export function setUserAccountId(value) {
  return localStorage.setItem(USER_ACCOUNT_ID_KEY, value);
}

export function clearTokens() {
  localStorage.removeItem(ID_TOKEN_KEY);
  localStorage.removeItem(USER_ACCOUNT_ID_KEY);
}

function getTokenExpirationDate(encodedToken) {
  const token = decode(encodedToken);
  if (!token.exp) {
    return null;
  }

  const date = new Date(0);
  date.setUTCSeconds(token.exp);

  return date;
}

function isTokenExpired(token) {
  const expirationDate = getTokenExpirationDate(token);
  return expirationDate < new Date();
}

export function isLoggedIn() {
  const idToken = getIdToken();
  return !!idToken && !isTokenExpired(idToken);
}
