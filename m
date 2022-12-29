Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745DDC4332F
	for <fio@archiver.kernel.org>; Thu, 29 Dec 2022 14:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiL2O2S (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 29 Dec 2022 09:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiL2O2Q (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Dec 2022 09:28:16 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C19BF4A
        for <fio@vger.kernel.org>; Thu, 29 Dec 2022 06:28:15 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id i32so2235277vkr.12
        for <fio@vger.kernel.org>; Thu, 29 Dec 2022 06:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=es/+CWkpABLYb8ogrYpv2LQc1CMPgivdX6538l4Cs3w=;
        b=eTZThXOGsY3KWyK/CQDfvu8ex54fV0b8SnhqHF9lDWTMrkUZtz7WW0gtl6fqKeHJqu
         shfBNX4I0HjpQFUVafWj+j+xNZxz+TjjnhZI/77HwaNseaSnuGDeXic6zIN1uVKIds3X
         05i4kPc2Dm+OClwG4cHCQZQP7KnPBowwB15EBA08VstKg8QVHXUhRJc9MHegI0uhVAxT
         tuXurlCU5YfwwSuf7FXErejR72tB/MNQZH+RCv1199CuJLUiRAvihul0CZMFcqnWSgqq
         yxEuNqCfsv8TtDUq2DVwJWeoywx69XUvxbxq3a4bN+YC9OW0hQQfyUiMJeiCcZMcLoEp
         LKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=es/+CWkpABLYb8ogrYpv2LQc1CMPgivdX6538l4Cs3w=;
        b=cU6oV1w6L65zqTF8OixFBWHIzyn+tl4YmxPAJEC+jNI41hbH99FrokMcWKzEVCJMCw
         l7Dfy0gu/oC8Qh4b/2LjRlMIDQ+ta1qey3NkLcy5XsMDYmZkAzyOzaW5fOEybQ5Wb+08
         afof66rwhP5p6dv6aR8OSGiewWD8hfUIo9l1SWuA1sThgeuvjqS+rf/WNKKt0PfE5Ox/
         HhqgCmP/KcDjnOCmSG53iphIqFmuz2AC1num8p3RMzVi/6zydnrCz1SLWWjADyrAw8St
         exT2vhCqbEmg4a+O9SrYzw+6OfTa3KSdOrKVNd4tadj4BDPAXmYY0dN/z607UbR/zb4E
         LMyQ==
X-Gm-Message-State: AFqh2kqFjX82DV9PKPNOE6rWp9ugThS6FueLkkG33HZAi72zDtPxcsUq
        TFJOaujELjh6sbgJVNq+z96xFfjU0B8=
X-Google-Smtp-Source: AMrXdXvbTKBwt60rU/esYkBzAz5riIUYXqVSKFs44r5q+7pj87YLBAPxEBGRuhrGaG2EM2ZZ5tk/Ow==
X-Received: by 2002:a1f:9014:0:b0:3bd:b507:631e with SMTP id s20-20020a1f9014000000b003bdb507631emr11054686vkd.6.1672324094584;
        Thu, 29 Dec 2022 06:28:14 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id u7-20020a05620a430700b006cbc6e1478csm13283881qko.57.2022.12.29.06.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 06:28:13 -0800 (PST)
Message-ID: <c30865ee-71cc-150d-5952-14eb61d40b07@gmail.com>
Date:   Thu, 29 Dec 2022 09:28:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: fio question
To:     M Kelly <mckelly2833@gmail.com>, fio@vger.kernel.org
References: <CAD5ox-FDUjeZRe9_h_2NtCOCSx2szCVnemO50GwGHa0R_PvqeA@mail.gmail.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAD5ox-FDUjeZRe9_h_2NtCOCSx2szCVnemO50GwGHa0R_PvqeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/27/22 18:50, M Kelly wrote:
> Hi,
> 
> Thank you for fio.
> Apologies if this is the wrong place to ask.
> 
> I am running fio on a laptop with an nvme ssd and have a question
> about differences between results.
> 
> test.1 - test.8 are each 900 Mb files of random data created beforehand
> 
> run 1 -
> 
> echo 3 | sudo tee /proc/sys/vm/drop_caches
> 
> fio --name=fiotest
> --filename=test.1:test.2:test.3:test.4:test.5:test.6:test.7:test.8
> -gtod_reduce=1 --size=900M --rw=randread --bs=8K --direct=0
> --numjobs=8 --invalidate=0 --ioengine=psync
> 
> results:
> 
>     iops        : min= 6794, max=86407, avg=26989.80, stdev=33609.35, samples=5
>     iops        : min= 6786, max=84998, avg=26818.40, stdev=32972.35, samples=5
>     iops        : min= 6816, max=83273, avg=26422.20, stdev=32200.02, samples=5
>     iops        : min= 6838, max=88227, avg=27462.20, stdev=34405.56, samples=5
>     iops        : min= 6868, max=85788, avg=26870.00, stdev=33332.10, samples=5
>     iops        : min= 6818, max=84768, avg=26719.60, stdev=32880.23, samples=5
>     iops        : min= 6810, max=86326, avg=27005.60, stdev=33581.89, samples=5
>     iops        : min= 6856, max=81411, avg=26165.00, stdev=31345.85, samples=5
>     READ: bw=2644MiB/s (2773MB/s), 331MiB/s-332MiB/s (347MB/s-348MB/s),
> io=7200MiB (7550MB), run=2709-2723msec
> 
> run 2 -
> 
> echo 3 | sudo tee /proc/sys/vm/drop_caches
> 
> fio --name=fiotest1 --filename=test.1 -gtod_reduce=1 --size=900M
> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> --ioengine=psync &
> fio --name=fiotest2 --filename=test.2 -gtod_reduce=1 --size=900M
> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> --ioengine=psync &
> fio --name=fiotest3 --filename=test.3 -gtod_reduce=1 --size=900M
> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> --ioengine=psync &
> fio --name=fiotest4 --filename=test.4 -gtod_reduce=1 --size=900M
> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> --ioengine=psync &
> fio --name=fiotest5 --filename=test.5 -gtod_reduce=1 --size=900M
> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> --ioengine=psync &
> fio --name=fiotest6 --filename=test.6 -gtod_reduce=1 --size=900M
> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> --ioengine=psync &
> fio --name=fiotest7 --filename=test.7 -gtod_reduce=1 --size=900M
> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> --ioengine=psync &
> fio --name=fiotest8 --filename=test.8 -gtod_reduce=1 --size=900M
> --rw=randread --bs=8K --direct=0 --numjobs=1 --invalidate=0
> --ioengine=psync &
> wait
> 
> results (from each) -
> 
>    iops        : min= 5836, max= 6790, avg=6481.37, stdev=140.90, samples=35
>    READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17777-17777msec
>    iops        : min= 5924, max= 6784, avg=6476.54, stdev=126.85, samples=35
>    READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17785-17785msec
>    iops        : min= 5878, max= 6766, avg=6475.23, stdev=138.57, samples=35
>    READ: bw=50.6MiB/s (53.0MB/s), 50.6MiB/s-50.6MiB/s
> (53.0MB/s-53.0MB/s), io=900MiB (944MB), run=17792-17792msec
>    iops        : min= 5866, max= 6788, avg=6478.74, stdev=139.18, samples=35
>    READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17782-17782msec
>    iops        : min= 5890, max= 6782, avg=6477.91, stdev=135.21, samples=35
>    READ: bw=50.6MiB/s (53.1MB/s), 50.6MiB/s-50.6MiB/s
> (53.1MB/s-53.1MB/s), io=900MiB (944MB), run=17783-17783msec
>    iops        : min= 5838, max= 6790, avg=6450.11, stdev=137.17, samples=35
>    READ: bw=50.3MiB/s (52.7MB/s), 50.3MiB/s-50.3MiB/s
> (52.7MB/s-52.7MB/s), io=900MiB (944MB), run=17892-17892msec
>    iops        : min= 5922, max= 6750, avg=6454.06, stdev=125.76, samples=35
>    READ: bw=50.3MiB/s (52.8MB/s), 50.3MiB/s-50.3MiB/s
> (52.8MB/s-52.8MB/s), io=900MiB (944MB), run=17880-17880msec
>    iops        : min= 5916, max= 6724, avg=6465.94, stdev=127.54, samples=35
>    READ: bw=50.5MiB/s (52.0MB/s), 50.5MiB/s-50.5MiB/s
> (52.0MB/s-52.0MB/s), io=900MiB (944MB), run=17816-17816msec
> 
> Question: if I am really doing 900 MiB of random reads from 8 separate
> files in both tests, and the page-cache was empty before each test,
> does this difference in performance make sense or am I reading the
> results incorrectly ?
> 
> thank you for any info/ advice, suggestions,
> -mark


Your first test directs fio to create a single job that reads from the 
files in a round robin fashion.

The second test has eight independent jobs reading separately from the 
eight files as fast as they can.

It's not a surprise that the results are different.

Vincent
