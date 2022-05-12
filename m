Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC257C433F5
	for <fio@archiver.kernel.org>; Thu, 12 May 2022 12:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242113AbiELM2Z (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 May 2022 08:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240502AbiELM2Y (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 May 2022 08:28:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFAB248264
        for <fio@vger.kernel.org>; Thu, 12 May 2022 05:28:23 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fv2so5001294pjb.4
        for <fio@vger.kernel.org>; Thu, 12 May 2022 05:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fdu4OMyv3SSXMU11mXEyHUx3NRRW/Da+D+YsrYRNqpI=;
        b=10ffwzzBzs8kT+l68AkvExHO09PyIxianxWRzuB89Ip7yRHgbApdPGWCGfoDuzyqKK
         YGYEgiLKdNk9ZdDtNPguE7VSWQ44uYjA3Kmsm0wTtH7cBF7WpRvxQOv6walV9HORWMCV
         jeU05JIWr1kFXOOF4Ct8AdetMN006JqCXYZfX4zk+Q0f7gEM8Ahwimqesaj3PSlhMSkS
         aTgu3uZk7kO+xHC32VQ5xRVidNM6ezsJSLH/rmN/dYCIj8kvCXkQ7wmHVV5AeYD1xDt1
         y8cf7GPoldmmm0WddoIdqQzK8JQFpnvT2kgFtRU41HL8shQudykTaN77fPS1I4yULV/w
         82dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fdu4OMyv3SSXMU11mXEyHUx3NRRW/Da+D+YsrYRNqpI=;
        b=Mp8TfegLtCloEJiK4qSlnVxp3Tldetbi/IO3LTZvgxCcPVXfesD0KQ8MS1yYi+OWgS
         DZQ5nf+aVwDEOeDNON3nklJXKXUJdJTfNbj1BGbvLI7oi7A+1fnisyAMFkyJ4ghQayVi
         +Q9JWNWOpNMAf0K1yiBnM97wRV0tUEpy1+Ge9vP2EiRbBXy54zkU3XnfCtlROEhifx2M
         2Re0RoZuKKS/RVLrR2Go9gWxYOW2tXX3d5lefkJiBknUIlI/h+2Fmwhi/EDKmBDYvKIS
         64d9OuB7pmX87tpaYaAQadQP6sidwCYXXjlDPtLeowx1CWp1aXu0CaKapTteOFR5BRf6
         +ArA==
X-Gm-Message-State: AOAM530o2JxpTauQ6ou2s2ipOSZ0S/iTKjAWQYd30JjWe9Y0JCHmHkWJ
        TK1yP5htsNN4UJ3f0TAuR1Zjvg==
X-Google-Smtp-Source: ABdhPJyRghLHLoC9LCRA/Q8goHqlBEhZcAqFAF7bkC5QgJXkWxWXAPOBRVdlEvhGDUoQYvaNkzyxgg==
X-Received: by 2002:a17:90a:e7d2:b0:1dc:e6c6:604b with SMTP id kb18-20020a17090ae7d200b001dce6c6604bmr10667373pjb.183.1652358503238;
        Thu, 12 May 2022 05:28:23 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i21-20020a170902e49500b0015e8d4eb20dsm3718333ple.87.2022.05.12.05.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 05:28:22 -0700 (PDT)
Message-ID: <cf9dbc97-0847-6887-3d8f-320432bf5176@kernel.dk>
Date:   Thu, 12 May 2022 06:28:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 0/3] fio: add xnvme engine
Content-Language: en-US
To:     Ankit Kumar <ankit1455@gmail.com>
Cc:     Ankit Kumar <ankit.kumar@samsung.com>, fio@vger.kernel.org,
        krish.reddy@samsung.com, simon.lund@samsung.com,
        joshiiitr@gmail.com, anuj1072538@gmail.com
References: <CGME20220511163552epcas5p4c2e1b204a47a543c24f84da89ef0c89a@epcas5p4.samsung.com>
 <20220511163019.5608-1-ankit.kumar@samsung.com>
 <698673c0-0fc4-671c-15da-0fb7a053da41@kernel.dk>
 <CAKi7+wew31=A5ZF+t2b479-zkrObRs+ze+-o0MVKX6kcfWP9UA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAKi7+wew31=A5ZF+t2b479-zkrObRs+ze+-o0MVKX6kcfWP9UA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/12/22 12:28 AM, Ankit Kumar wrote:
> Yes we are using xnvme on various platforms, and it would be great if
> it gets included as part of FIO.
> For supporting io_uring engine with passthrough, yes we also have a
> plan in place to clean up the code and send it for review.

Sounds good. I've applied the xvnme engine, would appreciate if we can
do the passthrough one shortly too. I'm wondering if that one is best
done as a separate engine too - it could still be in engines/io_uring.c
but have a separate ioengine_ops to keep the code nicely separated while
still being able to use the same helpers in there.

-- 
Jens Axboe

