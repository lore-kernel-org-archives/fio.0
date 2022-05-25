Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD5EC433F5
	for <fio@archiver.kernel.org>; Wed, 25 May 2022 15:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiEYPX1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 25 May 2022 11:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbiEYPX1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 May 2022 11:23:27 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2127CAFB12
        for <fio@vger.kernel.org>; Wed, 25 May 2022 08:23:26 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id y20so16612526qvx.3
        for <fio@vger.kernel.org>; Wed, 25 May 2022 08:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=IaVGGSYmYSo2jU1ajGr0A/okIB2Fu0ji5m9/P5XMZcE=;
        b=AdPOslsujgY8UgNmzvuJUnTteVfBm4qOtPrWkkojO1fGWAdxjUXDtCW2MaPVOfffI0
         fZkVqIQUYQ6OMjLOwRijboK/pTL4gexew70xHMd1kb/hYoU3/GtgbKVt/a5Drt/we1kB
         LpHnqep1WvZ/hTtybHhcs2M8L6O0GSh4zGRPu8tmEWmCK/L1y/1ZcxJFgWx5bHsMLZ29
         KDcWOjlaHuHsB8tpbBynB8mXe543n2gYfE9+/ZmXCMlM6SGUQoqM/yDm5iE+d/NeFKOK
         jDY0T6FCc63NkQoXyJz235sbcMQmfoRhHm/mm6R8zcG7Oy+xPJFNEzGWvinjZkj+NpF2
         3qQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=IaVGGSYmYSo2jU1ajGr0A/okIB2Fu0ji5m9/P5XMZcE=;
        b=okwSalqpB/tF3uT+keQ7VT8g42zkWXFE7cgALuXlXFy0xcdkg2vVgyIukBGuV9TGKG
         kvMVYmOOHPsc2NyZQWiS7JchpxqBjp5HOK4XCC4kwNprSYEYdExMm0UFZBkkUPHKY2iI
         hqw0LzpVYcjP6u71mi68Si5ShGJEtE9oPLB9TR3o9djEacWfWvdohEtLJC6Zyk4kItfn
         xcVwEKdbpokxqyn+u+MOoPlrsGjO/4LaP5rve9NBg0GqYP8yvFr/2gT7KXGAC2JAvJcS
         hMjUHuKewVwVNZ9Zg00vTU3vUBHcF9tUB0eHps88xxGlJ91+QD8vD9I/7fYcGspeKSPJ
         sPZw==
X-Gm-Message-State: AOAM533zsC/hfKHTt7h79e6ww3a/+KwZChEqT1RxXHd0Iz16QQ3TL7IB
        7g2jMELagR0xBGjkscstfEDVOztKNGgTIQ==
X-Google-Smtp-Source: ABdhPJy32OHXTwwec6VUfdbStYIP9Bk85HV6BEFf/9L5JaHJzXwYnJOsypL75QXXrjtbMp8xFvb+hQ==
X-Received: by 2002:ad4:576d:0:b0:45a:f221:6ba7 with SMTP id r13-20020ad4576d000000b0045af2216ba7mr26880080qvx.14.1653492204765;
        Wed, 25 May 2022 08:23:24 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-46-23.washdc.fios.verizon.net. [173.79.46.23])
        by smtp.gmail.com with ESMTPSA id g85-20020a379d58000000b006a0ffae114fsm1372829qke.120.2022.05.25.08.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 08:23:24 -0700 (PDT)
Message-ID: <74508867-2a7e-e541-94e1-4678d2fd42a8@gmail.com>
Date:   Wed, 25 May 2022 11:23:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>, gost.dev@samsung.com
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Blog post on detecting steady state with fio
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I have a new blog post describing fio's steady state detection feature.

https://github.com/vincentkfu/fio-blog/wiki/Detecting-steady-state-with-fio

Feedback is welcome!

Vincent
