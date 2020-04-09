Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f49.google.com ([209.85.166.49]:44023 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgDIKVR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Apr 2020 06:21:17 -0400
Received: by mail-io1-f49.google.com with SMTP id u2so3278467iop.10
        for <fio@vger.kernel.org>; Thu, 09 Apr 2020 03:21:17 -0700 (PDT)
MIME-Version: 1.0
From: Hselin Chen <hselin.chen@gmail.com>
Date: Thu, 9 Apr 2020 03:21:05 -0700
Message-ID: <CAMHtQmOvnJ-Unsc7V3RTh1NxXNqJ74H2g7bHNrsaRE764mjU4A@mail.gmail.com>
Subject: Clarification on FIO verify bad header answer
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Sitsofe,

You wrote the following answer for a question on bad header
verification back in Jan 15th of this year.
I have a follow-up question on why numjobs > 1 would create
interference with each other - doesn't each job write to their own
file?
Apologies in advance for the rudimentary question.

Thanks!
Albert

=3D=3D=3D=3D=3D=3D=3D

Re: FIO verify bad header question

Hi,

On Wed, 15 Jan 2020 at 15:32, Jens Axboe <axboe@xxxxxxxxx> wrote:
>
> Please use the fio list for this, CC'ed.
>
> On 1/15/20 8:28 AM, Michael Chichik wrote:
> >
> > */usr/bin/fio --time_based --runtime=3D1d --ioengine=3Dlibaio --iodepth=
=3D32 --rw=3Drandrw --bs=3D24k --direct=3D0 --io_size=3D60G --numjobs=3D10 =
--size=3D1G --rwmixread=3D0 --verify=3Dmd5 --verify_fatal=3D1 --output-form=
at=3Djson --output=3D4_randrw_0_10_32_libaio_xfs_1G.json --directory /mnt/t=
est-vol-23206-36 --name host1_test-vol-23206-36

^^^numjobs=3D10 will mean all the jobs are working inside the same
region. Because you're using randrw it's likely each job will write
blocks in a different sequence to other jobs.

> > *
> > FIO failed with the following error:
> > *
> > *
> > *verify: bad header rand_seed 1089408830752521594, wanted 7280637923435=
198810 at file /mnt/test-vol-23206-36/filename offset 776945664, length 245=
76

This means job 2 can interfere with the writes of job 1 so when job
one comes to do a verify it can't find the blocks written by itself
(because it may find job 2's data). If you're going to use numjobs I'd
strongly look into use offset_increment
(https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-offset-inc=
rement
) and size (https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg=
-size
) to ensure each job is working within a different region to any other
job.

