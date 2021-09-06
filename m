Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E15CC433EF
	for <fio@archiver.kernel.org>; Mon,  6 Sep 2021 03:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50B0360F3A
	for <fio@archiver.kernel.org>; Mon,  6 Sep 2021 03:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbhIFDNE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 5 Sep 2021 23:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhIFDND (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 5 Sep 2021 23:13:03 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D87C061575
        for <fio@vger.kernel.org>; Sun,  5 Sep 2021 20:11:59 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso3576041pjq.4
        for <fio@vger.kernel.org>; Sun, 05 Sep 2021 20:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1S/YQo0Le/uRTYzKRPU3E6lSDIXhjOcp15Obh14DlGs=;
        b=h3qIjKAgfAP8wWXQ3hDYiVIXnmuN3f0pRdNnvgO0UBqZsv1Ikw0opMTfaIJx/O0FKn
         UFSXTcU/6ZIBiTTHf2ERf1ny9EMyJ5c+Sby/2T8AW+DIeRLBw4wpgTGrMa1fUzvWjGcc
         Dbq38kWjqib4P99VKrgVc8O2zByiAUf/exOV4dH1x7P1tQaObnyrMmDR5MuAd/KxMJCt
         zqknH9It0XCUYAFEGOcqDqx0Bf/dUzMdjHHwL4b8jGdn1rqz2ZH62k/y//YxTUQ8tKw8
         SWain3yCB6q8pQEzq9IoQ4RfJcOYJZyjO7cQnXdUbIPd9IkuHMyHnHBStP8vbAfHCnKC
         F8bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1S/YQo0Le/uRTYzKRPU3E6lSDIXhjOcp15Obh14DlGs=;
        b=BFmFEJ8UPmxahHQsyThi9/3LTEN/QbnF8JbHFhIz/ZVFjDpCWWedC56a4vhaMl6roV
         e0f4lYA4xX8N1tnCKS3zrsXWclBcUHz6hN0ZgVQkA8HcMKndfDD5QDC+Zm11vKbXAqVD
         5IdJYh1cdKsE0X4PT7/yY8EbcDDc5270NPXbxRALRI1r9Mkf0d09my9VS3SauenxX3r3
         3KCxzduHDMw0FhJJo9qV7q1u1njYU5DaOeAHjlHKgVpSUpqkit9bwl7Ig7QtXQMNyZIx
         LTfBffCkrNJTI8AOg4d3u7CBKfKVxNK4SVbNJSPGOrsgFAS5Dt5ZzazMMvgk16JzIpsT
         xcWg==
X-Gm-Message-State: AOAM533+JlcTTM0ZH8WtKIIlfViVOp60AkcCa+jLdHdBborDpd71incc
        2SS44ND8QEHze1gfub8FTeXUFclJ6cZnUQ==
X-Google-Smtp-Source: ABdhPJx94GYqQ2faiNWpb55aqiL5cLyMb5+PlbUe4CxG0OMAWeVPpomlsYjqBISizSdRMocxsZPSTg==
X-Received: by 2002:a17:90b:3742:: with SMTP id ne2mr11773507pjb.218.1630897919325;
        Sun, 05 Sep 2021 20:11:59 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i1sm5811975pjs.31.2021.09.05.20.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 20:11:58 -0700 (PDT)
Subject: Re: [PATCH v3] options: Add thinktime_iotime option
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20210906015000.1780077-1-shinichiro.kawasaki@wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b0287d99-2ef4-92bf-8a6b-68f9eb25a03a@kernel.dk>
Date:   Sun, 5 Sep 2021 21:11:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210906015000.1780077-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/5/21 7:50 PM, Shin'ichiro Kawasaki wrote:
> The thinktime option allows stalling a job for a specified amount of
> time. Using the thinktime_blocks option, periodic stalls can be added
> every thinktime_blocks IOs. However, with this option, the periodic
> stall may not be repeated at equal time intervals as the time to execute
> thinktime_blocks IOs may vary.
> 
> To control the thinktime interval by time, introduce the option
> thinktime_iotime. With this new option, the thinktime stall is repeated
> after IOs are executed for thinktime_iotime. If this option is used
> together with the thinktime_blocks option, the thinktime pause is
> repeated after thinktime_iotime or after thinktime_blocks IOs, whichever
> happens first.
> 
> To support the new option, add a new member thinktime_iotime in the
> struct thread_options and the struct thread_options_pack. Avoid size
> increase of the struct thread_options_pack by replacing a padding 'pad5'
> with the new member. To keep thinktime related members close, move the
> members near the position where the padding was placed. Make same
> changes to the struct thread_option also for consistency.
> 
> To track the time and IO block count at the last stall, add
> last_thinktime variable and last_thinktime_blocks variable to struct
> thread_data. Also, introduce the helper function init_thinktime()
> to group thinktime related preparations.

Applied, thanks.

-- 
Jens Axboe

