Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C4DC433F5
	for <fio@archiver.kernel.org>; Thu, 24 Feb 2022 20:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiBXUII (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 24 Feb 2022 15:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiBXUIH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 24 Feb 2022 15:08:07 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB6B1405E1
        for <fio@vger.kernel.org>; Thu, 24 Feb 2022 12:07:36 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id c7so2783059qka.7
        for <fio@vger.kernel.org>; Thu, 24 Feb 2022 12:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=qQyx8d3gqoNtmr5exMYx9NlRf7ctP2J7/0ZP2UMJkJ0=;
        b=fstdZ82YlHwM3oBkwtwS1g2PJ4UYOQnoKVJoev5++Q5xIHTccWUQI2/jfwxBq572nZ
         PDLAKboC0ErH9S+BjzOuuILM8Bmb7zYvMG/3FnI6zobXmpOQLIuGvWbiQQhFj1fLG11c
         rYyvSDycIV8klHgVq82cu8y4SB/bRrOqBQZ3UE2csacpUMQ6IRfkKJ0Y3pHMmLhnHHOg
         acQINup2mQaRrgS9pSdluiZvDjxMmbpboqvx5Pb3ewV4NjenZQkqbkEM0X+8RBbqdGdK
         8xnTyKFUCuU8iCwJM7ao87SzapEXtVggNdixFk+LOWjxnHgWnQNgVjeZIJC8JLEuubvp
         pm/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=qQyx8d3gqoNtmr5exMYx9NlRf7ctP2J7/0ZP2UMJkJ0=;
        b=K9zVes3sxKuSdi2h8fNiQCaZPSEFwBdX/ivt8hTID4SC3HLBmI61Od/eXG4O6sZvYm
         I2LUPEzK5ocwjDu/CzAbcLNTlYIbJ0HdgqIJ8JkbqeKqmzFC52wdJB2eXdqI8qWwoteP
         aD03QhXhAfkKo5nuJ/lAXYwbofp7LWnmv61Jq7n4Yxb2lf8tiOYKEFAji5QC7F4JxSjc
         e9GtghBxri5kcYR4ybDprwUr2nq666m9ROnbr+EJujpDk1IFFJWoPW91SImU6Gf77Gqh
         NzIgKsgtOVIcCZnAKXRcIBVpIvOXLF4m157heLlGddVOq1rdsFAxGJAaaQSMsexp+rUs
         KBdQ==
X-Gm-Message-State: AOAM5305AmeIq/7jJIf696JRVTpTzkWTYMNYsA/s7/9KKaf0U0xbnwqZ
        7MoU5v45A2GMYHgXKmza2Kuom6YmEZxSqrbcCwDxZ5DjGO9nOA==
X-Google-Smtp-Source: ABdhPJydqLrdf4xiKjUUxFC4AobNZSocejBqSYqatt/OgoftaONrGgYW3ypHJFjqzLuFrKlN0OzbSUMdGW6d/7ue2/8=
X-Received: by 2002:a05:620a:2546:b0:508:19df:5fd6 with SMTP id
 s6-20020a05620a254600b0050819df5fd6mr2704652qko.757.1645733254897; Thu, 24
 Feb 2022 12:07:34 -0800 (PST)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Thu, 24 Feb 2022 14:07:21 -0600
Message-ID: <CADqNVTqmWV8MiFZ6x8N4u8Poefxb9jRbpLkH03w7VPoFzEixUQ@mail.gmail.com>
Subject: Not logging zero entry intervals when using --log_avg_msec seems problematic
To:     fio@vger.kernel.org
Cc:     axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I was digging into the bandwidth/iops logging code in stat.c after
thinking about how to compute an average bandwidth/iops over a period
of time given interval log entries.

I noticed something concerning. When there is an interval where
nothing happened (e.g. no read iops), nothing is logged but the time
of last interval is advanced (there is only one such time for each
log, shared by all directions).

This makes sense for a case when you are only doing reads and don't
want write entries in your log. But it means that looking at a log
file can be pretty misleading. If you are logging with an interval of
100ms but only one read is occurring per second, you get a log for
iops like this:

149, 6, 0, 0, 0
1056, 10, 0, 0, 0
2064, 9, 0, 0, 0
3072, 10, 0, 0, 0
4081, 10, 0, 0, 0

If you turn the interval up to every 10 ms, you get this:
149, 6, 0, 0, 0
1011, 100, 0, 0, 0
2011, 100, 0, 0, 0
3011, 100, 0, 0, 0
4011, 100, 0, 0, 0

Those zero entries are actually really important in a case like this.
Those logs do not look like logs for a job that did 1 read per second.
This is an extreme example to show the problem, and of course we know
what's going on here.

But what if you're doing a practical test on storage with a fairly
small log interval, and the storage hiccups and processes no
operations in an interval? It can be impossible to know if an apparent
"gap" in a log file is because there was a zero entry or a system
hiccup caused the logging process to run a little late.

Any thoughts? Just logging the zero entries would work, but at the
expense of noise in logs.

(One option I can think of is remembering, per direction, that the
last interval was a zero-entry one, and then writing that if a
non-zero interval is later encountered. Also the last entry per
direction must always be written, if any non-zero interval for that
direction was ever written.)

Thanks,
Nick
