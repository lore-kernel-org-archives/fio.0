Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhCQNCb (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Mar 2021 09:02:31 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6B4C06174A
        for <fio@vger.kernel.org>; Wed, 17 Mar 2021 06:02:31 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t9so1725302wrn.11
        for <fio@vger.kernel.org>; Wed, 17 Mar 2021 06:02:31 -0700 (PDT)
Received: from hub ([2a01:e34:edac:750:748e:da45:5a36:ca07])
        by smtp.gmail.com with ESMTPSA id z1sm25271118wru.95.2021.03.17.06.02.27
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 06:02:27 -0700 (PDT)
Date: Wed, 17 Mar 2021 14:02:25 +0100
From: Johann Lombardi <johann.lombardi@gmail.com>
Subject: Re: pthread_condattr_setclock: Invalid argument
Message-ID: <20210317130225.GA385833@hub>
References: <20210316172436.GA380295@hub>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316172436.GA380295@hub>
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Looking at the logs, it sounds like the pthread_condattr_setclock
configure check now passes on appveyor/msys2 while it used to fail before.
Then pthread_condattr_setclock(CLOCK_MONOTONIC) fails with EINVAL on
this platform. Shall we just force pthread_condattr_setclock to no on
cygwin?

Johann

On Tue, Mar 16, 2021 at 06:24:36PM +0100, Johann Lombardi wrote:
> Hi there,
> 
> While rebasing PR #1189 (DFS engine) against latest master, I ran into
> the following CI failure on appveyor/msys2:
> 
> make.exe test
> ./fio --minimal --thread --exitall_on_error --runtime=1s --name=nulltest --ioengine=null --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifyfstest --filename=fiotestfile.tmp --unlink=1 --rw=write --verify=crc32c --verify_state_save=0 --size=16K
> pthread_condattr_setclock: Invalid argument
> pthread_condattr_setclock: Invalid argument
> smalloc: failed adding pool
> Assertion failed: i, file smalloc.c, line 235
> make: *** [Makefile:622: test] Error 3
> Command exited with code 2
> 
> https://ci.appveyor.com/project/axboe/fio/builds/38248012/job/kk740eysg1bd1om9
> 
> It seems to have been introduced by a recent commit. Any thoughts?
> 
> Cheers,
> Johann

