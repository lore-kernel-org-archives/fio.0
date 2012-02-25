Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57523 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2BYUDV (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 25 Feb 2012 15:03:21 -0500
Message-ID: <4F493E86.5080403@kernel.dk>
Date: Sat, 25 Feb 2012 21:03:18 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Bug with small partitions?
References: <CB6D6B02.7ADB1%ross@gridironsystems.com>
In-Reply-To: <CB6D6B02.7ADB1%ross@gridironsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ross Becker <ross@gridironsystems.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-02-25 01:27, Ross Becker wrote:
> I've found something very very odd, and I've tested it out and verified it
> occurs with fio 1.54, 2.0.1 and 2.0.4.
> 
> Host OS is Redhat 5.7, kernel version 2.6.18-274.17.1.el5
> 
> I have 12 LUNs coming across fiber channel, each with multiple paths, and
> dm-multipath rolling them up into devices.  I partitioned them down to 100
> megabytes each.  I then told fio to go do random 4k reads across the 12
> partitions; (/dev/mapper/somenamep1).  I had a 10 minute test specified,
> and what occurred was that the time for the test to run started jumping
> down dramatically each tick; it jumped from 10 minutes remaining to 3
> minutes remaining to a minute and change, down to less than a minute.  I
> cannot seem to get it to run for more than about 20 seconds, no matter
> what I specify for the test run time.  I've been testing like this using
> the full size of the LUNs without any trouble.  I rebooted the system,
> same behavior.  I created LVM volume groups and logical volumes (one
> logical volume per volume group per LUN partition), and the same behavior
> occurred against those.  It's acting as if below a certain size, fio gets
> confused in it's timekeeping.  I used 1 gig partitions, and everything
> worked normally.  Here's my fio config file that I'm getting these results
> with:
> 
> [global]
> bs=4k
> ioengine=libaio
> iodepth=16
> openfiles=1024
> runtime=600
> ramp_time=5
> filename=/dev/mapper/dh0_extra_10p1:/dev/mapper/dh0_extra_11p1:/dev/mapper/
> dh0_extra_12p1:/dev/mapper/dh0_extra_20p1:/dev/mapper/dh0_extra_21p1:/dev/m
> apper/dh0_extra_22p1:/dev/mapper/dh1_extra_30p1:/dev/mapper/dh1_extra_31p1:
> /dev/mapper/dh1_extra_32p1:/dev/mapper/dh1_extra_40p1:/dev/mapper/dh1_extra
> _41p1:/dev/mapper/dh1_extra_42p1
> 
> 
> 
> [rand-read]
> rw=randread
> numjobs=12
> file_service_type=random
> direct=1
> disk_util=0
> gtod_cpu=1
> norandommap=1
> thread
> group_reporting

So I tried reproducing this, by creating 12 100MB files and using those
instead. The rest of the job file is the same. It seems to run as
expected, and the ETA looks fairly accurate given the rate of IO that
is going on. It shows 3min20sec from the get go, and it exits after 223
seconds. So not too far off.

The primary "problem" here is that you are probably expecting the
runtime to be the runtime, when it is just a cap of the job. If the job
finishes before the specified runtime, it exits. With the bigger
partitions, this likely didn't happen for you. You want to add
time_based=1 to force fio to keep going (it essentially restarts if it
completes before time). If you do that, it should run the full 600
seconds, as specified. It does here :-)

-- 
Jens Axboe

