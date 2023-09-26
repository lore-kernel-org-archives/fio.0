Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D9CE7E644
	for <fio@archiver.kernel.org>; Tue, 26 Sep 2023 15:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbjIZPrl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 26 Sep 2023 11:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbjIZPri (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Sep 2023 11:47:38 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94472116
        for <fio@vger.kernel.org>; Tue, 26 Sep 2023 08:47:31 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id ada2fe7eead31-452b0430cc5so4134451137.3
        for <fio@vger.kernel.org>; Tue, 26 Sep 2023 08:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695743250; x=1696348050; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9gHd8+KZpgnuPcmoe5hzaLlZ0oWSdoqLd+vA6XbTIZY=;
        b=TlLXJrCuqOGgFBu/EQL+kADohZ0cZFMQkZxA3HGkCvZVFCRE/hev5IHOy4I3Fce359
         u+9PlbO/mA6l5ULD1VH+cauSQW0gCcB1IQ6IpYeIlcdiwLNMi8XSGQ0pIdi3pL6rKf8u
         a4pfZs4+BTPlYjlSB32UBr9vqksyidTynbfP302AgSkALMyOr820A3THFZInafqQ1Z+R
         ieF9A9JNVEdBafjwZPsOf1DpqR/VWHjIFTHombo0KENjruU+4fHr3LwOmkg2/LQqB8bj
         cOUTEUMFoT5XbWGkowcgEMNRnY5BJW7QLlyJ9XntfZI2TV30Ue66Xaz548ADKlyYZEDi
         GJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695743250; x=1696348050;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9gHd8+KZpgnuPcmoe5hzaLlZ0oWSdoqLd+vA6XbTIZY=;
        b=EOlI/JBEDTznYr4ihdm/lfDinLzA8njc5r3eGalRs1E2ApGVwc7EdnYLhtMcuwBHgb
         b6zZDQqA8QYFRdOuCE+BgmsFMJNLPUg7AF45wH2Xekrcm0KkB58YWR3XCZhh8YZ9mCyw
         OJ3UxjHBss2JgVED5quXzwuNSWdyVGG3JJ+4NDdbYvLY2ecT/7F5Z7e2X7vnSzG70Px7
         FysnyuLphA4pTD7wCqdKDIfzvCkVqy/A0XWfjBTMIc6c/HT3gPia8eD1HVyTd8JIdHkN
         L8loJJBaWtdCajlrVngK7pu/L2fRCqL5G+1cJ6gqxjiuB0NZstkJt8qpVN0OUJ0zFBIz
         pD2A==
X-Gm-Message-State: AOJu0YzxWjk85vFs75howHl/2aOWa1EA4ktaZ0zv5ifveNrbRRDe9Xav
        f36ZNeLD+Fhv95s38bbFT04=
X-Google-Smtp-Source: AGHT+IGScDxuHXWRDZc1XcqVxw0wZA43FqfZy05Sstgk8+0KflN0vwrP9zMCjPHSsIoPwZxlLp+T6A==
X-Received: by 2002:a67:fa49:0:b0:452:6451:5e16 with SMTP id j9-20020a67fa49000000b0045264515e16mr6311468vsq.31.1695743250483;
        Tue, 26 Sep 2023 08:47:30 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id r18-20020a0cb292000000b0065b18f18709sm1429505qve.78.2023.09.26.08.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 08:47:29 -0700 (PDT)
Message-ID: <40a3c93d-686d-72d7-fba8-d87efd56c390@gmail.com>
Date:   Tue, 26 Sep 2023 11:47:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] t/zbd: set mq-deadline scheduler to device-mapper
 destination devices
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230913015249.2226799-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230913015249.2226799-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/12/23 21:52, Shin'ichiro Kawasaki wrote:
> When write workloads run on zoned block devices, mq-deadline scheduler is
> required to ensure write operations are sequential. To fulfill this
> requirement, the test script t/zbd/test-zbd-support sets mq-deadline to
> the sysfs attribute "queue/scheduler". However, this preparation does
> not work when the write target device is a bio based device-mapper
> device. The device is bio based then I/O scheduler does not work.
> Setting mq-deadline to the sysfs attribute has no effect. On top of
> that, the sysfs attribute "queue/scheduler" is no longer available for
> bio based device-mapper devices since Linux kernel version v6.5.
> 
> To ensure mq-deadline scheduler for bio based device-mapper devices,
> improve the helper function set_io_scheduler. If the sysfs attribute
> "queue/scheduler" is available, use it. Otherwise, check if the test
> device is a zoned device-mapper (linear, flakey or crypt). If so, set
> mq-deadline scheduler to destination devices of the device-mapper
> device. To implement these, add some helper functions.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Applied. Thanks.

Vincent

