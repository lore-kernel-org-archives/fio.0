Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2B0U6U (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Feb 2012 15:58:20 -0500
Message-ID: <4F4BEE68.2030001@kernel.dk>
Date: Mon, 27 Feb 2012 21:58:16 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Bug with small partitions?
References: <CB6D6B02.7ADB1%ross@gridironsystems.com> <4F493E86.5080403@kernel.dk> <CAAK6Zt1iRA9NiiRVUAsvLaVbzBqEVzeAfP=UrUEf4Ese2PWBRQ@mail.gmail.com>
In-Reply-To: <CAAK6Zt1iRA9NiiRVUAsvLaVbzBqEVzeAfP=UrUEf4Ese2PWBRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: Ross Becker <ross@gridironsystems.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Nauman Rafique <nauman@google.com>, Steven Lang <tirea@google.com>

On 2012-02-27 21:56, Daniel Ehrenberg wrote:
> On Sat, Feb 25, 2012 at 12:03 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2012-02-25 01:27, Ross Becker wrote:
>>> I've found something very very odd, and I've tested it out and verified it
>>> occurs with fio 1.54, 2.0.1 and 2.0.4.
>>>
>>> Host OS is Redhat 5.7, kernel version 2.6.18-274.17.1.el5
>>>
>>> I have 12 LUNs coming across fiber channel, each with multiple paths, and
>>> dm-multipath rolling them up into devices.  I partitioned them down to 100
>>> megabytes each.  I then told fio to go do random 4k reads across the 12
>>> partitions; (/dev/mapper/somenamep1).  I had a 10 minute test specified,
>>> and what occurred was that the time for the test to run started jumping
>>> down dramatically each tick; it jumped from 10 minutes remaining to 3
>>> minutes remaining to a minute and change, down to less than a minute.  I
>>> cannot seem to get it to run for more than about 20 seconds, no matter
>>> what I specify for the test run time.  I've been testing like this using
>>> the full size of the LUNs without any trouble.  I rebooted the system,
>>> same behavior.  I created LVM volume groups and logical volumes (one
>>> logical volume per volume group per LUN partition), and the same behavior
>>> occurred against those.  It's acting as if below a certain size, fio gets
>>> confused in it's timekeeping.  I used 1 gig partitions, and everything
>>> worked normally.  Here's my fio config file that I'm getting these results
>>> with:
>>>
>>> [global]
>>> bs=4k
>>> ioengine=libaio
>>> iodepth=16
>>> openfiles=1024
>>> runtime=600
>>> ramp_time=5
>>> filename=/dev/mapper/dh0_extra_10p1:/dev/mapper/dh0_extra_11p1:/dev/mapper/
>>> dh0_extra_12p1:/dev/mapper/dh0_extra_20p1:/dev/mapper/dh0_extra_21p1:/dev/m
>>> apper/dh0_extra_22p1:/dev/mapper/dh1_extra_30p1:/dev/mapper/dh1_extra_31p1:
>>> /dev/mapper/dh1_extra_32p1:/dev/mapper/dh1_extra_40p1:/dev/mapper/dh1_extra
>>> _41p1:/dev/mapper/dh1_extra_42p1
>>>
>>>
>>>
>>> [rand-read]
>>> rw=randread
>>> numjobs=12
>>> file_service_type=random
>>> direct=1
>>> disk_util=0
>>> gtod_cpu=1
>>> norandommap=1
>>> thread
>>> group_reporting
>>
>> So I tried reproducing this, by creating 12 100MB files and using those
>> instead. The rest of the job file is the same. It seems to run as
>> expected, and the ETA looks fairly accurate given the rate of IO that
>> is going on. It shows 3min20sec from the get go, and it exits after 223
>> seconds. So not too far off.
>>
>> The primary "problem" here is that you are probably expecting the
>> runtime to be the runtime, when it is just a cap of the job. If the job
>> finishes before the specified runtime, it exits. With the bigger
>> partitions, this likely didn't happen for you. You want to add
>> time_based=1 to force fio to keep going (it essentially restarts if it
>> completes before time). If you do that, it should run the full 600
>> seconds, as specified. It does here :-)
>>
>> --
>> Jens Axboe
>>
> 
> One issue I've seen with time_based tests is that opening and closing
> the file can lead to a significant reduction in throughput. For my
> tests, I have two options: make the file very large (what I'm
> currently doing) and adding a new option to avoid opening and closing
> the file on each iteration (what I'm planning, since it doesn't always
> work to make the file larger). Are there any other recommendations? Is
> there already an option for this?

This is the same (well, related) issue that Steven pointed out. It's
definitely something that needs fixing, and I'll happily take patches...
If nothing materializes within the next few weeks, I'll take a stab at
fixing it up.

-- 
Jens Axboe

