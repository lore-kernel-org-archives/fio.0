Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:56817 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab3BVLqc (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 Feb 2013 06:46:32 -0500
Received: by mail-we0-f176.google.com with SMTP id s43so457199wey.35
        for <fio@vger.kernel.org>; Fri, 22 Feb 2013 03:46:31 -0800 (PST)
MIME-Version: 1.0
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Fri, 22 Feb 2013 11:46:10 +0000
Message-ID: <CANUChTyH7CxuKJMevxQpVu6d4M9bn17XUpshyjGEfsoHo6LQ9w@mail.gmail.com>
Subject: Looping jobs from within the jobfile
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm trying to understand the "loops" feature.

I have jobfile that I would like to loop round a number of times:-

{jobfile.fio}
[global]
ioengine=libaio
direct=1

[job1]
rw=randrw
rwmixread=70
bsrange=4k-128k
iodepth=4
runtime=3m
filename=/dev/sdm
size=4G
time_based
offset=0

[job2]
stonewall
rw=write
bs=512K
size=12G
filename=/dev/sdm
iodepth=1
timeout=5m
offset=20G
{/jobfile.fio}

So above I have a random read/write section followed by a sequential
write section.  I would like to loop round this for x number of times,
for example randrw, seqw, randrw, seqw, randrw, etc.  I've tried using
the "loops=x" option in the global section, but all this does is loop
each job before moving onto the next, at the moment it does randrw,
randrw, seqw, seqw.

Along with the above I was hoping that with the run status group
report at the end of the run, it would give the average of each of
those runs with the received min and max values:-

Run status group 1 (all jobs):
  WRITE: io=8192.0MB, aggrb=56333KB/s, minb=56333KB/s, maxb=56333KB/s,
mint=148909msec, maxt=148909msec

but at the moment the "minb" and "maxb" have the same values.  Ideally
it would give the max and min values for each of those loops of that
particular job, along with the average.

Is this possible from within the jobfile?

Thanks,
Gavin

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------
