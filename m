Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f52.google.com ([209.85.128.52]:56272 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgDJHmp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Apr 2020 03:42:45 -0400
Received: by mail-wm1-f52.google.com with SMTP id e26so1626673wmk.5
        for <fio@vger.kernel.org>; Fri, 10 Apr 2020 00:42:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAMHtQmOvnJ-Unsc7V3RTh1NxXNqJ74H2g7bHNrsaRE764mjU4A@mail.gmail.com>
In-Reply-To: <CAMHtQmOvnJ-Unsc7V3RTh1NxXNqJ74H2g7bHNrsaRE764mjU4A@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 10 Apr 2020 08:42:17 +0100
Message-ID: <CALjAwxgveTU4AA6p6pAtNmdBt=k3JSZrQrfo_Xqt+uBj5rUc=Q@mail.gmail.com>
Subject: Re: Clarification on FIO verify bad header answer
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Hselin Chen <hselin.chen@gmail.com>
Cc: fio <fio@vger.kernel.org>, Michael Chichik <michael.c@excelero.com>

Hi Hselin,

On Thu, 9 Apr 2020 at 11:21, Hselin Chen <hselin.chen@gmail.com> wrote:
>
> Hi Sitsofe,
>
> You wrote the following answer for a question on bad header
> verification back in Jan 15th of this year.
> I have a follow-up question on why numjobs > 1 would create
> interference with each other - doesn't each job write to their own
> file?

True, re-reviewing the job I would have expected that job to create 10
different files (so you're correct and I think I mentally assumed
filename was being set). However, looking closer it seems something
strange is going on:

> *verify: bad header rand_seed 1089408830752521594, wanted 728063792343519=
8810 at file /mnt/test-vol-23206-36/filename offset 776945664, length 24576

Why does the error message say /mnt/test-vol-23206-36/filename (note
the last component of the path)? If each job is working on a different
file I would expect the problem file to have more numbers etc at the
end of it... In fact, I wouldn't expect it to have the word "filename"
in it at all (unless you were setting `--filename` or playing with
filename_format -
https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-filename-fo=
rmat
) so I wonder whether there was something extra left out of the
original job description...


> Apologies in advance for the rudimentary question.
>
> Thanks!
> Albert
>
> =3D=3D=3D=3D=3D=3D=3D
>
> Re: FIO verify bad header question
>
> Hi,
>
> On Wed, 15 Jan 2020 at 15:32, Jens Axboe <axboe@xxxxxxxxx> wrote:
> >
> > Please use the fio list for this, CC'ed.
> >
> > On 1/15/20 8:28 AM, Michael Chichik wrote:
> > >
> > > */usr/bin/fio --time_based --runtime=3D1d --ioengine=3Dlibaio --iodep=
th=3D32 --rw=3Drandrw --bs=3D24k --direct=3D0 --io_size=3D60G --numjobs=3D1=
0 --size=3D1G --rwmixread=3D0 --verify=3Dmd5 --verify_fatal=3D1 --output-fo=
rmat=3Djson --output=3D4_randrw_0_10_32_libaio_xfs_1G.json --directory /mnt=
/test-vol-23206-36 --name host1_test-vol-23206-36
>
> ^^^numjobs=3D10 will mean all the jobs are working inside the same
> region. Because you're using randrw it's likely each job will write
> blocks in a different sequence to other jobs.
>
> > > *
> > > FIO failed with the following error:
> > > *
> > > *
> > > *verify: bad header rand_seed 1089408830752521594, wanted 72806379234=
35198810 at file /mnt/test-vol-23206-36/filename offset 776945664, length 2=
4576
>
> This means job 2 can interfere with the writes of job 1 so when job
> one comes to do a verify it can't find the blocks written by itself
> (because it may find job 2's data). If you're going to use numjobs I'd
> strongly look into use offset_increment
> (https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-offset-i=
ncrement
> ) and size (https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-a=
rg-size
> ) to ensure each job is working within a different region to any other
> job.

--
Sitsofe | http://sucs.org/~sits/

