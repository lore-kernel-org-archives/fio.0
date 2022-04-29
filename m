Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E27CC433F5
	for <fio@archiver.kernel.org>; Fri, 29 Apr 2022 18:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379959AbiD2SZU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 29 Apr 2022 14:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376388AbiD2SZU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Apr 2022 14:25:20 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319C7D114D
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 11:22:00 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e1so4497424ile.2
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 11:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=boBqcZUUd3lpbXllOKgvkHZhlPyPffKAlzYRl9LXtpk=;
        b=gbjFB6+bQSryclVz014EuajmCHeeQwOC+fRF88W6on/Qkgft0NhjneEfdDSiENJJJd
         sFYRmc+tqshkFUX2jsmrzsWNksa8HKPbFkoePVCTnfgDuenfx9fgkI4KHXyDYeP7XS6C
         JaQz9ACpgAJ5xl8GNBtL8FMuXkzZUwTYAjJJVl6MNX59oX10BnNFKNhxEJGl65js4GdN
         AJDU4W/GrYbQ/8y4azb3qaeSRpelgWTRztBQBvnp25IZsFj6w4Uzvm4Scay9c98gq1pX
         aIgtE16hHGpR16mgmG1oVeigMzdQiKjYYl05spAar9AOBUHy1lUQjbOFMWoF0PQsqDTm
         8mIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=boBqcZUUd3lpbXllOKgvkHZhlPyPffKAlzYRl9LXtpk=;
        b=RPFc/laRmQpv2EzuXrkUlINMlrO/b2jrIAPgZUQUN7iQKWXKnK+ubrjtOExpwFJBrh
         kc989h6pWwHIbd8UMpKba5WJE+UeLrUW0hxaNV5ygfl+x/4oJZk9LI++/wiCv1+cwV7F
         5rCgO7l3gNKgVjF4b5FGMxFW1Ann5kR+yIXmUiv3/75rlLRg6QJmXcQyDym6CdzyvGgo
         b4K8SL9nnuUvDVWTR9HMlSt2hL0xL0lKnawhLG7io3uNFaWDbfwwmdtif7bqbT1o7hRW
         RnaQ9E3hNJO3VHGBsqInHTGLk2ISjl6Z2bjVi9bxmmlGGpLb2PNgmH1v7VOYxrSXueHp
         Yp0Q==
X-Gm-Message-State: AOAM533V/+ZKIwl2Z9T2lGJ9WS54EpxUvQaEE8vqlfIanZ7fUT7Nk0MJ
        duAKz19ieMO0mtoKUrvwwG2fnZ6wY7RbZw==
X-Google-Smtp-Source: ABdhPJy0hAazhU3cgDv3j2yfHLn7RPQyzvfqgHW5knMrNjpG7bnSys1jk7v8mjPYaPWvwRPwh5l3nA==
X-Received: by 2002:a05:6e02:16cf:b0:2cc:3986:264a with SMTP id 15-20020a056e0216cf00b002cc3986264amr267599ilx.8.1651256519542;
        Fri, 29 Apr 2022 11:21:59 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z7-20020a926507000000b002cde6e352e5sm703036ilb.47.2022.04.29.11.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 11:21:59 -0700 (PDT)
Message-ID: <5a686d0d-63e8-33c5-d59b-dad1bceaae4c@kernel.dk>
Date:   Fri, 29 Apr 2022 12:21:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v1 0/8] fio error handling fixes
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/28/22 6:46 PM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> This series contains patches that were dropped from my previous thread:
> 
>   https://lore.kernel.org/fio/20220428203954.222165-1-ammarfaizi2@gnuweeb.org
> 
> Plus, I have more patches in this series. This series contains error
> handling fixes, mostly about ENOMEM. There are 8 patches in this
> series. All of them are ENOMEM handling stuff except that patch #4 has
> extra fixes and a bit of refactoring.

While I agree on good error handling in general, I'm a bit dubious at
malloc() related NULL returns. Have you ever seen malloc() return NULL?
On Linux, or somewhere else? Most systems overcommit themselves to
death, and things will death spiral before you ever get NULL.

I'm happy to be convinced otherwise, just naturally skeptical that
there's any real value in making changes like this.

-- 
Jens Axboe

