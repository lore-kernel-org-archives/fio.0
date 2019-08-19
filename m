Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f48.google.com ([209.85.128.48]:55159 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfHSGDH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Aug 2019 02:03:07 -0400
Received: by mail-wm1-f48.google.com with SMTP id p74so462852wme.4
        for <fio@vger.kernel.org>; Sun, 18 Aug 2019 23:03:06 -0700 (PDT)
MIME-Version: 1.0
References: <A6EB8C9D-45E9-4BB4-8F69-3FFFBD326B47@integritech.solutions>
In-Reply-To: <A6EB8C9D-45E9-4BB4-8F69-3FFFBD326B47@integritech.solutions>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 19 Aug 2019 07:02:38 +0100
Message-ID: <CALjAwxg5r-mZezwmo2SeZ-o=dZ=_ogrBMzj=hRQyX268mi2NHg@mail.gmail.com>
Subject: Re: Total latency (lat) of a workload test
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Eliezer Nebab <eliezer@integritech.solutions>
Cc: fio <fio@vger.kernel.org>

Hi,

On Mon, 19 Aug 2019 at 00:02, Eliezer Nebab
<eliezer@integritech.solutions> wrote:
>
> Hello,
>
> I have the following workload:
>
> fio --randrepeat=3D1 --ioengine=3Dlibaio --direct=3D1 --sync=3D1 --name=
=3Dtest --filename=3Drandom_readwrite_test.fio --overwrite=3D1 --iodepth=3D=
64 --size=3D5GB --readwrite=3Drandrw --rwmixread=3D50 --rwmixwrite=3D50 --b=
s=3D32k --runtime=3D60 --time_based --ramp_time=3D15
>
> With the following result:
>
> read : io=3D1949.4MB, bw=3D33249KB/s, iops=3D1038 , runt=3D 60035msec
>     slat (usec): min=3D4 , max=3D30100 , avg=3D23.92, stdev=3D240.73
>     clat (msec): min=3D1 , max=3D80 , avg=3D31.59, stdev=3D 8.94
>      lat (msec): min=3D1 , max=3D80 , avg=3D31.61, stdev=3D 8.94
>
>  write: io=3D1830.3MB, bw=3D31219KB/s, iops=3D975 , runt=3D 60035msec
>     slat (usec): min=3D5 , max=3D30150 , avg=3D35.61, stdev=3D293.88
>     clat (msec): min=3D1 , max=3D80 , avg=3D31.91, stdev=3D 8.82
>      lat (msec): min=3D1 , max=3D80 , avg=3D31.95, stdev=3D 8.81
>
> This is a 2000 iops iscsi. The read operation shows a 31.61 (msec) lat an=
d the write operation at 31.95 (msec).  What is the correct way to interpre=
t the total latency of this fio workload?  Do you add the read lat (31.61) =
plus write lat (31.95) to get the overall latency for this workload?

I'm afraid I don't understand the question. I guess you're saying "can
I flatten the read and write latencies into one number by summation"
and my feeling would be no you can't because then it's not per I/O
data that you are talking about - you have two I/Os worth of latency
(I'm not statician though). I'd probably make some statement like "the
average per I/O latency with workload XYZ was approximately 32
milliseconds regardless of direction" (if you're about to publish
results don't forget about
https://github.com/axboe/fio/blob/master/MORAL-LICENSE ). Possibly
averaging the average is slightly more meaningful or taking the higher
of the two two numbers.

Just be aware it looks like the workload you're doing has a filesystem
between you and your disk and by default fio is going to be making
that "random_readwrite_test.fio" file in the current working
directory. If that's not a filesystem on the iSCSI disk you actually
wanted to test or it is a filesystem that ignores the direct flag
(https://stackoverflow.com/a/46377629/ ) then results may not be as
you expect etc. I'd recommend at least checking what you get doing I/O
against the block device directly but be aware that doing so will
DESTROY any data (e.g. like a filesystem) already there!

--=20
Sitsofe | http://sucs.org/~sits/

