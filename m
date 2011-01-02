Return-Path: <fio-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:49704 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1ABENG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 1 Jan 2011 23:13:06 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NW4WZY1400NG6DQ3@mx.isti.cnr.it> for
 fio@vger.kernel.org; Sun, 02 Jan 2011 05:12:00 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NW4WZXD8Z4NG6FAP@mx.isti.cnr.it> for
 fio@vger.kernel.org; Sun, 02 Jan 2011 05:11:59 +0100 (MET)
Received: from [10.0.0.61]
 (dynamic-adsl-78-12-75-177.clienti.tiscali.it [78.12.75.177])
 by mx.isti.cnr.it (PMDF V6.5-x5 #31826)
 with ESMTPSA id <01NW4WZWLOGUNV288K@mx.isti.cnr.it> for fio@vger.kernel.org;
 Sun, 02 Jan 2011 05:11:58 +0100 (MET)
Date: Sun, 02 Jan 2011 05:12:11 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Again on IOPS higher than expected in randwrite 4k
Message-id: <4D1FFB1B.1010000@shiftmail.org>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello, I just subscribed, I noticed that some 20 days ago there was a 
thread on "IOPS higher than expected on randwrite, direct=1 tests" on 
this ML.
It's curious because I subscribed to report basically the same thing.

With Hitachi 7k1000 HDS721010KLA330 (maybe the same drives as Sebastian) 
I am seeing the same problem of IOPS too high with FIO, up to 300 IOPS 
per disk (up to 500 per disk with storsave=performance on my 3ware but 
that's probably cheating). I am doing 4k random writes.

I followed the discussion, I don't really agree with the point at the 
end of the discussion, so I'd like to bump this thread again.

My impression is that these drives do not honor the flush or FUA. 
(Directio uses flush or FUA right? you can be sure that data is on the 
platters after directio right? Anyway I also set fsync=1 and nothing 
changed)

I think that on 4k random writes with 1 thread, iodepth=1, NCQ disabled 
via echo 1 > queue_depth, there really should be no reason for IOPS to 
be higher when write cache enabled compared to write cache disabled (in 
fact 300 IOPS vs 70 IOPS in my tests).  What do you think?

I think the drive returns immediately saying "yes, I did that, data is 
on the platters" and instead data is on the write cache, so that the 
drives it can write it on the platters in an optimized way doing both 
elevator-like and ncq-like optimizations, which clearly raises IOPS a 
lot but is not safe.

Me too I can obtain 300 IOPS only with short seeks, but please consider:
- due to rotational latency, with a 7200 RPM, sequential, ncq disabled, 
fsync=1, drive IOPS can never be higher than 240, not by a tiny bit, 
even on short seeks, and it will actually be much lower as that's ideal 
and doesn't take into consideration the seek time, data transfer time 
via SAS cables, or any overhead of the drive itself
- I don't see it strange that there is difference in IOPS between short 
seeks tests and long seeks tests even with my assumption of fake 
flush/FUA. The drive still reorders writes with elevator-like and 
ncq-like optimizations, but every write takes more due to the seeks.

I'd like to know how it goes with other brands of drives, possibly 
"raid-class enterprise-class drives"?

Thanks for your opinions
