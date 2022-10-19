Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5832C4332F
	for <fio@archiver.kernel.org>; Wed, 19 Oct 2022 12:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbiJSMQr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Oct 2022 08:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiJSMQP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Oct 2022 08:16:15 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B865A1162D1
        for <fio@vger.kernel.org>; Wed, 19 Oct 2022 04:52:07 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id y10so11147825qvo.11
        for <fio@vger.kernel.org>; Wed, 19 Oct 2022 04:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LGdYAX4VLQghQienoBEgDUPqBqrtHsMdSK8q2NWj/qk=;
        b=dxvYdPZgiciMuXC8SEW2ioAoWuqxgjS/cSlCX+vpu8tXDSiODnFG4Es6jym24/OD9q
         hNdnDiKEIlgTazLYxSAvEZckTVsvcKbg8HJejMTppK1KtSeeKR0pQ1n/vueF1dcxYQbu
         lEOsOarIo0m21ac7GS4jFsXPAfPJCLhH/vnKeHH4pt+UOdR46Kkm0bSbOXJn4ujFZswf
         U7AnDeA995HlH6SviDxvkRZbFZT/bntZAHgDWKo9EUTiBNfcMvFs46TG5fSd424KHmAa
         Z1srCe1T5ZrxxvaBGgKJjID8tTNbPOpOnEcGHN9n3A0MxbH92sPu+3zrkswOAIUB2quW
         9JIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LGdYAX4VLQghQienoBEgDUPqBqrtHsMdSK8q2NWj/qk=;
        b=vTgmsRPgoq/HmThbYL8pCLTKOxCxzok4mRn7MXxfzEVsdbdOJ1BAc5nStX105uWwSr
         nLHAP/DtQqg19mCwGBaeXUf6DOXV5f/pXmF16VwSQJj4JVh/WfSLwsR6vFHY9EDsnNut
         21EGb4bOglPMn1UMSw4rK9ftVp43qRq4KDFCzT5/3d+rTRpozxiXtpUZnM/+UhlrwxS0
         x5g2WRwJZcRbZ2avdYQjIKlAmeEKsLi9KFOIZklZOaRfkZZPp0DIdhTIDICGTG+riEHW
         AAyrazeApzuxZurKPnyjzEIQ0lEItFzmE6rbyl51iglsxUxR3fVrK82j3rPo+1TMbhmg
         CX4w==
X-Gm-Message-State: ACrzQf0pJ0Oug6IXM8DFUrBZpYTY4UomatQJlD649EQ6sskJ4pu5tuQg
        gcXaXFGrPxUJjnq9qRPsFAo=
X-Google-Smtp-Source: AMsMyM7AF1sk44gTWN/bQcu29dzb+Qw+LkqOOc+sNKAesajNZLCZYmGgqEzXytdYu1mGwimoWsJS4Q==
X-Received: by 2002:a0c:f550:0:b0:4b1:7af4:eece with SMTP id p16-20020a0cf550000000b004b17af4eecemr6085816qvm.110.1666180258748;
        Wed, 19 Oct 2022 04:50:58 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id g19-20020ae9e113000000b006ce3cffa2c8sm4516765qkm.43.2022.10.19.04.50.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 04:50:58 -0700 (PDT)
Message-ID: <05f680cd-1b34-c575-ab1d-81d533c080bb@gmail.com>
Date:   Wed, 19 Oct 2022 07:50:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/4] test: add test for verify read back of experimental
 verify
Content-Language: en-US
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
References: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
 <20221018041725.807940-4-shinichiro.kawasaki@wdc.com>
 <4640b1de-a98c-185e-e37c-770a895f1117@gmail.com>
 <20221019004204.lyd5zr5jqnzoankw@shindev>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221019004204.lyd5zr5jqnzoankw@shindev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/18/22 20:42, Shinichiro Kawasaki wrote:

...

> 
> Okay, I'll modify the lines as follows:
> 
>          if self.json_data['jobs'][0]['read']['io_kbytes'] != 128:
>              self.passed = False
> 
> Before the fix, the read io_kbytes was zero, so comparison with zero was enough
> to confirm the fix. But comparison with the file size is stricter and better.
> 

Great!

Vincent
