Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664ECC4332F
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 15:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242136AbiKRPA2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 10:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242150AbiKRPAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 10:00:03 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64A69208B
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 06:57:14 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id a27so3228989qtw.10
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 06:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I2W4n4KneGh4VO8dWf2KKzUAAkZI86MI0ZqDFnep97o=;
        b=c2madDmp9ENcPftkq9p1ls2d7ZLBwL7P31e1LJQ/RWjjn/U8Qi1BQ3X2th8f5NLTHV
         1apEATnL21KmeegqfDqAmO691qeuSArMd0+YBdk5GrW3RDgBJ3l2FenhNLIhj3qBCbMF
         bdpKtF6nlJNIMRTEnZpBiKn7pGG3h1mlF1E71escw5VJ0ZfKosjg5EC85GJG/PNfKLlQ
         1vYNYYcgX4R5Yo7WO+qXTEmsHlGBYcMUqlMgyic3a6omw6JrTdqY4PDqPLrgjURx3lZz
         gX8Gd6+tWOYyfQ1ClOAYE83JuvahLWkJuDW4fT0RdwqnUIOBTjb1Hk8RAXWyvBag0lXC
         VmOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2W4n4KneGh4VO8dWf2KKzUAAkZI86MI0ZqDFnep97o=;
        b=MDEBa5v5Um4EziCOB+p/sYPntY+BETqFxrPG5mzDKTseYT3D4FWzXwt41Ygc0b/Jxj
         op7i4hm3aPP/QePzFcrS8GEWKDaLnRV/DXaEkh+8/cei93h34CBFyYSFB2z12PhP+w3k
         bWKORU3F5lVaNV8P9EE02L494iaUZpU7Dt3y61mgpMhMiv5vXRMUVRQaPhsuoP4/guc5
         Ct3btea/HI+Bvpop2/n5y2Tq8/k9tsxyohPFv6kBmQdz1tZT3ElDyQKHWyVI+aqlrGV3
         ddkLa1O8NpKyI2ZFCRYle7L5U6glrMykHMEOoiRNO/JpgLN34G0M1i4fczS0zwhts6/4
         +Czw==
X-Gm-Message-State: ANoB5pkx5yU1puwqsudEOKD5dG3b8f8MMbt54kIvG1nS11jNjnw6tPZE
        eVcp+oKUAYHYDxQxjp76L3Y=
X-Google-Smtp-Source: AA0mqf5bYvyBtzjn5U3aQgxzAlv5VtuPRxDMV9K1yPLXTAY+RW2QBxa/0JlYBH0aBaWTm/HClUU2WA==
X-Received: by 2002:ac8:41cf:0:b0:3a5:868a:5b86 with SMTP id o15-20020ac841cf000000b003a5868a5b86mr6828932qtm.488.1668783433669;
        Fri, 18 Nov 2022 06:57:13 -0800 (PST)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id g10-20020a05620a40ca00b006faf76e7c9asm2588680qko.115.2022.11.18.06.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 06:57:12 -0800 (PST)
Message-ID: <10fb80d0-788d-9f92-cc66-896a262fffb6@gmail.com>
Date:   Fri, 18 Nov 2022 09:57:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 00/13] zbd: fix unaligned block size issue and verify
 issues
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221114021308.1684141-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/13/22 21:12, Shin'ichiro Kawasaki wrote:
> When zonemode is zbd and block size is not divisor of zone size, write target
> zone selection does not work as expected. First four patches in this series fix
> the issue by introducing zone finish operation. First three patches do
> preparation and the 4th patch does the fix.
> 
> This series also fix four more issues related to verify with zonemode zbd. The
> first issue is that verify is allowed only when block size is divisor of zone
> size. The 5th patch removes this limitation. The second and third issue are
> caused by zone reset, which erases data pattern for verify. The 6th and 7th
> patches adjust verify and zone reset timing to avoid verify errors by the erased
> data pattern. The last issue is experimental verify, which does not work with
> zonemode=zbd. The 8th patch checks options to error out when experimental
> verify is specified together with zonemode=zbd.
> 
> Five more patches follow to make test cases in t/zbd match with the fixes.
> 
> Of note is that the new test case #59 added by 11th patch may fail, when libzbc
> IO engine is specified to t/zbd/test-zbd-support script with -l option. For SAS
> ZBC drive, use latest libzbc with fix to avoid the faliure [1]. For SATA ZAC
> drive, use kernel with a fix posted to linux-ide list recently [2].
> 
> [1] https://github.com/westerndigitalcorporation/libzbc/commit/6de6869acbe7c3a12758b1f42c9da47bb873e621
> [2] https://lore.kernel.org/linux-ide/20221107040229.1548793-1-shinichiro.kawasaki@wdc.com/
> 
> 
> Changes from v4:
> * 7th patch: improved fix for test case #34 failure found with 16MB zone size
> * 10th patch: improved the test case #34 to trigger the failure found with 16MB
>                zone size
> 
> Changes from v3:
> * 6th patch: fixed get_next_verify() call and rand_seed check condition
> * 11th patch: improved to cover four types of workloads
> 
> Changes from v2:
> * Improved commit message and block comment in 3rd patch
> * Fixed a comment typo in last patch
> * Added Tested-by and Reviewed-by tags
> 
> Changes from v1:
> * Separated zbd_zone_remainder() addition to 3rd patch and added suggested hunks
> * Added last 13th patch for a new test case to test experimental_verify option
> * Reflected other comments on the list
> * Added Tested-by and Reviewed-by tags
> 
> 
> Shin'ichiro Kawasaki (13):
>    oslib: blkzoned: add blkzoned_finish_zone() helper function
>    engines/libzbc: add libzbc_finish_zone() helper function
>    zbd: add zbd_zone_remainder() helper function
>    zbd: finish zones with remainder smaller than minimum write block size
>    zbd: allow block size not divisor of zone size
>    zbd, verify: verify before zone reset for
>      zone_reset_threshold/frequency
>    zbd: fix zone reset condition for verify
>    zbd: prevent experimental verify with zonemode=zbd
>    t/zbd: fix test case #33 for block size unaligned to zone size
>    t/zbd: modify test case #34 for block size unaligned to zone size
>    t/zbd: add test case to check zone_reset_threshold/frequency with
>      verify
>    t/zbd: remove experimental_verify option from test case #54
>    t/zbd: add test case to check experimental_verify option
> 
>   engines/libzbc.c       |  34 ++++++++
>   ioengines.h            |   2 +
>   oslib/blkzoned.h       |   8 ++
>   oslib/linux-blkzoned.c |  37 +++++++++
>   t/zbd/test-zbd-support |  60 +++++++++++---
>   verify.c               |   6 +-
>   zbd.c                  | 175 +++++++++++++++++++++++++++--------------
>   zbd.h                  |   2 -
>   8 files changed, 250 insertions(+), 74 deletions(-)
> 

Applied. Thanks.
