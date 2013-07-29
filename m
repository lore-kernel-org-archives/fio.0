Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33232 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3G2JYT (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 29 Jul 2013 05:24:19 -0400
Received: by mail-wi0-f174.google.com with SMTP id j17so2215477wiw.1
        for <fio@vger.kernel.org>; Mon, 29 Jul 2013 02:24:17 -0700 (PDT)
MIME-Version: 1.0
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Mon, 29 Jul 2013 10:23:57 +0100
Message-ID: <CANUChTzeeq2c9kjZAsfLH2JFx+ruWMnA7XnsWsCUdzg58OQm+A@mail.gmail.com>
Subject: bs_is_seq_rand starts new offset for sequential for every random io
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens,

Playing with the new feature you have added, bs_is_seq_rand along with
rwmixread and percentage_random has allowed me to specify sequential
writes and random reads in one job, but I have noticed that the random
reads sets a new offset for the sequential part of the workload.
For example;

Seq Write LBA 1
Seq Write LBA 2
Seq Write LBA 3
Rnd Read LBA 10
Seq Write LBA 11
Seq Write LBA 12
etc.

Would it be possible to get the sequential workload to continue from
where it left off?

So for example in the above sequence it would go:

Seq Write LBA 1
Seq Write LBA 2
Seq Write LBA 3
Rnd Read LBA 10
Seq Write LBA 4
Seq Write LBA 5
etc.

Jobfile below for those interested;

; Large Sequential Writes (1MB) with Small Random Reads (4KB)
[global]
direct=1
ioengine=libaio
filename=/dev/sdb
runtime=30s
ramp_time=10s
bs_is_seq_rand=1

[1MB Writes, 4K Reads]
rw=randrw
bs=1M,4K
iodepth=4
rwmixread=1
percentage_random=100,0

Thanks,
Gavin

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------
