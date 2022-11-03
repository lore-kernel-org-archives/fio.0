Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AACFC4167B
	for <fio@archiver.kernel.org>; Thu,  3 Nov 2022 14:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiKCODb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Nov 2022 10:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiKCODI (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Nov 2022 10:03:08 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE1F15717
        for <fio@vger.kernel.org>; Thu,  3 Nov 2022 07:02:35 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id h24so1238279qta.7
        for <fio@vger.kernel.org>; Thu, 03 Nov 2022 07:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AhZun+OjCLRD46MAFv6m3YltlrRbJuovhteDV6NGp/E=;
        b=SWrqqRwBQRwM5MtXbAfBp460XhVhVeguAh+c738bwdISMDDEhunAUVKLgHEW6T/6AM
         +E1obuuAAquil2MLCuCZlqTGAQroNmBoz88+VIzzhP8c0LJ9W5a+NmcvhkGTL11bpsCe
         1SW6IBj3oz3iekXrcT1mMd9v1IS5VOriZ678Ejp5V+nFQowE01iVlrU5OIK0ZJMN5IIn
         wuYX+fdM7GJlmS9k+uenGsJkXwpxe82QrKRy6ZT5kaTFjaiP5lcd0q/sr9ovoDmHIBWf
         4Vd4JzYLDEM4BvmNpMJK7jQY2FBKfIla8oOBJpFSUKUBAacYaZf8baG1Vekmd8B6st+P
         pz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AhZun+OjCLRD46MAFv6m3YltlrRbJuovhteDV6NGp/E=;
        b=VY1yZMD6MO61GfXTbfxjAhRLePXqz/pJaPAfMVfp/xF7X9vuizLy6s/6sONzEf7VDT
         7HNZrzbVlfbp8kr2Y4hG0QJpB+7mW6VwZIqem86elUOXuxdl6YrM8T3G346cSvNYkqmq
         lagIkxfgHtxZPTGexWCqyCbfUEzFb1ptmiYRZUTAhI5Qq9ZKJePsZsIStGNp0B9vNnF6
         H/V+qSq6tsifblFx3Xi25pbum9sYDd3EoabmqNFE92O4M9NN7seJyJv8ryz00ldGC2Ie
         ymJvyZmDwyUqCgdD+XJnQkHclryGR1P0ypCqD9TonDsDs3KxdmC4y6rx3PPoTP8qRh+6
         Pb+g==
X-Gm-Message-State: ACrzQf2Gxh/kniyP7keJk29Amk+3E1YtoHan/oZMbYpnVReVWK8CQk/j
        DZOCUEBowa3Ywu6kBmRuBgQHxaDwsa0=
X-Google-Smtp-Source: AMsMyM4B82fI+7edZNT/PbfFegGHG/L+7dbZ84tC3vAdeTKEd2gWl0yBwDlDN/nPHQs8Xj4eN9a8+A==
X-Received: by 2002:a05:622a:54f:b0:39c:eb55:2534 with SMTP id m15-20020a05622a054f00b0039ceb552534mr25032759qtx.187.1667484154045;
        Thu, 03 Nov 2022 07:02:34 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id gb4-20020a05622a598400b0039853b7b771sm558466qtb.80.2022.11.03.07.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 07:02:33 -0700 (PDT)
Message-ID: <fcde0236-6ce1-2998-0046-a2be5f751ee0@gmail.com>
Date:   Thu, 3 Nov 2022 10:02:32 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: Details about the usage of flow
Content-Language: en-US
To:     Tom Cameron <tomc603@gmail.com>, fio@vger.kernel.org
References: <CA+Huu1HtX7qggn36DyqTrZCrrpm5hzNr7v4RbPbUo-2REULGwQ@mail.gmail.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CA+Huu1HtX7qggn36DyqTrZCrrpm5hzNr7v4RbPbUo-2REULGwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/2/22 16:34, Tom Cameron wrote:
 > All,
 >
 > I recently filed https://github.com/axboe/fio/issues/1483 on github
 > describing my usage of multiple concurrent jobs to split random read
 > and random write so I can have a different number of reader and writer
 > threads. I was informed that what I actually want is to use "flow=" to
 > specify the ratio of activity between jobs.
 >
 > My issue while testing the use of flow, is that it seems to be off by
 > a factor of 10x. For example, the following has two jobs, one for
 > readers and one for writers. The writer, as can be seen, has "numjobs"
 > set to 8, while the reader has "numjobs" set to 64. Flow is set to
 > "100" for reader, and "1" for writer. But from the output below we can
 > see the actual split is more like 786 to 1.
 >
 > Jobs: 72 (f=72):
 > [w(8),r(64)][26.6%][r=1254MiB/s,w=1632KiB/s][r=321k,w=408 IOPS][eta
 > 44m:11s]
 >
 > Should I be dividing the flow value by the ratio of "numjobs" as well?
 > The command running obviously has an 8:1 ratio of readers to writers,
 > and I've defined a 100:1 ratio in the value of "flow", so am I
 > actually seeing an 800:1 here?
 >
 > I suspect I'm missing a key piece of information, but the
 > documentation doesn't explicitly call this out. The line that makes me
 > think I may need to adjust for "numjobs" within each job is "The flow
 > parameter stands for how much should be added or subtracted to the
 > flow counter on each iteration of the main I/O loop.". This makes me
 > suspect that each of the threads spawned under a job definition is
 > spawned with it's own 100:1 ratio, and since there's an 8:1 numjobs
 > ratio, I end up seeing the above.
 >
 > The command, in total, is below.
 >
 > fio 
--output=fio-logs/m2test-01/20221102/manual-flow-test.write-1.qd-32/fio.manual-flow-test.log
 > \
 > --exitall_on_error --bs=4Ki --direct=1 --fadvise_hint=random
 > --filename=/mnt/testing/fio \
 > --group_reporting=1 --iodepth=32 --ioengine=libaio
 > --ioscheduler=mq-deadline --log_avg_msec=1000 \
 > --log_compression=1m --log_store_compressed=1 --ramp_time=10
 > --randrepeat=0 --runtime=1h --thread \
 > --time_based 
--write_bw_log=fio-logs/m2test-01/20221102/manual-flow-test.write-1.qd-32/fio-stress
 > \
 > 
--write_iops_log=fio-logs/m2test-01/20221102/manual-flow-test.write-1.qd-32/fio-stress
 > \
 > 
--write_lat_log=fio-logs/m2test-01/20221102/manual-flow-test.write-1.qd-32/fio-stress
 > \
 > --name=writer --new_group --stonewall --numjobs=8 --rw=randwrite
 > --flow=1 --exitall \
 > --name=reader --new_group --numjobs=64 --rw=randread --flow=100
 >
 >
 > Thanks for any advice,
 > Tom

numjobs=X directs fio to behave as if you had specified the same job 
configuration X times. So your options create 8 writer jobs with flow=1 
and 64 reader jobs with flow=100.

If you want a 100:1 r/w ratio you will need to use rw=randrw and rwmixread.

The flow feature does not guarantee a specified r/w mix because your 
device may have different read and write performance. What flow does is 
to direct jobs to skip opportunities to issue IO using the specified 
weights. The resulting r/w mix depends on this of course but also 
depends on the relative r/w performance of your device.

Vincent
