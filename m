Return-Path: <fio-owner@vger.kernel.org>
Received: from v150-95-18-100.b001.p.han1.static.cnode.io ([150.95.18.100]:55698
        "EHLO citigomail.webstarterz.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751349AbdDNDRF (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 13 Apr 2017 23:17:05 -0400
From: "Son Chu" <son.ct@citigo.com.vn>
References: <001b01d2b403$1aa072b0$4fe15810$@citigo.com.vn> <562d58d8-9c5c-3205-e624-df75b155c058@bluestop.org> <CALjAwxhY1LVWMDwiaRt6U=GTXBP=6o0yHeRJnbhBfR34GbQ9zQ@mail.gmail.com>
In-Reply-To: <CALjAwxhY1LVWMDwiaRt6U=GTXBP=6o0yHeRJnbhBfR34GbQ9zQ@mail.gmail.com>
Subject: RE: RE: FIo version 2.1.8 with write_iops_log option doesn't work as expected
Date: Fri, 14 Apr 2017 09:14:35 +0700
Message-ID: <000301d2b4c4$dc9b2330$95d16990$@citigo.com.vn>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Sitsofe Wheeler' <sitsofe@gmail.com>
Cc: fio@vger.kernel.org, 'Rebecca Cran' <rebecca@bluestop.org>

Hi Sitsofe,

Thank you very much for your help. I got the same result as you and =
Rebecca said after upgrade fio to version 2.19 . My version was too old =
(2.2.10).=20

Thank you all for the helping.

Best Regards,
Son

-----Original Message-----
From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]=20
Sent: Friday, April 14, 2017 3:56 AM
To: Son Chu <son.ct@citigo.com.vn>
Cc: fio@vger.kernel.org; Rebecca Cran <rebecca@bluestop.org>
Subject: Re: RE: FIo version 2.1.8 with write_iops_log option doesn't =
work as expected

Hi Son,

I tried fio on Windows (fio 2.18), Linux (fio
2.19) and macOS (fio 2.19) and all produce the same results for me with
the following:

$ fio --size=3D10M --ioengine=3Dnull --time_based=3D1 --runtime=3D5s
--write_iops_log=3Diops --rate_iops=3D50 --name iops
[...]
$ head -5 iops_iops.1.log
0, 1, 0, 4096
0, 1, 0, 4096
42, 1, 0, 4096
60, 1, 0, 4096
80, 1, 0, 4096

In all cases the second column contained one. You didn't actually
include the output of your Linux run but you seemed to be suggesting
that the second column wasn't "1" there by default but as said I do
see 1 in that column on Linux.

If you upgrade your Linux fio to something recent like 2.19 (2.2.10 is
very old!) do you see 1 in that column by default? Perhaps the default
behaviour changed over the years...

On 13 April 2017 at 16:59, Rebecca Cran <rebecca@bluestop.org> wrote:
> I'm seeing the same thing on Linux and Windows. Can somebody help Son?
>
> -------- Forwarded Message --------
> Subject:        RE: FIo version 2.1.8 with write_iops_log option =
doesn't
> work as expected
> Date:   Thu, 13 Apr 2017 10:07:36 +0700
> From:   Son Chu <son.ct@citigo.com.vn>
> To:     'Rebecca Cran' <rebecca@bluestop.org>
>
>
>
> Hi Rebecca,
>
> So to get more detail, I will list what I did on both Linux and =
Windows to
> let you see what is my issue:
>
> -Linux Ubuntu 16.04:
>
> oVersion
>
> =C2=A72.2.10
>
> oCommand
>
> =C2=A7fio --randrepeat=3D1 --ioengine=3Dlibaio --direct=3D1 =
--name=3Dtest --filename=3Dtest
> --bs=3D4k --iodepth=3D64 --size=3D100M --readwrite=3Drandrw =
--rwmixread=3D75
> --write_iops_log=3Drandrw
>
> oOutput
>
> =C2=A7
>
> -Windows Server 2012 R2:
>
> oVersion
>
> =C2=A72.1.8
>
> oCommand
>
> =C2=A7fio.exe --randrepeat=3D1 --ioengine=3Dwindowsaio --direct=3D1 =
--name=3Dtest
> --filename=3Dtest --bs=3D4k --iodepth=3D64 --size=3D100M =
--readwrite=3Drandrw
> --rwmixread=3D75 --write_iops_log=3Drandrw
>
> oOutput
>
> 33, 1, 0, 4096
>
> 34, 1, 1, 4096
>
> 35, 1, 1, 4096
>
> 44, 1, 0, 4096
>
> 46, 1, 0, 4096
>
> 53, 1, 0, 4096
>
> 54, 1, 1, 4096
>
> 58, 1, 0, 4096
>
> 63, 1, 0, 4096
>
> 64, 1, 1, 4096
>
> 64, 1, 1, 4096
>
> 73, 1, 0, 4096
>
> 81, 1, 0, 4096
>
> 89, 1, 0, 4096
>
> 98, 1, 0, 4096
>
> From these result I wonder why the second column from Windows Server =
is
> different from Linux???? It should be the IOPS like 844,289 from Linux =
than
> 1 from Windows.
>
> Can you help me on this please?
>
> Thanks a lot in advance.
>
> Regards,
>
> Son
>
> *From:*Rebecca Cran [mailto:rebecca@bluestop.org]
> *Sent:* Wednesday, April 12, 2017 10:53 PM
> *To:* Son Chu <son.ct@citigo.com.vn>
> *Subject:* Re: FIo version 2.1.8 with write_iops_log option doesn't =
work as
> expected
>
> I'm seeing exactly the same on Linux. What commandline are you using =
there?
>
> Rebecca
>
> On 4/11/2017 10:28 PM, Son Chu wrote:
>
>    Hi Rebecca,
>
>    I am using FIO version 2.1.8 on Windows Server 2012 R2. When I was
>    trying to write iops log with option write_iops_log follow this =
command:
>
>    fio --directory=3DC\:\fio --ioengine=3Dwindowsaio --direct=3D1
>    --name=3Drandwin --filename=3Drandwin --bs=3D4k --iodepth=3D16 =
--size=3D4G
>    --readwrite=3Drandrw --rwmixread=3D75 --write_bw_log=3Drandwin
>    --write_iops_log=3Drandwin --write_lat_log=3Drandwin =
--per_job_logs=3D0
>
>    I got a log file with example content below:
>
>    138, 1, 1, 4096
>
>    138, 1, 1, 4096
>
>    138, 1, 0, 4096
>
>    139, 1, 0, 4096
>
>    141, 1, 0, 4096
>
>    143, 1, 0, 4096
>
>    143, 1, 1, 4096
>
>    145, 1, 0, 4096
>
>    147, 1, 0, 4096
>
>    147, 1, 1, 4096
>
>    147, 1, 1, 4096
>
>    149, 1, 0, 4096
>
>    151, 1, 0, 4096
>
>    152, 1, 0, 4096
>
>    155, 1, 0, 4096
>
>    158, 1, 0, 4096
>
>    160, 1, 0, 4096
>
>    162, 1, 0, 4096
>
>    164, 1, 0, 4096
>
>    165, 1, 0, 4096
>
>    166, 1, 1, 4096
>
>    166, 1, 1, 4096
>
>    166, 1, 1, 4096
>
>    167, 1, 1, 4096
>
>    168, 1, 0, 4096
>
>    I have wondered why the second colume was 1 (iops) instead of the
> expected iops per second (milisecond). If I used command with option:
> log_avg_msec=3D1000 then I got expected iops value. This is not like =
Linux.
>
>
>    Can you please help on this?
>
>
>    Sorry if this disturbs you.
>
>
>    Thanks a lot in advance.
>
>
>    Regards,
>
>    Son

--=20
Sitsofe | http://sucs.org/~sits/

