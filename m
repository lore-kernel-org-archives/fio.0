Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B5EC76196
	for <fio@archiver.kernel.org>; Fri, 31 Mar 2023 18:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjCaSys (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 31 Mar 2023 14:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbjCaSyp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2023 14:54:45 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D175822210
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 11:54:41 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j13so21433776pjd.1
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 11:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680288881; x=1682880881;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bfqx1lt6VGmp68Fi/ShXGrVijiyDpcckxTb+T9HxlFA=;
        b=zIkrrgjxi/UvKAcs/SlGUW/lFV9wzNLF7lvZD0e1xA9JtXc1n1EYEV3DPQsinLvYQk
         tJYh9IWyBNI0S/5MAXaC1CXsXnZTrkEXOzewNdb8DNbMaMOIE6BkBEUzMZEq+SaoDQMZ
         4VPKBRzyz4jPHaomlZSrr05w1P3BJ5TO8fPua4Y4L7cu4oDLIQEVyB0iKPqeIlkocYgC
         hTMZIPeck8tXSAuPawoDE9VIfUvO3QEbG4Avsmm5H3rLD5jJMxnA5WurWTAw8iF/INKx
         Gg1E+n7Mnw/G+5pjOzpeRSLWx3IC0XnJShUdimRtkQZUahJ+k7TvV6M3BYLCGBIyV6Qx
         LAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680288881; x=1682880881;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bfqx1lt6VGmp68Fi/ShXGrVijiyDpcckxTb+T9HxlFA=;
        b=4c9wB+Gl+2tD+/ZEdkevSs2t47kxqvczETzUH/JTW+qHJ67pbLDuLA3my7cWPgwcRb
         fwbUyHvOtM+ZigXwT3ecAbTmK1KNPf7HoRKCy/Y+8Oix2yI1cfTlJIzvE36ZOpJpMiN5
         JNiAXqTvNLYaoEHdcZEqh+AdtFEE8BGsTni1/m8C1eQJe5YtQdGxbQhf8nH7Tesg9mzR
         pFhbfGoaMbkhz43EIeGyIZO5id2zKRsP8o2pbqP8cvZGbcNE+hiUF7LERTXWQko3kmfv
         ICbt2JTPZRXFZgtz/QL6ZRgoXB+vqM/IVqtpe2voEVIjhrnHeK39+WvJBaBgTNOYwGWu
         yrdw==
X-Gm-Message-State: AAQBX9c9iEiu5wq3A3WidmVl7kRYKV4JanTtbiL8eYb6gh0G8NKYVHYb
        l5pChR9uPjy+JOvfiAXDa40tig==
X-Google-Smtp-Source: AKy350b2UnUJcQpPKIPDmyLHC6fDV+d7Fk8UUbAUEKQZqNvOZctUQW/SoVn21dolx8rIxRjTvi8Iqw==
X-Received: by 2002:a17:902:c94d:b0:1a2:74bc:31d8 with SMTP id i13-20020a170902c94d00b001a274bc31d8mr9654531pla.4.1680288881192;
        Fri, 31 Mar 2023 11:54:41 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902b11200b001a216d44440sm1884683plr.200.2023.03.31.11.54.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 11:54:40 -0700 (PDT)
Message-ID: <eb82cb58-6f0f-81d0-79e0-714c5a5ee6b1@kernel.dk>
Date:   Fri, 31 Mar 2023 12:54:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 1/2] fio: add support for POSIX_FADV_NOREUSE
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Yuanchu Xie <yuanchu@google.com>, Vincent Fu <vincentfu@gmail.com>,
        fio@vger.kernel.org
Cc:     Yu Zhao <yuzhao@google.com>,
        "T . J . Alumbaugh" <talumbau@google.com>
References: <20230331183703.3145788-1-yuanchu@google.com>
 <dd139789-17e2-f99e-9362-40a266782719@kernel.dk>
In-Reply-To: <dd139789-17e2-f99e-9362-40a266782719@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 3/31/23 12:41 PM, Jens Axboe wrote:
> On 3/31/23 12:37 PM, Yuanchu Xie wrote:
>> As of Linux kernel commit 17e810229cb3 ("mm: support
>> POSIX_FADV_NOREUSE"), POSIX_FADV_NOREUSE hints at the LRU algorithm to
>> ignore accesses to mapped files with this flag. Previously, it was a
>> no-op.
>>
>> Add it in fio as an fadvise_hint option to test the new behavior.
> 
> I just applied this, but then I pondered if we'll be breaking normal
> installs that don't have POSIX_FADV_NOREUSE available? Maybe the
> libc define predates the kernel actually implementing it by long
> enough that this doesn't matter? Let's see what happens...

Somewhat unsurprisingly, this did break the build on OSX. I added
a patch to make it conditionally available.

-- 
Jens Axboe


