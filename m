Return-Path: <aherrmann@suse.com>
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH v3 resend 0/4] cgroup: Support cgroup-v2 weight and BFQ weight
Date: Fri, 30 Oct 2020 12:11:44 +0100
Message-ID: <20201030111147.19175-1-aherrmann@suse.com>
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

v3: - rebased on fio-3.23-28-g7064f894
      (now rebased on fio-3.23-48-ga0b72421 w/o changes)

v2: - bumped FIO_SERVER_VER
    - regrouped patches

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
2.29.0


