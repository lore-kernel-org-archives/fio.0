Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3548C25B0E
	for <fio@archiver.kernel.org>; Tue,  9 Aug 2022 22:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiHIW3s (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Aug 2022 18:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiHIW3r (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Aug 2022 18:29:47 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF8D61DAA
        for <fio@vger.kernel.org>; Tue,  9 Aug 2022 15:29:46 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id u12so9987289qtk.0
        for <fio@vger.kernel.org>; Tue, 09 Aug 2022 15:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=p5pABikio/lmwTxxWurARW7AgA9U2g4y1Rx6nklnXBA=;
        b=SZRbL2nQ4GnX/1GpuzwT40EsU7ZSHp+Pseu/LyqwNVQ3aeqSc7ga6h3++2UjQCpF7I
         Tys2NmLgTsSvgRrIC6esp6JOWN12zHrVjubUhl4WqHrrUAKg3t35rcsqrVyI+5b+ER9d
         aU/wnRY1b7QzCUl2ysNbUl3lk96LmVILEYb1tEa3oYzqljlX4j6L1TVm2M9ouk33hzKz
         tAROgSOtxNt5mTcL3yDJD87jAsXvzNz/rtbVBcdDWk1vz9atcMo6SLrVlNRWRbZqq6Kg
         yTqSfxm0Q0EKT7RCAkE3o20cdMCivJSNi4lhQNdcgbIFEPr5w6jjOxtv0pIXsn/XLI3C
         ilCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p5pABikio/lmwTxxWurARW7AgA9U2g4y1Rx6nklnXBA=;
        b=wgIBNiRs0xXJzcflytDMYGlfzHvWBTQxQcem0N3CJsIZfjmv0XeSzXgsQ4TqvBfy9m
         deqT2Ac40Ar/ppfKvp51LfsYnVCUYRQnu+QAc16ON2/iSaCylUvXSNdjnVVXEjBTQC6K
         M2phBa/lMoy8z2Vznienk1Hzh2mCcb7/tNrqd7V1pLkSznlvyorp4D6TmTVCyPB+LdMj
         35KnM2zE/P1FDAeyf0Kn6nyjHNuS5qC8gcW50/Xf76lOWP/BhPAJnmVQUxM9gp3MdhHM
         PpvR3Ane6qFYDFVitrK6B35P9RTYraS0bR63YM0J9y/q/uMuCvmNvijp12qOnE86Hbv1
         v4og==
X-Gm-Message-State: ACgBeo2oc1X/D5/92NubT+MlM5EQd9aEk4Zevfr9pph7+7wvvhGzuBeu
        6dp2IVRo3uLZRuojtKyUkM0=
X-Google-Smtp-Source: AA6agR4TTMuucSzd/+Kuhlq/yukq5mMO49IkeRvo5WKbqJuqXNtSOIqXe+E+cAm7F3magP+tRpeRcg==
X-Received: by 2002:a05:622a:4cb:b0:33b:a327:e4d8 with SMTP id q11-20020a05622a04cb00b0033ba327e4d8mr22028096qtx.331.1660084185339;
        Tue, 09 Aug 2022 15:29:45 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id i14-20020a05620a248e00b006b57b63a8ddsm12324213qkn.122.2022.08.09.15.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 15:29:44 -0700 (PDT)
Message-ID: <14412fef-1c6c-8872-2646-9f3d9976d559@gmail.com>
Date:   Tue, 9 Aug 2022 18:29:44 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
 releases
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincent.fu@samsung.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <CGME20220808175150uscas1p29cea1de374da02264662429884c9eedf@uscas1p2.samsung.com>
 <20220808175133.37920-1-vincent.fu@samsung.com>
 <746d3789-1551-6649-e49e-2472954be751@kernel.dk>
 <f77991f3144a45b9a3542769738cea3f@samsung.com>
 <cd6d66f0183a4849956a009fab36cfb0@samsung.com>
 <7ec3280a-dd14-47c7-5f79-dd0be1c016cb@kernel.dk>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <7ec3280a-dd14-47c7-5f79-dd0be1c016cb@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/9/22 16:40, Jens Axboe wrote:
> On 8/9/22 10:19 AM, Vincent Fu wrote:
>>> -----Original Message-----
>>> From: Vincent Fu [mailto:vincent.fu@samsung.com]
>>> Sent: Tuesday, August 9, 2022 9:31 AM
>>> To: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
>>> Subject: RE: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
>>> releases
>>>
>>>> -----Original Message-----
>>>> From: Jens Axboe [mailto:axboe@kernel.dk]
>>>> Sent: Tuesday, August 9, 2022 9:10 AM
>>>> To: Vincent Fu <vincent.fu@samsung.com>; fio@vger.kernel.org
>>>> Subject: Re: [PATCH 0/1] ci: upload tagged AppVeyor installers as
>>> GitHub
>>>> releases
>>>>
>>
>> <snip>
>>
>>>>
>>>> I applied the patch and updated the key, and pushed a test tag. Let's
>>>> see if this works!
>>>>
>>>> --
>>>> Jens Axboe
>>>
>>> Jens, if you don't want to wait you can kill this build:
>>>
>> <snip>
>>>
>>> And then this one should (fingers crossed) push installers to GitHub:
>>>
>> <snip>
>>
>> Ok I had to make a small tweak but I think it is all working now:
>>
>> https://github.com/axboe/fio/releases
>>
>> I pushed a tag to git.kernel.dk which got automatically pushed to GitHub
>> which then triggered the AppVeyor build and eventually we ended up with
>> the release artifacts on GitHub.
> 
> Excellent! Let's get a release tagged then...
> 

Ok I think it all worked.

For each release AppVeyor will do two builds, one for the commit and one 
for the tag.

I only saw the first build, forgot about the second, and thought that 
the integration failed. So I deleted the tag on GitHub and then 
re-tagged it to manually trigger the release process. So AppVeyor did 
two builds for the tag which did no harm except waste their resources.

I also deleted the test release artifacts on GitHub from earlier today 
to clean things up.

Vincent
