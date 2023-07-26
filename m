Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF12EC001B0
	for <fio@archiver.kernel.org>; Wed, 26 Jul 2023 13:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbjGZNH2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Jul 2023 09:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjGZNH1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Jul 2023 09:07:27 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252972698
        for <fio@vger.kernel.org>; Wed, 26 Jul 2023 06:07:19 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-682eef7d752so1535321b3a.0
        for <fio@vger.kernel.org>; Wed, 26 Jul 2023 06:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690376839; x=1690981639;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MH08+FKDFgGDHlSMX9T9o0ZkDg/YlCAbSe/yVVPsrpc=;
        b=zTV5hE5DOV/8ek7YiBv3YSy9naggi0lu4Q+TtWk8Hia+I3TWUQgx6awjhJpSVMbyIq
         vj4IzbyqoFJgrl5RwKQOfsjy6nJyq4UCvSwkP4T65cpU+IOwUEP9exeUagXYJKEbNKqV
         eem+Wu0bO+AoSQbnsqFbawJA+NkW8CmWlaOek4Cfz0q28p71tR7sbhjzrL8IfESa/UAO
         d5Fpv54HE2QMxqp5Ua5pQ2hNGklGoRFNMchGS0a+THk+pZmgFALfiWf1Ce5pdKMNfk/R
         WZpIPMsp9aZ8D21SMhUXkdFQV/Gjj9yeu0QErQsKBTdLEUP8UU1nc1Y7T6QsKeGu3P7N
         07Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690376839; x=1690981639;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MH08+FKDFgGDHlSMX9T9o0ZkDg/YlCAbSe/yVVPsrpc=;
        b=k3hHWTV60T1yxvXZ/PSF6UW+fFZ1VC5+gq7McXg9gqn2MKs9ojEtQVVLIKTyfwyC6h
         rp2h9jD389LQNnIPIsYQHXlgqhM9As57pGv238aL3W8OJlbG2B6bRihTSdepdQSwZt9/
         WzK8RBIDJncgwbxgJ6JkVHONpgVptKRUB3RCQXCxcw3eN+OY6ihtVSG1Ix2vYezUS3mQ
         v0WTvxULgZPduQ9u0sy5xWQlWw2nXhto1a8mXZNkzrlFtNJUBNuXu1iLIpBaV7dqIEYH
         rqiVI1/VonAYzELHUVtzR/NbzP1AZFeT6sJo5t0jX/TQxuMiW5F8DXQz9PlBLOc9oYv/
         5HSA==
X-Gm-Message-State: ABy/qLaSEwR9duXKBFSyvs7gGaWhW4nH5KLoRyLeVyOXfJyT2hbMleH+
        /GoOW4o/yapqEHqJeebweTc0GRuPIH2zMEJELzA=
X-Google-Smtp-Source: APBJJlF5pfIkj5Nrf4b0IEqE0OIP7hkcgbozlDLnr+iI8mVI5iNfT6WwpK1g382kTylQCaJWhSp8xg==
X-Received: by 2002:a05:6a00:4a0e:b0:677:3439:874a with SMTP id do14-20020a056a004a0e00b006773439874amr2325660pfb.3.1690376838952;
        Wed, 26 Jul 2023 06:07:18 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j23-20020aa783d7000000b00686940bfb77sm2606729pfn.71.2023.07.26.06.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 06:07:18 -0700 (PDT)
Message-ID: <2a66e6aa-f6df-2623-5500-5115f202ca85@kernel.dk>
Date:   Wed, 26 Jul 2023 07:07:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: gfio and GTK-3
Content-Language: en-US
To:     Martin Steigerwald <martin@lichtvoll.de>, fio@vger.kernel.org
References: <2016694.B2NXdZ3Yii@merkaba>
 <817148c6-67ff-f3bd-12b0-21e2e7b03748@kernel.dk>
 <1950739.PYKUYFuaPT@lichtvoll.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1950739.PYKUYFuaPT@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/26/23 2:47?AM, Martin Steigerwald wrote:
> Hi Jens.
> 
> Jens Axboe - 20.08.20, 13:52:40 CEST:
>> On 8/20/20 1:43 AM, Martin Steigerwald wrote:
>>> Is gfio compatible with GTK-3?
>>>
>>> I am asking due to Debian wanting to get rid of GTK-2 at some time:
>>>
>>> fio: depends on deprecated GTK 2: https://bugs.debian.org/967339
>>>
>>> If not, are there plans to make it compatible? Or are there plans to
>>> drop it instead?
>>
>> I'm tempted to just drop it. gfio never really got what I consider
>> finished, and I don't think it's in widespread use.
>>
>> Maybe I'm wrong and there are in fact people out there using it. I
>> know someone had a patch at some point to convert it to gtk3, and
>> if that's still the case, I would not mind applying that and making
>> it continue to live in the repo.
> 
> Did anyone submit a patch for GTK-3 support in gfio?

Not too my knowledge.

> If not, I agree, probably best to just drop it. Especially after almost 
> 3 years and as GTK-4 is around the corner. In case anyone would like to 
> port it they can resurrect it from git history.

Yep, we probably should. Nobody has been working on it in many years. It
probably still works fine, but it's mostly just a GUI frontend and it's
still lacking features that you would want to consider it a good GUI
frontend.

-- 
Jens Axboe

