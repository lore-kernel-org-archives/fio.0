Return-Path: <glqinhongwei@gmail.com>
Return-Path: <glqinhongwei@gmail.com>
From: Hongwei Qin <glqinhongwei@gmail.com>
Subject: [PATCH v3 0/2] Add a new parameter and fix minimal rate calculation.
Date: Mon, 18 Jan 2021 13:19:53 +0800
Message-Id: <cover.1610946213.git.glqinhongwei@gmail.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, sitsofe@gmail.com, Hongwei Qin <glqinhongwei@gmail.com>
List-ID: <fio@vger.kernel.org>

The first patch adds a new parameter thinktime_blocks_type to control
the behavior of thinktime_blocks. It can be either `complete`
or `issue`.
If it is `complete` (default), fio triggers thinktime when
thinktime_blocks number of blocks are **completed**.
If it is `issue`, fio triggers thinktime when thinktime_blocks
number of blocks are **issued**

The second patch updates the compare time if handle_thinktime
sleeps or spin.

I bring the test results from the first patch to here
for your convenience:

Tests:
jobfile1:
```
[global]
thread
kb_base=1000
direct=1
size=1GiB
group_reporting
io_size=96KiB
ioengine=libaio
iodepth=8
bs=4096
filename=/dev/qblkdev
rw=randwrite

[fio_randwrite]
thinktime=2s
thinktime_blocks=4
```

jobfile2:
```
[global]
thread
kb_base=1000
direct=1
size=1GiB
group_reporting
io_size=96KiB
ioengine=libaio
iodepth=8
bs=4096
filename=/dev/qblkdev
rw=randwrite

[fio_randwrite]
thinktime=2s
thinktime_blocks=4
thinktime_blocks_type=issue
```

Results:
Current HEAD:
fio jobfile1:
	write: IOPS=5, BW=24.6kB/s (24.0KiB/s)(98.3kB/4002msec); 0 zone resets

	- issue 11 requests
	- sleep 2s
	- issue 8 requests
	- sleep 2s
	- issue 5 requests
	- finish

This patch:
fio jobfile1:
	write: IOPS=5, BW=24.6kB/s (24.0KiB/s)(98.3kB/4001msec); 0 zone resets

	- issue 11 requests
        - sleep 2s
        - issue 8 requests
        - sleep 2s
        - issue 5 requests
        - finish

fio jobfile2:
	write: IOPS=1, BW=8191B/s (8191B/s)(98.3kB/12001msec); 0 zone resets

	- issue 4 requests
	- sleep 2s
	***
	- issue 4 requests
	- sleep 2s
	- finish


Hongwei Qin (2):
  Add a new parameter.
  Calculate min_rate with the consideration of thinktime

 HOWTO            |  7 +++++++
 backend.c        | 22 ++++++++++++++++------
 cconv.c          |  2 ++
 engines/cpu.c    |  1 +
 fio.h            |  5 +++++
 options.c        | 22 ++++++++++++++++++++++
 thread_options.h |  2 ++
 7 files changed, 55 insertions(+), 6 deletions(-)

-- 
1.8.3.1


