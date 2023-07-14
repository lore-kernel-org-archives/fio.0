Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F6FEB64DC
	for <fio@archiver.kernel.org>; Fri, 14 Jul 2023 18:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbjGNSHh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 14 Jul 2023 14:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbjGNSHg (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Jul 2023 14:07:36 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1754430CB
        for <fio@vger.kernel.org>; Fri, 14 Jul 2023 11:07:01 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3a3b7fafd61so1755974b6e.2
        for <fio@vger.kernel.org>; Fri, 14 Jul 2023 11:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689357967; x=1691949967;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wQ0SICVWatYmHi5DaCcgK0dZ1uVrEmy7WGOXaRTWbPE=;
        b=XkywLumWoTid4Qspg+/DUehwkAk9RomAsh7ZrDWSBq7qD/rTahxjNcAasMUn5CaNw+
         +8BagJRmcvE4KbIIgSHSbI/lgiOEzK8o3Ri5aXxg2d1Pxkl3d/FVHywIGIH56bMv/Ej/
         yDqMyKDeHhEffOv5IkhyNa303Ky/j9gdvlVYBB1PaWcXyBkN1q6/S9+gXZYRF4zXzZ1i
         IFJmpSfVVM54Cr2pgEIXDr/d2tF3tPfHcnIXc7rT31pM4XmfO2ddUG53AzxyEXqnUCIz
         R9K7ST/FCtSOg9BLprQN5MLH3RmqLJdqTEOiIV2bruL/UesNy6mh6+JmqZdcavpedunw
         5CTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689357967; x=1691949967;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wQ0SICVWatYmHi5DaCcgK0dZ1uVrEmy7WGOXaRTWbPE=;
        b=A9Z6LURdi4zMUMlYPCvjnPPHkRq6QkO1tmkXGg0NsZYh/8UsvdFStTFPkSvCi1GmXk
         L4y3CTZKvSs+3dm4Att37xXnAj303Ew+4193N1CgFOjW0Mh8tcX9ZOhxr3qhDtJq3RSY
         xUiPutm60UsApI89fqzzz0GoblT328kex2k+AIVCnzFQ32W4t2ZcUuvbppKSMWGsuyLl
         /zHaUv6lEqL0Mdxpvu94QtkLdPRHthfc5lSeNv+qCPIBuZNTKl2MvD5IK75yX86D8huz
         k28xS13ym4f1tFV6F1L6NnO4/AG47M1TuxvTmpN1D8Ek2DqFPOeGWTyWe8Mt2Ev4kIoa
         KO3A==
X-Gm-Message-State: ABy/qLZGOalUz4pB+0Zd+iXsabOEpf1vgT6our00EGXOfUIzU3nBMCv+
        5X8y8El2Drwsf1cwzxksWH5Z/m4W+IS5mXPO
X-Google-Smtp-Source: APBJJlGedTWDwhYzexztqEt/HEzA2QXUmsqgNnLD14tOXNlktR2lPfIozCALu5YP7hoZOBGS0avWmw==
X-Received: by 2002:a05:6808:f92:b0:3a1:e7fa:cd76 with SMTP id o18-20020a0568080f9200b003a1e7facd76mr6996503oiw.10.1689357967089;
        Fri, 14 Jul 2023 11:06:07 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id d28-20020a0caa1c000000b0062119a7a7a3sm4210752qvb.4.2023.07.14.11.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 11:06:06 -0700 (PDT)
Message-ID: <3d8d379e-bfb2-89e0-2979-3a430638c61b@gmail.com>
Date:   Fri, 14 Jul 2023 14:06:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/1] thinktime: Avoid calculating a negative time left to
 wait
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "ankit.kumar@samsung.com" <ankit.kumar@samsung.com>
References: <1689354334-131024-1-git-send-email-mikelley@microsoft.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <1689354334-131024-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/14/23 13:06, Michael Kelley (LINUX) wrote:
> When the thinktime_spin option specifies a value that is within
> a few milliseconds of the thinktime value, in handle_thinktime()
> it's possible in a VM environment for the duration of usec_spin()
> to exceed the thinktime value. While doing usec_spin(), the vCPU
> could get de-scheduled or the hypervisor could steal CPU time
> from the vCPU. When the guest vCPU runs after being scheduled
> again, it may read the clock and find that more time has elapsed
> than intended. In such a case, the time left to wait could be
> calculated as a negative value. Subsequent calculations then go
> awry because the time left is cast as unsigned.
> 
> Fix this by detecting when the time left would go negative and
> just set it to zero.
> 
> Fixes: 1a9bf8146 ("Add option to ignore thinktime for rated IO")
> Fixes: https://github.com/axboe/fio/issues/1588
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>   backend.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/backend.c b/backend.c
> index d67a4a07..b06a11a5 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -897,7 +897,16 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
>   	if (left)
>   		total = usec_spin(left);
>   
> -	left = td->o.thinktime - total;
> +	/*
> +	 * usec_spin() might run for slightly longer than intended in a VM
> +	 * where the vCPU could get descheduled or the hypervisor could steal
> +	 * CPU time. Ensure "left" doesn't become negative.
> +	 */
> +	if (total < td->o.thinktime)
> +		left = td->o.thinktime - total;
> +	else
> +		left = 0;
> +
>   	if (td->o.timeout) {
>   		runtime_left = td->o.timeout - utime_since_now(&td->epoch);
>   		if (runtime_left < (unsigned long long)left)

Applied, thanks!

Vincent
