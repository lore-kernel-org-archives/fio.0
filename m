Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAA9C64ED6
	for <fio@archiver.kernel.org>; Tue, 28 Feb 2023 14:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjB1O3t (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 28 Feb 2023 09:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjB1O3q (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Feb 2023 09:29:46 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD64412064
        for <fio@vger.kernel.org>; Tue, 28 Feb 2023 06:29:45 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id r5so10580648qtp.4
        for <fio@vger.kernel.org>; Tue, 28 Feb 2023 06:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WLjnl1YDcSNtsvhij8BvdY96Ps1M46/weioKqx+vZlo=;
        b=CKR4KUPfu+l1MjWrFZI6fa6v60ULKYnck7ZhGAdOnpUIs+wUZhcMD0rJR//RSuc6za
         dy/QzXvMBQH3n+qIxK7LSsDmcZr1lRcHqFz38NybZBEFV8JmymFLXkQU6P1QWE6gC9LO
         pzJ2+nfthsTNGJe3c62f0jbrSpqi28C/oJLnQG6WvFs0edULb5RH5hhlv9aXqEhlqf1J
         yRVSge/hO+VkFb9S1WNkSwt+BUu1ybHt2+IIcR/aCWHAvQIxJEOxPhtUzYU0SdjR8lO+
         UE6LPY4BkEYm0jiuNarR1HKpTJnu/ZTLM25JDnthWf7e3CbiBi3JiOjVVUCCFjv1s2QM
         FofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WLjnl1YDcSNtsvhij8BvdY96Ps1M46/weioKqx+vZlo=;
        b=OSj8aot8foj7QGK4Mke7uEV5hQ7wXXGY01xNaLgfcWt6AT0GnHKm7yGdGAIBydz/QD
         7/oYqSE1hxIVds/IsXesURUIkFjc0VsKaLgHdDi44PmHTg8/2fgvvI6ahjZ7/4C4l5Mb
         KwdKzBgKL7FGi7bCdhKuZNWkhKHqZCKVFlyUJVbCBXnbKb70pZ7iOQzPEzOA8M0PseAb
         0F4yr46lPf/wwYYsCENGbol25/LkDGK2ZCoHTq9vuD257rXZUXTkjAPragaHm2vVJ5ZP
         9ianFouhka0oC346uFtrIAQvOLMeWgeSKXeX5QJRpCU5XKc6wjq2VRgyLM7CVpSCw+8e
         HSNQ==
X-Gm-Message-State: AO0yUKWy+iSO0NDdDx34rYguqa46PwnxomO9GuKqq589SuAwMgdVPh3R
        jYBq1pYGtIvV50k+y+3yI84=
X-Google-Smtp-Source: AK7set84PBaVF6b1sfwgovogVR1N8C/ahg7liOxf6z0yUGK/pgeYVqRkj7CMT88DKQhSMZR49zLpvA==
X-Received: by 2002:ac8:5893:0:b0:3bf:d8b6:4ca1 with SMTP id t19-20020ac85893000000b003bfd8b64ca1mr4743745qta.28.1677594584256;
        Tue, 28 Feb 2023 06:29:44 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id c13-20020ac81e8d000000b003b84b92052asm6613625qtm.57.2023.02.28.06.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Feb 2023 06:29:43 -0800 (PST)
Message-ID: <704ce5a8-f1b4-bab2-374c-0a9b2ffa8410@gmail.com>
Date:   Tue, 28 Feb 2023 09:29:43 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHv4] fio: add fdp support for io_uring_cmd nvme engine
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org, axboe@kernel.dk
Cc:     its@irrelevant.dk, Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20230227155134.819147-1-kbusch@meta.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230227155134.819147-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/27/23 10:51, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Add support for NVMe TP4146 Flexible Data Placemen, allowing placement
> identifiers in write commands. The user can enabled this with the new
> "fdp=1" parameter for fio's io_uring_cmd ioengine. By default, the fio
> jobs will cycle through all the namespace's available placement
> identifiers for write commands. The user can limit which placement
> identifiers can be used with additional parameter, "fdp_pli=<list,>",
> which can be used to separate write intensive jobs from less intensive
> ones.
> 
> Setting up your namespace for FDP is outside the scope of 'fio', so this
> assumes the namespace is already properly configured for the mode.
> 
> Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Applied folding in Ankit's sfree fix. Thanks.

Vincent

