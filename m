Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33FEC4332F
	for <fio@archiver.kernel.org>; Wed,  2 Nov 2022 20:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiKBUeY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Nov 2022 16:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiKBUeX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Nov 2022 16:34:23 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084266387
        for <fio@vger.kernel.org>; Wed,  2 Nov 2022 13:34:22 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id o70so22561386yba.7
        for <fio@vger.kernel.org>; Wed, 02 Nov 2022 13:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6gkMduZB3fiewJxhleE3sLVfvjlRK1OzvuIIgdVMUr0=;
        b=g0oHhRMPvF3VL/LbzB614+595NkE7YAXGV6Cm5PQfTbsdOyHUu6J7dzLv7UM+wV53J
         rEuxML38K6cMRaNDM9RLCWX/vudKRnA7mz3KopWGWCLtR0o+5InsF8whLi329/olpE3l
         eiMrdZfXmGUB6bSFvYMlfEg1PzQDCKDkOrCd2MxgwreaoJYvhPsY8HXljHNQUBxU3AEE
         Jspq7LkPqMUvR/u3WrheKaHIsEOvdFyobOMU1H7sUUwIWsqz9y6PDycdahTCKeHbObkm
         970xVLkgNAQxAk3h0bIZNKI6EUZivNWyKoUzyMNX/5ZFDsfVZIS60CgUHemIaUbQDqel
         6KvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6gkMduZB3fiewJxhleE3sLVfvjlRK1OzvuIIgdVMUr0=;
        b=ePRec+7Rs3HdF2pfQ93QV0ZEOpo3A2THqpiOmG5/wmy3fTiYVJMDck8YWb3tAnzmS7
         D2qvKAVpD9qXPK3Gl6xGinSrF4UTI7hsQ6/doYjJU3Q14rdo/FBM7Fc0Ah0E4RHeEBhy
         W/kvJa1MjAzXVvF4NNZghpkdSMEvNn3hK5NCqP7Wsa1iWPyKzJ69YMOSK+u0Z4bAOQsS
         nzad3OavSgmeaUAzLxAXWu7VrS/Lcr8ObX3dFVYjsZwCQDMOqHGRscoxtI1Wj5hVsHnd
         p0nxehYtn/Vw5xUAMHbP+kwzhqtFQ3x9QpAtSh7J8evVQOqSQSKwBfY7gadn7fa17Aml
         ByFg==
X-Gm-Message-State: ACrzQf1uuW/QHd9xzaasVfqWhSkgkOB8rNbeDUJzZO7SFZS+TgsDHAKX
        M06Mt+5ETajncDJ7lOHhfqeowZSK0iDQe53wR6yD3130TaQ=
X-Google-Smtp-Source: AMsMyM7w7ojMP1hGeyVrgdD8QzEE7XnChuj5344IwyYjRM17awmLm42CC5J2cJU3uuaSMrxJk6d/8xQvhldCKwyZObo=
X-Received: by 2002:a25:2491:0:b0:6c9:d402:8556 with SMTP id
 k139-20020a252491000000b006c9d4028556mr26364061ybk.536.1667421260786; Wed, 02
 Nov 2022 13:34:20 -0700 (PDT)
MIME-Version: 1.0
From:   Tom Cameron <tomc603@gmail.com>
Date:   Wed, 2 Nov 2022 16:34:09 -0400
Message-ID: <CA+Huu1HtX7qggn36DyqTrZCrrpm5hzNr7v4RbPbUo-2REULGwQ@mail.gmail.com>
Subject: Details about the usage of flow
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

All,

I recently filed https://github.com/axboe/fio/issues/1483 on github
describing my usage of multiple concurrent jobs to split random read
and random write so I can have a different number of reader and writer
threads. I was informed that what I actually want is to use "flow=" to
specify the ratio of activity between jobs.

My issue while testing the use of flow, is that it seems to be off by
a factor of 10x. For example, the following has two jobs, one for
readers and one for writers. The writer, as can be seen, has "numjobs"
set to 8, while the reader has "numjobs" set to 64. Flow is set to
"100" for reader, and "1" for writer. But from the output below we can
see the actual split is more like 786 to 1.

Jobs: 72 (f=72):
[w(8),r(64)][26.6%][r=1254MiB/s,w=1632KiB/s][r=321k,w=408 IOPS][eta
44m:11s]

Should I be dividing the flow value by the ratio of "numjobs" as well?
The command running obviously has an 8:1 ratio of readers to writers,
and I've defined a 100:1 ratio in the value of "flow", so am I
actually seeing an 800:1 here?

I suspect I'm missing a key piece of information, but the
documentation doesn't explicitly call this out. The line that makes me
think I may need to adjust for "numjobs" within each job is "The flow
parameter stands for how much should be added or subtracted to the
flow counter on each iteration of the main I/O loop.". This makes me
suspect that each of the threads spawned under a job definition is
spawned with it's own 100:1 ratio, and since there's an 8:1 numjobs
ratio, I end up seeing the above.

The command, in total, is below.

fio --output=fio-logs/m2test-01/20221102/manual-flow-test.write-1.qd-32/fio.manual-flow-test.log
\
--exitall_on_error --bs=4Ki --direct=1 --fadvise_hint=random
--filename=/mnt/testing/fio \
--group_reporting=1 --iodepth=32 --ioengine=libaio
--ioscheduler=mq-deadline --log_avg_msec=1000 \
--log_compression=1m --log_store_compressed=1 --ramp_time=10
--randrepeat=0 --runtime=1h --thread \
--time_based --write_bw_log=fio-logs/m2test-01/20221102/manual-flow-test.write-1.qd-32/fio-stress
\
--write_iops_log=fio-logs/m2test-01/20221102/manual-flow-test.write-1.qd-32/fio-stress
\
--write_lat_log=fio-logs/m2test-01/20221102/manual-flow-test.write-1.qd-32/fio-stress
\
--name=writer --new_group --stonewall --numjobs=8 --rw=randwrite
--flow=1 --exitall \
--name=reader --new_group --numjobs=64 --rw=randread --flow=100


Thanks for any advice,
Tom
