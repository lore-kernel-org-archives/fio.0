Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5C9C433FE
	for <fio@archiver.kernel.org>; Tue, 15 Nov 2022 20:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiKOU1E (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKOU1D (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Nov 2022 15:27:03 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E988193D6
        for <fio@vger.kernel.org>; Tue, 15 Nov 2022 12:27:02 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id k4so10315921qkj.8
        for <fio@vger.kernel.org>; Tue, 15 Nov 2022 12:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q7KQhAYGLKtLrbHg4dNMEtKvgubHrJzUHe6H+7vxpQs=;
        b=Z2ko5pQ6Rj1OGOyO+eHj99Q0abEiyD9aG7hJIpQjdSgyO3N4URjwwJI5lRTwOrJw05
         uTVjR0qeA+GgXKtJ2sA+1wnQ8Cc4q3V/twHiF1XuVFKXRw4Sy8kmlbT1XQEmiUXYb9WM
         hx0jFEzuP63sBpSxsgkoLuVdtNb1ihIpX+N5yBinLxxGVk9YhCg2dRe+r6+msRvxIzC9
         mVGV+ZafVlY2pZ2Abhb6FfCc5LMhXKkmD0I6wJgglvKT29q+3xJVN+nBqL6gt57vSGtP
         WYNOEx5/UEKMZ/jJKCXkihE4m8olyBDrOq/nJGXPWgms30U8z/zXJeh9twNoGs7MDxKc
         957Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7KQhAYGLKtLrbHg4dNMEtKvgubHrJzUHe6H+7vxpQs=;
        b=SBlrZQ80+VQPlfcUMFxVnyvZK56kxmx0GQlNWrAq6kAWHa5mpu/YzKy6AAb4Ca7Oj2
         jKXnvb3K1rVC+TgG2OSJsBhywAqGXhVgZjWW9qaPnZcDE4GDxZ+V8PKAJU49jT38Yfa+
         z2QloK4qMvoCOik7CJ7uCw2nbJQa2Sd1CoTZErk/jpYwKK0Aj96ivXjWqErPZjk5ESr2
         +ZzKWv6/7o53R2zLrJ8cZT5se1WpsoEXxh0XqOPJ7yLaubL4VXNP14AuUqOnDt+Zj+di
         q7IY3NsIZHQC/LZxn+PVk/paLUjED0pH2AlsXTLeISsb3dbGAlIMPOErv8CA8SDS8zR0
         krxw==
X-Gm-Message-State: ANoB5pkpOTspHgNnzRUYslMWEe4jJ5FCTVrlqioIxHb0tSAeOQy2Tp9Y
        Vh3oduMbUQTXZq7u1vefP06fS7iOAy4=
X-Google-Smtp-Source: AA0mqf5uVdfervKBPAFn+5UwrII/LUp8oZZNmDEPDGfMHrdIomB6BLCH3TgzAju8fwLvgHX99LrYCQ==
X-Received: by 2002:a05:620a:1d4e:b0:6fa:b06:bd82 with SMTP id dm14-20020a05620a1d4e00b006fa0b06bd82mr17181865qkb.10.1668544021607;
        Tue, 15 Nov 2022 12:27:01 -0800 (PST)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id t8-20020a37ea08000000b006fa313bf185sm8880143qkj.8.2022.11.15.12.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 12:27:01 -0800 (PST)
Message-ID: <6a4ba961-4c76-e868-2dce-dac29736c35c@gmail.com>
Date:   Tue, 15 Nov 2022 15:27:00 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/4] cconv: Support pattern buffers of arbitrary size
To:     Logan Gunthorpe <logang@deltatee.com>, fio@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logan.gunthorpe@eideticom.com>
References: <20221026194019.32776-1-logang@deltatee.com>
 <20221026194019.32776-2-logang@deltatee.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221026194019.32776-2-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/26/22 15:40, Logan Gunthorpe wrote:
> From: Logan Gunthorpe <logan.gunthorpe@eideticom.com>
> 
> Change the thread_options_pack structure to support pattern buffers
> of arbitrary size by using a flexible array at the end of the the
> structure to store both the verify_pattern and the buffer_pattern
> in that order.
> 
> In this way, only the actual bytes of each pattern will be sent over
> the wire and patterns of an arbitrary size can be used with the packed
> structure.
> 
> In order to determine the required size of the structure the function
> thread_options_pack_size() is introduced which returns the total
> number of bytes required for a given thread_options instance.
> 
> The two callsites of convert_thread_options_to_net() are then converted
> to dynamically allocate a pdu of the appropriate size and the
> two callsites of convert_thread_options_to_cpu() are modified to
> take the size of the received data to prevent buffer overruns.
> 
> Also add specific testing of this feature in fio_test_cconv().
> 
> Seeing this changes the client/server protocol, the FIO_SERVER_VER
> is bumped.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---

<snip>

> diff --git a/thread_options.h b/thread_options.h
> index 634070af00ec..8a1340f23e97 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -464,7 +464,6 @@ struct thread_options_pack {
>   	uint32_t do_verify;
>   	uint32_t verify_interval;
>   	uint32_t verify_offset;
> -	uint8_t verify_pattern[MAX_PATTERN_SIZE];
>   	uint32_t verify_pattern_bytes;
>   	uint32_t verify_fatal;
>   	uint32_t verify_dump;
> @@ -572,7 +571,6 @@ struct thread_options_pack {
>   	uint32_t zero_buffers;
>   	uint32_t refill_buffers;
>   	uint32_t scramble_buffers;
> -	uint8_t buffer_pattern[MAX_PATTERN_SIZE];
>   	uint32_t buffer_pattern_bytes;
>   	uint32_t compress_percentage;
>   	uint32_t compress_chunk;
> @@ -699,9 +697,13 @@ struct thread_options_pack {
>   
>   	uint32_t log_entries;
>   	uint32_t log_prio;
> +
> +	uint8_t patterns[];

Since there is typically a 1:1 correspondence between the members of 
this struct and the unpacked version, I would add a comment here noting 
that patterns[] includes the contents of verify_pattern and 
buffer_pattern from the unpacked struct.

