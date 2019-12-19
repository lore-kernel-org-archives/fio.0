Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38772 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSDFP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Dec 2019 22:05:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id u2so4069227wmc.3
        for <fio@vger.kernel.org>; Wed, 18 Dec 2019 19:05:14 -0800 (PST)
MIME-Version: 1.0
References: <SN6PR11MB266941490E6BC6FD2B3CB8028B530@SN6PR11MB2669.namprd11.prod.outlook.com>
 <CALjAwxjzNuBx=i0EMiCT1s9KASS95_GhXAzATpV1cxG-vWdsDg@mail.gmail.com>
In-Reply-To: <CALjAwxjzNuBx=i0EMiCT1s9KASS95_GhXAzATpV1cxG-vWdsDg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 19 Dec 2019 03:04:47 +0000
Message-ID: <CALjAwxhuc-R_o24SdOir45HmB3QyShUdJTkOYGkxn9A4+=hCmw@mail.gmail.com>
Subject: Re: polled IO and 5.x kernels
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ober, Frank" <frank.ober@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Rajendiran, Swetha" <swetha.rajendiran@intel.com>, "Liang, Mark" <mark.liang@intel.com>, "Derrick, Jonathan" <jonathan.derrick@intel.com>, "Vyas, Satvik M" <satvik.m.vyas@intel.com>, "Knapp, Anthony J" <anthony.j.knapp@intel.com>

On Thu, 19 Dec 2019 at 02:40, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> On Wed, 18 Dec 2019 at 19:02, Ober, Frank <frank.ober@intel.com> wrote:
> >
> > On 4.x kernels we used to be able to do:
> > # echo 1 > /sys/block/nvme0n1/queue/io_poll
> >
> > And then run a polled_io job in fio with pvsync2 as our ioengine, with the hipri flag set.
> >
> > On 5.x kernels we see the following error trying to write the device settings>>>
> > -bash: echo: write error: Invalid argument
>
> Wouldn't this be better asked on the linux-block mailing list
> (http://vger.kernel.org/vger-lists.html#linux-block )?

In fact, doing another search on that list
(https://lore.kernel.org/linux-block/?q=io_poll ) or a more general
Google search (https://www.google.com/search?q=%22echo%3A+write+error%3A+Invalid+argument%22+io_poll
) turns up a post titled "Error while enabling io_poll for NVMe SSD"
(https://lore.kernel.org/linux-block/CAFQ9A4Zc8Fc4bDyAsiduTw4kTpxR=dVZr7LUdqUkvQSu1CaGpg@mail.gmail.com/
) where Keith Busch (who has an Intel address but I'm guessing isn't
in your group?) asks: "did the user turn on polling queues in the nvme
driver"? Another quick hunt
(https://github.com/torvalds/linux/search?q=%22poll_queues%22&type=Code
and following some blame lines) finds
https://github.com/torvalds/linux/commit/4b04cc6a8f86c4842314def22332de1f15de8523
which indicates an NVMe option was added in 5.0 related to polling.

(PS: If you're using fio to publish benchmarking results don't forget
about https://github.com/axboe/fio/blob/master/MORAL-LICENSE )

-- 
Sitsofe | http://sucs.org/~sits/

