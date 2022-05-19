Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AFAC433F5
	for <fio@archiver.kernel.org>; Thu, 19 May 2022 01:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiESBRE convert rfc822-to-8bit (ORCPT
        <rfc822;fio@archiver.kernel.org>); Wed, 18 May 2022 21:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiESBQ6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 May 2022 21:16:58 -0400
Received: from submit-01.torproject.org (submit-01.torproject.org [116.202.120.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCEA66222
        for <fio@vger.kernel.org>; Wed, 18 May 2022 18:16:55 -0700 (PDT)
Received: from localhost (localhost [::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: anarcat)
        by submit-01.torproject.org (Postfix) with ESMTPSA id 4018180124;
        Thu, 19 May 2022 01:16:53 +0000 (UTC)
Received: by angela.anarc.at (Postfix, from userid 1000)
        id 9E8A6AC0AB; Wed, 18 May 2022 21:16:50 -0400 (EDT)
From:   =?utf-8?Q?Antoine_Beaupr=C3=A9?= <anarcat@torproject.org>
To:     Vincent Fu <vincent.fu@samsung.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: running jobs serially
In-Reply-To: <ab0612e1ab8a40aaa8d6eaed69c5985b@samsung.com>
Organization: Tor
References: <CGME20220518195544uscas1p2df5012297be87e1151c9b1f2ea33ff01@uscas1p2.samsung.com>
 <87pmkaeicg.fsf@curie.anarc.at>
 <ab0612e1ab8a40aaa8d6eaed69c5985b@samsung.com>
Date:   Wed, 18 May 2022 21:16:50 -0400
Message-ID: <87tu9mqq2l.fsf@angela.anarc.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2022-05-18 22:41:24, Vincent Fu wrote:
> The jobs you are running have the *stonewall* option which should make them run
> serially unless something is very broken.

Yeah, so that's something I added deliberately for that purpose, but two
things make me think it's not working properly.

 1. the timestamps are identical for the two jobs

        randwrite-4k-4g-1x: (groupid=1, jobs=1): err= 0: pid=1033477: Wed May 18 15:41:04 2022
         randread-4k-4g-1x: (groupid=0, jobs=1): err= 0: pid=1033470: Wed May 18 15:41:04 2022

 2. when fio starts, it says:

         Starting 2 processes

    i would have expected it to start one process at a time

 3. when running larger batches, it starts laying out all files before
    starting the jobs:

$ fio ars.fio
randread-4k-4g-1x: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=1
randwrite-4k-4g-1x: (g=1): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=1
randread-64k-256m-16x: (g=2): rw=randread, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB, (T) 64.0KiB-64.0KiB, ioengine=posixaio, iodepth=16
...
randwrite-64k-256m-16x: (g=3): rw=randwrite, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB, (T) 64.0KiB-64.0KiB, ioengine=posixaio, iodepth=16
...
randread-1m-16g-1x: (g=4): rw=randread, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
randwrite-1m-16g-1x: (g=5): rw=randwrite, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.25
Starting 36 processes
randread-4k-4g-1x: Laying out IO file (1 file / 4096MiB)
randwrite-4k-4g-1x: Laying out IO file (1 file / 4096MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randwrite-64k-256m-16x: Laying out IO file (1 file / 256MiB)
randread-1m-16g-1x: Laying out IO file (1 file / 16384MiB)
[...]

I would have expected those files to be "laid" right before each job
starts, not all at once, in the beginning, although I'm not sure what
difference that would make. Maybe it would save disk space, at least?
Say if I have limited space left on the partition and I want to run
multiple large jobs, I'd expect each job to collect after itself..

> Here is documentation for the stonewall option:
>
> https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-stonewall

Speaking of which, it's not clear to me if I need to add stonewall to
each job or if I can just add it to the top-level global options and be
done with it...

> You could add the write_bw_log=filename and log_unix_epoch=1 options to
> confirm. You should see a timestamp for each IO and should be able to make
> sure that all the writes are happening after the reads.

So I tried this, and it's a little hard to figure out the output. But
looking at:

    head -1 $(ls *bw*.log -v)

it does look like the first line is incrementing and tests are not run
in parallel.

So maybe the bug is *just* 1 and 2: (1) the timestamps in the final
report are incorrect, and (2) processes are all started at once (and 1
may be related to 2!)

Does that make sense?

Thanks for the quick response!

-- 
Antoine Beaupré
torproject.org system administration
