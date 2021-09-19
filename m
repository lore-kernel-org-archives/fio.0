Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8D8C433F5
	for <fio@archiver.kernel.org>; Sun, 19 Sep 2021 02:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC9FE60F93
	for <fio@archiver.kernel.org>; Sun, 19 Sep 2021 02:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhISCcd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 18 Sep 2021 22:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhISCcc (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 18 Sep 2021 22:32:32 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD4FC061574
        for <fio@vger.kernel.org>; Sat, 18 Sep 2021 19:31:07 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id a15so17364979iot.2
        for <fio@vger.kernel.org>; Sat, 18 Sep 2021 19:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NGfLk3JG91hBrlhROZZnSRYISdw9CHMsQpmb9AhuFTI=;
        b=ediyfF3UlEYds8MujHHZdqwL0HRwrwOMM6BEsWP9oCUXSDWbqxZteDSOm5IjybjOBX
         C/o7/SGgMlH1WPc+KZVsgOasvrwfbDMmnvSXp3hG/Q8labKlLotEml/1dfJnFcO3GvYO
         AKu1JdYt9hflR0/cDuKhsak669znLlP/ZrRMtsseEMWhIJViifWJylCJP2lu+QeZwuOc
         ZYsE5S7D37ZRi4vhob/JCE8KHTXt+PRw1hGu1hkdClMLz80QlomfvBqMeSfaBEEXZTiT
         v6ovXLNv61O0wFqjvAWzWUaeg7vEiHAxDjt+m3TeXZT5PZTc2DGMeeYm5nWLDmJ0faJp
         gCDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NGfLk3JG91hBrlhROZZnSRYISdw9CHMsQpmb9AhuFTI=;
        b=Sqh1poq/8TBn7TFMAcg1682uKaOpp9wceXve9YEJBQ9b67PrEOGd8VUZIMbF71keGA
         nhW1Qw1wRU07tyYjifkOtaOzByWWZqwy/XdhlQi4UJ/otcFQ9IfItqbRnTKakCyazbbb
         RufVldabPfHqGmLOgEEGfZ0bMSdy0OICfgGjdHp90EibPzWKEfQDyzj24u2fC43WXLDE
         SqDJ9+zolyNEvcT2arwVGHLBxH1RQtRNkp+H1O1P8ZkaE3DFXqAgl7v8Om3NYANqJDht
         TzFZajdMaw4zcip2ViJeOVLVsJccYfkSK7iMtpO2MtRfxJtAdhHADmmRyGgBmlbTjzXB
         9Jog==
X-Gm-Message-State: AOAM533gltg6cymyLcH8umdCFLfcKrPiObZ9DaJBHZKSjAXHGDXnEZuH
        lMYGuDkDunSMALK3avLLHAutC+edEK88fA==
X-Google-Smtp-Source: ABdhPJzJwJFvJQWDKhzgae2XYCNfZZNxgQMxpA7+nf8nQhKQMu61p8pwiRjZHAYfoZahE5OWEUYPmw==
X-Received: by 2002:a5d:9da4:: with SMTP id ay36mr14467262iob.153.1632018665987;
        Sat, 18 Sep 2021 19:31:05 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m5sm6674297ila.10.2021.09.18.19.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 19:31:05 -0700 (PDT)
Subject: Re: fadvise_hint behavior unclear from documentation
To:     Isawan Millican <linux@isawan.net>, fio@vger.kernel.org
References: <769eb00b-fa01-a9f1-4fcc-09f4f7bbce38@isawan.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <692c86eb-8c9b-5475-5eab-4b988725da18@kernel.dk>
Date:   Sat, 18 Sep 2021 20:31:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <769eb00b-fa01-a9f1-4fcc-09f4f7bbce38@isawan.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/18/21 4:46 PM, Isawan Millican wrote:
> Hi,
> 
> I was using fio and noticed that the throughput was lower than expected for
> random reads to a small file; I would expect it to be entirely cached in
> memory. The issue seems to be because fadvise_hint=0 is not behaving as
> documented as POSIX_FADV_DONTNEED is being called.
> This might be the intended bahavior as the program is flushing the pages
> to purely test IO throughput
> 
> If the current behaviour is intentional, is there an existing flag that 
> could
> provide the desired functionality? Essentially I'd like to test the IO
> throughput of various file sizes without bypassing the page cache to see the
> effects of caching.

Just set invalidate=0 and fio won't invalidate the address space page
cache for the files or devices used.

You seem to have snipped most of the cmdhelp for fadvise_hint:

        fadvise_hint: Use fadvise() to advise the kernel on IO pattern
                type: string (opt=bla)
             default: 1
        valid values: 0          Don't issue fadvise/madvise
                    : 1          Advise using fio IO pattern
                    : random     Advise using FADV_RANDOM
                    : sequential Advise using FADV_SEQUENTIAL

which tells you that it's about telling the kernel if you're doing
random or sequential IO (this will impact read-ahead, for example).
Invalidation is kept separate.

-- 
Jens Axboe

