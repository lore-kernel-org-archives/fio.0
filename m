Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36502C433FE
	for <fio@archiver.kernel.org>; Fri,  7 Oct 2022 13:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJGNwN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 7 Oct 2022 09:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiJGNwM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Oct 2022 09:52:12 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE1C1B7B8
        for <fio@vger.kernel.org>; Fri,  7 Oct 2022 06:52:11 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id s19so803025qkg.1
        for <fio@vger.kernel.org>; Fri, 07 Oct 2022 06:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ykr2vNzxRqdYsjivna3Ygu/rV4EPMjYldMKjDjqyL4=;
        b=MKpsGGOHTrhrmwxiKyTO/IYeq3UZlxWTT3bbcm78Q8VPUDZASg0Lkf1VSKJCia8TvD
         YU0Z/nsC9lzKThBOqFzqrR1zqEnfdjNm7Ckm3uxyVO03li3J27ZSF8zia3oUD0qeQXHM
         Ux73ZMkV/H3uklYD5Fj+2Dnlk6fiehQdISq3Ltv9IH9uOh3XNCUmWBcwAM3iDe77FY6v
         IxmGikJdEPPTS5Tjk76vvk4psuDmK6Hqw5nmXhswfUIc+FUkEBuWfbWF+rhLHWKfVnRT
         Km0NfzgTziZZAw+Cn372SOjVBkGx8dE37heAnhHMikiga1BKsrF9W84LLAs3ijRWwGc5
         FkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ykr2vNzxRqdYsjivna3Ygu/rV4EPMjYldMKjDjqyL4=;
        b=BReI9Dg8fwUq8kb1Wc1M2mtdIfseB9IdfIiwVrDf8JEeo3h+qbaiPQDXaN3r2yliyc
         TI3wdCaeUvtjGGbXmWpU7R5osyEy66P2WiKvona8Lv3SsJ/uud6UdEjpqkU0OhlqdBhh
         hYaAwwbZwRVHmoOlhF/Tb+IDafp3d5kkmQeVQmuescsHmMoB2gyheIKQRLIwEaJ4+3cw
         8yPZfXFQqXV+2mlX50bdg8UX9WYtmorfhHVXy+ziP1cc29qtXFxxwjPssoSkJxCUeoiY
         ZPMDDbGwrjFLdIEXhWO/8w3Q4Qw3mVRFp+71Yx2AVZq7tgzef95hTp61/45wIYM1RYwa
         Ph0A==
X-Gm-Message-State: ACrzQf3ppInYKGqGuUjsjkdXRu1D9cxQDYrFwxasvhcbFFxpltORT3x9
        sQZ6hcBa4oDTbkMvy6wEpbmyKrriq3MIGw==
X-Google-Smtp-Source: AMsMyM52k49l6Mbgwdw4qgLdjy8gLnztyxsA0lCoOuK1h7A0inKny16t6r524i6VlfkUb1XROpgS4Q==
X-Received: by 2002:a37:bd84:0:b0:6cf:6049:f12a with SMTP id n126-20020a37bd84000000b006cf6049f12amr3628497qkf.697.1665150730664;
        Fri, 07 Oct 2022 06:52:10 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bq18-20020a05620a469200b006bb0f9b89cfsm2005637qkb.87.2022.10.07.06.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 06:52:10 -0700 (PDT)
Message-ID: <f65a9928-6d6b-1921-7c0d-d6148db895af@gmail.com>
Date:   Fri, 7 Oct 2022 09:52:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] examples: uring-cmd-zoned: expand the reasoning behind
 QD1
Content-Language: en-US
To:     Pankaj Raghav <p.raghav@samsung.com>, fio@vger.kernel.org
Cc:     gost.dev@samsung.com
References: <CGME20221007120530eucas1p16e2b45344e7148a39789645352a5aba8@eucas1p1.samsung.com>
 <20221007120528.58106-1-p.raghav@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221007120528.58106-1-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/7/22 08:05, Pankaj Raghav wrote:
> Expand the reasoning behind using QD1 for zoned devices with io_uring_cmd
> engine.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>   examples/uring-cmd-zoned.fio | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/examples/uring-cmd-zoned.fio b/examples/uring-cmd-zoned.fio
> index 58e8f79e..89be61be 100644
> --- a/examples/uring-cmd-zoned.fio
> +++ b/examples/uring-cmd-zoned.fio
> @@ -1,7 +1,11 @@
>   # io_uring_cmd I/O engine for nvme-ns generic zoned character device
>   #
> -# NOTE: with write workload iodepth must be set to 1 as there is no IO
> -# scheduler.
> +# NOTE:
> +# Regular writes against a zone should be limited to QD1, as the device can
> +# reorder the requests.
> +#
> +# As the passthrough path do not use an IO scheduler (such as mq-deadline),
> +# the queue depth should be limited to 1 to avoid zone invalid writes.
>   
>   [global]
>   filename=/dev/ng0n1

Applied. Thanks!
