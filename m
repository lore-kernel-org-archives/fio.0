Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6669FC05027
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 15:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjBCPc7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 10:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjBCPc6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 10:32:58 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4420F21963
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 07:32:57 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so9168284pjq.0
        for <fio@vger.kernel.org>; Fri, 03 Feb 2023 07:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q8kbHDZzpDu3NUz+5DbH859nzB27YNcSbJWQfpP1BZg=;
        b=SC8rKSeUN6HDZEPvbRn2sz91SYlBxQPztxsH1rwfdQ0kAoN80Adh0IVWSJM8tMNr5l
         YmTkf9lPOR4dFLVMKOidpQs13XKS51u+EIlVzdfP4fmkiOsalUPtD8US6ph861aHSm3q
         gO7AUwxdqbBRI/l1hPwIZ2uMYtux6qZRZMy2EaQ1crXffj1gNdUC3jdK1WB4WswOIVEO
         YDWFRmIa+r2DR9UYcn5v+WsUN33EiXEFvyKKAw5THXS0KN4s989ReXHGBB0FcrCAqPfp
         4BNpK8yegqGnVJJiSl4PCXYCgwj6Jp+85uACfZ3tNou4UU6HvTY6V3CANPvZrTxMNBJE
         l0cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8kbHDZzpDu3NUz+5DbH859nzB27YNcSbJWQfpP1BZg=;
        b=x9aO5Z/HK9/1tX5k5ItkYnpLQDAwu0tqahfKzGuuK/GRv0n7YCldt2Dy1YcYgtCDlo
         wWOz6hLoQy3vpuPdSP8Z94yLLux1hS7tBBkq8CwlG3qJrL43jHK+kON7jqEyOH18ZmT5
         daIx6VDZLfHxmFjI2Vkib43CQuAuLkXeT8qVggZKwWRCz17CeRjW4VepPrXYkPZ/wJSM
         6rsitvgYx379pJAKIEsAcMVuId0xFOydJU6DLADiEsTLZ2NPb22pdXe9fHyfyK2rYBpf
         9C9NBRXbX0ZT6dKz+WQV1KEJnzSy3ji2Ei2amuJTNt7G85q28NdIah1dSavRIqGrf+QT
         pvrA==
X-Gm-Message-State: AO0yUKVYFO5jU9jlT5iVj1FlMBXE9t6BeTwkBTb5Jqddeu3NDMmGjABg
        UJU7bdF3Uaf2iG19EmL7mpH+nA==
X-Google-Smtp-Source: AK7set+G96QB3QpimT6y1YBEJ3g+CgV3saEKGU78MmmrS/i6kE7WULYKsP0h8vI8vVroSS+1hzvVrA==
X-Received: by 2002:a17:903:41d1:b0:196:82d5:1ec4 with SMTP id u17-20020a17090341d100b0019682d51ec4mr12659075ple.0.1675438376625;
        Fri, 03 Feb 2023 07:32:56 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g10-20020a1709026b4a00b001966eaf7365sm1759735plt.17.2023.02.03.07.32.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 07:32:56 -0800 (PST)
Message-ID: <beb7543b-bd4a-3c7c-35f9-2d6e2d6eebcd@kernel.dk>
Date:   Fri, 3 Feb 2023 08:32:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] filesetup: do not ask O_RDWR for read-only workload
Content-Language: en-US
To:     Vincent Fu <vincentfu@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Cc:     fio@vger.kernel.org, vincent.fu@samsung.com
References: <20230203123421.126720-1-joshi.k@samsung.com>
 <5B11C29F-19ED-4ADF-A900-F430608CC46C@kernel.dk>
 <b14eae2a-56f9-0063-42b0-50ca35961d1a@gmail.com>
 <dee97219-f0ce-bae7-94ef-c4e56073ff2e@kernel.dk>
 <c7ae8aa4-7c91-f892-b7fa-0d34ab4ea536@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c7ae8aa4-7c91-f892-b7fa-0d34ab4ea536@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/3/23 8:26?AM, Vincent Fu wrote:
> diff --git a/engines/sg.c b/engines/sg.c
> index 24783374..0bb5be4a 100644
> --- a/engines/sg.c
> +++ b/engines/sg.c
> @@ -1428,7 +1428,7 @@ static struct ioengine_ops ioengine = {
>      .open_file    = fio_sgio_open,
>      .close_file    = fio_sgio_close,
>      .get_file_size    = fio_sgio_get_file_size,
> -    .flags        = FIO_SYNCIO | FIO_RAWIO,
> +    .flags        = FIO_SYNCIO | FIO_RAWIO | FIO_RO_NEEDS_RW_OPEN,
>      .options    = options,
>      .option_struct_size    = sizeof(struct sg_options)
>  };
> diff --git a/filesetup.c b/filesetup.c
> index 1d3cc5ad..cb7047c5 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -768,7 +768,7 @@ open_again:
>          else
>              from_hash = file_lookup_open(f, flags);
>      } else if (td_read(td)) {
> -        if (f->filetype == FIO_TYPE_CHAR && !read_only)
> +        if (td_ioengine_flagged(td, FIO_RO_NEEDS_RW_OPEN) && !read_only)
>              flags |= O_RDWR;
>          else
>              flags |= O_RDONLY;
> diff --git a/ioengines.h b/ioengines.h
> index d43540d0..2cb9743e 100644
> --- a/ioengines.h
> +++ b/ioengines.h
> @@ -89,6 +89,8 @@ enum fio_ioengine_flags {
>              = 1 << 16,    /* async ioengine with commit function that sets issue_time */
>      FIO_SKIPPABLE_IOMEM_ALLOC
>              = 1 << 17,    /* skip iomem_alloc & iomem_free if job sets mem/iomem */
> +    FIO_RO_NEEDS_RW_OPEN
> +            = 1 << 18,    /* open files in rw mode even if we have a read job */
>  };
> 
>  /*

Looks good to me.

-- 
Jens Axboe

