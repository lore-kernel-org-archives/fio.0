Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1F3C433FE
	for <fio@archiver.kernel.org>; Fri, 14 Oct 2022 12:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJNMNL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 14 Oct 2022 08:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiJNMNK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Oct 2022 08:13:10 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10431C493C
        for <fio@vger.kernel.org>; Fri, 14 Oct 2022 05:13:05 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id u71so4168207pgd.2
        for <fio@vger.kernel.org>; Fri, 14 Oct 2022 05:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dA4pj24AsJUSZSQesSn+6wnzZNV57SsOE8U2S/ludSk=;
        b=zOQSRFDReOWzr037gYzTotmYfjs2U/kCFZHoBJAF5b0d5ATyxgLvisWgpfWNE6j25v
         /Y9rF8GyQZ1sCGF8g2H8Y71tJ/JiQ5MRVJDzq8b++FOFM4ARKzciYTEEk/Fku13nHwJI
         9H0JeAaxUL3XurOx7GT/UL+D0a791/lBERIjfeo+L5Ka+wOhhz/zxYwZmXPCW7ql8EXe
         yjQPYuvh4aoDFHMvqYBp6GF55F2Ay0bhx6qLkUmx9+OhV4EUhaeT+xfeCIatx7e5iXM8
         EubBnmhM+gD+s0w4dCDGQ51xgTanDZ7dhhLs8jXgWttg3/DjcZA8YmCFgF7IMcPyr3Ht
         q8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dA4pj24AsJUSZSQesSn+6wnzZNV57SsOE8U2S/ludSk=;
        b=YmdFkS64lbsU+pOJOfjKW12cODfM0K1/gaJKoCNod/0FtXxmvlbslIIY1SHHUuVNkS
         Izy/dXCoaielFzr7J2aLex6TyRTzQZq+mv2IspGkXBZT3SdVGT4TWWlMbcoFhMMVKoZt
         9+IItTCBGQIiutAXdWLyKMoVjsOfDUpLkXlEqVFF4uuhRdzmgBO1sFl89T8w5MjRGv6C
         qzh5nhrGWwEN8xvGGFCRbSmBa2jiFsRRvU+9gC21qjQt9XcCXzOhickTTFQtLB4KCJNi
         TYZdO5Tp5srMQ+1AidO2iv3Gg5NZ0c8S+c8ToTZZ5D7MId3LDlmecqJ/IgJTQe8ba+ct
         4FKw==
X-Gm-Message-State: ACrzQf2f4LYqwtu5ci31OHEjhOsBMGcC4Ltxhd45OleVZsH7BMNCmde0
        laJJSoNHEj2GRf88nfhX3XEuaiwzpfoEpZuh
X-Google-Smtp-Source: AMsMyM4bHimies8J1YOBeHPhYACHF40C0EseRkslBFkmCipgasxloolpXJ3TapFgbvdZOuHm/mwl1w==
X-Received: by 2002:a65:6bca:0:b0:420:712f:ab98 with SMTP id e10-20020a656bca000000b00420712fab98mr4267303pgw.350.1665749584049;
        Fri, 14 Oct 2022 05:13:04 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z18-20020aa79592000000b00560a25fae1fsm1557901pfj.206.2022.10.14.05.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 05:13:03 -0700 (PDT)
Message-ID: <1f3bd479-a37b-ee9a-6e34-a4a424b46495@kernel.dk>
Date:   Fri, 14 Oct 2022 06:13:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH 0/1] Add missing flags to the uring passthrough engine
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     fio@vger.kernel.org, vincentfu@gmail.com
References: <CGME20221011110947epcas5p2f840397a3e45e1d9326619a10d52ffa3@epcas5p2.samsung.com>
 <20221011105935.10455-1-ankit.kumar@samsung.com>
 <166558078491.51388.13375358126701883071.b4-ty@kernel.dk>
 <20221014053211.GA25158@test-zns>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221014053211.GA25158@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/13/22 11:32 PM, Ankit Kumar wrote:
> On Wed, Oct 12, 2022 at 07:19:44AM -0600, Jens Axboe wrote:
>> On Tue, 11 Oct 2022 16:29:34 +0530, Ankit Kumar wrote:
>>> Add flag IORING_SETUP_COOP_TASKRUN for ring setup, to the uring
>>> passthrough I/O engine. This was introduced to the normal io_uring
>>> engine with commit 4d22c103
>>>
>>> Add flag IORING_SETUP_SINGLE_ISSUER & IORING_SETUP_DEFER_TASKRUN for
>>> ring setup, to the uring passthrough I/O engine. This was introduced
>>> to the normal io_uring engine with commit e453f369
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/1] engines/io_uring: set coop taskrun, single issuer and defer taskrun
>>       commit: 07f78c37833730594778fb5684ac6ec40d0289f8
>>
>> Best regards,
>> -- 
>> Jens Axboe
> 
> Hi Jens,
> 
> I don't see the commit in the master branch.
> Can you please take a look.

Guess it might help if I actually pushed it out after committing,
that has been done now.

-- 
Jens Axboe


