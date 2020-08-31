Return-Path: <aherrmann@suse.com>
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH v2 0/4] cgroup: Support cgroup-v2 weight and BFQ weight
Date: Mon, 31 Aug 2020 11:21:01 +0200
Message-ID: <20200831092104.3892-1-aherrmann@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
Return-Path: aherrmann@suse.com
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>, Andreas Herrmann <aherrmann@suse.com>
List-ID: <fio@vger.kernel.org>

These are changes to support weight with cgroup-v2, and also BFQ's
weight attribute. In recent kernels with cgroup v1 only
blkio.bfq.weight is available to set weight.

Andreas Herrmann (4):
  cgroup: Fix handling when cgroup blkio and cgroup-v2 are mounted
  cgroup: Allow to use weights with cgroup-v2
  thread_options: Introduce cgroup_use_bfq
  cgroup: Support BFQ's weight attributes

 HOWTO            |   6 +++
 cconv.c          |   2 +
 cgroup.c         | 110 ++++++++++++++++++++++++++++++++++++-----------
 fio.1            |   5 +++
 options.c        |  11 +++++
 server.h         |   2 +-
 thread_options.h |   7 ++-
 7 files changed, 116 insertions(+), 27 deletions(-)

--=20
2.28.0


