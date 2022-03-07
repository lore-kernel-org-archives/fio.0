Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6F7C433EF
	for <fio@archiver.kernel.org>; Mon,  7 Mar 2022 13:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238850AbiCGNgl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 7 Mar 2022 08:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiCGNgl (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 7 Mar 2022 08:36:41 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B837F6C1
        for <fio@vger.kernel.org>; Mon,  7 Mar 2022 05:35:46 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id s11so13745243pfu.13
        for <fio@vger.kernel.org>; Mon, 07 Mar 2022 05:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=yz38g03SsOwBiLgxRmLh4jvpPVHsk3/Fzlq+V7khFcU=;
        b=gEpV/T73T82KGQMB1MqnT7SPGx4c1F/8Iy4EN/nGAoKsnheFNCUd93bBLVy1NLxDlR
         FIDhXynke+XRyOXtZk5N+UTky8CamxqGJlZYshhPRcJr1PF+pRP3y6Z1livWdmLjtxiM
         pDPDtmjDV8cZun8iS5X+sBeexXpwrpebUJJKovZGzwn+NDAdRfRkH6HYe3siq4lzSgAv
         UfOL9eup1NICQOJLi1g9AP94ohTVwEzjCzRasvJQWy/HcwEsw/yjjazHP6Eat+qkTw91
         dkW9RdR+dMdPU79C94q5C+Kh1RQiNi052MFyc8YI6YPRPw/+03zPiCOHu5sjR14/SP+O
         7ZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yz38g03SsOwBiLgxRmLh4jvpPVHsk3/Fzlq+V7khFcU=;
        b=rJJXE1Busrys2LbBzhvskRz8DaiHFOc/zl8BJsmUGPOQibxf34LFtFwIeVcDWORaBI
         pYK7bUgmsJeUb4Rr2BLblmONmHi9jG9KphdxvbffC4xBCSbqSomslMBpjkRfLOUFisnc
         QqQxycO9dBmu792P8YBqEhlz2iA2rHmLdANRnmZvOYq9tm73IdXsOjPD5ilfjhQBZPiQ
         nuImUzaOZ2dYfL75ywzgUG0eHg2a8DVxrFmGqOJ6TDbNgsv/VATcbtDJ4D3PuAiEd0MZ
         DpvCQRnkf5h/pdx6A1N/gLFKaKb3ngQ9fM0uhMQMv/aE6NZI1kbC5DxX3alHUCzpUA1z
         jqKg==
X-Gm-Message-State: AOAM532KLUC+m2PwKUsoC3+FkrzYfkmOCQp9PBabCI/EmZCpNbr4z7X0
        72BQAYeigsqKeuYYxVjJEi5yXQ==
X-Google-Smtp-Source: ABdhPJx9m1kqfUQZNqH0spvE9edP+KxPPcCyttvEtJTrmtug/YHcPoniKUia0WWGNnzwLOhPjsWTjg==
X-Received: by 2002:a63:be0e:0:b0:363:e0be:613f with SMTP id l14-20020a63be0e000000b00363e0be613fmr9719131pgf.448.1646660145803;
        Mon, 07 Mar 2022 05:35:45 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y16-20020a056a00191000b004e155b2623bsm16632186pfi.178.2022.03.07.05.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 05:35:45 -0800 (PST)
Message-ID: <f1e8811b-2624-d5ae-0290-e8d15d0ebcb3@kernel.dk>
Date:   Mon, 7 Mar 2022 06:35:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] docs: generate manpage from README and HOWTO
Content-Language: en-US
To:     Vincent Fu <vincent.fu@samsung.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "martin.steigerwald@proact.de" <martin.steigerwald@proact.de>,
        "sandeen@redhat.com" <sandeen@redhat.com>
References: <CGME20220302152331uscas1p297d64e27b29db799fd64d494ad584860@uscas1p2.samsung.com>
 <20220302152122.64596-1-vincent.fu@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220302152122.64596-1-vincent.fu@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 3/2/22 8:22 AM, Vincent Fu wrote:
> We have a longstanding problem where fio documentation updates must be
> made to both the HOWTO and manpage.
> 
> Here is a solution that generates a manpage from the README and HOWTO
> using Sphinx.
> 
> The downside to being able to maintain only one version of the
> documentation is that this will cause a bit of trouble for those who
> package fio and users building fio without Sphinx support will no longer
> have a manpage.

That should most certainly be solvable.

> Does this seem like a reasonable tradeoff? If so, I will follow up with
> patches to remove the original manpage and update the Sphinx-generated
> manpage to have the standard NAME, SYNOPSIS, DESCRIPTION, etc layout.

Definitely! I absolutely hate that we have duplicated documentation,
and having to ask people to update both when they submit changes is
definitely not idea.

I don't have a lot of time to look into this right now, but would
certainly entertain applying the patch if I know the submitter has done
the legwork on checking if things look good post the patch.

-- 
Jens Axboe

