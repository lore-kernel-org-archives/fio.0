Return-Path: <prvs=4108b2f29=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 0/2] Fix compilation error on BSD
Date: Thu, 28 May 2020 21:56:40 +0900
Message-Id: <20200528125642.103863-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

It was reported that the commit b76949618d55 ("fio: Generalize zonemode=zbd")
triggered a compilation failure of zbd.c on NetBSD which does not have
pthread_mutexattr_setpshared(). This patch series addresses the failure. To
avoid pthread_mutexattr_setpshared() calls, utilize helper functions pshared.c
provides.

The first patch adds another helper function in pshared.c to initialize mutex
with attribute types desired. The second patch replace mutex initialization in
zbd.c with the helper functions. To initialize mutex with POSIX_MUTEX_RECURSIVE
attribute type, utilize the newly introduced function.

I do not have NetBSD (or other BSD) system then this series is not confirmed
build pass on NetBSD. Confirmation by BSD users will be appreciated.

Shin'ichiro Kawasaki (2):
  pshared: Add mutex_init_pshared_with_type()
  zbd: Fix compilation error on BSD

 pshared.c | 15 ++++++++++++++-
 pshared.h |  1 +
 zbd.c     | 22 +++++++---------------
 3 files changed, 22 insertions(+), 16 deletions(-)

-- 
2.25.4


