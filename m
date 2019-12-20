Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38394 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTICI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Dec 2019 03:02:08 -0500
Received: by mail-wm1-f67.google.com with SMTP id u2so8189445wmc.3
        for <fio@vger.kernel.org>; Fri, 20 Dec 2019 00:02:06 -0800 (PST)
MIME-Version: 1.0
References: <SN6PR11MB266941490E6BC6FD2B3CB8028B530@SN6PR11MB2669.namprd11.prod.outlook.com>
 <CALjAwxjzNuBx=i0EMiCT1s9KASS95_GhXAzATpV1cxG-vWdsDg@mail.gmail.com>
 <CALjAwxhuc-R_o24SdOir45HmB3QyShUdJTkOYGkxn9A4+=hCmw@mail.gmail.com> <SN6PR11MB26690A7625764F6E3E1376EC8B520@SN6PR11MB2669.namprd11.prod.outlook.com>
In-Reply-To: <SN6PR11MB26690A7625764F6E3E1376EC8B520@SN6PR11MB2669.namprd11.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 20 Dec 2019 08:01:40 +0000
Message-ID: <CALjAwxjoJp6jTtRnC0vn38FrP=JbHm0R7LyuVGHmt03d9mm-7g@mail.gmail.com>
Subject: Re: polled IO and 5.x kernels
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ober, Frank" <frank.ober@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Rajendiran, Swetha" <swetha.rajendiran@intel.com>, "Liang, Mark" <mark.liang@intel.com>, "Derrick, Jonathan" <jonathan.derrick@intel.com>, "Vyas, Satvik M" <satvik.m.vyas@intel.com>, "Knapp, Anthony J" <anthony.j.knapp@intel.com>

> -----Original Message-----
> From: Sitsofe Wheeler <sitsofe@gmail.com>
> Sent: Wednesday, December 18, 2019 7:05 PM
>
> > Wouldn't this be better asked on the linux-block mailing list
> > (http://vger.kernel.org/vger-lists.html#linux-block )?

On Thu, 19 Dec 2019 at 17:22, Ober, Frank <frank.ober@intel.com> wrote:
>
> Sitsofe,
> Ok I will do that.

For anyone who might be following along (e.g. by finding the post
you're reading via Google some time in the future), Frank did indeed
do this and you can see the outcome in the "Polled io for Linux kernel
5.x" thread on the Linux block mailing list (e.g.
https://lore.kernel.org/linux-block/SN6PR11MB2669E7A65DD0AD9DC65A67C58B520@SN6PR11MB2669.namprd11.prod.outlook.com/
).

-- 
Sitsofe | http://sucs.org/~sits/

On Thu, 19 Dec 2019 at 17:22, Ober, Frank <frank.ober@intel.com> wrote:
>
> Sitsofe,
> Ok I will do that.
> Frank
>
>
> -----Original Message-----
> From: Sitsofe Wheeler <sitsofe@gmail.com>
> Sent: Wednesday, December 18, 2019 7:05 PM
> To: Ober, Frank <frank.ober@intel.com>
> Cc: fio@vger.kernel.org; Rajendiran, Swetha <swetha.rajendiran@intel.com>; Liang, Mark <mark.liang@intel.com>; Derrick, Jonathan <jonathan.derrick@intel.com>; Vyas, Satvik M <satvik.m.vyas@intel.com>; Knapp, Anthony J <anthony.j.knapp@intel.com>
> Subject: Re: polled IO and 5.x kernels
>
> On Thu, 19 Dec 2019 at 02:40, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> >
> > On Wed, 18 Dec 2019 at 19:02, Ober, Frank <frank.ober@intel.com> wrote:
> > >
> > > On 4.x kernels we used to be able to do:
> > > # echo 1 > /sys/block/nvme0n1/queue/io_poll
> > >
> > > And then run a polled_io job in fio with pvsync2 as our ioengine, with the hipri flag set.
> > >
> > > On 5.x kernels we see the following error trying to write the device
> > > settings>>>
> > > -bash: echo: write error: Invalid argument
> >
> > Wouldn't this be better asked on the linux-block mailing list
> > (http://vger.kernel.org/vger-lists.html#linux-block )?
>
> In fact, doing another search on that list (https://lore.kernel.org/linux-block/?q=io_poll ) or a more general Google search (https://www.google.com/search?q=%22echo%3A+write+error%3A+Invalid+argument%22+io_poll
> ) turns up a post titled "Error while enabling io_poll for NVMe SSD"
> (https://lore.kernel.org/linux-block/CAFQ9A4Zc8Fc4bDyAsiduTw4kTpxR=dVZr7LUdqUkvQSu1CaGpg@mail.gmail.com/
> ) where Keith Busch (who has an Intel address but I'm guessing isn't in your group?) asks: "did the user turn on polling queues in the nvme driver"? Another quick hunt (https://github.com/torvalds/linux/search?q=%22poll_queues%22&type=Code
> and following some blame lines) finds
> https://github.com/torvalds/linux/commit/4b04cc6a8f86c4842314def22332de1f15de8523
> which indicates an NVMe option was added in 5.0 related to polling.
>
> (PS: If you're using fio to publish benchmarking results don't forget about https://github.com/axboe/fio/blob/master/MORAL-LICENSE )
>
> --
> Sitsofe | http://sucs.org/~sits/



-- 
Sitsofe | http://sucs.org/~sits/

