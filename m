Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE797C433F5
	for <fio@archiver.kernel.org>; Thu, 29 Sep 2022 17:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbiI2RXY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 29 Sep 2022 13:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235025AbiI2RXA (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Sep 2022 13:23:00 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF141EC9A4
        for <fio@vger.kernel.org>; Thu, 29 Sep 2022 10:21:44 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id r14so1324511qvn.3
        for <fio@vger.kernel.org>; Thu, 29 Sep 2022 10:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=GCjIU1XIA1xouLtLl04vL/thkwRjssClOVqB8qvDg/g=;
        b=P5r+/a5+zWDVPk5eOvB5M6UyVsMGo565XUgd7GGnvArRO4SXYcovezBtIAzDo/8iEU
         OlVCT6Lc4Vb5SooDWyzRXcLONQlyAlv3zyji6TELX3R0Hp7s2S6naq73O66Y5LIZGcFU
         j5okSbjvG4twjle2vmuWM86eC8obQYZDn7HM95EsZ2nH39d4T1whHfPbcCSgexAcuDYn
         /a0Gmjxz1p7ZIJjqCDiiwyr6kgiNJhbByLYHzHf5IdLzUaa2Tp1KhLZAp0+2ZjYvHtWJ
         y90vDoG9OvRo8laoEQBN4ybub8Y3Cgq1DZuFddGHLAmnH75C4A60I8RXrzPEbkGGU2Fd
         vL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=GCjIU1XIA1xouLtLl04vL/thkwRjssClOVqB8qvDg/g=;
        b=qMkqq/m3ADgBuOieo4TYnMPLo2oxIpG4wKin73M4JytBj5CRDnUhzh1J8sk0d9uBs/
         uPdcWM262L4Zg1A6i1zcl7sXdaj4A0dBqVgd/DD2fzFx8eoCBQWPck82BTmpYxGwemar
         atf+SG7Kax5e1Jq+gZIB0NliqxhkQRK/rq3B14B9SO2Ht9b/Ggcz7ySpPAPz8gsTXkdV
         esRmSyhAr2PYSrtQ/XLKb9gP9VfiQ+DMu5kIo+YNzg3Q3PEaew6sKDg1A3E7maJ5bFwq
         wzukqJN2ZxSZIiM9OWA/TtveFNhnNIh9MvXlGmLVP3PCTY3a+NwQlvBLkcRklvsMvOLd
         o+2w==
X-Gm-Message-State: ACrzQf3c2yxQx76bNRpTKzSB+4+IEueacswGWnExFGlvjmm5Q57KdWdj
        0kn34Gm4tMYBeNfBCz796FBsh4kx50sPVQ==
X-Google-Smtp-Source: AMsMyM4RXcOqNinWm7K+51qbYUJST+xVOhEv/izeitRXPgNWAOaqAKA00eaT11ydKH2pct0ugcmKBg==
X-Received: by 2002:a05:6214:20ac:b0:4ad:79d:dde5 with SMTP id 12-20020a05621420ac00b004ad079ddde5mr3538371qvd.76.1664472103635;
        Thu, 29 Sep 2022 10:21:43 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id k6-20020a05620a138600b006bc56c063fcsm6295979qki.62.2022.09.29.10.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 10:21:42 -0700 (PDT)
Message-ID: <74177734-41b8-8340-a308-5c9aa3f104c6@gmail.com>
Date:   Thu, 29 Sep 2022 13:21:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>, gost.dev@samsung.com
From:   Vincent Fu <vincentfu@gmail.com>
Subject: blog post on timekeeping in fio
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I have written a blog post describing how fio uses the CPU clock to keep 
time. It's admittedly a slog to understand the entire process but I 
think there is some nice engineering in there.

https://github.com/vincentkfu/fio-blog/wiki/How-does-fio-keep-time

Feedback is appreciated!

Vincent
