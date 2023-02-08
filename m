Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DAEC05027
	for <fio@archiver.kernel.org>; Wed,  8 Feb 2023 22:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjBHW5S (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Feb 2023 17:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjBHW5R (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Feb 2023 17:57:17 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC1A15CB5
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 14:57:16 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id s89-20020a17090a2f6200b0023125ebb4b1so440862pjd.3
        for <fio@vger.kernel.org>; Wed, 08 Feb 2023 14:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VW+7Mo4MoPFC1/V31f6J0zTFW4TuT0cPHj7AkA9c200=;
        b=eA4sgI6cjElP6VU+3arEz7ODAdmRq9Br2zeL1PGrfW9OX4q2Qid+8rSyY15pMrVRJs
         ioBXrpTJvyinBhRHgIIcpqOcImcXDtL4Q7MdmMDcXFt6Bq0lP8AilVIiI75wQQ4T1oD3
         ixEZY7o8gPOlOlumkBUjkXI3zq13UeWvozB4czSX4olPuIn4N3M96ZYG2BYM15m1oFGR
         TIPtrFGm07q7HaA7smJOyHA7RAMrNB5RStvz6kLYFXAb9BMSdvxZi9wU7+XN5oJ/ExXH
         MP/fQ01EGuB6Jw+oX2d1Nyz06GjZk1N7lWAZjrwwKJDYBS491xn5Lxz5zEdSxY/1LI0F
         ndjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VW+7Mo4MoPFC1/V31f6J0zTFW4TuT0cPHj7AkA9c200=;
        b=E8I81tgehlDHjNt1LR6ff3B92Ngn4KUpG2p2wXo7eYNeNICMS7yAWSvsrpjuxUDhGA
         jcgEEFzZnt7se5PwEdrRdEIEAzzAJDPy2oAjYbo+x81s89n4xl0HaNOm/JwRrkqro2uN
         pMFa7CJ9ORG/kLpYfoHZQ6te48Dx3UlXJart/Dlts5XMQvbu+fPHIaedDK4Aq8CNG7Xb
         aoLsHRUqIkMws90h2tBQynsp0L2BjdG7pkriwRQbpjth0389Db/mdtqBGQubwLQ1QMnL
         YWkP1iW1uJiQVAH9hfYBYo9BOpoUv+wSZmr+ig0zulYMKxARL/r3oVibyZWr2l8AeEdQ
         53gg==
X-Gm-Message-State: AO0yUKV8qFCrlu1hdYf8zb9KOoAdK2CZwet4iNYjT8bFmZQ23cLkOoDa
        TdIXFGcTKTU6y99TGYR6NJCF4g==
X-Google-Smtp-Source: AK7set8zoHzJp4MJKezEV6zFnHObutdU0ltiXByHllBWe6jWEWZL2L8Xx6eRhEKDZkG8LIlZANOQ8A==
X-Received: by 2002:a17:903:32c6:b0:196:1cc3:74fc with SMTP id i6-20020a17090332c600b001961cc374fcmr9729857plr.4.1675897036313;
        Wed, 08 Feb 2023 14:57:16 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a6ac100b00232cc61e16bsm134681pjm.35.2023.02.08.14.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 14:57:15 -0800 (PST)
Message-ID: <dfeb3707-42e6-c20b-2c6c-cc0d408b7ed7@kernel.dk>
Date:   Wed, 8 Feb 2023 15:57:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] fio: add nvme fdp support for io_uring_cmd engine
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org
Cc:     its@irrelevant.dk, Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>
References: <20230208222023.895024-1-kbusch@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230208222023.895024-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/8/23 3:20?PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> NVMe TP4146 creates a new feature called Flexible Data Placement. This
> feature allows a host to tell the device how to group write data through
> the use of "Placement Identifiers" in write commands.
> 
> Add support for using placement identifiers in write commands. The user
> can enabled this with the new "fdp=1" parameter for fio's io_uring_cmd
> ioengine. By default, the fio jobs will cycle through all the namespace's
> available placement identifiers for write commands. The user can limit
> which placement identifiers can be used with additional parameter,
> "fdp_plis=<list,>", which can be used to separate write intensive jobs
> from less intenstive ones.
> 
> Setting up your namespace for FDP is outside the scope of 'fio', so this
> assumes the namespace is already properly configured for the mode.

Looks pretty clean to me, but the fdp options need documenting in HOWTO
and the man page. Outside of that, spotted:

> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index a9abd11d..644b279f 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -1262,6 +1262,34 @@ static int fio_ioring_cmd_get_max_open_zones(struct thread_data *td,
>  	return fio_nvme_get_max_open_zones(td, f, max_open_zones);
>  }
>  
> +static int fio_ioring_cmd_fdp_support(struct thread_data *td, struct fio_file *f,
> +                                  bool *support)
> +{
> +	return fio_nvme_is_fdp(td, f, support);
> +}
> +
> +static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
> +                                 struct fio_ruhs_info *fruhs_info)
> +{
> +	struct nvme_fdp_ruh_status *ruhs;
> +	int bytes, ret, i;
> +
> +	bytes = sizeof(*ruhs) + 1024 * sizeof(struct nvme_fdp_ruh_status_desc);
> +	ruhs = malloc(bytes);
> +	memset(ruhs, 0, bytes);
> +
> +	ret = fio_nvme_iomgmt_ruhs(td, f, ruhs, bytes);
> +	if (ret)
> +		goto free;
> +
> +        fruhs_info->nr_ruhs = le16_to_cpu(ruhs->nruhsd);
> +        for (i = 0; i < fruhs_info->nr_ruhs; i++)
> +                fruhs_info->plis[i] = le16_to_cpu(ruhs->ruhss[i].pid);

Tabs vs spaces here.

> +free:
> +	free(ruhs);
> +	return ret;
> +}
> +
>  static struct ioengine_ops ioengine_uring = {
>  	.name			= "io_uring",
>  	.version		= FIO_IOOPS_VERSION,
> @@ -1307,6 +1335,9 @@ static struct ioengine_ops ioengine_uring_cmd = {
>  	.get_max_open_zones	= fio_ioring_cmd_get_max_open_zones,
>  	.options		= options,
>  	.option_struct_size	= sizeof(struct ioring_options),
> +
> +        .fdp_support		= fio_ioring_cmd_fdp_support,
> +        .fetch_ruhs		= fio_ioring_cmd_fetch_ruhs,
>  };

Ditto

In a bunch more spots too.

-- 
Jens Axboe

