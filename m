Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1554C433F5
	for <fio@archiver.kernel.org>; Fri, 28 Jan 2022 23:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245608AbiA1XJh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Jan 2022 18:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243573AbiA1XJh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Jan 2022 18:09:37 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34172C061714
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 15:09:37 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id b5so6515886qtq.11
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 15:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29oTknzxjm/zbcKzYVkhlKUGhhcAuCUnDcTnKdQMMKI=;
        b=pJLY4PLHC/5NQ5Dv1HGbqIbv4XjuKbHdgkNUzngtaRtdkJVspoiipuToDWuh0H52/X
         PsOPB4KpbqvrBC3FmRxeYp9f+/Y52kp6Gly5pnH7s8XhJZNuiFlYLMDitt89sHA/fUVT
         8CM9iZnUVniwMwdsTwWuOkjMAkHh1z6lQopEBK0Yt9XHiHwBN3oWlNjk7cl6X7K/qi/6
         lK4LTMjU04efafKk7+X9NIq+15cggjQBSMhRvFucRfGaLG/CeBwWimJwYy642pFRP/A7
         NggicwyiKX/oCYuYNzW/FYMKJJYV0ZnuGQ2NbdNCtqzFRwkyWW1uKp/3geKLVLjC3+hA
         5VwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29oTknzxjm/zbcKzYVkhlKUGhhcAuCUnDcTnKdQMMKI=;
        b=Ymb9LUmh4ATvDdeoSq2R1/moUm/in2lcBdiurjYubuaT3uHeceg8Wd32sFL2HylOSf
         d6L5kyx7ON3J0ho+uoRPaMmI7ziVddfpseFNs6Q1UDVjVkezekHVcCew0asWRIdeJ0TH
         ZguJFLOR26PevM8VYYt9cH/yRjJFdM49MWT3crVp9ULiFNlmZrPVMx28ohyhALl7JCtX
         y00widywmUhAHtdhFw+HkQT4G1XcpI7hIR1o2UDVO8SdhM0Jstu8A0S/P/Ij6HemtL58
         9acksouwRtYe1XTEXzjdeLmDQHPkc572GgWYsp34mIgeE2EuUYyzkix6SU5dreos/Hu+
         NMkQ==
X-Gm-Message-State: AOAM533+OsNqbTNBaSAh0ezSdr//6qVkF9rIOQXwtKlZ4aSrrM1NRm+m
        jjeUY10F7K8rLjQGmZC+HLfL/JkSxBc42jDQe67OSQ==
X-Google-Smtp-Source: ABdhPJzBFpkzpf3t66+TgV9uzIVTAQCYykDQmRDoLOnaQLnRDr4Ea2tH0d1C2GkpYTVcYD3+3pF/Rv4H+AMayPMFVfg=
X-Received: by 2002:ac8:7f09:: with SMTP id f9mr3055550qtk.143.1643411375958;
 Fri, 28 Jan 2022 15:09:35 -0800 (PST)
MIME-Version: 1.0
References: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
 <5f2cbacd-16dc-bc98-3bcb-24a24f160476@criteo.com> <CADqNVTpO8MeB0A_Xa_rTkCXmYNr-nKAq8kcW6pbMXjxy0T0igA@mail.gmail.com>
In-Reply-To: <CADqNVTpO8MeB0A_Xa_rTkCXmYNr-nKAq8kcW6pbMXjxy0T0igA@mail.gmail.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Fri, 28 Jan 2022 17:09:23 -0600
Message-ID: <CADqNVTo=dXoFtnR0x-NnB4ui-J=r3fbh08OnJmAkeZg5Sd9heQ@mail.gmail.com>
Subject: Re: A fio job that just waits?
To:     Erwan Velu <e.velu@criteo.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Jan 28, 2022 at 11:11 AM Nick Neumann <nick@pcpartpicker.com> wrote:
> Oooh, that looks really nice, and so flexible too. I will definitely
> give it a try. On linux I'm running ubuntu 20 so it's an older version
> of fio by default, but I can definitely deal with that. I'm also
> running fio on windows too though, so unfortunately it doesn't help
> there yet.
>
> Thanks very much for pointing me to this.

Your pointer to the exec engine got me to look more carefully at the
other engines. While not nearly as extensible or pure, there is the
"cpuio" ioengine. Setting its cpuload to 1 and making a time_based job
with desired runtime seems to work pretty well. I was hopeful it would
work on windows as well. While a cpuio task runs fine on windows,
there is something wrong when you try to run a task after it. For
example, running this:

time sudo fio --ioengine=libaio --direct=1 --filename=/dev/nvme1n1
--rw=write --iodepth=16 --bs=128k --name=job1 --size=15GB
--runtime=10s --time_based --name=job2 --ioengine=cpuio --cpuload=1
--runtime=5s --time_based --wait_for=job1 --name=job3 --size=15GB
--runtime=10s --time_based --wait_for=job2

does exactly what I expect on linux. 10 seconds of write for job 1,
then 5 seconds of idle for job 2, then 10 seconds of write for job 3.
Total runtime 25 seconds. But the equivalent on windows (just changing
the global ioengine and filename):

.\fio.exe --thread --ioengine=windowsaio
--filename='\\.\PhysicalDrive1' --rw=write --iodepth=16 --bs=128k
--name=job1 --size=15GB --runtime=10s --time_based --name=job2
--ioengine=null --size=1GB --runtime=5s --time_based --wait_for=job1
--name=job3 --size=15GB --runtime=10s --time_based --wait_for=job2

finishes and never even starts job3. Total runtime 15 seconds.

It seems to be something with the cpuio option, because changing it to
the null engine with --size=1GB gives the expected idle delay (but
pollutes logs/stats with job2 which doesn't really write).

Also, just examining the code in backend.c, it indeed looks like
startdelay is evaluated based on time since fio began, not since the
job itself became eligible to run due to a wait_for finishing..
