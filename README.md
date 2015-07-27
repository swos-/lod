# _Legend of the Dragon_
_Legend of the Dragon is a remake of the classic BBS door game, Legend of the Red Dragon (LORD)._

The intention is to create a game in the spirit of the original which is playable on modern platforms, with flexibility to change over time.

To that end, LoD will rely on Backbone.js on the front end, with a RESTful backend powered by the Slim framework for routing, and MySQL stored procedures to process requests. The set of technologies may evolve over time if it is needed. My initial effort is getting a minimal backend wired, connecting the front end to that, and subsequently defining features. Wiki documentation will accompany these steps as they are carried out.

## Pre-requisites
* PHP 5.5.x
* [Composer dependency manager](https://getcomposer.org/). Follow instructions [here](https://getcomposer.org/doc/00-intro.md#globally) to make Composer globally executable.
* MySQL 5.5.x
* Apache 2.2.x with mod_rewrite enabled for Slim framework to work

## Setup
Once you have verified that you meet the pre-requisites, you can proceed with setup.

1. Clone the repository (https://github.com/swos-/lod.git) (or fork the repository on GitHub, and clone that).  To clone this repository use
```
$ git clone https://github.com/swos-/lod.git
```

2. From the cloned repository, you'll need to run the deployment script (deploy.sh)
```
$ ./deploy.sh
```
The deployment script will prompt you for database credentials, which it will use to generate the appropriate configuration file and initial database setup.

3. To test that the deployment has worked, you can test the REST endpoint, users, which should return plain text 'users without parameter'.
```
$ curl http://$host/$local_repo/users
```
4. That's it for now! My attention has been split between getting a very minimal backend API and a deployment script to ensure the process is reproducible.

## Contributing
Though this is in its infancy, I welcome changes and improvements. Feel free to fork and open a pull request with changes.
Please make changes in a specfic branch (i.e.: bugfix/branch-name, feature/branch-name, doc/branch-name), and request to pull into `develop`. Please e-mail me instructions to test, or if any special instructions are needed.

## License
Legend of the Dragon is licensed under the [MIT license.](https://github.com/gabrielecirulli/2048/blob/master/LICENSE.txt)
