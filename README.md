# laravel-docker 🐳

Generic docker image for Laravel applications with minimal footprint and support for cronjobs (so Laravel `Schedule`'s
work), gd configured/installed with jpeg support, configured/installed exif and has installed Imagick. Comes with a
production-like php.ini file with a maximum upload size set to 20M. Compressed docker image size is only 62mb. Php
version is 7.2.

### Usage

Create this Dockerfile in your Laravel application root directory:

```
FROM aal89/laravel-docker:latest

COPY . .

RUN composer install --optimize-autoloader --no-dev
```

And thats it! Build, tag and run the Docker image and you'll find your Laravel application running on port `8189`.

Optionally you could add in these steps to further optimize your Laravel application in production:

```
RUN php artisan route:cache
RUN php artisan config:cache
etc...
```

**Note:** if port `8189` is not a good fit or you'd like to launch your application differently, feel free to overwrite
the `CMD` line with one of your own. Don't forget to incorporate `crond` in there somewhere, otherwise your `Schedule`'s
won't run.

Try using this as a `.dockerignore` file for minimal clutter inside the image:

```
/node_modules
/public/hot
/public/storage
/storage/*.key
/vendor
Homestead.json
Homestead.yaml
npm-debug.log
yarn-error.log
.env
.phpunit.result.cache
.DS_Store
.hg
.hgcheck
.hgignore
.hgtags
.vscode
.git
.gitignore
.gitmodules
```
