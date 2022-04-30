Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6092FC433EF
	for <fio@archiver.kernel.org>; Sat, 30 Apr 2022 13:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbiD3NLd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 30 Apr 2022 09:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiD3NLc (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 30 Apr 2022 09:11:32 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB5756208
        for <fio@vger.kernel.org>; Sat, 30 Apr 2022 06:08:10 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id h12so9257277plf.12
        for <fio@vger.kernel.org>; Sat, 30 Apr 2022 06:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=M5VDwtLgTTW6fupYE3P3tISqyvfbw58e9xX/+aympG8=;
        b=F9dESD7NK1J6UEI68TT8XiZTIopSWx5BMSPjGEVRI4obs3dNKBfco8xqSumrk5ejKH
         pXHck6gcXl1Yx87K90+RaY5bCwmL812MeUEmV96dNVjTUOdrs+Ec42gz01EeEFRcO9z0
         7Nc5nczZCg/FEozu9bFBdQ5yCYcbS6UOHV2TQRBYZANxrAQxCGDf0LBy/Lh9qsf9ComQ
         ixQZY5BfPARifPc5DLZ0JnD3HYUynjPNYMBtD8DPoJzLchtrqAznzvVAfquKFXL9XCRV
         rmbyxO5crGOvMHuX0MDqB3PsxG2fkvgur/vzMsNw5oi29FYo79Bkj5etezxsA5KU9CJR
         vKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M5VDwtLgTTW6fupYE3P3tISqyvfbw58e9xX/+aympG8=;
        b=lpyogPTdgk7GJVIGmkLYEbGKg9aBZ+1oqOzCoHmos174J5fufmOFeDagTK1oczOipU
         5+5THA3LxNdAE+IkN9EaljGPZBaaDpwvs6MQaJW/tc/ASyvOb+z//CKtY392dkTfD2br
         EJz7vSkyq+E1/aLmccbB6mFz8seDVYUxhZeURPxy+qHzRyOKQt5xQsa+wkimwtVoTk1P
         7YK+xtPFHkT6s8UPJlW3lZIxbTwvhKS5z+Sva6nBD/Ct5IbWpWbTQmCdpL7H2wuQaqx+
         3g1WadvX9GwmGqw8/u9QbARe414tvthot+nTwvzfzlBUv3sOEoQGx8mV8VX+ordda8KT
         lB6Q==
X-Gm-Message-State: AOAM531pc62ssT1rRpS3DydysKPY4yWyUOujH0uESsTD76IWi3Z9+pLV
        Cf472gzmvbJ1NFOh8arDxTcEAvM4PLiLS1iL
X-Google-Smtp-Source: ABdhPJzVKR+GBLN+VpvY5o0h71f10/m9kIp0jXG6VG6bstA/kswGO6BW4P9t7qCvVltdy5p/6NYR6Q==
X-Received: by 2002:a17:90a:c302:b0:1bd:14ff:15 with SMTP id g2-20020a17090ac30200b001bd14ff0015mr9051704pjt.19.1651324088446;
        Sat, 30 Apr 2022 06:08:08 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d16-20020a170902b71000b0015e8d4eb228sm1441112pls.114.2022.04.30.06.08.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Apr 2022 06:08:07 -0700 (PDT)
Message-ID: <15f7bb93-9633-23cd-976d-4b8fc3ebde51@kernel.dk>
Date:   Sat, 30 Apr 2022 07:08:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v1 8/8] client: Add ENOMEM handling on `malloc()`,
 `calloc()` and `strdup()` calls
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
 <20220429004705.260034-9-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220429004705.260034-9-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/28/22 6:47 PM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Avoid a NULL pointer dereference bug. There are many places that don't
> handle the ENOMEM case. Add it.
> 
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  client.c | 107 +++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 89 insertions(+), 18 deletions(-)
> 
> @@ -473,6 +478,8 @@ int fio_client_add(struct client_ops *ops, const char *hostname, void **cookie)
>  	}
>  
>  	client = get_new_client();
> +	if (!client)
> +		return -ENOMEM;

I don't think we should be using -errno in fio if we can avoid it. Are
there cases where we need to discern one failure from another for alloc
fixes? Looking at this case, we really just want a non-zero return.

-- 
Jens Axboe

