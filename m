Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD31C19F2D
	for <fio@archiver.kernel.org>; Tue,  9 Aug 2022 20:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbiHIUk5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Aug 2022 16:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbiHIUk5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Aug 2022 16:40:57 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208246423
        for <fio@vger.kernel.org>; Tue,  9 Aug 2022 13:40:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so125979pjl.0
        for <fio@vger.kernel.org>; Tue, 09 Aug 2022 13:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=ZHGmlNrcaNguyu7vi1GjjukFi4G6hB3ra1H7PrY90Mo=;
        b=qnPPGFoLCR5fc515aIg9kYv2LTYxNpm9kyT0qRPxz+lnZBrsvZtbZpqmYAEwPrnG+G
         THx1nIqLOA/54ETnYobWZ6pQTIiCSS57uh9rtM62TE9Xy15WfTv1cSMMrzwWyb4RKDlb
         GhfjNDQcRItu2TLa5Qtj1Nv2Ur0XziZJr1DfcvoznGXCIvd5HrtdGkLMSeR5hwZQjZYc
         st+OJLhdceV/Zv8ectcTthuXL/cIDQhE4WeMGsiNpUa+8eKv8bPYzcvYPUBnGkUsvuSA
         Y7/Xqjv7GwspFJuLX59tqqhb5Ez0qpeuU0QGD4XXwhYunGx9xbjR9GronqrICiFWL1MD
         lTHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ZHGmlNrcaNguyu7vi1GjjukFi4G6hB3ra1H7PrY90Mo=;
        b=qnaC3RPiWfQM/fS+zVgrek+LfQIJWJTitfOTZ0/SBPGQVjQsznnNdwq6n1jDBlkdN/
         wvWsqvcMcKus3pQOCOhCQwIaD/fuXuFMtSrPorfEqCcg5rbDV95U27OVS+bwUVGFtt2f
         UWpNp+iZTqqDvb3dYOwbO+40a34LbKW4JtdIo1ZezNSYXcl0onXQuuLPhUYfUD9uZXR7
         u/fMoLLamLOnDezHPTYR7mhxsJM1dN2QzCndYfBsmvceWFlaQ0cbVjVEWBVoI+J7BExj
         TK8JW8dEmglxSi7J5sFLTDuCULrxCSMKOIJnASQiy59D687rv36WL1ct74I68EgtJKXZ
         jdZw==
X-Gm-Message-State: ACgBeo14P12Y2qHcNDN3C9MlwDiM8KLgvNW7eYk0MGcBHFs55TLHjzb8
        JEyM7f8uZW/iCFtmPcGCnmL6qrBeXaHIyw==
X-Google-Smtp-Source: AA6agR7IxruCvyQjPZonxliMTQ/f/BW0vTNeyJkR5Em6AsvB1DA/fo3XgS2/WShJWGSkVVCxIibZqg==
X-Received: by 2002:a17:902:bc49:b0:170:9ba1:f390 with SMTP id t9-20020a170902bc4900b001709ba1f390mr13316026plz.93.1660077652491;
        Tue, 09 Aug 2022 13:40:52 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902780600b00170aed6c4a8sm4581364pll.245.2022.08.09.13.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:40:52 -0700 (PDT)
Message-ID: <7ec3280a-dd14-47c7-5f79-dd0be1c016cb@kernel.dk>
Date:   Tue, 9 Aug 2022 14:40:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
 releases
Content-Language: en-US
To:     Vincent Fu <vincent.fu@samsung.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <CGME20220808175150uscas1p29cea1de374da02264662429884c9eedf@uscas1p2.samsung.com>
 <20220808175133.37920-1-vincent.fu@samsung.com>
 <746d3789-1551-6649-e49e-2472954be751@kernel.dk>
 <f77991f3144a45b9a3542769738cea3f@samsung.com>
 <cd6d66f0183a4849956a009fab36cfb0@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cd6d66f0183a4849956a009fab36cfb0@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/9/22 10:19 AM, Vincent Fu wrote:
>> -----Original Message-----
>> From: Vincent Fu [mailto:vincent.fu@samsung.com]
>> Sent: Tuesday, August 9, 2022 9:31 AM
>> To: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
>> Subject: RE: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub
>> releases
>>
>>> -----Original Message-----
>>> From: Jens Axboe [mailto:axboe@kernel.dk]
>>> Sent: Tuesday, August 9, 2022 9:10 AM
>>> To: Vincent Fu <vincent.fu@samsung.com>; fio@vger.kernel.org
>>> Subject: Re: [PATCH 0/1] ci: upload tagged AppVeyor installers as
>> GitHub
>>> releases
>>>
> 
> <snip>
> 
>>>
>>> I applied the patch and updated the key, and pushed a test tag. Let's
>>> see if this works!
>>>
>>> --
>>> Jens Axboe
>>
>> Jens, if you don't want to wait you can kill this build:
>>
> <snip>
>>
>> And then this one should (fingers crossed) push installers to GitHub:
>>
> <snip>
> 
> Ok I had to make a small tweak but I think it is all working now:
> 
> https://github.com/axboe/fio/releases
> 
> I pushed a tag to git.kernel.dk which got automatically pushed to GitHub
> which then triggered the AppVeyor build and eventually we ended up with
> the release artifacts on GitHub.

Excellent! Let's get a release tagged then...

-- 
Jens Axboe

