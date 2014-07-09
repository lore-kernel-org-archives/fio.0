Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:54604 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaGIW4g convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 9 Jul 2014 18:56:36 -0400
Received: by mail-oa0-f52.google.com with SMTP id j17so8872484oag.39
        for <fio@vger.kernel.org>; Wed, 09 Jul 2014 15:56:35 -0700 (PDT)
MIME-Version: 1.0
From: Michael Mattsson <michael.mattsson@gmail.com>
Date: Wed, 9 Jul 2014 15:56:15 -0700
Message-ID: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>
Subject: fio hangs with --status-interval
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hey,
I've got 8 identical CentOS 6.5 clients that randomly keeps hanging
fio when using --status-interval. I've tried fio 2.1.4 and fio 2.1.10
they both behave the same. I've also tried piping the output to tee
instead of redirecting to a file. I also tried --output and specified
output file, still same problem. My fio command runs through its tests
flawlessly without --status-interval and exits cleanly every time.
There could be anywhere from 0 to 5 clients that gets affected.
Running strace on the process that seem hung yields the following
output:

$ strace -p 31055
Process 31055 attached - interrupt to quit
futex(0x7f346ede802c, FUTEX_WAIT, 1, NULL

It will sit there forever. Excuse the splurge but this is the command
(run 8 clients simultaneously where /fut1 and /fut2 is on shared
storage (NFSv3)):

$ fio --minimal --direct=1 --group_reporting --filesize=64m
--norandommap --blocksize=4k --time_based --iodepth=1 --ramp_time=15
--ioengine=libaio --status-interval=5 --name=mytest-foo --rw=randread
--numjobs=64 --filename=/fut1/6of4_1:/fut2/6of4_1:/fut1/6of4_2:/fut2/6of4_2:/fut1/6of4_3:/fut2/6of4_3:/fut1/6of4_4:/fut2/6of4_4:/fut1/6of4_5:/fut2/6of4_5:/fut1/6of4_6:/fut2/6of4_6:/fut1/6of4_7:/fut2/6of4_7:/fut1/6of4_8:/fut2/6of4_8:/fut1/6of4_9:/fut2/6of4_9:/fut1/6of4_10:/fut2/6of4_10:/fut1/6of4_11:/fut2/6of4_11:/fut1/6of4_12:/fut2/6of4_12:/fut1/6of4_13:/fut2/6of4_13:/fut1/6of4_14:/fut2/6of4_14:/fut1/6of4_15:/fut2/6of4_15:/fut1/6of4_16:/fut2/6of4_16:/fut1/6of4_17:/fut2/6of4_17:/fut1/6of4_18:/fut2/6of4_18:/fut1/6of4_19:/fut2/6of4_19:/fut1/6of4_20:/fut2/6of4_20:/fut1/6of4_21:/fut2/6of4_21:/fut1/6of4_22:/fut2/6of4_22:/fut1/6of4_23:/fut2/6of4_23:/fut1/6of4_24:/fut2/6of4_24:/fut1/6of4_25:/fut2/6of4_25:/fut1/6of4_26:/fut2/6of4_26:/fut1/6of4_27:/fut2/6of4_27:/fut1/6of4_28:/fut2/6of4_28:/fut1/6of4_29:/fut2/6of4_29:/fut1/6of4_30:/fut2/6of4_30:/fut1/6of4_31:/fut2/6of4_31:/fut1/6of4_32:/fut2/6of4_32
--runtime=60

Worth noting is that the output file is redirected to shared storage
(NFSv4) on a different system than the one under test.

These are the fio 2.1.4 compile options:
$ ./configure
Operating system              Linux
CPU                           x86_64
Big endian                    no
Compiler                      gcc
Cross compile                 no

Wordsize                      64
zlib                          no
Linux AIO support             yes
POSIX AIO support             yes
POSIX AIO support needs -lrt  yes
POSIX AIO fsync               yes
Solaris AIO support           no
__sync_fetch_and_add          yes
libverbs                      no
rdmacm                        no
Linux fallocate               yes
POSIX fadvise                 yes
POSIX fallocate               yes
sched_setaffinity(3 arg)      yes
sched_setaffinity(2 arg)      no
clock_gettime                 yes
CLOCK_MONOTONIC               yes
CLOCK_MONOTONIC_PRECISE       no
gettimeofday                  yes
fdatasync                     yes
sync_file_range               yes
EXT4 move extent              yes
Linux splice(2)               yes
GUASI                         no
Fusion-io atomic engine       no
libnuma                       no
strsep                        yes
strcasestr                    yes
getopt_long_only()            yes
inet_aton                     yes
socklen_t                     yes
__thread                      yes
gtk 2.18 or higher            no
RUSAGE_THREAD                 yes
SCHED_IDLE                    yes
TCP_NODELAY                   yes
RLIMIT_MEMLOCK                yes
pwritev/preadv                yes

Regards
Michael
