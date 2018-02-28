Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:45454 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934866AbeB1QPr (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Feb 2018 11:15:47 -0500
Received: by mail-ua0-f178.google.com with SMTP id z3so1873513uae.12
        for <fio@vger.kernel.org>; Wed, 28 Feb 2018 08:15:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <000101d3b070$6b165dd0$41431970$@163.com>
References: <000801d3afb8$1ffb6a10$5ff23e30$@163.com> <CALjAwxgYcdTe68JPjo6fJHOYc=nD_Tb8Tyd995D1ONbQx3Lvjg@mail.gmail.com>
 <000101d3b070$6b165dd0$41431970$@163.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 28 Feb 2018 16:15:16 +0000
Message-ID: <CALjAwxid8oNmnwg98UNghod6jV2cKW7X_N+JOGtJu4k0ghWihw@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E7=AD=94=E5=A4=8D=3A_How_to_ensure_split_verification_will_ge?=
        =?UTF-8?Q?nerate_the_same_configs_as_write_phase=3F?=
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vaughan <cxt9401@163.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 28 February 2018 at 08:44, Vaughan <cxt9401@163.com> wrote:
>
>> The  randseed is the same across different invocations of fio unless you say otherwise (see randrepeat - http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-randrepeat
>> ). So even if you weren't using a verification state file you will re-generate the same pattern if the rest of the job is the same.
> Thank you for the explanation. A deep question about the seed comes:) Though randseed is the same across different invocation of fio, is it different for different sections in one job file?

> I made another job file as below:
> myjob.fio:
>         [global]
>         bs=4k
>         direct=1
>         ioengine=sync
>         verify=crc32c
>         filename=/dev/sdf
>         io_size=10k

^^^ Note that io_size may create a potential issue - we're not
necessarily going to complete a total loop (e.g. /dev/sdf is bigger
than 10k) and the second job may not be aware we stopped the first job
part way. In the issue you linked
(https://github.com/axboe/fio/issues/468#issuecomment-332828729 ) the
reporter was asking something similar (although with triggers).

>         [write-phase]
>         rw=randwrite
>         do_verify=0
>         write_iolog=iolog
>
>         [verify-phase]
>         stonewall
>         rw=randread
>         do_verify=1
>
> I think these two sections have the same settings except the date direction. So I expect the later one can verify the write-phase. But it failed.
> run it with --debug, and found the offset generated are not the same, so verify abort with error for the first time, as below:
>         random   24382 off rand 259043585
>         io       24382 fill_io_u: io_u 0x25ad740: off=71233536/len=4096/ddir=1//dev/sdf
>         random   24382 off rand 3179521932
>         io       24382 fill_io_u: io_u 0x25ad740: off=874364928/len=4096/ddir=1//dev/sdf
>         random   24382 off rand 3621444214
>         io       24382 fill_io_u: io_u 0x25ad740: off=995893248/len=4096/ddir=1//dev/sdf
>         random   24388 off rand 1094293889
>         io       24388 fill_io_u: io_u 0x25ad500: off=300929024/len=4096/ddir=0//dev/sdf
> You can see [24382] is write-phase and [24388] is verify-phase, and the first round of them use different seed I suppose.
>
> I search in the source code, and found the following snippet:
>         static int setup_random_seeds(struct thread_data *td)
>         {
>         ...
>                         for (i = 0; i < FIO_RAND_NR_OFFS; i++) {
>                                         td->rand_seeds[i] = seed * td->thread_number + i;
>                                         seed *= 0x9e370001UL;
>                         }
>
> Is td->thread_number different for different sections? I thought they both equal to 1 before.

It looks that way - it seems like thread_number is incremented for each job in
get_new_job() so this would affect the random seeds generated in
different sections of the same job file.

Note that because you're verifying by header and via a separate job I
believe fio checks the header in the current block and if it looks
intact it then uses that to regenerate the data in the rest of the
block. You can get just about away with this when you're writing and
verifying the entirety of the file with fixed block sizes but I think
what you've pointed out will make jobs like:

fio --stonewall --verify=crc32c --size=24k --bsrange=512-4k
--filename=/tmp/fio.tmp --name=write-phase --rw=randwrite
--do_verify=0 --name=verify-phase --rw=randread --do_verify=1

fail because the random ordering of block sizes now depends on the job
number too.

> Later, I realize split verify using two sections in one file is not a formal way? Is it better to just write only one write section, and use 'fio --verify-only jobfile' to do the split verification as the updated one below?

That does look like it will be more robust and will also allow you to
use a state file if you wanted too.

-- 
Sitsofe | http://sucs.org/~sits/
