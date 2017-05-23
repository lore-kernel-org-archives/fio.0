Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 0/2] configure
Date: Tue, 23 May 2017 21:43:56 +0300
Message-Id: <20170523184358.48088-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Regarding below, whatever I tried ended up just adding unnecessary
complexity on runtime, so I'd like to submit two patches that weren't
picked up in the previous series of commits for now. These two are just
cleanups.

Printing the fs name to error messages for those that compiles but may
fail on runtime could be good enough to make it less insane, however
detecting the fs type from a given regular file path is another less
trivial thing, especially if we want to do it on all supported platforms
(I think du(1) does this).

 http://www.spinics.net/lists/fio/msg05807.html
 >> Yes, so the next one 2/11 actually mostly reverts this, and replace it
 >> with runtime check, so that it works not only with this specific
 >> NetBSD/UFS case, but also for e.g. Linux fs (something other than
 >> ext4, XFS, etc).
 >> I wasn't sure if runtime check (execute $TMPE) is preferred.
 >
 >Let's just drop 1/11 then, and have the first patch cover the runtime of
 >it. But don't do that from configure. Whatever fs is hosting configure
 >is less interesting. Maybe that doesn't support fallocate, but whatever
 >you end up running on does. Or vice versa.
 >
 >> Any how, I'll resend the 1,2,3,4,11 with --cover-letter as you commented.
 > 
 >Thanks!

Tomohiro Kusumi (2):
  configure: Use single square brackets (POSIX)
  configure: Add print_config() for "<config>... <yes|no>" outputs

 configure | 159 ++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 82 insertions(+), 77 deletions(-)

-- 
2.9.4


