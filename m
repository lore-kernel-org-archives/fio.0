Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53064 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727667AbfHSPnT (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Aug 2019 11:43:19 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E3B163DE02
        for <fio@vger.kernel.org>; Mon, 19 Aug 2019 15:43:18 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id c14so658660wml.5
        for <fio@vger.kernel.org>; Mon, 19 Aug 2019 08:43:18 -0700 (PDT)
MIME-Version: 1.0
References: <A6EB8C9D-45E9-4BB4-8F69-3FFFBD326B47@integritech.solutions> <CALjAwxg5r-mZezwmo2SeZ-o=dZ=_ogrBMzj=hRQyX268mi2NHg@mail.gmail.com>
In-Reply-To: <CALjAwxg5r-mZezwmo2SeZ-o=dZ=_ogrBMzj=hRQyX268mi2NHg@mail.gmail.com>
From: Bryan Gurney <bgurney@redhat.com>
Date: Mon, 19 Aug 2019 11:43:05 -0400
Message-ID: <CAHhmqcQo8wOuBT3PGvGdPbSgD-QqmM4mAgvTBr+NRx83qXd2dQ@mail.gmail.com>
Subject: Re: Total latency (lat) of a workload test
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Eliezer Nebab <eliezer@integritech.solutions>, fio <fio@vger.kernel.org>

On Mon, Aug 19, 2019 at 2:03 AM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Hi,
>
> On Mon, 19 Aug 2019 at 00:02, Eliezer Nebab
> <eliezer@integritech.solutions> wrote:
> >
> > Hello,
> >
> > I have the following workload:
> >
> > fio --randrepeat=1 --ioengine=libaio --direct=1 --sync=1 --name=test --filename=random_readwrite_test.fio --overwrite=1 --iodepth=64 --size=5GB --readwrite=randrw --rwmixread=50 --rwmixwrite=50 --bs=32k --runtime=60 --time_based --ramp_time=15
> >
> > With the following result:
> >
> > read : io=1949.4MB, bw=33249KB/s, iops=1038 , runt= 60035msec
> >     slat (usec): min=4 , max=30100 , avg=23.92, stdev=240.73
> >     clat (msec): min=1 , max=80 , avg=31.59, stdev= 8.94
> >      lat (msec): min=1 , max=80 , avg=31.61, stdev= 8.94
> >
> >  write: io=1830.3MB, bw=31219KB/s, iops=975 , runt= 60035msec
> >     slat (usec): min=5 , max=30150 , avg=35.61, stdev=293.88
> >     clat (msec): min=1 , max=80 , avg=31.91, stdev= 8.82
> >      lat (msec): min=1 , max=80 , avg=31.95, stdev= 8.81
> >
> > This is a 2000 iops iscsi. The read operation shows a 31.61 (msec) lat and the write operation at 31.95 (msec).  What is the correct way to interpret the total latency of this fio workload?  Do you add the read lat (31.61) plus write lat (31.95) to get the overall latency for this workload?
>
> I'm afraid I don't understand the question. I guess you're saying "can
> I flatten the read and write latencies into one number by summation"
> and my feeling would be no you can't because then it's not per I/O
> data that you are talking about - you have two I/Os worth of latency
> (I'm not statician though). I'd probably make some statement like "the
> average per I/O latency with workload XYZ was approximately 32
> milliseconds regardless of direction" (if you're about to publish
> results don't forget about
> https://github.com/axboe/fio/blob/master/MORAL-LICENSE ). Possibly
> averaging the average is slightly more meaningful or taking the higher
> of the two two numbers.
>
> Just be aware it looks like the workload you're doing has a filesystem
> between you and your disk and by default fio is going to be making
> that "random_readwrite_test.fio" file in the current working
> directory.

The job in this example contains "--overwrite=1", which I'm guessing
would simply reuse the existing file and overwrite its contents during
the test.

However, I had a look at the fio HOWTO file, and I see this:

(begin excerpt from https://github.com/axboe/fio/blob/master/HOWTO )
.. option:: overwrite=bool
If true, writes to a file will always overwrite existing data. If the
file doesn't already exist, it will be created before the write phase
begins. If the file exists and is large enough for the specified write
phase, nothing will be done. Default: false.
(end excerpt)

I'm guessing that the phrase "nothing will be done" means that the
existing file will be used before the write phase begins, without
attempting to delete the file.  Is this correct?


Thanks,

Bryan


> If that's not a filesystem on the iSCSI disk you actually
> wanted to test or it is a filesystem that ignores the direct flag
> (https://stackoverflow.com/a/46377629/ ) then results may not be as
> you expect etc. I'd recommend at least checking what you get doing I/O
> against the block device directly but be aware that doing so will
> DESTROY any data (e.g. like a filesystem) already there!
>
> --
> Sitsofe | http://sucs.org/~sits/

