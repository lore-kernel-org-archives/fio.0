Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D72C54EBC
	for <fio@archiver.kernel.org>; Wed, 11 Jan 2023 15:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbjAKPVN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 11 Jan 2023 10:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbjAKPVB (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Jan 2023 10:21:01 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C622616
        for <fio@vger.kernel.org>; Wed, 11 Jan 2023 07:20:56 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id e21so15362703ybb.3
        for <fio@vger.kernel.org>; Wed, 11 Jan 2023 07:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qdA2hpy1U1vQ6bxV/X06xhLiS55JNJmHiDhpDsSIhoM=;
        b=c+Ib7eQP84YBgidkUHiIS2Li8gNDVAh3mSK3W6oG/gNi39yYw/6zHcIIpccQug6NT1
         TpB6KITvSzYXW7+GOdin++LTs5ANu/1+A0TR+NIkNaKMNZOjw51mHOawLJrM3HttxIpN
         0dT10yRQqoi+wv7d+y2d1Tznsyxk8T4OOzg2KxB8RRiHLvlsYacMbqQesLcakjaMTAjb
         RxdslRpNXQfIol6IM+e/ojrtR2R272ot+YBs/I9YaOJK/+5cJeMRW7LE5v5EBQ3RbZKQ
         18+EJ2hwR+iwo4SfYBRE8n58NjSPiK9jX6Bsu4OIXtb4I/Zwqm1h8ddL7YETNWJJNaEg
         s8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdA2hpy1U1vQ6bxV/X06xhLiS55JNJmHiDhpDsSIhoM=;
        b=zJtES1aH1lKhbWQJ1zUjNPgJsZYSRL/ICBxIzVQck7h3vH4Tn4P1oPSFXgMPG/j6UJ
         6/CXP1GOZh9nPldvHMnR/pxv8fNhJnLcgSrgbfAO/T5Fn+Ua34AAnZduzornePbgsvYs
         EA7HQUWLPjc2H2E/ti1HiYKSfRucXP9HVPJMRyXBhBJ3N3hOSMLf6lWbhxbJdCwz4ugW
         lwuOaenGoiYqp5pCHeRnh53rEHqa6V6knXeSve+m6G3Mm1GKppeje4pIRjda7zL4gS3M
         skBekNudc8IebRtMfYkm7Q+Sy9T0mxL6sSeqFgTp8T6tZLzTpF0MCq5SbWyXCp4aOe0W
         klng==
X-Gm-Message-State: AFqh2koJhc4Wt/u2ifzk3jUf2F9PBgVXkeLeAaPrhgpMmAd4+fPAsbtT
        yOduiHrEQNUB2cfYhEc0HYo=
X-Google-Smtp-Source: AMrXdXtPhAv8uLAFNXq5Uit7yZF3k1h3JwoUFKwAh2XMfKBBcdLrG7dCzCmG02oGf1OM0mlZ0t2eHg==
X-Received: by 2002:a25:6d06:0:b0:6f2:63ac:49bd with SMTP id i6-20020a256d06000000b006f263ac49bdmr64044072ybc.38.1673450455724;
        Wed, 11 Jan 2023 07:20:55 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id do44-20020a05620a2b2c00b006f8665f483fsm2266178qkb.85.2023.01.11.07.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 07:20:55 -0800 (PST)
Message-ID: <baf02329-1f87-162d-ec49-fb4d10e0e24a@gmail.com>
Date:   Wed, 11 Jan 2023 10:20:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 0/1] Update doc for option rw_sequencer
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org
References: <CGME20230111064841epcas5p3b26ec4b04ab5ddbfc5ce4caea0dc4687@epcas5p3.samsung.com>
 <20230111064805.10001-1-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230111064805.10001-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 1/11/23 01:48, Ankit Kumar wrote:
> Fixes: https://github.com/axboe/fio/issues/1223
> 
> Changes since v1:
>   - Changed the wording for rw_sequencer=sequential as per
>     Vincent's feedback.
>   - Added few examples explaining about rw_sequencer.
> 
> Ankit Kumar (1):
>    doc: clarify the usage of rw_sequencer
> 
>   HOWTO.rst | 35 ++++++++++++++++++++++++++++-------
>   fio.1     | 47 +++++++++++++++++++++++++++++++++++++++++------
>   2 files changed, 69 insertions(+), 13 deletions(-)
> 

Applied. Thanks.
