Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34634 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbcJOBEY (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Oct 2016 21:04:24 -0400
Received: by mail-io0-f179.google.com with SMTP id r30so138167031ioi.1
        for <fio@vger.kernel.org>; Fri, 14 Oct 2016 18:03:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOHuL9jnXcN4Tn5ri6WWtWXmH7HbV2TB20VDe1vAZ1ca7NMoHA@mail.gmail.com>
References: <CAOHuL9jnXcN4Tn5ri6WWtWXmH7HbV2TB20VDe1vAZ1ca7NMoHA@mail.gmail.com>
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Fri, 14 Oct 2016 18:03:45 -0700
Message-ID: <CAF+0mvmERxKpo0BBxbjb5NeM8FbY10ESAnmuHmYp0gyZUKjaOg@mail.gmail.com>
Subject: Re: Fio Multiple Nvme Disks
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tarek <cashew250@gmail.com>
Cc: fio@vger.kernel.org

On Fri, Oct 14, 2016 at 12:09 PM, Tarek <cashew250@gmail.com> wrote:
> I want to run Fio on 10 NVME drive sending each iodepth of 128, having the
> results combined as an aggregate result, and also have logging every
> 1000ms for BW and IO. I did the following below, combining all drives in
> one 'filename' separated by colon under global, then set my job below.
> However, I don't think it's doing what I intended and sending each drive
> 128 iodepth. How can I achieve what I am after?
>
> Example of what I was doing
> Example below: 10 NVME drives are each getting iodepth of 128, or just
> 12.8 (roughly)?
> [global]
> thread
> ioengine=libaio
> direct=1
> buffered=0
> log_avg_msec=1000
> group_reporting=1
> filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1:/dev/nvme4n1:
> /dev/nvme5n1:/dev/nvme6n1:/dev/nvme7n1:/dev/nvme8n1:/dev/nvme9n1
>
> [sequential-write_4k_qd128_jobs_1]
> description=Sequential write precondition
> rw=write
> bs=4k
> iodepth=128
> numjobs=1
> size=100%
> stonewall
>
> thank you
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

For testing multiple devices I usually create a new job per device, in
your case:

[global]
thread
ioengine=libaio
direct=1
buffered=0
log_avg_msec=1000
group_reporting=1
rw=write
bs=4k
iodepth=128
numjobs=1
size=100%

[job1]
filename=/dev/nvme0n1

[job2]
filename=/dev/nvme1n1

[job3]
filename=/dev/nvme2n1
...

Fio will write logs per job but you might use the fiologparser script
to get what you want:

# fiologparser.py
#
# This tool lets you parse multiple fio log files and look at interaval
# statistics even when samples are non-uniform. For instance:
#
# fiologparser.py -s *bw*
#
# to see per-interval sums for all bandwidth logs or:
#
# fiologparser.py -a *clat*
#
# to see per-interval average completion latency.
