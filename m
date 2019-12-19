Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37936 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfLSClD (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Dec 2019 21:41:03 -0500
Received: by mail-wm1-f65.google.com with SMTP id u2so4036334wmc.3
        for <fio@vger.kernel.org>; Wed, 18 Dec 2019 18:41:02 -0800 (PST)
MIME-Version: 1.0
References: <SN6PR11MB266941490E6BC6FD2B3CB8028B530@SN6PR11MB2669.namprd11.prod.outlook.com>
In-Reply-To: <SN6PR11MB266941490E6BC6FD2B3CB8028B530@SN6PR11MB2669.namprd11.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 19 Dec 2019 02:40:35 +0000
Message-ID: <CALjAwxjzNuBx=i0EMiCT1s9KASS95_GhXAzATpV1cxG-vWdsDg@mail.gmail.com>
Subject: Re: polled IO and 5.x kernels
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ober, Frank" <frank.ober@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Rajendiran, Swetha" <swetha.rajendiran@intel.com>, "Liang, Mark" <mark.liang@intel.com>, "Derrick, Jonathan" <jonathan.derrick@intel.com>, "Vyas, Satvik M" <satvik.m.vyas@intel.com>, "Knapp, Anthony J" <anthony.j.knapp@intel.com>

Hi,

On Wed, 18 Dec 2019 at 19:02, Ober, Frank <frank.ober@intel.com> wrote:
>
> Hi fio community,
> On 4.x kernels we used to be able to do:
> # echo 1 > /sys/block/nvme0n1/queue/io_poll
>
> And then run a polled_io job in fio with pvsync2 as our ioengine, with the hipri flag set.
>
> On 5.x kernels we see the following error trying to write the device settings>>>
> -bash: echo: write error: Invalid argument

Wouldn't this be better asked on the linux-block mailing list
(http://vger.kernel.org/vger-lists.html#linux-block )?

If you're saying "This worked in 4.20 but not in 5.0" (after all since
you can see this clearly bisection is always an option for you) then a
quick search (https://github.com/torvalds/linux/search?o=desc&p=2&q=%22io_poll%22&s=committer-date&type=Commits
) finds this commit -
https://github.com/torvalds/linux/commit/cd19181bf9ad4b7f40f2a4e0355d052109c76529
which might have something to do with the change of behaviour...

> This is verifiable on 5.3, 5.4 kernels with fio 3.16 builds.
>
> What is the background on what has changed because Jens wrote this note back in 2015, which did work once upon a time.
> But now things have changed, but none of us here in the Intel SSD group and OSS Driver team really know why.
>
> https://lwn.net/Articles/663543/

Note: this is just an excerpt from a mailing list post that LWN
happened to highlight. See
https://lore.kernel.org/lkml/1446830423-25027-1-git-send-email-axboe@fb.com/
for the post and its thread...

> More documentation can be found here: https://stackoverflow.com/questions/55223883/echo-write-error-invalid-argument-while-setting-io-poll-for-nvme-ssd/

Isn't stackoverflow for programming questions rather than "where's a
kernel option gone?" style question? Maybe
https://unix.stackexchange.com/ would have been a better home?

> Here is a good sample A / B test:
> [global]
> direct=1
> filename=/dev/nvme1n1
> log_avg_msec=500
> time_based
> percentile_list=1:5:10:20:30:40:50:60:70:80:90:95:99:99.5:99.9:99.95:99.99:99.999:99.9999
>
>
> [rand-read-4k-qd1]
> runtime=120
> bs=4K
> iodepth=1
> numjobs=1
> cpus_allowed=0
> ioengine=io_uring
> hipri
> rw=randread
> Works!
>
> [global]
> direct=1
> filename=/dev/nvme1n1
> log_avg_msec=500
> time_based
> percentile_list=1:5:10:20:30:40:50:60:70:80:90:95:99:99.5:99.9:99.95:99.99:99.999:99.9999
>
>
> [rand-read-4k-qd1]
> runtime=120
> bs=4K
> iodepth=1
> numjobs=1
> cpus_allowed=0
> ioengine=pvsync2
> hipri
> rw=randread
> Does not work... you do not see the CPU spin up to 100% (kernel/sys usage) on hipri with pvsync2 on a 5.x kernel.
>
> Why not?

Glancing at https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-engine-specific-parameters
, hipri on the pvsync2 ioengine means something different to hipri on
io_uring ioengine...

> And what changed here?

Just to check, do you get the same "full CPU" utilisation when you
remove hipri from your pvsync job on a 4.x kernel?

> Is it possible to get a new LWN article?

That sounds like one for Jon Corbet (LWN.net editor) and the block
maintainers but as mentioned above what you linked to was just a
mailing list excerpt...

> Thank you!
> Frank Ober

Good luck!

-- 
Sitsofe | http://sucs.org/~sits/

