Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E60EC4332F
	for <fio@archiver.kernel.org>; Wed, 23 Nov 2022 19:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbiKWTHc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239682AbiKWTH2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 23 Nov 2022 14:07:28 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C4DA6A00
        for <fio@vger.kernel.org>; Wed, 23 Nov 2022 11:07:20 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id l15so11860182qtv.4
        for <fio@vger.kernel.org>; Wed, 23 Nov 2022 11:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ek4Al1KJH9NBT5q3oN3An73Qj+iljXhtLVoIZSNqhzY=;
        b=P+4y56EYlrH7XlAeibpd0VkU2Pc4pFYNA9zUOG8vZxf4dshmaEPbOuo88RpZx5foxe
         tKbmm4Ps2M1apRW6X7VoON+Fl0ERy35+sBsQQNI7sEc5qrXo5S3La+a6v2sAKMzVm8Kl
         XTHkVzMa8Z+JZhHfWQt15AFBAzl5xBmR64QFyDBQB20hux8bhvbQlHQFrzOo02mjce2g
         hZBgvcrMtjrFAg6Al63UWk+IYzJjD8YA4wR8FWad9YUri5wBxmgnuUMWpYn5R2g6OGUA
         yy6iyDVJiH7uhCz9N3uvKkjm6tdgizPcOH7uNvyiYh109X+5HXS2EC/17ylnwxXMOtVb
         tDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ek4Al1KJH9NBT5q3oN3An73Qj+iljXhtLVoIZSNqhzY=;
        b=D+34YJ3N7IObVuahF0J0inBz6gxtHChdKyn4LzHu4Ijbxo8umw8ERtn/emIKVzYGW3
         bZXl9VOKtur4HNrQ4NbdB2yfkwegCMe3jXU79v3jgtGWh6UqvuGi2R4dAY8SAJb4b5up
         t7HPGzIWNBje/xzWJIdQYybi0IghYTi7tv90iwsR+YigXTFTGGl8Ruw5mwazI1nnV+Kh
         uCXaCJyKScV8iqepaSriNWkRS7pzIyXW5hHE8oH6eiObFRWikfMd7OPXohPENTK2YtpE
         s5lmOA1hOCB9tCgmq0JLV3MIxwgTz6V9R1S6nZV7dqfBn4JlER0Kxh+W6VemADkkq2vF
         vKWA==
X-Gm-Message-State: ANoB5pmWbytWuMVzBa3Dgb8qLunFrORi/fhxZkcGNSSi/ZVSjeH59TEz
        l4cA7+lWv/sN0krj2/6xCPs=
X-Google-Smtp-Source: AA0mqf7OuZW6N7SlPXrvT+iZhLhW+OnFbUbRPCAhWX7scS4aBTiiIqpHZcrb07UOz6OdiemuCEg1Wg==
X-Received: by 2002:a05:622a:5c8e:b0:3a5:5c9e:d453 with SMTP id ge14-20020a05622a5c8e00b003a55c9ed453mr28527178qtb.403.1669230439942;
        Wed, 23 Nov 2022 11:07:19 -0800 (PST)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id dm53-20020a05620a1d7500b006fbbdc6c68fsm12283495qkb.68.2022.11.23.11.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 11:07:19 -0800 (PST)
Message-ID: <f70645a2-3b7e-2b69-76cc-218fa061cd13@gmail.com>
Date:   Wed, 23 Nov 2022 14:07:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 0/2] fix clat reporting with sqthread poll
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org
References: <CGME20221123113911epcas5p198248dd58155d554974c3221d843271d@epcas5p1.samsung.com>
 <20221123112738.24820-1-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221123112738.24820-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/23/22 06:27, Ankit Kumar wrote:
> When sqthread_poll is specified for io_uring and io_uring_cmd I/O
> engines, fio reports garbage value for completion latencies. This is
> because the issue time was not recorded. This adds a change for that.
> As the submission latency for sqthread poll is really just
> the time it takes to fill in the SQ ring entries and any syscall
> required to wake up the idle kernel thread. So there is really no need
> to report those.
> 
> Also Updated the documentation to reflect the changes.
> 
> FIO command used to test:
> fio --name=test --size=1M --rw=randread --ioengine=io_uring --sqthread_poll=1
> 
> Latencies reported before the change:
>      clat (msec): min=7543.5k, max=7543.5k, avg=7543493.06, stdev= 8.30
>       lat (usec): min=104, max=5070, avg=131.54, stdev=309.92
>      clat percentiles (msec):
>       |  1.00th=[17113],  5.00th=[17113], 10.00th=[17113], 20.00th=[17113],
>       | 30.00th=[17113], 40.00th=[17113], 50.00th=[17113], 60.00th=[17113],
>       | 70.00th=[17113], 80.00th=[17113], 90.00th=[17113], 95.00th=[17113],
>       | 99.00th=[17113], 99.50th=[17113], 99.90th=[17113], 99.95th=[17113],
>       | 99.99th=[17113]
>    lat (msec)   : >=2000=100.00%
> 
> latency reported after the changes:
>      clat (usec): min=106, max=5122, avg=132.95, stdev=313.07
>       lat (usec): min=106, max=5125, avg=133.11, stdev=313.27
>      clat percentiles (usec):
>       |  1.00th=[  108],  5.00th=[  108], 10.00th=[  109], 20.00th=[  111],
>       | 30.00th=[  112], 40.00th=[  113], 50.00th=[  114], 60.00th=[  115],
>       | 70.00th=[  116], 80.00th=[  118], 90.00th=[  120], 95.00th=[  121],
>       | 99.00th=[  122], 99.50th=[  122], 99.90th=[ 5145], 99.95th=[ 5145],
>       | 99.99th=[ 5145]
>    lat (usec)   : 250=99.61%
>    lat (msec)   : 10=0.39%
> 
> This fixes the issue: https://github.com/axboe/fio/issues/1484
> 
> Ankit Kumar (2):
>    engines:io_uring: fix clat calculation for sqthread poll
>    doc: update about sqthread_poll
> 
>   HOWTO.rst          |  4 +++-
>   engines/io_uring.c | 20 ++++++++++++++++++++
>   fio.1              |  4 +++-
>   3 files changed, 26 insertions(+), 2 deletions(-)
> 

Applied. Thanks.
