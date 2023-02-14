Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9DFC05027
	for <fio@archiver.kernel.org>; Tue, 14 Feb 2023 15:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjBNPXr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Feb 2023 10:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjBNPXq (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Feb 2023 10:23:46 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BA825941
        for <fio@vger.kernel.org>; Tue, 14 Feb 2023 07:23:45 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id h24so17881173qtr.0
        for <fio@vger.kernel.org>; Tue, 14 Feb 2023 07:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cy0ABhjQ1sliNCSFp5AX1yGdeniusRvjpXp2D1bBI4Y=;
        b=KlPYEd6288+Nr4hSiD8iyDPNu8pT1ZtvJrRZ/E1ZHGX9xiGNPM1tVAuoByCZibDu+U
         Ov9m92vDiNqNqszJjjbezroabECmkVHd//SZ62Og3/GVWQI/E3pOw8s4GQuGd6aaxOCu
         5aMkZ1sMxZekrf/BVigfsrj0Ygt1VWYR0CY9WMGrUgoQvTGPX0pDMxUOJjdWjGSiGlkm
         elYEjczE0zNgqYz+WdB+pzKMEZXqU0duJMu08hqF+mRz5eC/Xy3KlB81qfeQj70nc1qB
         9ZfGS/NlI50XeGOPj9KnPiMmx2chEesfUXg/wRLwONQr1dJWun4owedd5Q39v0zm1R6P
         BRLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cy0ABhjQ1sliNCSFp5AX1yGdeniusRvjpXp2D1bBI4Y=;
        b=ADmm70s+EkXY6/FhW/xafJhORKwhJt4mtcsv0vuoXqjqoMQQ68/d0NsI8p+aVTVkIz
         MlZxiJ3+BDAXq9hBAOwSrY0cmLKX3+P/AkbNKkpCZGnQGlIC5I45PBLfwXKpiBdGPFod
         fy1OTeJfrLs6aSNb09KXH3e9MRytVbw6EZLXySUK/ePc2mpbJ9KH6yhhl/fiejE2/e/h
         ttufaZPROFs8CQguWHS1jUv2OeqyVuYgeYQ2rb13F7mGWsymWFDqn5COdLG5b64wyedY
         +4WfyXeVM+PG0C1g3nBjCSITSdseVbLvzKjFwi+Lfr4ETpuPo2X1+Ci8jpIZf3RLz0Ey
         dRRA==
X-Gm-Message-State: AO0yUKUximUXsCTORuW+mN0IXFuUwZ7jEjBFj+5nMAcg+EESG1YOk9ho
        Hifqghnja19tCrZ48Cbqr0o=
X-Google-Smtp-Source: AK7set+PcmzecoNxgs7BrmTnnjHljkGJTo/CGVBfbANiUhOzeZxlwDxtxUwrY9bC4vZ/Ea6Xz4fZkg==
X-Received: by 2002:ac8:5cd4:0:b0:3b8:4694:b727 with SMTP id s20-20020ac85cd4000000b003b84694b727mr4731870qta.55.1676388224429;
        Tue, 14 Feb 2023 07:23:44 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id m4-20020a375804000000b0073b4d8cb4a5sm2928187qkb.60.2023.02.14.07.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 07:23:43 -0800 (PST)
Message-ID: <484bf3b5-d840-5e77-4194-b347a217cbb6@gmail.com>
Date:   Tue, 14 Feb 2023 10:23:43 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 0/8] zbd: fix 'sectors with data' and
 zone_reset_threshold accounting issues
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/9/23 02:08, Shin'ichiro Kawasaki wrote:
> When zonemode=zbd is specified, fio does 'sectors with data' accounting to
> record the total number of sectors that have been written on a zoned block
> device. This accounting has issues as follows:
> 
> Issue 1)
>     The name 'sectors with data' indicates that the accounting uses 'sector' as
>     the unit. However, it is implemented using 'byte' as the unit.
> 
> Issue 2)
>     The accounting does not work correctly when multi-jobs with different IO
>     ranges due to two reasons. One reason is the accounting field initialization.
>     The accounting field is shared across all jobs, but it is initialized
>     repeatedly by all jobs. This results in wrong behaviors except the last job.
>     The second reason is definition difference between the zone_reset_threshold
>     option and the accounting. The option is defined as the ratio of valid
>     written data to the IO range of each job. However, the accounting is done
>     per device and shared across all jobs. This coverage gap between each job's
>     IO range and the accounting range causes unexpected zone reset.
> 
> Issue 3)
>     Counting the total number of written sectors requires taking the zone lock of
>     all zones in a job IO range. For a multi-job workload with overlapping IO
>     ranges, this often leads to significant zone lock contention, resulting in
>     some jobs starting IOs only after other jobs have completed their work
>     (which looks like an apparent deadlock on startup).
> 
> This series addresses the issues with solutions as follows:
> 
> For Issue 1)
>     Rephrase variables, comments and man pages to indicate that the accounting
>     unit is not sector. -> 3rd and 4th patches
> 
> For Issue 2)
>     Limit the condition of the accounting to ensure correct accounting. Do the
>     accounting only when the zone_reset_threshold option is specified and all
>     write jobs have the same IO range. Initialize the accounting field only once
>     for the 1st job. -> 5th and 6th patches
> 
> For Issue 3)
>     Move the total valid bytes counting code from "file reset" after job start
>     to "file set up" before job start. This allows to count without zone locks,
>     then avoids the lock contention. -> 7th patch
> 
> The first two patches are preparation patches to reduce references to the
> 'sectors with data' accounting field. The last 8th patch adds test cases for the
> zone_reset_threshold option.
> 
> Changes from v2:
> * 4th patch: rephrased to cover the case that IO range has conventional zones
> * 6th patch: added a check to ensure f->min_zone and f->max_zones are different
> * 7th patch: renamed zbd_set_vdb() to zbd_verify_and_set_vdb()
> * Reflected other comments on the list and added Reviewed-by tags
> 
> Changes from v1:
> * Reworked not to change the definition of the zone_reset_threshold option
> * Separated the patch to remove CHECK_SWD (or CHECK_VDB) to clarify the removal
> 
> Shin'ichiro Kawasaki (8):
>    zbd: refer file->last_start[] instead of sectors with data accounting
>    zbd: remove CHECK_SWD feature
>    zbd: rename the accounting 'sectors with data' to 'valid data bytes'
>    doc: fix unit of zone_reset_threshold and relation to other option
>    zbd: account valid data bytes only for zone_reset_threshold option
>    zbd: check write ranges for zone_reset_threshold option
>    zbd: initialize valid data bytes accounting at file setup
>    t/zbd: add test cases for zone_reset_threshold option
> 
>   HOWTO.rst              |   9 ++-
>   fio.1                  |   8 ++-
>   t/zbd/test-zbd-support |  60 ++++++++++++++++-
>   zbd.c                  | 149 +++++++++++++++++++----------------------
>   zbd.h                  |  11 +--
>   5 files changed, 145 insertions(+), 92 deletions(-)
> 


Applied. Thanks.

Vincent
