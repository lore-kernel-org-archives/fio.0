Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239065AbhCPRYm (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 Mar 2021 13:24:42 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5B8C06174A
        for <fio@vger.kernel.org>; Tue, 16 Mar 2021 10:24:41 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o16so7846947wrn.0
        for <fio@vger.kernel.org>; Tue, 16 Mar 2021 10:24:41 -0700 (PDT)
Received: from hub ([2a01:e34:edac:750:4d78:fa77:4b3b:aa80])
        by smtp.gmail.com with ESMTPSA id l21sm44032wmg.41.2021.03.16.10.24.39
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 10:24:39 -0700 (PDT)
Date: Tue, 16 Mar 2021 18:24:36 +0100
From: Johann Lombardi <johann.lombardi@gmail.com>
Subject: pthread_condattr_setclock: Invalid argument
Message-ID: <20210316172436.GA380295@hub>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi there,

While rebasing PR #1189 (DFS engine) against latest master, I ran into
the following CI failure on appveyor/msys2:

make.exe test
./fio --minimal --thread --exitall_on_error --runtime=1s --name=nulltest --ioengine=null --rw=randrw --iodepth=2 --norandommap --random_generator=tausworthe64 --size=16T --name=verifyfstest --filename=fiotestfile.tmp --unlink=1 --rw=write --verify=crc32c --verify_state_save=0 --size=16K
pthread_condattr_setclock: Invalid argument
pthread_condattr_setclock: Invalid argument
smalloc: failed adding pool
Assertion failed: i, file smalloc.c, line 235
make: *** [Makefile:622: test] Error 3
Command exited with code 2

https://ci.appveyor.com/project/axboe/fio/builds/38248012/job/kk740eysg1bd1om9

It seems to have been introduced by a recent commit. Any thoughts?

Cheers,
Johann

