Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796F7C433F5
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 19:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 604A1610C8
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 19:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240696AbhIHTPt (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 15:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbhIHTPt (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 15:15:49 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E08DC061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 12:14:41 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id f6so4771670iox.0
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 12:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=b6f5jbAmbfAKPJL5guvKtQ34GqZAgTylq7xfheT5594=;
        b=OXbQChF0pSsDkofxs5vWC01YR33uHweE2yf30lwQH0Klu5J920MitzaJn7hYULPh7Q
         /UBDMPNMiVRKgzaQEISBOcFmC5LNB67iwB24ZmnaJGgNwaZ5iENMyHr1spTU+UiCf2OQ
         /UDrxYTd43snVm9j9KrkNh1Zeto4qsjqKYT/GPGNX+0Xu++7ffnfBqlDtRpvdQpMWiBP
         D7lXI50rWUhZkpiALXyc4na6j9n9DFjGSnhicYNcc2U2UTyrxxcpe5B5nUDZ8BqwYxAA
         j4IRzuCOPp6YvNkzz4ro/upmlYSwimgNFIjxpvqHhT/1wPvNFdTnIgdgSZSHdPsGO9Gg
         9rrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b6f5jbAmbfAKPJL5guvKtQ34GqZAgTylq7xfheT5594=;
        b=7q8/OEbQTOHrmbCoWq1UL3DBzI+mjjFPnz8QpsGahcYcwpvWhZdM2O+125YGdiM6Pi
         TYbjRCt065dF1qspG82O13rG5uUKn8YJMLGkhW41QoSlG3gQPF72rsHRjMeb3ox8gehd
         vdCCQs/65Qmxfroutf4TSususfMK6IQlM7S6kKRhi/SQRwAtHly4kuamSXOUpLkChFeT
         EarqPJgE3jynqWgTrcS5gqn+/hXPR9qFB4LcAj4ZMO98+I+6ALTV3DaM21WMczq6zCEU
         Gjel4eV8FJjwRYmQqSfCu+w7tcwiEZBZ48XYdhjjl4ZupVTpFFI35eu+g88Ma7aKQpil
         8j4g==
X-Gm-Message-State: AOAM531yAZLhU5nPEtq4g9068p+JMi25AFNDJs5tHQ/NSONgbcdckj2i
        Mc27AaEl360MXzgKcfB1c5qr1vaEIdvD9A==
X-Google-Smtp-Source: ABdhPJw+UkRUNCv+Erp/s45yAjzlDLHjbyBWkmm7/IWBw6W7wEqRVH/e8PD0rtgyNJKGGr6F95AJgw==
X-Received: by 2002:a5e:d80c:: with SMTP id l12mr1231548iok.120.1631128480463;
        Wed, 08 Sep 2021 12:14:40 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 9sm617458ily.9.2021.09.08.12.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 12:14:40 -0700 (PDT)
Subject: Re: [PATCH v3] t/io_uring: allow flexible IO threads assignment
To:     Andrzej Jakowski <andrzej.jakowski@intel.com>, fio@vger.kernel.org
References: <1631126100-28184-1-git-send-email-andrzej.jakowski@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b1e911a0-4150-dbb8-a713-8ade2bcac890@kernel.dk>
Date:   Wed, 8 Sep 2021 13:14:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1631126100-28184-1-git-send-email-andrzej.jakowski@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/8/21 12:35 PM, Andrzej Jakowski wrote:
> This patch allows to flexibly assign IO threads to fileset. When
> you specify:
> 
> t/io_uring -n 5 /dev/dev1 dev/dev2
> 
> First file/device will get 3 IO threads and second file/device
> remaining 2 IO threads. When there is more files then IO threads,
> IO thread may get assigned multiple files/devices.

Applied, thanks.

-- 
Jens Axboe

