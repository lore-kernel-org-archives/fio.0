Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180129164548.GA7056@localhost.didichuxing.com>
References: <20180129164548.GA7056@localhost.didichuxing.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 17 Mar 2018 08:44:35 +0000
Message-ID: <CALjAwxgNXU41zLyXsSrZ+JxDdx1Td=_1ju5v73O8wdm5sPKBqA@mail.gmail.com>
Subject: Re: [RFC PATCH] doc: add comments for the difference between iodepth
 and blkdev's inflight
Content-Type: text/plain; charset="UTF-8"
To: weiping zhang <zhangweiping@didichuxing.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

(I know this one is old but I seem to have had a reply rolling around
in my draft folder for a while)

On 29 January 2018 at 16:45, weiping zhang <zhangweiping@didichuxing.com> wrote:
> If user want control the inflight IOs for the tested block device, for
> example set iodepth=16, and we can get result like following:
>
> IO depths: 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, >=64=0.0%
>
> this result only means (16~31) IOs inflight, don't means requests inflight,
> if max_sectors_kb = 64KB, and we set bs=256KB, the number of inflight
> requests may reach to 64(if nr_request allow). So for user want to control
> the number of inflight requests, bs should less than max_sectors_kb.

You have a point but that's very Linux platform specific information
(then again so is the libaio warning so there's a precedent there
already). Additionally, dependent on a device's I/O scheduler and its
options etc. just because you submitted smaller blocks doesn't mean those
I/Os won't be merged together thus the amount of requests inflight down to
a device can still be different to what fio is submitting to the
kernel. Further, there may also be different layers in the strack
between userspace and the device that transform the I/Os (e.g. md RAID
etc.) before they turn into device requests so there are lots of
caveats.

-- 
Sitsofe | http://sucs.org/~sits/

