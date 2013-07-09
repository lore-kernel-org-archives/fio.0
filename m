Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:53887 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3GIRbz (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Jul 2013 13:31:55 -0400
Received: by mail-we0-f181.google.com with SMTP id p58so4809514wes.26
        for <fio@vger.kernel.org>; Tue, 09 Jul 2013 10:31:54 -0700 (PDT)
MIME-Version: 1.0
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Tue, 9 Jul 2013 18:31:34 +0100
Message-ID: <CANUChTxLS6NVoCSSkTDnrm2m6otLX_OMzcWkqRaOqj2qLqO6yA@mail.gmail.com>
Subject: Large Seq Write interspersed with Small Rnd Read
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens & Group,

I've got an interesting one here and am wondering if there is a better
way to run this.

I'm trying to run a particular benchmark for HDD's and need to run
large sequential writes (1M) and intersperse it with small random
reads (4K).  I don't think I can run this within a single job, as even
though I could specify read/write mix (rwmixread) and specify
sequential/random mix (percentage_random), I am unable to guarantee
that the reads are in fact random.

So this is my jobfile (fio 2.1);

[global]
direct=1
ioengine=libaio
filename=/dev/sdb
runtime=30s

[Writes]
rw=write
bs=1M
iodepth=3
flow=-1

[Reads]
rw=randread
bs=4K
iodepth=2
flow=30

As you can see I'm using the flow= argument, and I think it is working
correctly, rough ratio of 1:30, or 3 percent reads.

One thing that I can't see and it would be good (and a way to prove
the randomness of the random reads) is a log file that contains both
writes and reads in the order they are processed. I can use the
write_iolog= argument, but if I place it in global it seems to record
all the writes close and reopen the file and then the reads so I am
unable to match up the actual sequence of writes/reads, is there an
argument that will do this that I'm missing?

Has anybody done anything similar to this to see the impact on large
sequential writes?  Or see a better way to run this?

Thanks,
Gavin

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------
