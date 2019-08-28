Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [three fio patches 0/3]
Date: Wed, 28 Aug 2019 13:48:39 -0400
Message-Id: <20190828174842.25423-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, please consider this series of patches. They do the following:

- fix a smalloc synchronization bug
- allow offset_increment to understand percentages
- fix minor documentation issues

Vincent


Vincent Fu (3):
  docs: small HOWTO fixes
  options: allow offset_increment to understand percentages
  smalloc: allocate pool-> members from shared memory

 HOWTO            | 12 ++++++++++--
 cconv.c          |  2 ++
 filesetup.c      | 32 ++++++++++++++++++++++----------
 fio.1            |  4 +++-
 options.c        | 17 +++++++++++++++++
 server.h         |  2 +-
 smalloc.c        | 36 ++++++++++++++++++++----------------
 thread_options.h |  3 +++
 8 files changed, 78 insertions(+), 30 deletions(-)

-- 
2.17.1


