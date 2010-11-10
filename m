Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:33844 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab0KJTvy (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 10 Nov 2010 14:51:54 -0500
Message-ID: <4CDAF7D0.4080709@fusionio.com>
Date: Wed, 10 Nov 2010 20:51:44 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
References: <20101109182801.GP15588@sebastiankayser.de> <AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com> <20101110082223.GB14261@sebastiankayser.de> <4CDAA783.9050902@fusionio.com> <20101110171856.GI28050@sebastiankayser.de> <20101110185826.GJ28050@sebastiankayser.de>
In-Reply-To: <20101110185826.GJ28050@sebastiankayser.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: fio@vger.kernel.org

On 2010-11-10 19:58, Sebastian Kayser wrote:
> * Sebastian Kayser <sebastian@skayser.de> wrote:
>> What I will do now is to export the whole 2TB of the disk (instead of
>> just 10GB) and increase size= to see whether that makes any difference
>> (hopefully). Other than that, further ideas?
> 
> Interim update. Exported the whole 2TB disk as a LUN, mkfs.ext3'd it and
> set size=100g in fio's configuration. Also set runtime=1800, re-started
> the test and could observe ~80 IOPS ... my dear heart was jumping with
> joy :)
> 
> However, a few minutes into the test, IOPS started to increase steadily
> and by now have again reached (non-bursty) regions that don't seem
> plausible for a single 7.2K SATA disk.
> 
> root@ubuntu-804-x64:~# ./fio --section=iscsi patterns.fio 
> iscsi: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> Starting 1 process
> iscsi: Laying out IO file(s) (1 file(s) / 102400MB)
> Jobs: 1 (f=1): [w] [48.4% done] [0K/986K /s] [0/240 iops] [eta 15m:28s] 

A 7200RPM drive will spin around 120 times per second, that yields an
average rotational latency of 8.3 msecs. For truly random IO, rotational
latency will dominate the seek and the average wait-for-platter-spin
will be half that, so 4.17 msecs. That gives us about 240 IOPS.

So your results don't seem all that out of whack. What are your reasons
for expecting ~80 IOPS?

-- 
Jens Axboe

