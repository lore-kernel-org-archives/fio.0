Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 715B0ECAAA2
	for <fio@archiver.kernel.org>; Sun, 28 Aug 2022 21:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiH1VBo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 28 Aug 2022 17:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH1VBn (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 28 Aug 2022 17:01:43 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CFF65E3
        for <fio@vger.kernel.org>; Sun, 28 Aug 2022 14:01:43 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id n4so2447227qvt.7
        for <fio@vger.kernel.org>; Sun, 28 Aug 2022 14:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=OUrdivJkoYB2fB7kXFTOvwPf7AACar9uuHWWf2Czt6I=;
        b=ARntHwZbUP1Zvyva/qhXpdwjcbGSUmll4wHuFQJmxpxDIhZ7MRA9lOmlg993od7HQI
         4Zcj6QyjARteuJ2z72c1gsimY1zQQSaN2VRj162RCDiY+89AztrgFItaYK+jbDAp7IPJ
         b+/VgIruME785czp5NxFB1M/ff3gfMsPMTLL3IBEjfXJLl1GuYi61Cxkolz4mMksXvBj
         ebQqfZFRpb33W1n7mObL35VWdtiw286DJu4ok4o2yovS55WFMALYfGSp3hkQJoKCSw2W
         kNUN7LRyPFW8EiDj9KjnuRJ742mZQFyvdGOSW/Ti7GBdLgDTA9eC6GutnatOVWeFKpLB
         HoNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=OUrdivJkoYB2fB7kXFTOvwPf7AACar9uuHWWf2Czt6I=;
        b=H7imLzeoUl05c6stMPmkfdsBLlcRgSSYA0i1DNqB9+VADtIO2v9mQHQ0fMfL+q2xvH
         AD5YqBvZfflipfug9r/CYdfaYI3tqAM2pUnAStsvMgOM/ORGokKr/MgrSGMW5YPXwzjI
         1B08iyGW/6QaOQMcd74Yj2oVIxBbUA8HXnCql7XSvv0iZgSuEK/dbolYnvNDbypsKVYM
         V1Qo/9sERni6kC37N5nOlIwZisSK5DZvR8taLgxEbiCop0302IN7utRbhu0Vnni/Kqew
         a5gOYw6bcnj7FLcbjrk+802qyq5q1TjaBgaC2kSw153IBx6ToxlUXP47sNqmHKL3dsIS
         CaAA==
X-Gm-Message-State: ACgBeo0YZRPMYmM0ZQpPY3zU+BlwtoYWoVFH4W9cEGcnKvlnViLum2qS
        1IUbC+Be64w90Ey/FdskeO8sPAKrX8QupGYhDzF9gVK9fq3UYg==
X-Google-Smtp-Source: AA6agR7hBhgZc/CoZifunhZdafczgTZkJsmEBABR7RHEV+m54SKfFR3Sw968unlJmjCZhSzbssndIObZHMi+EmFD6o4=
X-Received: by 2002:ad4:5aec:0:b0:498:f40a:dcc4 with SMTP id
 c12-20020ad45aec000000b00498f40adcc4mr7135585qvh.115.1661720502095; Sun, 28
 Aug 2022 14:01:42 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Sun, 28 Aug 2022 16:01:30 -0500
Message-ID: <CADqNVTrsKpVM6xUV_oTaoJcLc1=4mRXagAQA7sr40KCBKYEidA@mail.gmail.com>
Subject: 
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I've filed the issue on github, but just thought I'd mention here too.
In real-world use it appears to be intermittent. I"m not yet sure how
intermittent, but I could see it being used in production and not
caught right away. I got lucky and stumbled on it when looking at
graphs of runs and noticed 15 seconds of no activity.

https://github.com/axboe/fio/issues/1457

With the null ioengine, I can make it reproduce very reliably, which
is encouraging as I move to debug.

I had just moved to using log compression as it is really powerful,
and the only way to store per I/O logs for a long run without pushing
up against the amount of physical memory in a system.

(Without compression, a GB of sequential writes at 128K block size is
on the order of 245KB of memory per log, so a TB is 245MB per log. Now
run a job to fill a 20TB drive and you're at 4.9GB for one log file.
If you record all 3 latency numbers too, you're talking close to
20GB.)
