Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] revert/rework "fix load_ioengine() not to support no "external:" prefix"
Date: Fri,  1 Sep 2017 22:54:11 +0300
Message-Id: <20170901195412.119846-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

A patch for what was talked in below, which allows both of these.

 # fio --name=xxx --ioengine=external:./engines/skeleton_external.so
 # fio --name=xxx --ioengine=./engines/skeleton_external.so

Re: [PATCH 4/5] fix load_ioengine() not to support no "external:" prefix
http://www.spinics.net/lists/fio/msg06255.html

--
Tomohiro Kusumi (1):
  revert/rework 81647a9a('fix load_ioengine() not to support no
    "external:" prefix')

 ioengines.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

-- 
2.9.5


