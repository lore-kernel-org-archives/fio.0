Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 0/4] v2 Patchset : Zone Append command support for NVMe
 Zoned Namespaces (ZNS)
Date: Thu, 25 Jun 2020 23:08:48 +0530
Message-Id: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20200625174119epcas5p122a2197102fe336aa35fdea1273fd1b0@epcas5p1.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

This is a v2 Patchset for the Zone Append command support for NVMe Zoned Namespaces
The v1 Pull Request is https://github.com/axboe/fio/pull/1021

Review comments for the v1 Pull Request have been taken care of in the v2 Patchset.
New Opcodes added for libaio and io_uring are removed as per the review comments for the Linux kernel patches in LKML.
Linux Kernel v1 Patchset for the Zone Append command support :
	https://lkml.org/lkml/2020/6/17/801
	https://lkml.org/lkml/2020/6/17/802
	https://lkml.org/lkml/2020/6/17/803
	https://lkml.org/lkml/2020/6/17/804

RWF_ZONE_APPEND flag is passed in iocb->aio_rw_flags for libaio IO Engine and sqe->rw_flags for io_uring IO Engine.

Add Zone Append command support for NVMe Zoned Namespaces (ZNS) defined in NVM Express TP4053.

1. Added a new FIO option zone_append.
	When zone_append option is enabled, the existing write path will send Zone Append command with LBA offset as start of the Zone.
2. libaio: support for Zone Append command in libaio IO engine
3. iouring: support for Zone Append command in io_uring IO engine
4. t/zbd: Add support to verify Zone Append (ZNS)) command with libaio, io_uring IO engine tests

This is a RFC and the Linux Kernel interface is under submission and review.
Feedback / Comments will help in improving this further.

Ankit Kumar (3):
  Add Zone Append command support for NVMe Zoned Namespaces (ZNS)
  libaio: support for Zone Append command
  iouring: support for Zone Append command

Krishna Kanth Reddy (1):
  t/zbd: Add support to verify Zone Append command with libaio, io_uring
        IO engine tests

 HOWTO                  |  7 ++++
 engines/io_uring.c     | 23 ++++++++++++-
 engines/libaio.c       | 20 ++++++++++-
 fio.1                  |  7 ++++
 io_u.c                 |  4 +--
 io_u.h                 | 10 ++++--
 ioengines.c            |  4 +--
 options.c              | 10 ++++++
 t/zbd/test-zbd-support | 48 +++++++++++++++++++++++++++
 thread_options.h       |  2 ++
 zbd.c                  | 90 ++++++++++++++++++++++++++++++++++++++++++++++----
 zbd.h                  | 13 +++++---
 12 files changed, 220 insertions(+), 18 deletions(-)

-- 
2.7.4


