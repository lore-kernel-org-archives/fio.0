Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE380C3DA79
	for <fio@archiver.kernel.org>; Thu, 29 Dec 2022 21:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiL2Vvz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 29 Dec 2022 16:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbiL2Vvy (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Dec 2022 16:51:54 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D601572B
        for <fio@vger.kernel.org>; Thu, 29 Dec 2022 13:51:53 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-14ffd3c5b15so11504867fac.3
        for <fio@vger.kernel.org>; Thu, 29 Dec 2022 13:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XBxqS8yg/FRgZi36fqVHyN3AISBU9/hIZGruLnZNmfw=;
        b=fVyBGc4ScQP97XatNEcDH7lMPKgv94X5uqYz7PjqCMABsUzMwUwgeizqjPy/4Cm8Zq
         eEGugN0gOjFe/MzAq98HUdXLP+uDEYr8uB7g6ITTsl2+eA5oqaEeUpIpGrcXqEFgr1qn
         pwajbRpj2HH67eCew018orAROip2xNDWh3RpSrHDB/P9s421XfnWsvq/2FllJMu7RPYN
         aJ1XmwPpJ3Uc0zmt+OaeI8rT5JdAdgvV8Oa0L7suWhDM7WOZZn+CQdtWQfaAjxViZPMu
         7N3CqftM4gp/NOtbkKGVkvEkEI8u5ENkQQlQDlhVUUgAobQ55N1iDZIak+oaxppuQiAC
         dSaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XBxqS8yg/FRgZi36fqVHyN3AISBU9/hIZGruLnZNmfw=;
        b=gQgLbOe76Nwb9Is0ue3M8HqWulrj/xRFiB834vv6Sux0S3+JHknTovcQD/DG7G6D+R
         k9Csp78sG3DQ24mSJCl/becoddvhFc/ddayx76Eut1zOehtfhxXoyTb7t1K+TINWde8S
         YIs53z86zuv5t/3kqrxbttUOEbAn57/3uQO3VIKUaBTaPgI19VA+M9pwpuNVm4sDuZg2
         0W5ugCUyoovi9mIYlmbKP7mncaB8pQmsUCnLb3sk+a7NQ08rm533Gf3RMHhoa84c8q4N
         sfAYaV4/Lplnf9jwmYDSMDOO8kG/cm3etXuhEEQ+E/xZRlBEmk3pAp1T5sBqWDrDxVpu
         TAKg==
X-Gm-Message-State: AFqh2kolC7D31BXN9yI/Gy1yBDZTC0YPN3j/PXzQB2ePMeHM58reXU9Y
        WEmzs8Ahe2Jn0VySscgcOjW8O1q8e9jf/dJVhBN8hiNaozc=
X-Google-Smtp-Source: AMrXdXtBophg2W0zQujF8td4xcJVjGl50KmciXe7e5d7IoaGXQoPjPUf/coSz+eQm4AZ4SNohRlCbGuGTeGJkG3O44c=
X-Received: by 2002:a05:6870:cc89:b0:150:39e2:c688 with SMTP id
 ot9-20020a056870cc8900b0015039e2c688mr441283oab.287.1672350712442; Thu, 29
 Dec 2022 13:51:52 -0800 (PST)
MIME-Version: 1.0
References: <CAD5ox-FDUjeZRe9_h_2NtCOCSx2szCVnemO50GwGHa0R_PvqeA@mail.gmail.com>
 <c30865ee-71cc-150d-5952-14eb61d40b07@gmail.com> <CAD5ox-GcbKpGmJoCqcx0NM=y_ioDnokygqVu41WFy7z-A8i5Fg@mail.gmail.com>
 <078ce8d4-2080-ff5f-6b58-f157c3b21181@gmail.com>
In-Reply-To: <078ce8d4-2080-ff5f-6b58-f157c3b21181@gmail.com>
From:   M Kelly <mckelly2833@gmail.com>
Date:   Thu, 29 Dec 2022 16:51:16 -0500
Message-ID: <CAD5ox-Ejmf3gTBWvLM+CG=fKE-fkD3=rqDa9tU--rS3Gf4_vAw@mail.gmail.com>
Subject: Re: fio question
To:     Vincent Fu <vincentfu@gmail.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

ok, thanks.
I am speculating here ... the random pattern (--rw=randread) in the
threaded+rr case is not the same as separate processes - and we are
getting a lot more page-cache re-use.
But no matter, I know enough now to collect the i/o perf info we need.
TY again for fio!

take care,
-mark

On Thu, Dec 29, 2022 at 4:12 PM Vincent Fu <vincentfu@gmail.com> wrote:
>
> On 12/29/22 13:16, M Kelly wrote:
> > Hi,
> >
> > Thank you for your reply and that info, I really appreciate it.
> > One last question, if you have time -
> >
> > I incorrectly thought the cmdline options:
> >
> >      --numjobs=8 --filename=1:2:3:4:5:6:7:8 --size=X (or perhaps --filesize=X)
> >
> > would have each of the 8 threads doing i/o independently and concurrently.
> >
> > Q: Is there a way to use a single command-line to get X threads doing
> > i/o in parallel to separate files that it is similar to my 8 separate
> > cmdlines ?
> >
> > thx again, and wishing you a happy 2023
> > -mark
> >
>
> Oh, I missed that in your original message. numjobs=8 will create 8
> independent jobs that read from the 8 files in a round robin fashion. I
> would still expect performance to differ from 8 jobs reading from
> separate files.
>
> > On Thu, Dec 29, 2022 at 9:28 AM Vincent Fu <vincentfu@gmail.com> wrote:
> >>
> >> On 12/27/22 18:50, M Kelly wrote:
> >>> Hi,
> >>>
> >>> Thank you for fio.
> >>> Apologies if this is the wrong place to ask.
> >>>
> >>> I am running fio on a laptop with an nvme ssd and have a question
> >>> about differences between results.
> >>>
> >>> test.1 - test.8 are each 900 Mb files of random data created beforehand
> >>>
> >>> run 1 -
> >>>
> >>> echo 3 | sudo tee /proc/sys/vm/drop_caches
> >>>
> >>> fio --name=fiotest
> >>> --filename=test.1:test.2:test.3:test.4:test.5:test.6:test.7:test.8
> >>> -gtod_reduce=1 --size=900M --rw=randread --bs=8K --direct=0
> >>> --numjobs=8 --invalidate=0 --ioengine=psync
> >>>
> >>> results:
> >>>
> >>>      iops        : min= 6794, max=86407, avg=26989.80, stdev=33609.35, samples=5
> >>>      iops        : min= 6786, max=84998, avg=26818.40, stdev=32972.35, samples=5
> >>>      iops        : min= 6816, max=83273, avg=26422.20, stdev=32200.02, samples=5
> >>>      iops        : min= 6838, max=88227, avg=27462.20, stdev=34405.56, samples=5
> >>>      iops        : min= 6868, max=85788, avg=26870.00, stdev=33332.10, samples=5
> >>>      iops        : min= 6818, max=84768, avg=26719.60, stdev=32880.23, samples=5
> >>>      iops        : min= 6810, max=86326, avg=27005.60, stdev=33581.89, samples=5
> >>>      iops        : min= 6856, max=81411, avg=26165.00, stdev=31345.85, samples=5
> >>>      READ: bw=2644MiB/s (2773MB/s), 331MiB/s-332MiB/s (347MB/s-348MB/s),
> >>> io=7200MiB (7550MB), run=2709-2723msec
> >>>
> >>> run 2 -
> >>>
> >>> echo 3 | sudo tee /proc/sys/vm/drop_caches
> >>>
> >>> fio --name=fiotest1 --filename=test.1 -gtod_reduce=1 --size=900M
> >>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> >>> --ioengine=psync &
> >>> fio --name=fiotest2 --filename=test.2 -gtod_reduce=1 --size=900M
> >>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> >>> --ioengine=psync &
> >>> fio --name=fiotest3 --filename=test.3 -gtod_reduce=1 --size=900M
> >>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> >>> --ioengine=psync &
> >>> fio --name=fiotest4 --filename=test.4 -gtod_reduce=1 --size=900M
> >>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> >>> --ioengine=psync &
> >>> fio --name=fiotest5 --filename=test.5 -gtod_reduce=1 --size=900M
> >>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> >>> --ioengine=psync &
> >>> fio --name=fiotest6 --filename=test.6 -gtod_reduce=1 --size=900M
> >>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> >>> --ioengine=psync &
> >>> fio --name=fiotest7 --filename=test.7 -gtod_reduce=1 --size=900M
> >>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> >>> --ioengine=psync &
> >>> fio --name=fiotest8 --filename=test.8 -gtod_reduce=1 --size=900M
> >>> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> >>> --ioengine=psync &
> >>> wait
> >>>
> >>> results (from each) -
> >>>
> >>>     iops        : min= 5836, max= 6790, avg=6481.37, stdev=140.90, samples=35
> >>>     READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
> >>> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17777-17777msec
> >>>     iops        : min= 5924, max= 6784, avg=6476.54, stdev=126.85, samples=35
> >>>     READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
> >>> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17785-17785msec
> >>>     iops        : min= 5878, max= 6766, avg=6475.23, stdev=138.57, samples=35
> >>>     READ: bw=50.6MiB/s (53.0MB/s), 50.6MiB/s-50.6MiB/s
> >>> (53.0MB/s-53.0MB/s), io=900MiB (944MB), run=17792-17792msec
> >>>     iops        : min= 5866, max= 6788, avg=6478.74, stdev=139.18, samples=35
> >>>     READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
> >>> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17782-17782msec
> >>>     iops        : min= 5890, max= 6782, avg=6477.91, stdev=135.21, samples=35
> >>>     READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
> >>> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17783-17783msec
> >>>     iops        : min= 5838, max= 6790, avg=6450.11, stdev=137.17, samples=35
> >>>     READ: bw=50.3MiB/s (52.7MB/s), 50.3MiB/s-50.3MiB/s
> >>> (52.7MB/s-52.7MB/s), io=900MiB (944MB), run=17892-17892msec
> >>>     iops        : min= 5922, max= 6750, avg=6454.06, stdev=125.76, samples=35
> >>>     READ: bw=50.3MiB/s (52.8MB/s), 50.3MiB/s-50.3MiB/s
> >>> (52.8MB/s-52.8MB/s), io=900MiB (944MB), run=17880-17880msec
> >>>     iops        : min= 5916, max= 6724, avg=6465.94, stdev=127.54, samples=35
> >>>     READ: bw=50.5MiB/s (52.0MB/s), 50.5MiB/s-50.5MiB/s
> >>> (52.0MB/s-52.0MB/s), io=900MiB (944MB), run=17816-17816msec
> >>>
> >>> Question: if I am really doing 900 MiB of random reads from 8 separate
> >>> files in both tests, and the page-cache was empty before each test,
> >>> does this difference in performance make sense or am I reading the
> >>> results incorrectly ?
> >>>
> >>> thank you for any info/ advice, suggestions,
> >>> -mark
> >>
> >>
> >> Your first test directs fio to create a single job that reads from the
> >> files in a round robin fashion.
> >>
> >> The second test has eight independent jobs reading separately from the
> >> eight files as fast as they can.
> >>
> >> It's not a surprise that the results are different.
> >>
> >> Vincent
>
