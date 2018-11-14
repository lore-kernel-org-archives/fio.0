Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f42.google.com ([209.85.217.42]:44234 "EHLO
        mail-vs1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbeKNOHX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Nov 2018 09:07:23 -0500
Received: by mail-vs1-f42.google.com with SMTP id g68so8704236vsd.11
        for <fio@vger.kernel.org>; Tue, 13 Nov 2018 20:05:58 -0800 (PST)
MIME-Version: 1.0
References: <CAKiK_mAyMPdR9JamSee8XLQJoBehdGFY1a92NEgH+DmjpnKBow@mail.gmail.com>
In-Reply-To: <CAKiK_mAyMPdR9JamSee8XLQJoBehdGFY1a92NEgH+DmjpnKBow@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 14 Nov 2018 04:05:33 +0000
Message-ID: <CALjAwxgAdak2m0s2F_7HQYYqVeEGj2P7bjx3Le7rPFtH0QcT6A@mail.gmail.com>
Subject: Re: Question about data verification using verify_state_save and verify_state_load
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Taylor Yang <taylor4869@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi Taylor,

On Tue, 13 Nov 2018 at 09:01, Taylor Yang <taylor4869@gmail.com> wrote:
>
> I want to do some writes and reads to a device for a period of time
> and then verify the writes. So I have the following job files.
>
> write.fio job file:
> [global]
> direct=1
> ioengine=libaio
> numjobs=1
> verify=crc32c
>
> [/dev/sdf]
> filename=/dev/sdf
> time_based
> runtime=500
> bwavgtime=1000
> iopsavgtime=1000
> rw=randrw
> rwmixwrite=50
> verify_state_save=1
> iodepth=4
> bs=4k
>
>
> verify.fio file
> [global]
> direct=1
> ioengine=libaio
> group_reporting
> numjobs=1
> verify=crc32c
>
> [/dev/sdf]
> rw=read
> do_verify=1
> filename=/dev/sdf
> verify_state_load=1

^^^ You have different options here to your original job (rw is
different, and technically you're missing rwmixwrite). I think you're
right to drop the time restriction and bandwidth options but you've
changed rw=randrw into rw=read which will make the verify examine
blocks that weren't necessarily written by the original job. Maybe
verify_only (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify-only
) would be of use to you?

> I saw some bad magic header errors while doing this but when I added
> all the related flags I have in the write.fio file to the verify.fio
> file. Everything seems to work.
>
> [global]
> direct=1
> ioengine=libaio
> numjobs=1
> verify=crc32c
>
> [/dev/sdf]
> rw=randrw
> rwmixwrite=50
> do_verify=1
> filename=/dev/sdf
> verify_state_load=1
> iodepth=4
> bs=4k

This will run a write followed by a verify so it overwrites whatever
data was originally there then verifies it and the verify knows
exactly what the write phase did.

> For example, if I change the verify job file to below, everything
> looks fine but the verification might take some time.
>
> I have a few questions regarding this.
> 1. Does the write phase `rw` option have to match the verify phase?
> For example if I have `randomwrite` for write phase, do I need to put
> 'randomread' for verify phase but not 'read'? And if I have 'randomrw'
> in write phase, is it true that I have to use it in verify phase?

Sometimes - it depends on the job file and the options you are using.
I'm going to sidestep this question and say:

"I think it's easier to use verify_only to flip the writes to reads in
the verify job".

> 2. Do I need to put all the flags in write phase to verify phase? So
> in my case, do I have to add iodepth and bs to the verify phase as
> well?

This depends on whether you are writing the entire region using a
fixed block size. If you are doing both (whole region is changed,
fixed block size) then life is easy when you are running split jobs as
all sorts of things happen to work. If you are not then you need to be
careful about matching things up. With respect to your examples:
iodepth is unlikely to matter on the verify part but having a matching
blocksize/bs is critical!

> 3. Are there other ways to achieve what I want? I mainly want to have
> some kinda of complicated IO workload (mix writes and reads) with the
> time_based option and if the verification could complete during this
> timed phase, I could save the progress and then have a separate verify
> phase later to fully verify the writes. I know I could use
> verify_backlog but I intend to verify the writes separately.

As mentioned in https://www.spinics.net/lists/fio/msg07237.html ,
split verify jobs where the original job was timed limited are always
more complicated to get going but something is typically achievable.
Other approaches usually depend on some additional restriction so I
think your approach is right given what you want to achieve. You're
unlikely to hit it with the jobs above but there's a tiny corner case
if the job ends up rewriting blocks it wrote earlier when looping
round which can be sidestepped using serialize_overlap
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-serialize-overlap
) but we can chat about that some other time.

Keep us informed of your progress getting this to work!

--
Sitsofe | http://sucs.org/~sits/

