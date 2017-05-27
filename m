Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:36473 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbdE0Gis (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 May 2017 02:38:48 -0400
Received: by mail-ua0-f177.google.com with SMTP id j17so15582023uag.3
        for <fio@vger.kernel.org>; Fri, 26 May 2017 23:38:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <MWHPR12MB16488DDE399E6157B36217EEF1FF0@MWHPR12MB1648.namprd12.prod.outlook.com>
References: <MWHPR12MB16488DDE399E6157B36217EEF1FF0@MWHPR12MB1648.namprd12.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 27 May 2017 07:38:16 +0100
Message-ID: <CALjAwxj-k_QPWp2ULyVSEScNQNgc-cBZMz38RC5R4HiEKRv0jw@mail.gmail.com>
Subject: Re: Running multiple jobs on a raw drive
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ratn, Prasun" <Prasun.Ratn@amd.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 25 May 2017 at 18:15, Ratn, Prasun <Prasun.Ratn@amd.com> wrote:
>
> I am trying to run fio on a raw NVMe drive using 2 jobs with QD=4.
>
> I am not sure how to specify the offsets for each job to write to. I tried using offset_increment but that doesn't seem to work.
>
> The first run with 1 job runs smoothly.
>
>         $ sudo fio --rw=randwrite --bs=4k --name=/dev/nvme0n1 --runtime=10 --direct=1 --ioengine=libaio --iodepth=4
[...]
>
> When I try specifying numjobs=2 with offset_increment, I get an error and only 1 process is launched.
>
>
>         $ sudo fio --rw=randwrite --bs=4k --name=/dev/nvme0n1 --runtime=10 --direct=1 --ioengine=libaio --iodepth=4 --numjobs=2 --offset_increment=81920m
>         /dev/nvme0n1: (g=0): rw=randwrite, bs=4k-4k/4k-4k/4k-4k, ioengine=libaio, iodepth=4
>         ...
>         fio-2.2.8
>         starting 2 processes
>         /dev/nvme0n1: you need to specify size=
>         fio: pid=0, err=22/file:filesetup.c:802, func=total_file_size, error=invalid argument
>         ^cbs: 1 (f=1): [w(1),x(1)] [54.5% done] [0kb/510.2mb/0kb /s] [0/131k/0 iops] [eta 00m:05s]
>         fio: terminating on signal 2
>
> What's the best way to have multiple jobs run on a single raw drive.

Because you don't want fio to "invent" the name of the file you are
are doing I/O to you're better off using a filename job parameter and
then the name of your job can be whatever you like e.g.

fio --rw=randwrite --bs=4k --filename=/dev/nvme0n1 --runtime=10
--direct=1 --ioengine=libaio --iodepth=4 --numjobs=2
--offset_increment=81920m --name=randomwrites

(all the job parameters were global) or

fio --rw=randwrite --bs=4k --name=randomwrites --filename=/dev/nvme0n1
--runtime=10 --direct=1 --ioengine=libaio --iodepth=4 --numjobs=2
--offset_increment=81920m

(two parameters were global but achieving an identical effect)

See http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-filename
for details and
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-size
for how the size semantics change when filename is used. Tip: if you
don't want the regions the jobs do I/O against to overlap (which I'm
guessing is why you already have offset_increment) you'll need to set
the size parameter too.

-- 
Sitsofe | http://sucs.org/~sits/
