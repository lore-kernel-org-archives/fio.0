Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA5FC43334
	for <fio@archiver.kernel.org>; Mon, 11 Jul 2022 14:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiGKOmE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Jul 2022 10:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiGKOl5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Jul 2022 10:41:57 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E086D2EC
        for <fio@vger.kernel.org>; Mon, 11 Jul 2022 07:41:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b2so4608011plx.7
        for <fio@vger.kernel.org>; Mon, 11 Jul 2022 07:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=0Relg3FRYPYn3YsW56kXVVvmCQ5M5fE2/+k2Cl2o3qE=;
        b=AR3Op1+T9D2tE9epD/EUMfd/N+i4oYysYIjQSGfXM7hlWCwZulgk8ACPHjPOcRQnsf
         6+n5uNrkAJWP2TOafLlMmqxjGJPiCxZVpSVQEbUObA7NuQJlky51Oyv64AA4bbvbCjr3
         bCaeEuY8/bsRA/PmP8ODc7V89IS+6WgU0wxaXlZBhPOyXQuEo8HQswqRvJ5DgrxhI7mg
         2h8t+4+R7PV7A8WNM/PdJ5XUAEi8GU24qkJO7fIyE/U/nW4zUNR+l0xfD7Uaj54CSaDy
         +E6mxsWknyEgGcw87vMojrmDI3N1o8LpVccHOJ1KAEeHYhjvVF1FGn4qJSl9A8Iu03c9
         2vhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0Relg3FRYPYn3YsW56kXVVvmCQ5M5fE2/+k2Cl2o3qE=;
        b=6A7ygaggGCljCZt2K9L6LODdaw865lfIadQnAUECQypGL0BzvN3+HCqTfmphKc+QD1
         p8TWNR6WH9SiaUUVc7twywku+q7Z8nsI8c91ERXAOz+XLp7QKhHLtBC+SGFH/CIhYQQk
         +r/rRf+m0asMB3+yFLvBk0/0JEuDNiPYAjul9WGJKoVssCa5YxjGmGQuofQ1XB3lyMe4
         IiAaHkPPwD5+sPxx9rqsA6s0t7BVhRGFQx/W0lY6Wv4XHqkwgCHqRKO3pKnFY6qrsdbW
         UOtxvt35zcsPbLqwK3CPSB2wLmC3KVzH/l51Lwfr0A9Z3Dyo+zWc8qqWFTGMmelUDKX9
         rqgA==
X-Gm-Message-State: AJIora8CqRJt9KjgqmxkWvKcnwFu8Lqam7q56owQzbE7hbXH58w7tJqx
        avRcVmm7Dkenz0NI4XEFtFhPey2hwaP7Lw==
X-Google-Smtp-Source: AGRyM1sernCgckESthd8VLo2Tj40SZ7PF22YPnXjdcVF6ISVjwyLv8j1P/FbA6Ee4EPTsIL/7dBfqQ==
X-Received: by 2002:a17:903:2409:b0:16b:c062:87ea with SMTP id e9-20020a170903240900b0016bc06287eamr18841316plo.73.1657550508355;
        Mon, 11 Jul 2022 07:41:48 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r9-20020aa79ec9000000b0052aaf7fdf2esm4832975pfq.137.2022.07.11.07.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 07:41:47 -0700 (PDT)
Message-ID: <7238434d-1f4b-4433-1892-6c4cc10d407b@kernel.dk>
Date:   Mon, 11 Jul 2022 08:41:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Update README.rst to specify secure protocols where
 possible
Content-Language: en-US
To:     Rebecca Cran <rebecca@bsdio.com>, fio@vger.kernel.org
References: <20220711025547.11917-1-rebecca@bsdio.com>
 <9013e193-10fc-e2b3-4cd5-8a421fbcee10@kernel.dk>
 <f9acd108-ad25-47db-9346-d5a87d8a8f8b@www.fastmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f9acd108-ad25-47db-9346-d5a87d8a8f8b@www.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/11/22 8:32 AM, Rebecca Cran wrote:
> On Mon, Jul 11, 2022, at 7:54 AM, Jens Axboe wrote:
>> On 7/10/22 8:55 PM, Rebecca Cran wrote:
>>> Change git clone commands to specify https instead of git or http.
>>> GitHub has removed support for the git protocol
>>> (https://github.blog/changelog/2022-03-15-removed-unencrypted-git-protocol-and-certain-ssh-keys/)
>>> and http accesses will normally redirect to https.
>>>
>>> Update links to use https where possible: all the sites with updated links
>>> automatically redirect http accesses to https.
>>>
>>> Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
>>> ---
>>>  README.rst | 27 ++++++--------------
>>>  1 file changed, 8 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/README.rst b/README.rst
>>> index 527f33ab..ce5c0707 100644
>>> --- a/README.rst
>>> +++ b/README.rst
>>> @@ -27,31 +27,20 @@ Source
>>>  
>>>  Fio resides in a git repo, the canonical place is:
>>>  
>>> -	git://git.kernel.dk/fio.git
>>> -
>>> -When inside a corporate firewall, git:// URL sometimes does not work.
>>> -If git:// does not work, use the http protocol instead:
>>> -
>>> -	http://git.kernel.dk/fio.git
>>> +	https://git.kernel.dk/fio.git
>>
>> I don't think you checked that one... I've fixed it up, looks like the
>> cgit redirect doesn't always work reliably.
> 
> I did check it: cloning worked, but accessing it in a web browser
> didn?t work, and since accessing git:// in a web browser also doesn?t
> work I decided to update it.

https://git.kernel.dk/cgit/fio/

should work for both cloning and in a browser, which is why I made the
update.

-- 
Jens Axboe

