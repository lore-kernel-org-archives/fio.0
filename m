Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B07C433EF
	for <fio@archiver.kernel.org>; Mon, 25 Oct 2021 15:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D08C460F70
	for <fio@archiver.kernel.org>; Mon, 25 Oct 2021 15:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhJYPnq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 25 Oct 2021 11:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbhJYPnq (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 25 Oct 2021 11:43:46 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D944C061745
        for <fio@vger.kernel.org>; Mon, 25 Oct 2021 08:41:24 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id t4so16106898oie.5
        for <fio@vger.kernel.org>; Mon, 25 Oct 2021 08:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xj1gyryCRzkV71LLtYbQoGCS/l8a6c28OLIKOle+eZo=;
        b=eqIN3nZJBW7wzpxQbrS32OFsSQqesrj2N6gljE/BXuxohUoLH0dW4V9tX8OPjnf8lS
         VVI65MofNylWSwCUWxHlvtltkWVcuZ26A8c9p7+Q4Y453tYmo7UBSGKmxyIs43/m6kee
         hMX/mzhXQ6dwWUZjl7G4o7uSGq2Kk597dFi2FfT04Bl7ELB4WTbB+RD3wFz5gFlRoFJO
         Ab4hVzOjTYdB5LPQv8XVNewlomzpqKZj11tEUAMF5Gamv2pMlWmR0KNNRf+k+AyvwdVz
         e/YsJQhFrW8X93vpzPsIQCSEct8Ane/niv8Zs1wAttvcBjjBJWhpbbQsh3bIQDz05cnl
         on0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xj1gyryCRzkV71LLtYbQoGCS/l8a6c28OLIKOle+eZo=;
        b=UulA6e2opD3bqCdA//ll0ODkcIOnd8C3S5eBIPsibxRdpngHL/tAAumkuVbxuJ7kDt
         DVow4qbT25KTjOh3IPQINRgPyufetqLR2cYC2S8i4qSIPnMiscCP4BQ9krEIH3FwRkgq
         sHWQziO33QaHMy9KCZ6mMankZ73/IRAd3S+DrKsE5+plR6hRsV+cLkeOa3XdIiXpUp12
         k7vC+GDUvxrsnBwQDyq39gmI7XtYYqfXsMmzR0eFEb+PVOoaYCckDtXoyqUn+DXb+Gex
         nOqUCOb3lZmYEtjj3dLfRnBLQVHvV1npicYoTEtMXNPJ48xr9pQpfkpUszRAZnr68ava
         pPIw==
X-Gm-Message-State: AOAM531C2CVKrmo7esXJn/g4me5SrjPavCSSRGHkdAVQimqUOF40Rei6
        YaBO3KVmnOE7p2I8kub2XwKQ8kXE1wOffGLs
X-Google-Smtp-Source: ABdhPJwmO/W8Qwsb0VroxowBVdcOc7ACXlcyhmxEh1LWNmaKheZ2QEyQwd6/4u06tL5hVeEXU1cnqg==
X-Received: by 2002:aca:eb15:: with SMTP id j21mr12665173oih.59.1635176483248;
        Mon, 25 Oct 2021 08:41:23 -0700 (PDT)
Received: from ?IPv6:2600:380:602d:d087:5bee:e9ee:c67d:4ccf? ([2600:380:602d:d087:5bee:e9ee:c67d:4ccf])
        by smtp.gmail.com with ESMTPSA id q12sm3582345oth.79.2021.10.25.08.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 08:41:22 -0700 (PDT)
Subject: Re: Recent changes (master)
To:     Rebecca Cran <rebecca@bsdio.com>, fio@vger.kernel.org
References: <20211023120001.B33411BC0139@kernel.dk>
 <13b58f71-076c-02a8-985c-60294a6d35b4@bsdio.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a26a7532-0c76-2b8c-f28c-e760c13b1833@kernel.dk>
Date:   Mon, 25 Oct 2021 09:41:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <13b58f71-076c-02a8-985c-60294a6d35b4@bsdio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/25/21 9:37 AM, Rebecca Cran wrote:
> On 10/23/21 6:00 AM, Jens Axboe wrote:
>> The following changes since commit 09d0a62931df0bb7ed4ae92b83a245e35d04100a:
>>
>>    Merge branch 'patch-1' of https://github.com/sweettea/fio (2021-10-19 16:09:21 -0600)
>>
>> are available in the Git repository at:
>>
>>    git://git.kernel.dk/fio.git master
> 
> I just noticed this. Is it possible to change this to specify the https 
> URL instead, since the git protocol is insecure?

Both will work with git.kernel.dk

-- 
Jens Axboe

