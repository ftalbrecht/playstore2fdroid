# playstore2fdroid

Dockercontainer wich imports apks from the playstore and generates an fdroid-repo

## How to use this container

1) create an raccon repository like written on [raccoon website](http://raccoon.onyxbits.de/)

2) Strat the docker container and mount the volumes

```
docker run --name p2f \
 -v <path-to-raccoon-archive>:/raccoon \
 -v <path-to-fdroid-repo>:/fdroid \
 -v <path-to-import.txt>:/import.txt headbanger84/playstore2fdroid
```

3) Adding new Apps is done via the `import.txt` add the market-link for the app you want to add to the repository.

```
market://details?id=org.videolan.vlc
```
The content of the file is deleted after importing the apps.

## how to publish fdroid repository

use an nginx container to publish your repository

```
docker run --name some-nginx -p 80:80 \
 -v <path-to-fdroid-repo>/repo:/usr/share/nginx/html/repo:ro \
 -v <path-to some-index.html>:/usr/share/nginx/html/index.html:ro \
 -d nginx
```

## Volumes

### /import.txt

Allows to add new apps to your

### /raccoon

Path for the raccon Archive

### /fdroid

Path to your fdroid repository

## Thx

Special Thanks to:

* [fdroidserver](https://gitlab.com/fdroid/fdroidserver)
* [guardianproject](https://guardianproject.info/)
* [raccoon](http://raccoon.onyxbits.de/)
* [go-cron](https://github.com/michaloo/go-cron)
