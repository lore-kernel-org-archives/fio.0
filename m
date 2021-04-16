Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbhDPFLh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Apr 2021 01:11:37 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911D0C061574
        for <fio@vger.kernel.org>; Thu, 15 Apr 2021 22:11:09 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id p19so13604141wmq.1
        for <fio@vger.kernel.org>; Thu, 15 Apr 2021 22:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <059fa98d-9088-5daa-834e-5c87d60bb836@nttcom.co.jp_1>
 <7875665d-82ca-2bf5-faf2-21c67dfc613e@criteo.com> <6bf156f9-5771-0afe-92c5-d8bb1e04b69f@nttcom.co.jp_1>
 <CALjAwxj_-Q1HteM1MdcmxfeuAD54jvQMNpQi5Rt78sC-9ZRgHw@mail.gmail.com>
 <f2e9d44d-9d1f-46a2-3112-a1982c559ac5@nttcom.co.jp_1> <CALjAwxh79d7ebKNU3xZUaQgF50q-3bVLVSC1QJ+Ub=3DsX6XPQ@mail.gmail.com>
 <7cd0c68b-e3fe-10fe-27ba-9e92688ea931@nttcom.co.jp_1>
In-Reply-To: <7cd0c68b-e3fe-10fe-27ba-9e92688ea931@nttcom.co.jp_1>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 16 Apr 2021 06:10:42 +0100
Message-ID: <CALjAwxhB1PUQKrW7QNZsYLJ-LKtW+hegV3YQiHhmz2j4McOw0A@mail.gmail.com>
Subject: Re: [Question] Sequential mesuaring and filename option
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
List-Id: fio@vger.kernel.org
To: Nakajima Akira <nakajima.akira@nttcom.co.jp>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Erwan Velu <e.velu@criteo.com>

Hey,

On Fri, 16 Apr 2021 at 04:49, Nakajima Akira
<nakajima.akira@nttcom.co.jp> wrote:
>
> On 2021/04/16 4:37, Sitsofe Wheeler wrote:
> > On Thu, 15 Apr 2021 at 03:49, Nakajima Akira
> > <nakajima.akira@nttcom.co.jp <mailto:nakajima.akira@nttcom.co.jp>> wrot=
e:
> >
> >
> >     Hi.
> >
> >     Sorry. Due to my company's email sender domain restrictions,
> >        it could not be sent to gmail.
> >
> >
> >     Above is the result on unencrypted ext4/xfs.
> >     Similar results are obtained on encrypted ext4/xfs.
> >
> >
> >     Since the memory is 24GB, I tried it with 72GB + =CE=B1 =3D 76GB.
> >
> >     # fio -filename=3D/testfile -direct=3D1 -ioengine=3Dlibaio -rw=3Dwr=
ite -bs=3D1m
> >     -size=3D76G -runtime=3D60 -numjobs=3D1 -group_reporting -name=3Da
> >         write: IOPS=3D195, BW=3D195MiB/s (205MB/s)(11.4GiB/60023msec)
> >
> >     # fio -filename=3D/testfile -direct=3D1 -ioengine=3Dlibaio -rw=3Dwr=
ite -bs=3D1m
> >     -size=3D76G -runtime=3D60 -numjobs=3D10 -group_reporting -name=3Da
> >         write: IOPS=3D1622, BW=3D1622MiB/s (1701MB/s)(95.1GiB/60042msec=
)
> >
> >     # fio -filename=3D/testfile -direct=3D1 -ioengine=3Dlibaio -rw=3Dwr=
ite -bs=3D1m
> >     -size=3D76G -runtime=3D300 -numjobs=3D10 -group_reporting -name=3Da
> >         write: IOPS=3D1879, BW=3D1880MiB/s (1971MB/s)(551GiB/300004msec=
)
> >
> >
> > Ah, that numjobs value is REALLY important for the type of job file
> > you have! Using numjobs on the same filename can lead to reuse of the
> > same area (think job 1 and job 2 writing the same blocks in lockstep)
> > which may in turn lead to not all I/Os being sent down to the disk if
> > they are close enough together. This may make a nonsense of your
> > benchmark...
> >
> >     Up to numjobs =3D about 10, it increases in proportion to the value=
 of
> >     numjobs.
> >
> > --
> > Sitsofe
>
> Hi.
>
>
> Now I tried, but these had the same results.
>    (twice as much as numjobs=3D1)
> -filename=3D/mnt/test1:/mnt/test2
> -filename=3D/dev/sdb  (after umount /mnt)
>
> # fio -filename=3Dxxx -direct=3D1 -ioengine=3Dlibaio -rw=3Dwrite -bs=3D1m=
 -size=3D8G
> -runtime=3D60 -numjobs=3D2 -group_reporting -name=3Da
>
>
> Using -directory instead of -filename is only way to get correct result?

That would work but it depends on what "correct" means :-) The problem
with your jobs above is that you have not eliminated the possibility
of two or more jobs still writing the same area at the same time (the
colon syntax in filename just tells fio it might have to pick a
different file to last time - see
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-file-servic=
e-type
further info). If all jobs are switching files in lockstep on each I/O
what is stopping collisions?

I'll illustrate the original scenario but simplified a bit:

job1: | 0 | 1 | 2 | ...
job2: | 0 | 1 | 2 | ...

Time is flowing from left to right and the numbers represent the LBA
being written within a given period. In this case in the first
"instant" LBA 0 is being written twice, LBA 1 is being written twice
in the second instant and LBA 2 is being written twice in the third
instant. Sending a write for an LBA that still has an incomplete
in-flight write against it typically results in unspecified behaviour
- we just don't know what sort of "optimisations" might kick in
because we've created a scenario where we've told the system we can't
care about the result of every write...

Ideas for how to avoid getting into the above scenario with numjobs:
- Have each job work with a *different* file to any other job so they
can't collide. As you suggest you can use directory and let fio make
up the filename so each job is working on a seperate file (filename
must NOT be set!).
- Have each job work on a different part of the same "file" so they
can't collide. This requires some sort of partitioning and if you
choose to do this size
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-size
) and offset_increment
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset-inc=
rement
) may help. Obviously each "region" shouldn't be too small but you get
the idea.

I don't know your circumstances but a part of me wonders if it would
have been easier to just increase iodepth and stick a single job to
get increased simultaneous I/O.

--
Sitsofe

