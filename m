Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E602C433F5
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 20:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380994AbiD2Ul2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381049AbiD2UlK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Apr 2022 16:41:10 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938E4C9B4B
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 13:37:39 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id iq10so8072245pjb.0
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 13:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NRhhCK3GT/y/Zi1uwzAe7OHKimJk7g4khsv9OjwSjV8=;
        b=4+ISdTvZwQ/E2dUL1MSKZXF/oQsB7hEGvFWkls8GdG7jKwTqs9X+QHKqzNfRFa2Nu+
         Zq7/rDbJX5Q4dlG/wLtjIMaMOxe2+X1PN5myrGlwNJCGB5wDmeB9sz+03C/3LJtjmRd2
         XG4/ihZCLIUQbfRJ9ZmhcxyAPcSlCnDANah/ZFC/V6mggNoa+Ykdsz7CJ9l3Cwq1k2LQ
         8nECQtJjDEB5j0squC5YEdznUeTtzlKT8KL3XUaOYtDNUzZ07jSqEEOEMyeSx+LYaeIn
         QBed4flcuHJ5f7fDY8wjjEjf6GmxXirbJoBCU9OL4vWJoVzxdBVJFtSUFEugDfpeGO/z
         R+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NRhhCK3GT/y/Zi1uwzAe7OHKimJk7g4khsv9OjwSjV8=;
        b=R/vcx994YmxtySfn5iysyUAbuUiPsyYtMQPzAEJWqxeAdpju6BZ03bWYCy9BaQQ4Ia
         2qRGp9Twz4ASTrMMgQpFyTWPM6Hcnr+YN9EErovSYOn9y8pNtRFttmhUSnNuaG6UChit
         +cMfYtxfR8OZCSAQ3T1zjqz9OGnON7lmOWvs5DTDcYk900qPpwKK/iS8DrMQbAjlIsDH
         n6EeLirl7D1CD83ifj/HoTSHEgNQFQPfnoN3WY3Ymx14oRKyVD99E9DkacUibYRQOaTY
         g7E/ldN04c1Klbs4o9OYjE8xsLJymFW01gcwf1jhFELXFOxyjX//JXsDwXds9VDPeA5R
         hFUw==
X-Gm-Message-State: AOAM5337wlRlbvscyBRX1fcn1JPTHM0G/x6gO7LQfhMaVACZdVoYw9kK
        I+TJ5ikUHfDygKK00oxVEJEP8EuAFZAshLWG
X-Google-Smtp-Source: ABdhPJwiImRPALKeiImujoOEjPX7UtnAK2OjTjC4aOXmm2KvNhnTu0Uz/hrf8aR1z6AWLX9K4wnQ0w==
X-Received: by 2002:a17:902:c3cb:b0:15c:e5d2:227e with SMTP id j11-20020a170902c3cb00b0015ce5d2227emr1071273plj.13.1651264658468;
        Fri, 29 Apr 2022 13:37:38 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n7-20020a1709026a8700b0015e8d4eb248sm22438plk.146.2022.04.29.13.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 13:37:37 -0700 (PDT)
Message-ID: <b787d5f2-8d3d-ba22-7e7e-b066cf518e2b@kernel.dk>
Date:   Fri, 29 Apr 2022 14:37:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v1 0/8] fio error handling fixes
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Vincent Fu <vincent.fu@samsung.net>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
 <5a686d0d-63e8-33c5-d59b-dad1bceaae4c@kernel.dk>
 <CAFBCWQKun4kpe-tHKsTUpERwh0zxeUfn1=b6yNU-aRYt8Fdfgg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAFBCWQKun4kpe-tHKsTUpERwh0zxeUfn1=b6yNU-aRYt8Fdfgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/29/22 2:15 PM, Ammar Faizi wrote:
> On Sat, Apr 30, 2022 at 1:21 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 4/28/22 6:46 PM, Ammar Faizi wrote:
>>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>>
>>> Hi Jens,
>>>
>>> This series contains patches that were dropped from my previous thread:
>>>
>>>   https://lore.kernel.org/fio/20220428203954.222165-1-ammarfaizi2@gnuweeb.org
>>>
>>> Plus, I have more patches in this series. This series contains error
>>> handling fixes, mostly about ENOMEM. There are 8 patches in this
>>> series. All of them are ENOMEM handling stuff except that patch #4 has
>>> extra fixes and a bit of refactoring.
>>
>> While I agree on good error handling in general, I'm a bit dubious at
>> malloc() related NULL returns. Have you ever seen malloc() return NULL?
>> On Linux, or somewhere else? Most systems overcommit themselves to
>> death, and things will death spiral before you ever get NULL.
> 
> Yes, you're right. malloc() returns NULL is a very rare case. I don't
> think fio users will ever see that in general.
> 
> I have seen malloc() return NULL when a program is in jail (e.g.
> inside cgroup, or whatever that puts a limit on the memory resource).
> But obviously, it is not reasonable for fio. Although that's one of my
> motivations, it's actually not the main one that brought me to do this
> series.
> 
>> I'm happy to be convinced otherwise, just naturally skeptical that
>> there's any real value in making changes like this.
> 
> I am a bit bothered seeing inconsistent error handling in the
> codebase. From what I see in the fio codebase today, sometimes we
> handle ENOMEM cases, sometimes we don't. I want to make it consistent
> in the hope we can improve the quality of the overall error handling.

Any internal allocator use case must handle errors, but malloc() and
friends most likely do not, or at least do so inconsistently I'm sure.

> If you are fine with that, I can send more incremental patches for
> review in the future to fix those inconsistencies. It may be tiring
> and progressive work. But I am okay doing that.
> 
> However, if you NAK this series. I will start fixing other broken
> things I can find, like in patch #4 for example. And that's fine.

It's not that I'm against cleaning up these bits, my only worry is that
it's quite easy to add errors when fixing these things up. And if the
choice is between some inconsistency in alloc error handling or
potentially adding error that users WILL actually hit, then I'd pick the
former any day.

I'll leave the decision to you. If you feel they are all trivial and
risk of introducing errors it close to zero, then I'm happy to apply
them. I just don't have the strongest motivation myself for doing
thorough reviews of it, just don't have time to do so.

-- 
Jens Axboe

