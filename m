Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36D2C77B73
	for <fio@archiver.kernel.org>; Thu, 27 Apr 2023 13:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242993AbjD0NWc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjD0NWb (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Apr 2023 09:22:31 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFA24489
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 06:22:30 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-763af6790a3so38698939f.0
        for <fio@vger.kernel.org>; Thu, 27 Apr 2023 06:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682601750; x=1685193750;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HPdB22/P2BR02l9mvM11YUjo8+/FA3Wiino5XhDpGKI=;
        b=NSJZcbwqBoa0slV686UTsardFWpTfZQ43tUsU7mv9V5g3wxyQISkGG9Kf8Z5YWNEOQ
         gUg/bdQRE83iCwbeTOw33Ae1h+ZC1zY0IWdS4OFfmBTrAVHOHIxHXaXE8/+rNM8vg087
         D7uTcMjS4+2KlT9JX2VKKkmDj7XVi9L2GnJfjVIGLPJQf+AR7DRK2dq42QdyHqCPtgLj
         ntFZJPenz+QCl9rv1LgWxZgeQLZ0Eu5seEBGXw9Cse3gvoFyWAbKviqgxVA+WvQ1FdTk
         d0Rif7J3TUbE7eBu+chMHCtrjvj/6iyL5B1Bd4Yj6Cjj6zIfxph4t+wWgV43EUAsXrQ/
         d02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682601750; x=1685193750;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HPdB22/P2BR02l9mvM11YUjo8+/FA3Wiino5XhDpGKI=;
        b=OjfT7zOZrHTc59d861ooRII4Qujq/uzESBpxu3DO5fStV9cCrev6T9DqhLRP5ZMtqd
         ZyTnoQs9tkcZEuMQiSJAMsFfin/JYqBf6eCOl8m9kNOi2d7OEb2MAmuekdFS6BIWD20C
         ji+/xkr3yuLps2TB+rh3YTw4FL6M1kUwHikiZJyp9SBBoXEVulaGfZZ1XjO0k2SoqKhN
         G8xas0f17Cgt75k6ZLD0zdb4cbfaSkYL+gY2g/y3iVtvLB2UDDiTUeCULLztyOzx6AMD
         kOjwNXbDOUzhV5HxE5+WjcCRLVllSAEd+d007pEwqume2ORw2N7idaOrD3prmaBNx0id
         IYQg==
X-Gm-Message-State: AC+VfDx1wQ7dZKsG5K5gykMfVcVRq9skymbuy240PvAnRp3NZ8+GbYhm
        ewj1XBkInC5gOor7m9oI6UV8UdnpeH3IKxBYlG4=
X-Google-Smtp-Source: ACHHUZ6hUGSK0CVkXLGlTVX6AUWomCXiVP4NqfQ4mjzxEq/eZEeuoWaViZTGSpvAV9iLsCmJMKmSIw==
X-Received: by 2002:a05:6e02:1c0a:b0:32a:a8d7:f099 with SMTP id l10-20020a056e021c0a00b0032aa8d7f099mr1192151ilh.3.1682601750011;
        Thu, 27 Apr 2023 06:22:30 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id s17-20020a92cb11000000b0032a8e1ba829sm4878052ilo.16.2023.04.27.06.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 06:22:29 -0700 (PDT)
Message-ID: <ece9613d-ffeb-7fd7-942a-0902259e5a65@kernel.dk>
Date:   Thu, 27 Apr 2023 07:22:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] t/io_uring: fix error handling for setup_ring
Content-Language: en-US
To:     Anuj gupta <anuj1072538@gmail.com>
Cc:     Anuj Gupta <anuj20.g@samsung.com>, vincent.fu@samsung.com,
        fio@vger.kernel.org, ankit.kumar@samsung.com
References: <CGME20230427094952epcas5p32967ed548e18e60ea3134a03aa046bb8@epcas5p3.samsung.com>
 <20230427151004.1146679-1-anuj20.g@samsung.com>
 <4e368610-30aa-4f2a-202b-d93050ea1f02@kernel.dk>
 <cdbabe77-9b1d-c020-e7fe-528e453af002@kernel.dk>
 <CACzX3AvLdk8rLH-3DOe1Ono9xabi2NMsoXBnvpmMj6rFPVfM-A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACzX3AvLdk8rLH-3DOe1Ono9xabi2NMsoXBnvpmMj6rFPVfM-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/27/23 6:26?AM, Anuj gupta wrote:
> On Thu, Apr 27, 2023 at 5:23?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/27/23 5:48?AM, Jens Axboe wrote:
>>> On 4/27/23 9:10?AM, Anuj Gupta wrote:
>>>> s->sq_ring.ring_entries and s->cq_ring.ring_entries will be NULL,
>>>> incase setup_ring fails. This will cause a segmentation fault.
>>>>
>>>> In case setup_ring fails, bail out by setting finish.
>>>
>>> Any reason why we don't just use the return code of submitter_init()
>>> on whether to abort or not?
>>
>> Something like this as a prep patch, then do the trivial version
>> of your patch after that.
>>
>> Totally untested...
>>
>>
>> diff --git a/t/io_uring.c b/t/io_uring.c
>> index 6b0efef85cb7..2f8d63fbe67e 100644
>> --- a/t/io_uring.c
>> +++ b/t/io_uring.c
>> @@ -1049,7 +1049,7 @@ static int submitter_init(struct submitter *s)
>>
>>                 buf = allocate_mem(s, bs);
>>                 if (!buf)
>> -                       return 1;
>> +                       return -1;
>>                 s->iovecs[i].iov_base = buf;
>>                 s->iovecs[i].iov_len = bs;
>>         }
>> @@ -1066,7 +1066,7 @@ static int submitter_init(struct submitter *s)
>>         }
>>         if (err) {
>>                 printf("queue setup failed: %s, %d\n", strerror(errno), err);
>> -               return 1;
>> +               return -1;
>>         }
>>
>>         if (!init_printed) {
>> @@ -1172,9 +1172,15 @@ static void *submitter_aio_fn(void *data)
>>         struct iocb *iocbs;
>>         struct io_event *events;
>>  #ifdef ARCH_HAVE_CPU_CLOCK
>> -       int nr_batch = submitter_init(s);
>> -#else
>> -       submitter_init(s);
>> +       int nr_batch;
>> +#endif
>> +
>> +       ret = submitter_init(s);
>> +       if (ret < 0)
>> +               goto done;
>> +
>> +#ifdef ARCH_HAVE_CPU_CLOCK
>> +       nr_batch = ret;
>>  #endif
>>
>>         iocbsptr = calloc(depth, sizeof(struct iocb *));
>> @@ -1238,6 +1244,7 @@ static void *submitter_aio_fn(void *data)
>>         free(iocbsptr);
>>         free(iocbs);
>>         free(events);
>> +done:
>>         finish = 1;
>>         return NULL;
>>  }
>> @@ -1277,9 +1284,15 @@ static void *submitter_uring_fn(void *data)
>>         struct io_sq_ring *ring = &s->sq_ring;
>>         int ret, prepped;
>>  #ifdef ARCH_HAVE_CPU_CLOCK
>> -       int nr_batch = submitter_init(s);
>> -#else
>> -       submitter_init(s);
>> +       int nr_batch;
>> +#endif
>> +
>> +       ret = submitter_init(s);
>> +       if (ret < 0)
>> +               goto done;
>> +
>> +#ifdef ARCH_HAVE_CPU_CLOCK
>> +       nr_batch = ret;
>>  #endif
>>
>>         if (register_ring)
>> @@ -1383,6 +1396,7 @@ submit:
>>         if (register_ring)
>>                 io_uring_unregister_ring(s);
>>
>> +done:
>>         finish = 1;
>>         return NULL;
>>  }
>> @@ -1393,7 +1407,8 @@ static void *submitter_sync_fn(void *data)
>>         struct submitter *s = data;
>>         int ret;
>>
>> -       submitter_init(s);
>> +       if (submitter_init(s) < 0)
>> +               goto done;
>>
>>         do {
>>                 uint64_t offset;
>> @@ -1429,6 +1444,7 @@ static void *submitter_sync_fn(void *data)
>>                         add_stat(s, s->clock_index, 1);
>>         } while (!s->finish);
>>
>> +done:
>>         finish = 1;
>>         return NULL;
>>  }
>>
> 
> Tested this and the patch works out fine. This can go on top of this
> to avoid access to NULL pointer -

Thanks! Can you send this one as a real patch to make my life just a
tiny bit easier?

-- 
Jens Axboe

