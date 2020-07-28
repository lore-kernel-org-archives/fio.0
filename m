Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 0/3] v3 Patchset : Zone Append command support
Date: Tue, 28 Jul 2020 18:06:52 +0530
Message-Id: <20200728123655.30780-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20200728124000epcas5p4fa4a9eed2e1f8d3e20f36ede60a63708@epcas5p4.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

This is a v3 Patchset for the Zone Append command support
The v1 Pull Request is https://github.com/axboe/fio/pull/1021
The v2 Pull Request is https://github.com/axboe/fio/pull/1026

Review comments for the v2 Patchset have been taken care of in the v3 Patchset.
Corresponding Linux Kernel Patchset for the Zone Append command support :
https://lore.kernel.org/linux-block/1595605762-17010-1-git-send-email-joshi.k@samsung.com/

1. Added a new FIO option zone_append.
	When zone_append option is enabled, for Zone mode ZBD,
	the existing write path will send Zone Append command with offset as start of the Zone.
2. libaio: support for Zone Append command in libaio IO engine
3. t/zbd: Add support to verify Zone Append command with libaio IO engine tests

This is a RFC and the Linux Kernel io_uring interface is being discussed in the LKML.
io_uring engine's Zone Append command support will be submitted for review after the kernel interface is finalized.

Feedback / Comments will help in improving this further.

Ankit Kumar (2):
  Add Zone Append command support
  libaio: support for Zone Append command

Krishna Kanth Reddy (1):
  t/zbd: Add support to verify Zone Append command with libaio tests

 HOWTO                  |  7 +++++++
 engines/libaio.c       | 32 ++++++++++++++++++++++++++++----
 fio.1                  |  7 +++++++
 ioengines.c            |  6 ++++++
 ioengines.h            |  3 ++-
 options.c              | 10 ++++++++++
 t/zbd/test-zbd-support | 29 +++++++++++++++++++++++++++++
 thread_options.h       |  2 ++
 8 files changed, 91 insertions(+), 5 deletions(-)

-- 
2.17.1


