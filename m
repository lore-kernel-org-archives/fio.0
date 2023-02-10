Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6C1C636CD
	for <fio@archiver.kernel.org>; Fri, 10 Feb 2023 15:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjBJPpv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Feb 2023 10:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBJPps (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Feb 2023 10:45:48 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6075FDA
        for <fio@vger.kernel.org>; Fri, 10 Feb 2023 07:45:47 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id g8so6123754qtq.13
        for <fio@vger.kernel.org>; Fri, 10 Feb 2023 07:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bNyHQ30uWBFZeAeNvvSYVqi0TAKd0baHqtKkjx24hGI=;
        b=cqA3ktyV4Cu5BRrorCXGWn7x2onjRc7C0NdNh8mznm1p/ggtdJdS8S8LXoXlc8nQoh
         KodfM1Y8q8o78ZtZkyMieW6M/x7k/XWiOIQeHEWRq5ZHEA3QQEkkK9von6G671eSgx3y
         Wep1rHuI7tTEZ7YrV6sB5JalTQaFIn3dEbYi7Z+4Ri4h6Y2R9yRap/eQ/LTEXN1wbmot
         I/Cp0YbINiLwzlxYFKwn0JH5Z0nACdxQ1EbX7kR+GDeSLy3n3iQMuaQffZ1vpdwS5fFu
         8KemxGv6aHLIvcwQhm8DlB1ujlBBRhMhXZ6Cim+YwoG+uosUYhQYhKCXRYJtCXgJInVm
         aPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bNyHQ30uWBFZeAeNvvSYVqi0TAKd0baHqtKkjx24hGI=;
        b=6L/B6JJ94suXu3tkhyHfa2wgE9E+jp7nTz+6GS57+o3YCfMHaXFteYMHQ1LfFIkDac
         v2TbI00UzQ3NVhD+1fg0L/yoX8xxdGrUzUUzZy/+9akwmuGACbtawycd6a6fgBG9aQl9
         OHK8e4EzO08HfnwuTPTXBYT56/E+7qT4NoLnW4MPZJlAiggfFaAwxJWks4oOCceHQdW4
         bpAigZTtu+bmtmVv3u0ihwUzn3SfRkuWBz9K5XeW8zp2s/CogVSlwnWHtnq5vp7rD70B
         mmHs4v3XqCFCJCREMjgICZznB5HS2TraQWfkgXfAeuWeP0EQspmpgTm3sT7FD86Wmpht
         Gorg==
X-Gm-Message-State: AO0yUKXSRehT/t1vc9uB/CvfXMCe8kWvNaYQH1SOgy17G2UWdS0fSi2+
        n2ICaGJWYpJ9ndQKSmhskDY=
X-Google-Smtp-Source: AK7set+YSWRBJZBGB6JZvD3hX9UorL5nb5jdqv+Xh8i6sVLOtZXm61ul3WHoMUaTKxrB1xdhN6MSVQ==
X-Received: by 2002:ac8:4e51:0:b0:3b9:b260:1e76 with SMTP id e17-20020ac84e51000000b003b9b2601e76mr27776713qtw.1.1676043946423;
        Fri, 10 Feb 2023 07:45:46 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id ew12-20020a05622a514c00b003b86a6449b8sm3592018qtb.85.2023.02.10.07.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 07:45:45 -0800 (PST)
Message-ID: <d20cabb7-4a5b-455d-de7c-b3301e1d1c5a@gmail.com>
Date:   Fri, 10 Feb 2023 10:45:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCHv2] fio: add fdp support for io_uring_cmd nvme engine
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org, axboe@kernel.dk
Cc:     its@irrelevant.dk, damien.lemoal@opensource.wdc.com,
        Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>
References: <20230209171236.1113887-1-kbusch@meta.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230209171236.1113887-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/9/23 12:12, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Add support for NVMe TP4146 Flexible Data Placemen, allowing placement
> identifiers in write commands. The user can enabled this with the new
> "fdp=1" parameter for fio's io_uring_cmd ioengine. By default, the fio
> jobs will cycle through all the namespace's available placement
> identifiers for write commands. The user can limit which placement
> identifiers can be used with additional parameter, "fdp_plis=<list,>",
> which can be used to separate write intensive jobs from less intensive
> ones.
> 
> Setting up your namespace for FDP is outside the scope of 'fio', so this
> assumes the namespace is already properly configured for the mode.
> 
> Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---

<snip>

> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index a9abd11d..4d1ee021 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -1262,6 +1262,28 @@ static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
>   	return fio_nvme_get_max_open_zones(td, f, max_open_zones);
>   }
>   
> +static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
> +				     struct fio_ruhs_info *fruhs_info)
> +{
> +	struct nvme_fdp_ruh_status *ruhs;
> +	int bytes, ret, i;
> +
> +	bytes = sizeof(*ruhs) + 1024 * sizeof(struct nvme_fdp_ruh_status_desc);
> +	ruhs = malloc(bytes);
> +	memset(ruhs, 0, bytes);

calloc?

<snip>

> diff --git a/thread_options.h b/thread_options.h
> index 74e7ea45..605eb259 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -386,6 +386,11 @@ struct thread_options {
>   	fio_fp64_t zrt;
>   	fio_fp64_t zrf;
>   
> +#define FIO_MAX_PLIS 16
> +	unsigned int fdp;
> +	unsigned int fdp_plis[FIO_MAX_PLIS];
> +	unsigned int fdp_nrpli;
> +
>   	unsigned int log_entries;
>   	unsigned int log_prio;
>   };
> @@ -698,6 +703,8 @@ struct thread_options_pack {
>   	uint32_t log_entries;
>   	uint32_t log_prio;
>   
> +	uint32_t fdp;
> +
>   	/*
>   	 * verify_pattern followed by buffer_pattern from the unpacked struct
>   	 */

struct thread_options_pack also needs fdp_plis[] and fdp_nrpli members. 
In addition to the cconv.c changes that Ankit mentioned FIO_SERVER_VER 
should also be bumped so that these options can be properly transmitted 
when fio is run in client/server mode.

Vincent
