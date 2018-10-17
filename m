Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH v3 0/4] cross-job overlap patches
Date: Wed, 17 Oct 2018 12:03:21 -0400
Message-Id: <20181017160325.16866-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org, vincentfu@gmail.com
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Jens, I have updated the patch series in response to the latest
comments. Specifically, I have

- removed the unneeded parentheses in PATCH 1/4
- removed the unneeded memset in PATCH 2/4

Please let me know if you see any other issues.

Vincent

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
 io_u_queue.c   | 17 +++++++++++++----
 io_u_queue.h   |  4 ++--
 ioengines.c    |  9 ++++++++-
 lib/memalign.c | 16 ++++++++++++----
 lib/memalign.h |  5 +++--
 rate-submit.c  |  8 ++++++++
 t/dedupe.c     | 12 ++++++------
 11 files changed, 72 insertions(+), 29 deletions(-)

-- 
2.17.1


