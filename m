Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgDVURU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Apr 2020 16:17:20 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3CFC03C1A9
        for <fio@vger.kernel.org>; Wed, 22 Apr 2020 13:17:20 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 188so3938841wmc.2
        for <fio@vger.kernel.org>; Wed, 22 Apr 2020 13:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAH8AYr4Boyh=1r9f96Qf66htO=oUET4RyiwiE0ZC=ZoOELzjDw@mail.gmail.com>
In-Reply-To: <CAH8AYr4Boyh=1r9f96Qf66htO=oUET4RyiwiE0ZC=ZoOELzjDw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 22 Apr 2020 21:16:53 +0100
Message-ID: <CALjAwxjv7PEsgBWR4qNmaRegXDbhscTkFC8MikN4egBX3p5KSw@mail.gmail.com>
Subject: Re: Write and verify
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: KaiKai Chen <fast.marmot@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Wed, 22 Apr 2020 at 08:24, KaiKai Chen <fast.marmot@gmail.com> wrote:
>
> I have some basic questions:
>
> 1. Is following a correct understanding?
> If time_based is not set and nrfiles = 1 and size = 1GB.
> A sequential write job will write 1GB worth of data and create a
> "solid" 1GB file (writes will cover all file blocks).

Assuming no errors and the "file" doesn't have an immutable smaller size.

> A random write job with norandommap = 0 will write 1GB worth of data
> and create a "solid" 1GB file (writes will cover all file blocks).

Same caveat as above yes (the file will actually be preallocated
before I/O is done (at least on Linux)).

> A random write job with norandommap = 1 will write 1GB worth of data
> and create a 1GB file with potential "holes"  (some file blocks may
> not be written).

Due to preallocation (see above) the file may not have holes in the
"sparse file" sense. But yes, some areas of the file (if it didn't
already exist at the right size and we're talking about a file in a
filesystem etc) likely won't be written by the main job (I think they
would contain zeros).

> 2. Is the following a valid usage of fio's write and verify capabilities?
> If so, is it possible to add "time_based" and "runtime" parameters to
> the write-job and still expect verify-job to function correctly (i.e.
> verify data that was written within runtime)?

If you use time_based and verify then the initial writes just use up
all the time and there's no time for the verify (I think fio prints a
warning in that circumstance).

> Also, does "verify_only=1" mean the verify-job's "rw" parameter is
> ignored? (suppose we've written sequentially, but want to verify the
> data through random or sequential reads)
> https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-verify-only
> mentioned that "verify_only" flag "Do not perform specified workload,
> only verify data still matches previous invocation of this workload."

No but it does mean the initial "phase" of the job is skipped. If you
have say rw=write verify=crc32c then the writes happen and then once
the write phase is over fio switches to a verify phase. If you do
rw=write verify=crc32c verfy_only=1 then the write phase is skipped
and it goes straight into trying to verify the data in the file.

>
> [write-job]
> ioengine=libaio
> bs=4K
> size=1GB
> numjobs=2
> iodepth=64
> rw=randwrite
> direct=1
> verify_state_save=1
> verify=crc32c
> do_verify=0
> serialize_overlap=1
>
> [verify-job]
> ioengine=libaio
> bs=4K
> size=1GB
> numjobs=2
> verify_state_load=1
> verify_only=1
> iodepth=64
> rw=randread
> direct=1
> verify=crc32c
>
> Thanks!

The above job file may not work as expected because the filenames
chosen by the verify-job, er, jobs likely won't match those used for
the write-job jobs - take a look at the files in the current working
directory when that finishes to see what I mean.

-- 
Sitsofe | http://sucs.org/~sits/

