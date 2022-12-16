Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1904EC4332F
	for <fio@archiver.kernel.org>; Fri, 16 Dec 2022 15:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiLPPvd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 16 Dec 2022 10:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiLPPvC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Dec 2022 10:51:02 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EF6A1B1
        for <fio@vger.kernel.org>; Fri, 16 Dec 2022 07:50:44 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id pv25so1869694qvb.1
        for <fio@vger.kernel.org>; Fri, 16 Dec 2022 07:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJY6TkTGIss6u46rEZ0rgzeMsi3mIaKtYwan6a3DpWg=;
        b=VKvL6TGmV2RwIAfTmvNC39WMKzBCdJ9KakoJAz5z944bxDSex7SB9QmX+343Fks4Q7
         vaBHeXNNP1RL0u0x0+iDe0slKCh05BePlYguHdhM+m2U4b1GtDsBjjzVkxxSutG7QQsk
         9MDetL0D7c2wrWqtGRo+s7AZ0dEyHdvPZ5wRcInDEJMgPBA5tB30maFaJU/okLvIi5xw
         MsdX5hYjuDI3tuvOj8pPLClFxwS/96Nis8QRD60zXCMrRUn+PH6YyZAwnPOndYnkK8TC
         /wYM+WxgJvgihCHJeGyJMKeJ8+WNXpBYarIrEaKyg9rOP65HLiI8E4KmKJ2hvFK9TV4P
         YoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MJY6TkTGIss6u46rEZ0rgzeMsi3mIaKtYwan6a3DpWg=;
        b=6ol35CqdS8gHfSrsBh6u366/Dk+uXp2boCuM5Ys4a9xvIeKn5TbnsP+Ub1YjDwzIOY
         MZwd6DHtx/sZxSkMI4x4uZCm4YBMlcx4Fau7BHtSQ7bo7I1NGvM314tUD4jHK0tK+nek
         VHouDfhLiBJzHBk5ok09BlukLPQZRUebO9e47O250h+jMnQOeTVfEUt0MON6uoSFcAqB
         uB7gsbA1Qktt1hMGz065hVY/HXPo4x6cuGGcoEinlWKzE482VHEPyB6/DvKdS0zZ0q0u
         d/sQy5kS/JIcO6K2oLKJySnnLqe28efeCMO6mfVGDQ3TwI41Uj7kFTQc6ni67loEWSSc
         Zrcg==
X-Gm-Message-State: ANoB5pk5z1G56hjWenux/Ku3rYIrv/VQ0Vbu1G0hsCWFR1OGJYqW0h6D
        euRboCx38SUiMtPDNkJmTTrWXnirajs=
X-Google-Smtp-Source: AA0mqf6Hvr6SAMFBqDjymsoiCTou6fR6vuuGxfpDewRXpTVVxQfTQz13iom/7s2VsWtKSJc9pkWpRQ==
X-Received: by 2002:a0c:ee8e:0:b0:4bb:85f1:e2a4 with SMTP id u14-20020a0cee8e000000b004bb85f1e2a4mr44711543qvr.31.1671205842910;
        Fri, 16 Dec 2022 07:50:42 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id u7-20020a05620a430700b006fa31bf2f3dsm1710394qko.47.2022.12.16.07.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 07:50:42 -0800 (PST)
Message-ID: <9117fd15-051a-06de-c9da-dfecfe6d139b@gmail.com>
Date:   Fri, 16 Dec 2022 10:50:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc:     gost.dev@samsung.com, joel.granados@gmail.com
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Fio blog post on measuring write amplification by Joel Granados
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I am happy to announce that the fio blog has a new post. This one is a 
guest post by Joel Granados on using fio to measure write amplification. 
It describes using fio of course to issue write commands but also uses 
the exec ioengine to launch an external script that measures device 
writes. Take a look:

https://github.com/vincentkfu/fio-blog/wiki/fio-waf

Feedback is welcome!

Vincent
