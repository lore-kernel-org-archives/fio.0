Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.hig.no ([128.39.41.135]:47869 "EHLO smtp.hig.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280AbcDDLQN (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 4 Apr 2016 07:16:13 -0400
From: Mihkal Dunfjeld <mihkal.dunfjeld@stud.ntnu.no>
Subject: Missing log entries and other questions
Message-ID: <57024B1A.10808@stud.ntnu.no>
Date: Mon, 4 Apr 2016 13:08:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: birger.lunstoeng@stud.ntnu.no

Hello fio team!

We are a group of three students that are writing a bachelor thesis at
NTNU Gjøvik Norway about Ceph and we are trying to measure its
performance using the great tool Fio. During our testing we find that
for 16 job write runs, the amount of lines in our logs falls
significantly below what we expect for a test set to run for 120 seconds.

Example: 4 jobs, 8 QD, random write
sudo fio --filename=/dev/rbd0 --direct=1 --rw=randwrite --refill_buffers
--norandommap --randrepeat=0 --ioengine=libaio --bs=4k --iodepth=8
--numjobs=4 --runtime=120 --log_avg_msec=1000
--write_iops_log=fsrandW4-8-iopslog --group_reporting --ramp_time=60
--name=fsrandW4-8 --output=fsrandW4-8

For this test we are missing 23% of the log entries. Got 369/480 (120
sec times 4 jobs).
Raw data file: http://pastebin.com/CeXa61MF
This gets worse with higher load. On 16 jobs 64 QD runs, more than 50%
of the log entries are missing.
The tests are run from a HP DL380G6 with 2x Xeon X5560 @ 2.8 Ghz, 12 GB
ECC RAM running Ubuntu Server 14.04. Tested with both the Ubuntu
repository version and the latest version compiled from github. We also
tried to output the log files to tempfs without that making much of a
difference.

Because of this we have a few questions:

1. What causes fio to not be able to write a new line to the 	
Write_iops_log file at the set interval? (log_avg_msec=1000).  We see up
to several seconds of delay (See above pastebin).

2. Does fio write to the write_iops_log file even if iops is zero? For
instance if cluster performance is really bad.

3. The iops-number that Fio writes to the log, is that the number of I/O
operations since the last line in the log, or the number of operations
during the time specified with iopsavgtime, or just a snapshot of the
current number of operations at the time of writing to the log?

4. Does the operation to write to the log enter the same I/O queue as
the jobs/QD Fio uses? This is not directly a Fio question, but maybe
someone knows. I suppose we really ought to know this ourselves, but
sadly do not.

5. The average IOPS number that Fio reports for a run, how is that
calculated? We see an at times significant disparity between our own
calculation from the raw data log (--write_iops_log) and the standard
--output. Our average is always higher when we calculate the iopslog
like this: http://pastebin.com/ZY3hNWh3

There may be simple explanation for all of this, but we are
unfortunately unable to see it.

Any help would be much appreciated.

Regards,
Birger, Mihkal, Øyvind
