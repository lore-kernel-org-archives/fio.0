Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f49.google.com ([209.85.222.49]:44844 "EHLO
        mail-ua1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgAaSmU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Jan 2020 13:42:20 -0500
Received: by mail-ua1-f49.google.com with SMTP id x16so2931154uao.11
        for <fio@vger.kernel.org>; Fri, 31 Jan 2020 10:42:19 -0800 (PST)
MIME-Version: 1.0
References: <CAL-AFxyeQ_mnGmy_458jm=CXVdXYd9Gdz77UDbAxDknR7Lv0Ow@mail.gmail.com>
 <0b3477ac-858c-742c-d4e6-21e6174e456d@criteo.com>
In-Reply-To: <0b3477ac-858c-742c-d4e6-21e6174e456d@criteo.com>
From: Louwrentius <louwrentius@gmail.com>
Date: Fri, 31 Jan 2020 19:42:08 +0100
Message-ID: <CAL-AFxx=y8dxsCd6oZid=0RVk49Wv7Zqu2Tj8w9wZ2khMKV7qg@mail.gmail.com>
Subject: Re: Strange benchmark results of SSD - any ideas
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <e.velu@criteo.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks for the feedback. I have to make an apology to you all. I made
a rather stupid mistake.
I tested the SSDs on a P420i RAID controller (not in HBA mode) and
this seems to cause these strange patterns.

After some feedback, I decided to test the SSDs again on a regular
AHCI SATA 300 controller and the results were as expected.
I've updated my blog post with the new benchmark results. This is an exampl=
e:

https://raw.githubusercontent.com/louwrentius/fio-plot/master/images/SAMSUN=
G-PM883-ON-AHCI-SATA-300-FULL-DISK-4K-RANDOM-READ-WRITE-50%25-2020-01-31_14=
4732.png

As to why I test this way (with qd=3D1): I like to see how SSDs perform
under worst-case performance situations.
Although SSDs can get to crazy IOPs with high queue depths, I wonder
if those queue depths are always encountered in real-life situations.
Probably depends on the workload.

Thanks again for the suggestions.

Op vr 31 jan. 2020 om 08:58 schreef Erwan Velu <e.velu@criteo.com>:
>
> A couple of comments on your testing procedure.
>
> - Please version everything you use  : fio, kernel, system, bios, ssd
> firmware
>
> All this can have an impact on your testing.
>
> It's unclear if they all run of the same host/setup or not.
>
>
> - Please expose the device size as the ssd model/brand isn't enough.
>
> The size of the SSD have a huge impact on its performance
>
> You should also expose the DWPD of these drive to detail how much
> endurant they are supposed to be.
>
> The public price could be also a hint for the reader.
>
>
> - Please expose the SMART attributes of these drives
>
> If some are older than other, the wear leveling status could impact the
> performance too
>
>
> - Why do you enforce iodepth to 1 ? SSD devices can perfectly handle
> much more than that, and that what will happen when used by the OS.
>
> I'd suggest to run at least iodepth =3D 32.
>
>
> - Please expose the device configuration with a sdparm -a (to know what
> are the read & write cache settings on this devices)
>
>
> - Starting from the fresh erased disk would be better to start from a
> clear device (same TRIM state on all devices)
>
>
> On 29/01/2020 23:43, Louwrentius wrote:
> > Hello,
> >
> > I've done some benchmarks with FIO of entire SSD devices. So the FIO
> > benchmark stops when the whole device has been read/written. I've
> > logged latency and iops for the entire run.
> >
> > Those logs are then translated to graphs. The Intel SSD shows the kind
> > of graph I would expect. The Samsung and Kingston SSDs show 'strange'
> > results.
> >
> > I've written a brief blog article about this which includes links to
> > the raw data and the images.
> > https://eur03.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flou=
wrentius.com%2Fdifference-of-behavior-in-sata-solid-state-drives.html&amp;d=
ata=3D02%7C01%7Ce.velu%40criteo.com%7C0bfd1acab1454841fad208d7a50ca983%7C2a=
35d8fd574d48e3927c8c398e225a01%7C1%7C1%7C637159346115224065&amp;sdata=3DDzE=
ZDHTfCk6tpEsYacMRETj5rUbRoLRtQu7yUW%2BeV3M%3D&amp;reserved=3D0
> >
> > Does anybody have an idea what could be going on? Why do we see these
> > 'golden gate bridge' patterns? Maybe I did something wrong?
> >
> > With regards,
> >
> > Louwrentius

