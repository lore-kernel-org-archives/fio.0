Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:42099 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753061AbeB0L7c (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Feb 2018 06:59:32 -0500
Received: by mail-vk0-f54.google.com with SMTP id y127so11942753vky.9
        for <fio@vger.kernel.org>; Tue, 27 Feb 2018 03:59:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <000801d3afb8$1ffb6a10$5ff23e30$@163.com>
References: <000801d3afb8$1ffb6a10$5ff23e30$@163.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 27 Feb 2018 11:59:00 +0000
Message-ID: <CALjAwxgYcdTe68JPjo6fJHOYc=nD_Tb8Tyd995D1ONbQx3Lvjg@mail.gmail.com>
Subject: Re: How to ensure split verification will generate the same configs
 as write phase?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vaughan <cxt9401@163.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 27 February 2018 at 10:45, Vaughan <cxt9401@163.com> wrote:
>
> I want fio to do an split verification for RAID as did in
> https://github.com/axboe/fio/issues/468. Once written, the verification will
> be repeat several times for raid recovery for each disk.
>
> The example job file is as below:
> ----- write job -----
> [global]
> do_verify=0
> iodepth=32
> filename=/dev/nvme0n6
> rw=randwrite
> ioengine=libaio
> verify=crc32c-intel
> direct=1
> verify_offset=100
> bs=4096
> [job_0]
> size=209715200
> offset=0
>
> ----- read job -----
> [global]
> do_verify=1
> verify_state_load=1
> iodepth=32
> filename=/dev/nvme0n6
> rw=read

^^^ Here's a problem - you can't randomly write and then verify
sequentially via a different run. In your case you need rw=randread.
Note this is exactly what Jens was warning about in
https://github.com/axboe/fio/issues/468#issuecomment-332821507 :

"It works for me, as long as you make sure that the rw=write is paired
with rw=read, or if rw=randwrite is paired with rw=randread. It can't
work otherwise."

> ioengine=libaio
> verify=crc32c-intel
> direct=1
> verify_offset=100
> bs=4096
>
> [job_0]
> size=209715200
> offset=0
>
> I don't see it use the same randseed. Can it generate the same offset as
> write phase without randseed= option set?

The  randseed is the same across different invocations of fio unless
you say otherwise (see randrepeat -
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-randrepeat
). So even if you weren't using a verification state file you will
re-generate the same pattern if the rest of the job is the same.

Next, in your case you're explicitly reloading the verification state
(notice how you carefully kept the job name the same) which contains
the random seed state and is able to restore them. So even if the
random seed were being randomly chosen your second job will reseed it
to the original value.

> If I use randbs= to also use an random write blocksizes, how can I ensure
> the verification will do the same as write?

See above. Try a very small run (e.g. where size is only 64k) with
--debug=io and bsrange (which I'm guessing is what you meant) to check
this.

> Can write_iolog ensure that? However, I suppose it may slow down the write
> speed and randomness of test.

I suppose you could do it that way. I wouldn't expect it to make
things less random but yes the speed could be impacted (and there's
the issue of how big that log file will be etc).

-- 
Sitsofe | http://sucs.org/~sits/
