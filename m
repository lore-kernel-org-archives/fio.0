Return-Path: <fio-owner@vger.kernel.org>
Received: from fed1rmfepi201.cox.net ([68.230.241.140]:53709 "EHLO
	fed1rmfepi201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcDZCbl convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 25 Apr 2016 22:31:41 -0400
Received: from fed1rmimpo210.cox.net ([68.230.241.161])
          by fed1rmfepo201.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20160426022206.DRVH5597.fed1rmfepo201.cox.net@fed1rmimpo210.cox.net>
          for <fio@vger.kernel.org>; Mon, 25 Apr 2016 22:22:06 -0400
From: "Paul Alcorn" <paullie1@cox.net>
References: <eBGJ1s00E1TeosZ01BGKGG>
In-Reply-To: <eBGJ1s00E1TeosZ01BGKGG>
Subject: RE: Missing log entries and other questions
Date: Mon, 25 Apr 2016 21:22:11 -0500
Message-ID: <036a01d19f62$717af530$5470df90$@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Mihkal Dunfjeld' <mihkal.dunfjeld@stud.ntnu.no>, fio@vger.kernel.org
Cc: birger.lunstoeng@stud.ntnu.no

I have also encountered this problem, it is very severe with SATA HDDs, and also is prevalent with SATA SSDs as well. In Centos 7 with the latest fio version it is very bad. The only two variables that seem to remain the same are with SATA drives and with slow devices. Perhaps the perception that it is with slow devices is merely because they are SATA, but the exact same configurations with PCIe SSDs never experience skipped log entries. 

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Mihkal Dunfjeld
Sent: Monday, April 4, 2016 6:08 AM
To: fio@vger.kernel.org
Cc: birger.lunstoeng@stud.ntnu.no
Subject: Missing log entries and other questions

Hello fio team!

We are a group of three students that are writing a bachelor thesis at NTNU Gjøvik Norway about Ceph and we are trying to measure its performance using the great tool Fio. During our testing we find that for 16 job write runs, the amount of lines in our logs falls significantly below what we expect for a test set to run for 120 seconds.

Example: 4 jobs, 8 QD, random write
sudo fio --filename=/dev/rbd0 --direct=1 --rw=randwrite --refill_buffers --norandommap --randrepeat=0 --ioengine=libaio --bs=4k --iodepth=8
--numjobs=4 --runtime=120 --log_avg_msec=1000 --write_iops_log=fsrandW4-8-iopslog --group_reporting --ramp_time=60
--name=fsrandW4-8 --output=fsrandW4-8

For this test we are missing 23% of the log entries. Got 369/480 (120 sec times 4 jobs).
Raw data file: http://pastebin.com/CeXa61MF This gets worse with higher load. On 16 jobs 64 QD runs, more than 50% of the log entries are missing.
The tests are run from a HP DL380G6 with 2x Xeon X5560 @ 2.8 Ghz, 12 GB ECC RAM running Ubuntu Server 14.04. Tested with both the Ubuntu repository version and the latest version compiled from github. We also tried to output the log files to tempfs without that making much of a difference.

Because of this we have a few questions:

1. What causes fio to not be able to write a new line to the 	
Write_iops_log file at the set interval? (log_avg_msec=1000).  We see up to several seconds of delay (See above pastebin).

2. Does fio write to the write_iops_log file even if iops is zero? For instance if cluster performance is really bad.

3. The iops-number that Fio writes to the log, is that the number of I/O operations since the last line in the log, or the number of operations during the time specified with iopsavgtime, or just a snapshot of the current number of operations at the time of writing to the log?

4. Does the operation to write to the log enter the same I/O queue as the jobs/QD Fio uses? This is not directly a Fio question, but maybe someone knows. I suppose we really ought to know this ourselves, but sadly do not.

5. The average IOPS number that Fio reports for a run, how is that calculated? We see an at times significant disparity between our own calculation from the raw data log (--write_iops_log) and the standard --output. Our average is always higher when we calculate the iopslog like this: http://pastebin.com/ZY3hNWh3

There may be simple explanation for all of this, but we are unfortunately unable to see it.

Any help would be much appreciated.

Regards,
Birger, Mihkal, Øyvind
--
To unsubscribe from this list: send the line "unsubscribe fio" in the body of a message to mailto:majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

