Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6E4C6FA82
	for <fio@archiver.kernel.org>; Tue, 20 Sep 2022 21:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiITVsB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 20 Sep 2022 17:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiITVsA (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 20 Sep 2022 17:48:00 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFCA61D50
        for <fio@vger.kernel.org>; Tue, 20 Sep 2022 14:47:59 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id w2so2819001qtv.9
        for <fio@vger.kernel.org>; Tue, 20 Sep 2022 14:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=fIajJoXPq5LA3QmPE622MG8pJK+SDZQBiwqm6Bbeq7o=;
        b=NrlYxe4xvv3WEhSjKLDujNTSBlT1/52/ps/s6NFQdz0hDGP4In/SiCa+r1n9wuMxk7
         StnFYWgYgPeCMEAS1LnACWOztxifb3CLuQDWGgRCLp61r6fRJIqYv9HJRQCMOW5ZvqrG
         8rsZjn30P8JDTmukZw9TMGp/zHdThyo9OdXNqCaDX2k4W1CQPSXmx9b0Kko1uUSRZNr+
         WIWm4c2/PD7vY7rMfDZ+oWhc8CPsswSu3WC5XcKIfifn0i914Dwim0cmCNFPrE4UEt/n
         mMYJjtCWPsjCzXVGark+8MC3m9HIo8Tdnin/yQak6XOmbmOdFf426Z6c4HaZvDREdja9
         vGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=fIajJoXPq5LA3QmPE622MG8pJK+SDZQBiwqm6Bbeq7o=;
        b=vGnBv6dzP7AKZ/fc8TSY9mSk+QT7lgXlYxLs0/3tABzLk+2JhNAKCcQ2XJ90hAuHG5
         ZpvrfPK3uVOXOSW1D75ewSCLJ4+YvN6Yeur38TOhBhT2FQ9bxyfnsW1LnghLTIM0gqat
         QpZ7HF5QqExSDjP3EjJpuNDbNJDgmYjfFGqlQKohWmLSV629jDg+ZtM9z0IbiiqpJneq
         1+vPAM1v3Cy4aXuhojiDq9FgTydNVAFYvrwv8qMgGavDqN+5IjYC3D4ngSl9EVJsN8+7
         q2UDYdFz2DZFFQUD3z1wUd62AUwbD3v+hsNqvoLgiJL2iE5w3CWvZU09um4pUaXpf4PA
         cIOg==
X-Gm-Message-State: ACrzQf0JV5TxTe3cclf4MrNvlLwt49ETqYeUCDe+0+cisCNLGh3o/RO0
        1A6Bflu658eWuXOaqtML1Z4/o6+bIXs=
X-Google-Smtp-Source: AMsMyM5zYYiNUSIDUaBonHuXwua61RY3rBOrjXWs1ejCKE09k/ccUSsL8QUWauZJPYlktdwUPSlmlA==
X-Received: by 2002:a05:622a:406:b0:35c:b76f:909f with SMTP id n6-20020a05622a040600b0035cb76f909fmr20751226qtx.432.1663710478248;
        Tue, 20 Sep 2022 14:47:58 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bs39-20020a05620a472700b006bad7a2964fsm592621qkb.78.2022.09.20.14.47.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 14:47:57 -0700 (PDT)
Message-ID: <0ba23bde-1b80-414d-c520-ab39687bf892@gmail.com>
Date:   Tue, 20 Sep 2022 17:47:57 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Project to standardize on IOPS per CPU core
Content-Language: en-US
To:     Stephen Bates <sbates@raithlin.com>, fio@vger.kernel.org
References: <YyoBne389mzhCT8J@ip-172-31-63-112.us-west-2.compute.internal>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <YyoBne389mzhCT8J@ip-172-31-63-112.us-west-2.compute.internal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/20/22 14:08, Stephen Bates wrote:
> Hi fio'ers
> 
> I have been working with a few others on NVMe performance in a range
> of different environments. At the same time I have been tracking some
> of the reports on IOPS per core for NVMe+io_uring [1][2]. I was hoping
> to create a standrd and repeatable test for this using a mix of
> packer, Ansible and AWS machines.
> 
> The idea would be a scriptable flow to obtain a working
> fio+libiouring+kernel on some AWS EC2 instance(s) and then automate
> some tests to obtain IOPS per CPU core.
> 
> To help me get started on this does anyone have any pointers on how
> best to configure the system to maximize this metric? Also any fio
> scripts for this that people can point me too would be excellent.
> 
> If there is interest I would happily work this into a patch for fio
> (perhaps in some sort of CI way).
> 
> Cheers
> 
> Stephen Bates, PhD.
> 
> [1]: https://www.phoronix.com/news/7.4M-IOPS-Linux-Per-Core
> [2]: https://twitter.com/axboe/status/1452689372395053062?lang=en

Stephen, t/one-core-peak.sh was added last year by Erwan Velu and might 
be useful to you:

https://github.com/axboe/fio/blob/master/t/one-core-peak.sh

Vincent
