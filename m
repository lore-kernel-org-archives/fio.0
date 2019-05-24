Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f51.google.com ([209.85.221.51]:37905 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389677AbfEXJbO (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 May 2019 05:31:14 -0400
Received: by mail-wr1-f51.google.com with SMTP id d18so9247810wrs.5
        for <fio@vger.kernel.org>; Fri, 24 May 2019 02:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <CY4PR0801MB3793BFC227015B3DEC29C824D9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
 <CY4PR0801MB3793680FDFFBB3AE6BD85514D9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
 <AT5PR8401MB1169C4380AA584992B610CBDAB010@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CY4PR0801MB37936DF26D88B44E94A1221FD9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
In-Reply-To: <CY4PR0801MB37936DF26D88B44E94A1221FD9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 24 May 2019 10:30:47 +0100
Message-ID: <CALjAwxhd9=+W3zsKfbmA11ke31+Dj8fvuOWT0J7XtwWmQXc+mA@mail.gmail.com>
Subject: Re: Either I don't understand how it work or I get unexpected result
 - mixed workload
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Etienne-Hugues Fortin <efortin@cyberspicace.com>
Cc: "Elliott, Robert (Servers)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, 23 May 2019 at 19:35, Etienne-Hugues Fortin
<efortin@cyberspicace.com> wrote:
>
> Hi,
>
> I did the change which also forced me to switch to windowsaio as the ioen=
gine. Now the read/write ratio is aligned with what is expected (70/30) but=
 the performance is about 1/5 of what it was. Based on your email, I unders=
tand that it was using Windows Volume Cache but I don't get why the perform=
ance as seen from the storage unit was 5x higher then it is now. If I would=
 have had hit cache at the Windows level, it seems to me that it would not =
have get a higher throughput as seen from the storage unit (not the server)=
. It should have reduce the number of IO going to the storage, no?

Not necessarily - making use of the OS cache can mean the OS can try
and coalesce/rearrange I/Os which is beneficial for device throughput
(the caches we're referring to are a cache for collecting reads/writes
to do "later" as well as a cache for reads already seen).
Additionally, some of your read I/O is sequential so you start
benefiting from things like readahead when you're going through the
cache. I think the biggest factor is that your iodepth is only 1 so
when you had caching your OS likely found a way to turn some amount of
your requests into parallel I/Os thus creating better throughput. When
you go direct that iodepth has to be respected (with iodepth=3D1 fio
won't have more than one I/O in flight and the OS can't do anything
because there are no additional in-flight I/Os to play with). All this
is a big reason why there are OS caches - it helps programs that
aren't generating I/O the way the "device likes best" to still get
good performance...

> Also, I'm using multiple 20GB files per host (16x) and the hosts only hav=
e 4GB of RAM so... that doesn't make a large cache as I understand it. Righ=
t now, I can see that changing direct=3D0 by direct=3D1 and the ioengine to=
 windowsaio is slowing down the performance while, at the same time, fix th=
e ratio read/write so the Windows Volume Cache is certainly doing something=
 but I would not expect it to increase the performance and certainly not wh=
en looking at it from the storage unit. I'm also monitoring the throughput =
on the network and it was 5x higher before then now which contribute to my =
understanding that there was not much hit rate at the Windows Volume Cache =
level.
>
> Any idea of why I'm seeing those results?

See above - caching doesn't just speed up re-reads, it given the OS a
chance to re-arrange I/O into a more favourable form if the userspace
programs didn't submit it that way originally (you may want to look
into upping your iodepth to see what impact that has and finding some
way of monitoring what is being sent down to the disk (I think Windows
Resource Manager has a way of showing you the current OS "queue
length").

--
Sitsofe | http://sucs.org/~sits/

