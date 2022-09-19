Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DA4ECAAD3
	for <fio@archiver.kernel.org>; Mon, 19 Sep 2022 14:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiISOYG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 19 Sep 2022 10:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiISOYF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Sep 2022 10:24:05 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30F51D316
        for <fio@vger.kernel.org>; Mon, 19 Sep 2022 07:24:03 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id h21so20672073qta.3
        for <fio@vger.kernel.org>; Mon, 19 Sep 2022 07:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=vT4IvyZO95Bcb3H6fLkP4KHiVJtt1hMDyfUBc5yLuyw=;
        b=qqdXTawyVqi3zXDIj2FjfMIY5dycXmyU+zX7aQuPl8sea2pmqxqpDvua8tndEdUXDs
         q+IhCgiM6azm1qPPJkFEW8M7zm5UfS55Ui4SkoE1YsAo/b38uKAkIvsmTaq6y+zbO/0K
         JPSxBdjVwopqXqdPMsekea/96VuEHOPbskTlgLiuzbRn87dUNf9CadwEpz8WOy0XmfBZ
         1I6hFOfrEZniPpBvP6xNTMYNUntOzNGrgQeTUI2Q9P6ngicf6F46s48n0O3Ii30uxzT8
         KzxrZunucCvVWzKm6hym0Q/upDscxngg1ujWo21PKFmYAWmXV/N2Xp6fusy2SvHoOvh/
         vjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=vT4IvyZO95Bcb3H6fLkP4KHiVJtt1hMDyfUBc5yLuyw=;
        b=JGUogNohcY8hrmnLsX5lBH+zKYaRJQuB9AjSmSJ2ZjUIjfp1iMxSmmH+a/3UVxVi4T
         Hfv7lCK8V5QjGtPBbO7O7vK0Gj7GrVHTeGHvRMViuVcoCGyeSqoCRsu7JT9VfVIibU6O
         OPu04Kw0Ac4PwxkP6CwUFZ4Xp2DMzY5YTS5TlPHvOoCXlbH8TTlCf81q2sm6FAIfxuQw
         YhssQSxTedBblwufFUwBg9D3GnlHYNFK9QoC3HZuslEtDEwYtRAt0mLPDGCgq3LwL+SP
         LnAMCivjpQ5TjqadpZ0oDlQh5SSCl2EZsDiD7Eym6kwQc9rhqsnterQUVKEekBlpit4f
         cV9A==
X-Gm-Message-State: ACrzQf2kUWXv1dEogwsHn1yGXV9PVRREyt723WGMnSCrmser+foS+Z5U
        tNW93mcxQDHfzRYyLfgZ0hw=
X-Google-Smtp-Source: AMsMyM7CdHRxXYJhEaNj98PfOqZ5y4ntM5B8lesUKKP132xY0TuktFWt5lcH/ggvAt+CNIWTuvtlrA==
X-Received: by 2002:ac8:5f53:0:b0:35b:b155:1c1f with SMTP id y19-20020ac85f53000000b0035bb1551c1fmr15437836qta.148.1663597442701;
        Mon, 19 Sep 2022 07:24:02 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bm29-20020a05620a199d00b006bb11f9a859sm13453624qkb.122.2022.09.19.07.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 07:24:02 -0700 (PDT)
Message-ID: <4f2ca76e-30a3-e58d-4b13-6c1a43a6fddc@gmail.com>
Date:   Mon, 19 Sep 2022 10:24:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: configure on FreeBSD reports "grep: The -P option is not
 supported"
Content-Language: en-US
To:     Rebecca Cran <rebecca@bsdio.com>, fio@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
References: <7b55f5b3-ae72-b99a-9fe1-04d60ba7161e@bsdio.com>
 <9295573b-a112-eaba-f441-99ccad62d5c8@gmail.com>
 <26076f36-54d5-ca6e-0b96-a7371b1c5e49@bsdio.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <26076f36-54d5-ca6e-0b96-a7371b1c5e49@bsdio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/19/22 09:15, Rebecca Cran wrote:
> On 9/19/22 07:12, Vincent Fu wrote:
>> On 9/18/22 23:33, Rebecca Cran wrote:
>>> It looks like commit 7ff204c83595cd7d6b7b6a813d9fda97afd25198 
>>> introduced an error on some systems such as FreeBSD, whose grep 
>>> doesn't support -P.
>>>
>>> num() {
>>>    echo "$1" | grep -P -q "^[0-9]+$"
>>> }
>>>
>>> ./configure now reports:
>>>
>>> grep: The -P option is not supported
>>> seed_buckets                  4
>>>
>>> Is -P required?
>>>
>>
>> Hello Bex,
>>
>> Does it work for you to replace -P with -E?
>>
>> Alternatively, what if we replaced grep with
>>
>> test "$1" -eq "$1" 2>/dev/null
> 
> 
> Replacing it with -E works.
> 
> 
Bex, change committed here:

https://github.com/axboe/fio/commit/d14687025c0c61d047e4252036d1b024d62cb0a6

Thanks.

Vincent
