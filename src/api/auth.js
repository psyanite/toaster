import express from 'express';
import * as AuthService from './../utils/AuthService';

// Not currently used

import asyncMiddleware from './asyncMiddleware';

const router = express.Router(null);

router.post(
  '/authenticateFacebookLogin',
  asyncMiddleware(async (req, res, next) => {
    const { accessToken, profile } = req.body;
    console.log(req.body);
    console.log(accessToken);
    console.log(profile);
    const response = await AuthService.consumeFacebookAuth(
      accessToken,
      profile,
    );
    res.send(response);
  }),
);

export default router;
