Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 27 May 2017 09:27:12 +0100
Message-ID: <CALjAwxjZ=WWs9VEUR=685v+fuytgNrydJ9ntkx96tzjz-sz+qQ@mail.gmail.com>
Subject: Change of fio homepage
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

(follow up to "Re: [PATCH] Windows: Update the EULA year and add more
examples to the installer"
http://www.spinics.net/lists/fio/msg05510.html )

As the noted in the recent commit
https://github.com/axboe/fio/commit/e5123c4ad9b0626e25d9b243f1111fa89082308b
the old gitweb fio repo browser has gone away and only the cgit
browser (http://git.kernel.dk/cgit/fio/ ) remains. Unfortunately there
are huge numbers of links out there that still point to fio's gitweb
URL which will now become broken. Typically such links look like:

http://git.kernel.dk/?p=fio.git
http://git.kernel.dk/?p=fio.git;a=summary

Is there any chance that a redirect for the two URLs above could be
put in to bounce the visitor to http://git.kernel.dk/cgit/fio/ ?

Also going forwards is http://git.kernel.dk/cgit/fio/ the "official"
homepage? If it too is subject to change would people just be better
off pointing to https://github.com/axboe/fio mirror in a similar way
to what happened in the freshmeat era?

Here's a quick list of resources referring to fio's "homepage":
https://github.com/Ponce/slackbuilds/blob/current/system/fio/fio.info
(has http://git.kernel.dk/cgit/fio/ as the HOMEPAGE)
https://anonscm.debian.org/cgit/collab-maint/fio.git/tree/debian/control
(has https://github.com/axboe/fio as the Homepage)
https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/fio
(has https://github.com/axboe/fio as the url)
https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-block/fio/fio-2.16.ebuild
(has http://brick.kernel.dk/snaps/ as the HOMEPAGE)
http://pkgs.fedoraproject.org/cgit/rpms/fio.git/tree/fio.spec (has
http://git.kernel.dk/?p=fio.git;a=summary as the URL)
https://svnweb.freebsd.org/ports/head/benchmarks/fio/pkg-descr?revision=340718&view=markup
(has http://git.kernel.dk/?p=fio.git as the WWW)
https://www.openhub.net/p/fio (has
http://git.kernel.dk/?p=fio.git;a=summary as the Homepage)
http://freecode.com/projects/fio (aka
http://freshmeat.net/projects/fio , clicking website goes to
http://git.kernel.dk/?p=fio.git;a=summary )
https://github.com/Homebrew/homebrew-core/blob/master/Formula/fio.rb
(has http://freecode.com/projects/fio as the homepage)
https://www.opencsw.org/package/fio/ (has
http://freshmeat.net/projects/fio as the Source URL)
https://build.opensuse.org/package/view_file/benchmark/fio/fio.spec
(has http://freshmeat.net/projects/fio/ as the Url)

-- 
Sitsofe | http://sucs.org/~sits/

