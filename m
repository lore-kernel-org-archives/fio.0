Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH v2 0/4] cross-job overlap patches
Date: Wed, 17 Oct 2018 10:52:21 -0400
Message-Id: <20181017145225.14546-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, this series of patches allocates io_u's and io_u_all members from
shared memory when serialize_overlap=1 and io_submit_mode=offload so
that processes can now be used. Also included are the locking comments
you requested and some other cleanups. Please let me know what comments
you have.

Vincent Fu (4):
  fio: add function to check for serialize_overlap with offload
    submission
  fio: enable cross-thread overlap checking with processes
  fio: document locking for overlap checking in offload mode
  docs: serialize_overlap=1 with io_submit_mode=offload no longer
    requires threads

 HOWTO          |  2 +-
 backend.c      | 21 +++++++++++++--------
 fio.1          |  2 +-
 fio.h          |  5 +++++
 io_u_queue.c   | 19 +++++++++++++++----
 io_u_queue.h   |  4 ++--
 ioengines.c    |  9 ++++++++-
 lib/memalign.c | 16 ++++++++++++----
 lib/memalign.h |  5 +++--
 rate-submit.c  |  8 ++++++++
 t/dedupe.c     | 12 ++++++------
 11 files changed, 74 insertions(+), 29 deletions(-)

-- 
2.17.1


