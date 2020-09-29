Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 0/3] v1 Patchset : Zone Explicit Open support
Date: Tue, 29 Sep 2020 18:29:47 +0530
Message-Id: <20200929125950.20343-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20200929130315epcas5p4e6a11cc77fb06a64c31e57740d2e0e31@epcas5p4.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

1. Added a new FIO option zone_open.
	When it is enabled, Zones will be opened explicitly before sending I/Os.
2. Add support for open_zones in libzbc I/O engine
3. t/zbd: Add support to verify Zone Explicit Open

This is a RFC.
Feedback / Comments will help in improving this further.

Ankit Kumar (2):
  Add support for Explicit open zones
  Add support for open_zones in libzbc I/O engine.

Krishna Kanth Reddy (1):
  t/zbd: Add support to verify Zone Explicit Open

 HOWTO                       | 13 ++++++++
 engines/libzbc.c            | 42 +++++++++++++++++++++++++
 engines/skeleton_external.c | 12 ++++++++
 fio.1                       | 11 +++++++
 ioengines.h                 |  2 ++
 options.c                   | 20 ++++++++++++
 oslib/blkzoned.h            |  7 +++++
 oslib/linux-blkzoned.c      | 26 ++++++++++++++++
 t/zbd/test-zbd-support      | 27 ++++++++++++++++
 thread_options.h            |  7 +++++
 zbd.c                       | 61 +++++++++++++++++++++++++++++++++++++
 11 files changed, 228 insertions(+)

-- 
2.17.1


