Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D759ECAAD3
	for <fio@archiver.kernel.org>; Thu,  1 Sep 2022 17:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiIARyq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Sep 2022 13:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbiIARyo (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Sep 2022 13:54:44 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BCEB861
        for <fio@vger.kernel.org>; Thu,  1 Sep 2022 10:45:01 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id j6so10229403qvu.10
        for <fio@vger.kernel.org>; Thu, 01 Sep 2022 10:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date;
        bh=n/H2h93XQJ09BmUITN13EPOyYIL5cr9ohPy14WDACNo=;
        b=njexe5fd5Oq+XnhbyFJE55cV0RoS2KRFJT2lN7Tw/d+kQkXw2UxIA71Yj+W15qGLXM
         bn0R9bvPrFj6u2g3u1RICsZNP/ieRCM/I1Qx8kBfi2AKYT8T7UHOOQ9Ly0orR22uoPid
         P3GUzGvAV4oNo0TfKLhZTT3bMkHrm43H/Lc7lP3tasjwHneUAOHuaXZQW1p/kNET1sFp
         cI2AKle7NvPmkMzvhK3SgufBWgZZ0Aj6wMJIMzYW+XdFoLjIPdQQaIJuRZNxVHN65csG
         //fk91u9J4tPP2k9mOJdn4XJ/H0bNIwEgW9BiFokpTsiQJSytKEqUMOtuvBzL41qgE6f
         SGbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=n/H2h93XQJ09BmUITN13EPOyYIL5cr9ohPy14WDACNo=;
        b=o8KMCB1JT5CdIXT56vzUVj7tF4aTBBThsOzRhLPXZp+TiM9VHKE634odLTiy+BNEzK
         DVyOepBWM9hzCUXr7xjJEEkuiNHrC3fAqg7gGeS/nR8Jh7AXXb7E2wY4ny7Z+y7ZBxtb
         XaWoCVeuO8shCtiqCEEjzCTvX2lchRkPjRSY+LmM5OYunCwycoW9T0sGlcCJREgWF1dS
         6qoK4wWdsiM68uXzEBVybx2ZWirt2emMGLSXXgkVAJajxxSezzr4N3nfPF/LMsMwdIjD
         KVRvJNiTC6hCy8oy33ePm2fZ0cz9n2wTDS2F2zLDBXj5xAUu+xnivXv1UNlLWj+5SF+O
         a6iw==
X-Gm-Message-State: ACgBeo3UWxX+8/QoCga6/vb+H334aXNnwMh5GdR5zd+dA0V+uZppTBpm
        JPaMx0rDrY/eeudSNj/m4g72sdCxIFBuZ0tTxhoyOy0W9qE=
X-Google-Smtp-Source: AA6agR68pp4A4qHX2w2MBtUu1MiyWEK0BMpqyWQ5nkx8HP2IM1nYFBSkCVmxFyaL2B0CnXjJ2AWAtyDrpE8kM0uf2po=
X-Received: by 2002:ad4:5946:0:b0:477:42fd:6492 with SMTP id
 eo6-20020ad45946000000b0047742fd6492mr25425536qvb.88.1662054299943; Thu, 01
 Sep 2022 10:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <CADqNVTrsKpVM6xUV_oTaoJcLc1=4mRXagAQA7sr40KCBKYEidA@mail.gmail.com>
In-Reply-To: <CADqNVTrsKpVM6xUV_oTaoJcLc1=4mRXagAQA7sr40KCBKYEidA@mail.gmail.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Thu, 1 Sep 2022 12:44:48 -0500
Message-ID: <CADqNVTq_NE5wedX6KYrn5u866LuRwNt0VWcarHhSCZSFV8DbRA@mail.gmail.com>
Subject: Re:
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PR for this is up now.

On Sun, Aug 28, 2022 at 4:01 PM Nick Neumann <nick@pcpartpicker.com> wrote:
>
> I've filed the issue on github, but just thought I'd mention here too.
> In real-world use it appears to be intermittent. I"m not yet sure how
> intermittent, but I could see it being used in production and not
> caught right away. I got lucky and stumbled on it when looking at
> graphs of runs and noticed 15 seconds of no activity.
>
> https://github.com/axboe/fio/issues/1457
>
> With the null ioengine, I can make it reproduce very reliably, which
> is encouraging as I move to debug.
>
> I had just moved to using log compression as it is really powerful,
> and the only way to store per I/O logs for a long run without pushing
> up against the amount of physical memory in a system.
>
> (Without compression, a GB of sequential writes at 128K block size is
> on the order of 245KB of memory per log, so a TB is 245MB per log. Now
> run a job to fill a 20TB drive and you're at 4.9GB for one log file.
> If you record all 3 latency numbers too, you're talking close to
> 20GB.)
