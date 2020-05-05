# Fix up storage buckets

```
update post_photos set url = replace(url, '/b/burntoast-fix.appspot.com/', '/b/burntoast.appspot.com/');
update post_photos set url = replace(url, '/b/burntbutter-fix.appspot.com/', '/b/burntbutter-inc.appspot.com/');

update user_profiles set profile_picture = replace(profile_picture, '/b/burntoast-fix.appspot.com/', '/b/burntoast.appspot.com/');
update user_profiles set profile_picture = replace(profile_picture, '/b/burntbutter-fix.appspot.com/', '/b/burntbutter-inc.appspot.com/');

update stores set cover_image = replace(cover_image, '/b/burntoast-fix.appspot.com/', '/b/burntoast.appspot.com/');
update stores set cover_image = replace(cover_image, '/b/burntbutter-fix.appspot.com/', '/b/burntbutter-inc.appspot.com/');
```

