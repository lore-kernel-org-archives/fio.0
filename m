Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAE1C4332F
	for <fio@archiver.kernel.org>; Wed, 19 Oct 2022 12:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiJSMNO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Oct 2022 08:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiJSMM4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Oct 2022 08:12:56 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9211E3E4
        for <fio@vger.kernel.org>; Wed, 19 Oct 2022 04:48:54 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id w3so11430836qtv.9
        for <fio@vger.kernel.org>; Wed, 19 Oct 2022 04:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l7Rm0+AUVsmJ6NLWBbGy2b6+pDN4eHUphsu7fZwklgI=;
        b=DPrdHkHtxAkUDgCAaudPnkDK6iOqYPVrTXAEWbei1kC0oHY/aBxHN3gMR/oq7MEVJz
         Csco9PXjeL+t0QYoOdR+KcwA6OS+IpBLHldJQHx0lf69Kh6JToH5dKgDA3nZ03pLESfq
         x24oz4elZML1Tceko3rB45SfnGs27SNbWG8fs6Ig6LnQ3kp3debl78q2HL/KHl28Xh7f
         hkH0z8wouMCBLTK8zDtDdzQvKJXu04tlXkXmCXBz3pid1jgGgS0rVecJPc5YrA7MCWlt
         BgHrjToiik1zezo+WSOGez5g+nyrWXa0MX8rE5RgduFACWmjhDUCqgrbKL3/CYms7809
         +E1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l7Rm0+AUVsmJ6NLWBbGy2b6+pDN4eHUphsu7fZwklgI=;
        b=2u/qjzWqU/PajciE4faO1apgjKIv8Hh4SRdVPHDIw++eGr2sPABvtlIL9uP08TdA1N
         kc4F3wG0c0Cedj6ervcqILccntm+J8Gm6jQIpea/BUUwkWR9hxBxfSUVQwlkjm6m0KTc
         6MUw8NvztSyUK30XdCrJOeOqXvvssYYCc8FL+bSu1OUatrQ4F7q8lnxYLVnOoXegIJw0
         wJi3mRFA4GHBex4yo31Se44UDL52WKY1LYnMP3V/soe8buV2YQw/iTQrIYxIUyi6nPwF
         Uyzaput0Yvwi77fRiMltXfaawDrXcBTKGslSGSCSFPuGd/EZ7JJDRHWTIV4DI+luGmEa
         uUUA==
X-Gm-Message-State: ACrzQf1v5AP9XirtIn7jApQA0mfYOPqJ91d5KSkKOa6JvARPBWEoI4yw
        h+Jj3tpmiKf5cF3CftNrwbk=
X-Google-Smtp-Source: AMsMyM4pTTSjh0I7p8UDZKj1DRoLSKFZOaSAnfCpX0XMVAf+oI6mjq/6ktCXvfwOPiCOMFApoxsHMw==
X-Received: by 2002:a05:622a:92:b0:39c:f95d:5718 with SMTP id o18-20020a05622a009200b0039cf95d5718mr4477023qtw.298.1666180059824;
        Wed, 19 Oct 2022 04:47:39 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bi26-20020a05620a319a00b006ce7bb8518bsm4838306qkb.5.2022.10.19.04.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 04:47:39 -0700 (PDT)
Message-ID: <e647e75e-24ba-c08c-182d-d4c64c8d9ade@gmail.com>
Date:   Wed, 19 Oct 2022 07:47:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/4] fix experimental verify
Content-Language: en-US
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
References: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
 <e1d0b1fa-b36a-1269-7d3d-4998d2b62177@gmail.com>
 <20221019003434.phkgrtape26sxgza@shindev>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221019003434.phkgrtape26sxgza@shindev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/18/22 20:34, Shinichiro Kawasaki wrote:
> On Oct 18, 2022 / 12:14, Vincent Fu wrote:
> 
> [...]
> 
>> Hello Shin'ichiro,
>>
>> I applied your patches to a branch on GitHub:
>>
>> https://github.com/vincentkfu/fio/commits/exp-verify
>>
>> All of the automated Linux and macOS tests pass but on Windows I see
>> failures with t0026:
>>
>> https://ci.appveyor.com/project/vincentkfu/fio/builds/45105941
>>
>> Would you take a look?
> 
> Thanks. All 3 failures reported "bad header rand_seed":
> 
> verify: bad header rand_seed 59864971564696990, wanted 1584616954246794908 at file t0026file offset 1019904, length 4096 (requested block: offset=1019904, length=4096)
> verify: bad header rand_seed 59864971564696990, wanted 1584616954246794908 at file t0026file offset 1019904, length 4096 (requested block: offset=1019904, length=4096)
> verify: bad header rand_seed 822895868, wanted 2592444842 at file t0026file offset 1019904, length 4096 (requested block: offset=1019904, length=4096)
> 
> The bug fixes made experimenal verify work again, and unveiled another failure
> scenrio unique to Windows. I walked through rand_seed handling in verify path,
> but could not find anything wrong, or anything os dependent. I guess integer
> type sizes unique to Windows could be the cause, but not sure.
> 
> My Windows development skill is dusty now, and I don't have Windows environment.
> It is difficult for me to chase it further.
> 
> Or, it would be the better to disable this test case for Windows. Is it ok to
> add the requirement below to this test case?
> 
>          'requirements':     [Requirements.not_windows],
> 

Disabling the test on Windows is a reasonable thing to do.

Vincent
