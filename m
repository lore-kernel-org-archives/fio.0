Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot1-f52.google.com ([209.85.210.52]:36040 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgAOPu5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Jan 2020 10:50:57 -0500
Received: by mail-ot1-f52.google.com with SMTP id m2so11652008otq.3
        for <fio@vger.kernel.org>; Wed, 15 Jan 2020 07:50:57 -0800 (PST)
MIME-Version: 1.0
From: Mauricio Tavares <raubvogel@gmail.com>
Date: Wed, 15 Jan 2020 10:50:46 -0500
Message-ID: <CAHEKYV6AqY=u=PZ2EAxLwM2a3TL6ByAwTRyURA=9CA1dAtwLbw@mail.gmail.com>
Subject: CPUs, threads, and speed
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Let's say I have a config file to preload drive that looks like this
(stolen from https://github.com/intel/fiovisualizer/blob/master/Workloads/Precondition/fill_4KRandom_NVMe.ini)

[global]
name=4k random write 4 ios in the queue in 32 queues
filename=/dev/nvme0n1
ioengine=libaio
direct=1
bs=4k
rw=randwrite
iodepth=4
numjobs=32
buffered=0
size=100%
loops=2
randrepeat=0
norandommap
refill_buffers

[job1]

That is taking a ton of time, like days to go. Is there anything I can
do to speed it up? For instance, what is the default value for
cpus_allowed (or cpumask)[2]? Is it all CPUs? If not what would I gain
by throwing more cpus at the problem?

I also read[2] by default fio uses fork. What would I get by going to threads?

[2] https://fio.readthedocs.io/en/latest/fio_doc.html#threads-processes-and-job-synchronization

