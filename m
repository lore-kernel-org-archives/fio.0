Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB98C433EF
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 12:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A005161157
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 12:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351718AbhIHMtl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 08:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349243AbhIHMtg (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 08:49:36 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4E3C061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 05:48:28 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id b4so2141891ilr.11
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 05:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UZbwhzfg1aUpGyTJvWE4IT/0WzCeriPPlUnLC6cE9PI=;
        b=Zlf7ADrEXHSbzF8ubNSgSDQQxhtV5Ci82nEwkbcwfoNMlRO+oczL55BvE87tu0EymU
         Wq9xl7014zpf0a+Wq2jxk2vKxKNeHzwStIBjnaKgifFvyHCcaDTGDbRlj1bt5ZWa6oCf
         0Fjh0s/wF9+6OYwdazCAm0OVrhlGSvDAg4nemKeKAnJ1dY+gvnf5+aVYL5Gyfzog0KsR
         WU8erJY6VMG716KX+RByCMNnThhJyUOl6/wCaAoTgJ1b+PLYfg63PjI5DoqeM0dhJpJz
         OfDO1IMoUnQysXYm7m8ymptlRrWawHg1VbmadL7vybuYaOTk72nu8Jnziu7hd3Kw5aBk
         eIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UZbwhzfg1aUpGyTJvWE4IT/0WzCeriPPlUnLC6cE9PI=;
        b=QbBOgNE6OtYBNw0do2JQtOU/xTDhGl+ZVFRToCgXfZ29SLJYuvzyiz+sIDB+R2IlvX
         Y0LkZ8roJ8HjU8fAjZDiGQbPWJ9p3jt4cmb8x70HQUHuvddjIvTiImlCH2Tr+NK9Pbdk
         0AvE5gfudPSQWaOvstHwOOVBltTV/kyQ00Psgm0bpsqhXKrMf7YoF1mQdRFdKRZ/sEFb
         TJV0Qp0pU1Jp3eKZE65xi9WgZ+L07v8zqalBxoi5ZJRmyS8MuILlVLcNxDFbYH0/3Y5d
         BP2q6LdtCFnMKsowm7YNqDXrWM+sTGm71mIsS5M1wvzn0Vu8NR0fC6dWJovOKztLJwVP
         OlSw==
X-Gm-Message-State: AOAM532uC7XrkoUGrhmVMIbZDvr2+u6sezm95OgDXht5d1k3VPK2oI+p
        z7AL68a4+K14G8Y7IEIW6p8Xk2oVc23lag==
X-Google-Smtp-Source: ABdhPJxGJPkacnKC3mpOOzuHWRwnyZmesOxk7YNonuJHHIWfcRPGMmcQeaKW4Qyt+A66Dlo5awxbOg==
X-Received: by 2002:a92:194c:: with SMTP id e12mr2793827ilm.3.1631105308189;
        Wed, 08 Sep 2021 05:48:28 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s7sm1059076ioc.42.2021.09.08.05.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 05:48:27 -0700 (PDT)
Subject: Re: [PATCH 1/2] t/io_uring: fixes in output
To:     Andrzej Jakowski <andrzej.jakowski@intel.com>, fio@vger.kernel.org
References: <1631074245-16080-1-git-send-email-andrzej.jakowski@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <05dd6a56-d210-f47a-2f26-ab287d18ac19@kernel.dk>
Date:   Wed, 8 Sep 2021 06:48:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1631074245-16080-1-git-send-email-andrzej.jakowski@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/7/21 10:10 PM, Andrzej Jakowski wrote:
> Provide description of available options in usage command
> and fix alignment so they look pretty.
> 
> Also remove debug output.

Applied, thanks.

-- 
Jens Axboe

