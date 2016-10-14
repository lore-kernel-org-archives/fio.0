Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36589 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbcJNTJ5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Oct 2016 15:09:57 -0400
Received: by mail-oi0-f51.google.com with SMTP id m72so147826527oik.3
        for <fio@vger.kernel.org>; Fri, 14 Oct 2016 12:09:56 -0700 (PDT)
MIME-Version: 1.0
From: Tarek <cashew250@gmail.com>
Date: Fri, 14 Oct 2016 14:09:55 -0500
Message-ID: <CAOHuL9jnXcN4Tn5ri6WWtWXmH7HbV2TB20VDe1vAZ1ca7NMoHA@mail.gmail.com>
Subject: Fio Multiple Nvme Disks
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I want to run Fio on 10 NVME drive sending each iodepth of 128, having the
results combined as an aggregate result, and also have logging every
1000ms for BW and IO. I did the following below, combining all drives in
one 'filename' separated by colon under global, then set my job below.
However, I don't think it's doing what I intended and sending each drive
128 iodepth. How can I achieve what I am after?

Example of what I was doing
Example below: 10 NVME drives are each getting iodepth of 128, or just
12.8 (roughly)?
[global]
thread
ioengine=libaio
direct=1
buffered=0
log_avg_msec=1000
group_reporting=1
filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1:/dev/nvme4n1:
/dev/nvme5n1:/dev/nvme6n1:/dev/nvme7n1:/dev/nvme8n1:/dev/nvme9n1

[sequential-write_4k_qd128_jobs_1]
description=Sequential write precondition
rw=write
bs=4k
iodepth=128
numjobs=1
size=100%
stonewall

thank you
