Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB4F3C61DA4
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 15:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjBCP06 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 10:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjBCP0b (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 10:26:31 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E47323D9A
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 07:26:17 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id i188so5688376vsi.8
        for <fio@vger.kernel.org>; Fri, 03 Feb 2023 07:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U2WZ2/nMEpHqF8Lh7cFUXWEfk2J02iD35GAs5vvqwis=;
        b=LPJfNiAOjYDqQSrBZo2nVY5due+D0pxDNvuZPxK8kGpEOHfh91cnJj5DPsQ+e3vyud
         adme/ZMxN31t8QLHkRWqmA8Hr7RYy1Zg+YJiuG64E12D6MrQ1N+rU944STArX/6BKZ0+
         fDrnov/titwi7J+IuRoAe+8txcEv4IbEeCQF1iJQcyB0MlHKyWXrSqSA/QxvVYRL8n9F
         ltZCmVcYP1AkgV6l+Yvt2CbwK8BlCKabfryz/oOfESQH1hPdhRNDOf992bCDC4oV+aj5
         JZHlbEjqFP1hTx1WxAec5QEQjMYmSszB4BSrvuX8f0GFwkQH1YDnu78PfmhAugfI6hFM
         PRYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U2WZ2/nMEpHqF8Lh7cFUXWEfk2J02iD35GAs5vvqwis=;
        b=23kwY9/GygJroCEvvle9r1y75DScYTA9jxsNGKVtsMip68Qja7rYhtACjsgNhDZ/zr
         +Qzh22lggMgktAVE2CF1Xnb+mMRG/GLMNfOzxyFr8ccO4evACVFtxY+ihvJ9njfB9B+0
         Z1O8VjwzCAxdWBRqN5qqlFsyO/XJ/T3peJ/aDcjpUJH/ggoFqZnMgUN16JSIVk6S1N++
         51x3nkUMHOweQfY8+QwCb3tkhpP5e1TrVvKIDnE4lnxjulMB+CL938SqJhSHkPU/cL2p
         FdsSwB8v2fG1oRQWnXs69upTWPe9+BBT83qh5KcY4FZfVfrrJjtgDVrXTolnfrUEB9wq
         +V5w==
X-Gm-Message-State: AO0yUKXFGreAy92Qy46cBV9C65vEcUwaORg7B4bgzC74LEAFjSJA1A36
        8edRB79fYgp6EGtrE+TkdiQ=
X-Google-Smtp-Source: AK7set9qdnW14vBKHcQWp3LFMfA0cvE8+H/0dsZ9kUdvPQWzLYCSXHBa9vj0BsJPy/RLp65AHdFshw==
X-Received: by 2002:a67:6743:0:b0:3b5:142d:2e53 with SMTP id b64-20020a676743000000b003b5142d2e53mr5115678vsc.14.1675437976163;
        Fri, 03 Feb 2023 07:26:16 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id ed4-20020a05620a490400b007195af894e7sm1970466qkb.76.2023.02.03.07.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 07:26:15 -0800 (PST)
Message-ID: <c7ae8aa4-7c91-f892-b7fa-0d34ab4ea536@gmail.com>
Date:   Fri, 3 Feb 2023 10:26:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] filesetup: do not ask O_RDWR for read-only workload
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     fio@vger.kernel.org, vincent.fu@samsung.com
References: <20230203123421.126720-1-joshi.k@samsung.com>
 <5B11C29F-19ED-4ADF-A900-F430608CC46C@kernel.dk>
 <b14eae2a-56f9-0063-42b0-50ca35961d1a@gmail.com>
 <dee97219-f0ce-bae7-94ef-c4e56073ff2e@kernel.dk>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <dee97219-f0ce-bae7-94ef-c4e56073ff2e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/3/23 09:14, Jens Axboe wrote:
> On 2/3/23 7:08?AM, Vincent Fu wrote:
>> On 2/3/23 07:46, Jens Axboe wrote:
>>> On Feb 3, 2023, at 5:35 AM, Kanchan Joshi <joshi.k@samsung.com> wrote:
>>>>
>>>> ?Use O_RDONLY flag when read is requested on char-type files.
>>>>
>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>> ---
>>>>
>>>> Before this patch: unexpected permission-denial for unprivileged-user.
>>>>
>>>> $ ls -l /dev/ng0n1
>>>> cr--r--r-- 1 root root 242, 0 Feb  3 16:30 /dev/ng0n1
>>>>
>>>> $ ./fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -bs=4k -numjobs=1
>>>> -size=4k -cmd_type=nvme -filename=/dev/ng0n1 -name=t
>>>> t: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
>>>> 4096B-4096B, ioengine=io_uring_cmd, iodepth=1
>>>> fio-3.33-71-g7d7a
>>>> Starting 1 process
>>>> fio: pid=131312, err=13/file:filesetup.c:805, func=open(/dev/ng0n1),
>>>> error=Permission denied
>>>>
>>>> filesetup.c | 5 +----
>>>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>>>
>>>> diff --git a/filesetup.c b/filesetup.c
>>>> index 1d3cc5ad..d77b8ba4 100644
>>>> --- a/filesetup.c
>>>> +++ b/filesetup.c
>>>> @@ -768,10 +768,7 @@ open_again:
>>>>          else
>>>>              from_hash = file_lookup_open(f, flags);
>>>>      } else if (td_read(td)) {
>>>> -        if (f->filetype == FIO_TYPE_CHAR && !read_only)
>>>> -            flags |= O_RDWR;
>>>> -        else
>>>> -            flags |= O_RDONLY;
>>>> +        flags |= O_RDONLY;
>>>
>>> This will break sg like interfaces, where a read is done by writing the command to the char device.
>>>
>>> ?
>>> Jens Axboe
>>>
>>
>> Kanchan, does it work if you run fio with the --readonly option?
> 
> I think we should just make it work. Conceptually, the patch is obviously
> fine, it just happens to break some oddball cases like sg/bsg. But maybe
> we just add a fio ioengine flag for that, like FIO_RO_NEEDS_RW_OPEN or
> something, where the engine can tell us if it needs a writeable open
> even or a read-only workload.
> 
> Then generic_file_open() can use O_RDONLY for td_read(), except if the
> engine has FIO_RO_NEEDS_RW_OPEN set.
> 

Kanchan, can you try the diff below? It's also available at 
https://github.com/vincentkfu/fio/tree/rwopen

Vincent

diff --git a/engines/sg.c b/engines/sg.c
index 24783374..0bb5be4a 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -1428,7 +1428,7 @@ static struct ioengine_ops ioengine = {
  	.open_file	= fio_sgio_open,
  	.close_file	= fio_sgio_close,
  	.get_file_size	= fio_sgio_get_file_size,
-	.flags		= FIO_SYNCIO | FIO_RAWIO,
+	.flags		= FIO_SYNCIO | FIO_RAWIO | FIO_RO_NEEDS_RW_OPEN,
  	.options	= options,
  	.option_struct_size	= sizeof(struct sg_options)
  };
diff --git a/filesetup.c b/filesetup.c
index 1d3cc5ad..cb7047c5 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -768,7 +768,7 @@ open_again:
  		else
  			from_hash = file_lookup_open(f, flags);
  	} else if (td_read(td)) {
-		if (f->filetype == FIO_TYPE_CHAR && !read_only)
+		if (td_ioengine_flagged(td, FIO_RO_NEEDS_RW_OPEN) && !read_only)
  			flags |= O_RDWR;
  		else
  			flags |= O_RDONLY;
diff --git a/ioengines.h b/ioengines.h
index d43540d0..2cb9743e 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -89,6 +89,8 @@ enum fio_ioengine_flags {
  			= 1 << 16,	/* async ioengine with commit function that sets 
issue_time */
  	FIO_SKIPPABLE_IOMEM_ALLOC
  			= 1 << 17,	/* skip iomem_alloc & iomem_free if job sets mem/iomem */
+	FIO_RO_NEEDS_RW_OPEN
+			= 1 << 18,	/* open files in rw mode even if we have a read job */
  };

  /*
-- 

