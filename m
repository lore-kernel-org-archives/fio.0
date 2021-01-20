Return-Path: <glqinhongwei@gmail.com>
Return-Path: <glqinhongwei@gmail.com>
From: Hongwei Qin <glqinhongwei@gmail.com>
Subject: [PATCH v4 0/2] Add a new parameter and fix minimal rate calculation.
Date: Wed, 20 Jan 2021 18:43:42 +0800
Message-Id: <cover.1611138623.git.glqinhongwei@gmail.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, sitsofe@gmail.com, Hongwei Qin <glqinhongwei@gmail.com>
List-ID: <fio@vger.kernel.org>

v3 -> v4:
	Use uint32_t for thinktime_blocks_type.
	The tests in patch1 has been re-verified.

v3:
	The first patch adds a new parameter thinktime_blocks_type
	to control the behavior of thinktime_blocks.
	It can be either `complete` or `issue`.
	If it is `complete` (default), fio triggers thinktime when
	thinktime_blocks number of blocks are **completed**.
	If it is `issue`, fio triggers thinktime when thinktime_blocks
	number of blocks are **issued**

	The second patch updates the compare time if handle_thinktime
	sleeps or spin.

Hongwei Qin (2):
  Add a new parameter.
  Calculate min_rate with the consideration of thinktime

 HOWTO            |  7 +++++++
 backend.c        | 22 ++++++++++++++++------
 cconv.c          |  2 ++
 engines/cpu.c    |  1 +
 fio.h            |  5 +++++
 options.c        | 22 ++++++++++++++++++++++
 thread_options.h |  5 +++++
 7 files changed, 58 insertions(+), 6 deletions(-)

-- 
1.8.3.1


