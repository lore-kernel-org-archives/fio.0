Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FBFC54EBC
	for <fio@archiver.kernel.org>; Tue, 10 Jan 2023 16:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbjAJQW5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 10 Jan 2023 11:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238604AbjAJQWv (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 Jan 2023 11:22:51 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1540271884
        for <fio@vger.kernel.org>; Tue, 10 Jan 2023 08:22:50 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id j15so5832903qtv.4
        for <fio@vger.kernel.org>; Tue, 10 Jan 2023 08:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xTLn0l8XJmuBYtsJb/3FpK+JdEixWN72PXLUtJ/BGLk=;
        b=O4RYgdXs7I+qHpVJjPqVbJo1UTJlAeo9CxpabeO5BRsvRxxTfaxoE1JURC5gq4ntxY
         +vMbAeBO7zS4OOFDsG8nCUIzEAVfYy7upA69J0IWIqhU5UR7DTbbN+jr2ydcWoX7cGBn
         p9mTk5OCuBvGZH1Kg6zTLnam7jL5t0y39PEpTR0uZZeV0EPtpju2EyxSClyIbJsU9wua
         TSrYZw+wILfxOIkbjahM5cwkn5HrqaC7JQlBMZdBvVHZzAdH8fo714ZE0zrd7E+flE6a
         +DdxecqRMi83T77mnDEn3MBydhfGTclG50IjVe61OzJOkpcg6J9CFVzqBiOkiCqDDx+p
         f+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTLn0l8XJmuBYtsJb/3FpK+JdEixWN72PXLUtJ/BGLk=;
        b=3Cz/O8eH5yi9ai65/DtXoWgTA8xx4nIoHwr0Wvv3NprIvw1MK7/usl6TKJLu6cO6W3
         /DQHBooQJZO+C2iRsdOE7aGwd/GmJZzfecUYAur9xZME08NdvhCTY2hb41eYLTXyJ/Xr
         FcEM9xDcF2wwBZk88kRMGFvT1eob1rOiU3b3NfTaqUrxW1fBHUbOnRwNCCshFbkAi+Nn
         /Pfp3yiC0oZHKDjiZhR2MzQKy63vMHSsauU/wQ9WlzTZuc+mHVUObz2D7VhhwXwq2wGq
         ZQUlqDrawILfVASHuYKG77mIrl8kH38Lh48um2f/SH3N8V+xUbmxrXNUcbOtTMy2Nlr2
         cIXw==
X-Gm-Message-State: AFqh2koAORRdZ8mLs8SLZ1y6HGBI97/derTI4UINzfSkSG6ATlS9XbVL
        7ns5DAZUIP3qT7GP4VBe+Os=
X-Google-Smtp-Source: AMrXdXs3NJmI4pU6n/WoIFakhC7e4mpjfI0naMRxk2b3cug7augE1eUM9yKkszuOrvUVLVuwOe0eyw==
X-Received: by 2002:ac8:5e06:0:b0:3ab:5bb4:ae6d with SMTP id h6-20020ac85e06000000b003ab5bb4ae6dmr124881886qtx.43.1673367769045;
        Tue, 10 Jan 2023 08:22:49 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id x23-20020ac87ed7000000b0039467aadeb8sm6138277qtj.13.2023.01.10.08.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 08:22:48 -0800 (PST)
Message-ID: <af40d4b4-2ce8-3e34-ddf5-a57fe4d14547@gmail.com>
Date:   Tue, 10 Jan 2023 11:22:47 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/1] doc: clarify the usage of rw_sequencer
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org
References: <20230110064240.30344-1-ankit.kumar@samsung.com>
 <CGME20230110064319epcas5p3de72dc6ff06df62ba8d6441878c4ea6b@epcas5p3.samsung.com>
 <20230110064240.30344-2-ankit.kumar@samsung.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230110064240.30344-2-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 1/10/23 01:42, Ankit Kumar wrote:
> Update man page clarifying the usage of rw_sequencer=sequential
> 
> Fixes: https://github.com/axboe/fio/issues/1223
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   HOWTO.rst | 10 +++++-----
>   fio.1     | 12 ++++++------
>   2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 0a48a453..806c1053 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -1176,11 +1176,11 @@ I/O type
>   			Generate the same offset.
>   
>   	``sequential`` is only useful for random I/O, where fio would normally
> -	generate a new random offset for every I/O. If you append e.g. 8 to randread,
> -	you would get a new random offset for every 8 I/Os. The result would be a
> -	seek for only every 8 I/Os, instead of for every I/O. Use ``rw=randread:8``
> -	to specify that. As sequential I/O is already sequential, setting
> -	``sequential`` for that would not result in any differences.  ``identical``
> +	generate a new random offset for every I/O. If you append e.g. 8 to
> +	randread, i.e. ``rw=randread:8`` you would get a new random offset for
> +	every 8 I/Os. The result would be one single random offset and 7
> +	sequential offset. As sequential I/O is already sequential, setting
> +	``sequential`` for that would not result in any difference.  ``identical``
>   	behaves in a similar fashion, except it sends the same offset 8 number of
>   	times before generating a new offset.
>   
> diff --git a/fio.1 b/fio.1
> index eb87533f..c5ba0436 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -952,12 +952,12 @@ Generate the same offset.
>   .P
>   \fBsequential\fR is only useful for random I/O, where fio would normally
>   generate a new random offset for every I/O. If you append e.g. 8 to randread,
> -you would get a new random offset for every 8 I/Os. The result would be a
> -seek for only every 8 I/Os, instead of for every I/O. Use `rw=randread:8'
> -to specify that. As sequential I/O is already sequential, setting
> -\fBsequential\fR for that would not result in any differences. \fBidentical\fR
> -behaves in a similar fashion, except it sends the same offset 8 number of
> -times before generating a new offset.
> +i.e. `rw=randread:8' you would get a new random offset for every 8 I/Os. The
> +result would be one single random offset and 7 sequential offset. As
> +sequential I/O is already sequential, setting \fBsequential\fR for that would
> +not result in any difference. \fBidentical\fR behaves in a similar fashion,
> +except it sends the same offset 8 number of times before generating a new
> +offset.
>   .RE
>   .TP
>   .BI unified_rw_reporting \fR=\fPstr

Ankit, how about:

"The result would be a sequence of 8 sequential offsets with a random 
starting point."

Vincent

