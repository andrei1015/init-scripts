# Arch AWS EC2 init scripts

##### Prerequisites

~~Use the [standard kernel ami](http://arch-ami-list.drzee.net/). I have no idea why stuff breaks on the ec2 optimised kernel. The setup as it is (with a lot of my own preferences and needs in it) takes around 12 minutes to boot up, but is entirely usable.~~ I was just dumb, the ec2 optimised kernel works just fine, don't listen to past me, i was dumb.

---

##### How-to

1. Use `aws-user-data-script.sh` in your ec2 instance.
2. Start the instance.
3. Clone this repo.
4. Modify the variables in`generate.php`
5. Run`php generate.php wordrpess` (replace wordpress with the service you want, out of what's available)
6. Run bash setup scripts
7. Have fun I guess? 🎉️

(stuff with sudo works because you are not asked for password with the arch user, so that's nice for automation, thanks)

---

##### Scripts

-   "lamp" • `bash server-stack.sh` • this installs everything php (set up with libphp), apache, mariadb and phpmyadmin, and sets them up with an example php page as the index. site root is in`/srv/http`. after running this you end up with a complete(?) lamp stack ready for use. this is a base script for some others below, stuff that requires a web server (restricted to only local db connections)
-   "the generator" • `php generate.php service` • where `service ` is `matomo ` or `wordpress ` at the moment. changes the appropriate `files/` for when you run the setup script of that particular service. done in php because once chaining commands doesn't cut it anymore, i run away from bash, and php _is_ already there so might as well use it
-   "analytics" • `bash matomo.sh` • this sets up a self-hosted analytics solution powered by [matomo](https://matomo.org/faq/on-premise/installing-matomo/). it gets you very close to the finish line
-   "blogs!" • `bash wordpress.sh` • another almost-to-go setup script, but for wordpress this time
-   "github" • still working on this but the goal is to have a way of authenticating as automatically as possible on your github. i haven't found a working way yet
-   "the godfather" - `aws-user-data-script.sh` • this is the initial init script for the instance setup, should not be run afterward, though I don't think anything wrong happens if you do run it. when done through ec2's user data script, the entire thing takes around 12 minutes to complete (i use t3a.micro usually so it probably depends). one curious thing I discovered is that because the script runs for so long, if you don't give it enough time, when you first log in, it might not look right, as the init script is still running in the background. just give it some time
    -   it also installs yay and some aur packages
    -   this, like all other scripts, contains a lot of personal preference which, of course, you are free to change in any way you want
    -   it enables pretty colors and pacman eating progress by default, of course
    -   Arch btw!

##### Why?

Had a centos7 server initially, updating didn't seem viable, plus centos8 died rather quickly and took centos as a whole down the drain. RIP

Then I manually moved everything (configs, files and customisations) to debian 10 at that time. After a while debian 11 came along and, for some reason, even a `sudo apt update; sudo apt upgrade` just... utterly destroys the whole server.

Plus I like new features and new softwares and new versions. Which is a problem in both cases above.

Solving the version upgrades and software updates was easy: Arch. Totally new, first time actually intending to do long-lasting stuff with it. Pretty cool. Doing automated setup scripts because I am fed up of moving. EC2 because it lets you choose your distro so freely.

**Why is X yay or pacman package included?** Because I wanted to, of course! But that's the fun part about all of this! You can take this code and do ABSOLUTELY whatever you want with it!

**Why is my code so bad?** Continue reading. Create a branch, submit code, teach me. This has all been a really cool learning experience for me.

---

##### Why not ...?

-   docker - too dumb to understand how to use it, too resource intensive for me
-   packer-absible-terraform - i know these words from work and i think they deal with similar stuff but again, to dumb to understand
-   kubernetes - same, not even sure what it does
-   nginx - tried it, didn't like it

# WIP WIP WIP

This was done mainly because I need it and it was fun learning some new stuff. Use at your own risk blah blah, yada yada, you know. Of course I try to make my stuff work...
