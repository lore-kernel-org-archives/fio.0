Return-Path: <dennisszhou@gmail.com>
Return-Path: <dennisszhou@gmail.com>
From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 0/4] add option to interleave blktraces
Date: Wed, 19 Sep 2018 14:25:28 -0400
Message-Id: <20180919182532.8405-1-dennis@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com, Dennis Zhou <dennis@kernel.org>
List-ID: <fio@vger.kernel.org>

Hi everyone,

Understanding how a workload performs on different devices has been
nice and easy given the infrastructure around blktrace, blkparse, and
fio. Given a blktrace, fio can rerun that workload on a different drive.

Exploring colocation is a little tricker, but doable via adding multiple
jobs in fio. An issue here is that the scheduler can influence the
performance of each run as each job is async.

This patchset adds the ability to pass multiple blktrace binary dumps to
"--read_iolog" as colon separated paths and then performs simple
timestamp merging between the traces. Two additional parameters are
added, "--merge_blktrace_scalars" and "--merge_blktrace_iters", to allow
for scaling a particular trace and adjusting the number of iterations
respectively.

In an example, given two 60s blktraces, A and B. Imagine we want to see
how trace A would perform if we slowed it down by 50%. We can experiment
here with --merge_blktrace_scalars="200:100" and
--merge_blktrace_iters="1:2". This says to run the first blktrace over
200% of the time and the second at 100% running the first for a single
iteration and the second for 2 iterations. This puts the overall runtime
at 120s for each trace.

This patchset includes the following 4 patches:
  0001-options-rename-name-string-operations-for-more-gener.patch
  0002-blktrace-add-support-to-interleave-blktrace-files.patch
  0003-blktrace-add-option-to-scale-a-trace.patch
  0004-blktrace-add-option-to-iterate-over-a-trace-multiple.patch

0001 renames some string parsing functions to be more generic.
0002 adds basic merging support. 0003 adds merge_blktrace_scalars.
0004 adds merge_blktrace_iters.

diffstats below:

Dennis Zhou (4):
  options: rename name string operations for more general use
  blktrace: add support to interleave blktrace files
  blktrace: add option to scale a trace
  blktrace: add option to iterate over a trace multiple times

 blktrace.c       | 210 +++++++++++++++++++++++++++++++++++++++++++++++
 blktrace.h       |  17 ++++
 init.c           |  20 +++++
 options.c        |  47 +++++++++--
 options.h        |   2 +
 thread_options.h |   3 +
 6 files changed, 290 insertions(+), 9 deletions(-)

Thanks,
Dennis

