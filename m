Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C094EB64DD
	for <fio@archiver.kernel.org>; Thu, 20 Jul 2023 19:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjGTTgU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Jul 2023 15:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjGTTgT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Jul 2023 15:36:19 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211E11995
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 12:36:17 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-785ccd731a7so15362639f.0
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 12:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689881776; x=1690486576;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fz/iMlsSqQrQQZv2byZjn13uoi8CVAUvkiOqYB5maRk=;
        b=gP+BP7JlDO/Pyc4Spk+7d2IxAD9mW7AZphq8mfC5fdQX5JYuuWVbYO/YGoBZT6AqQ9
         ejSVYWvj382CjidaXMmYB8tCYgrJ6L8aBMbRy4RtQ8Iz4fJF9xgF4jKjgNSmmLbPRsX9
         pVI+E3xETVqPN49q5l8MXbX03TKHbUgRGjRBYXPyzvQgzBg26Py00PVfTm1P03wOCldh
         mE3h6wJjmGujT5Q7WgDsMrvHRv7Awluz6z1fOut/Mi+tVoJnfShOarb6XN1NrY+N0eSA
         RTT5SHnEBx572/GB1M+DCOaQMKsuegvWobLYa6gDncd4cmrBQzQxBwGMTLa7yNSl9Ny3
         iwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689881776; x=1690486576;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fz/iMlsSqQrQQZv2byZjn13uoi8CVAUvkiOqYB5maRk=;
        b=BP09/rhNTEsUwaEKN1hlAaKxHsJmgBeupDLf3hbIDk6wmca3FQOIeFhlO3E4BlgpXs
         sv2FZNl1KhaB+LPSsmU6qji6M2lR/LpsUJBKiT7lhnRiy8EeY7VdEfSIAAsinkG16FmT
         l6zGa0WdrjGEIjo8pxLF3ve02pW6zja9aJpkPv+6WTosD6aZD3xHw42lydIdxa1TitRh
         YcbudME9qs/SVSP3CCjaXS9Lm19pQUVJ82Af3IxAk+p/DYMZwfBy44CF6WyGFoLXNRIO
         y66GIbljBJZGAGay4FNA+zOQHBRBl31OkrOXnh5tWK7UZ4fu5UA1Qi+GL2QwiLf1dlop
         2H0g==
X-Gm-Message-State: ABy/qLbEjsMQQ3IoqoCfONXMqTvtydF3FFEA/6+GTODO1jkqZP7lP/lc
        Oo8YWaktZWIoUK2Tcb7LSCvo/g==
X-Google-Smtp-Source: APBJJlFB/Y7rxQEGSveM8B0mgQgaDOSgh16trfWIwxLGampLB41295EIaqj1dEsN9+87RXx/zUGvLA==
X-Received: by 2002:a05:6602:3423:b0:780:d65c:d78f with SMTP id n35-20020a056602342300b00780d65cd78fmr4847221ioz.2.1689881776469;
        Thu, 20 Jul 2023 12:36:16 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u2-20020a02cb82000000b0042bb3e62108sm534112jap.4.2023.07.20.12.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 12:36:15 -0700 (PDT)
Message-ID: <7bf0279a-0d54-03ab-15a0-84ae1b89e62e@kernel.dk>
Date:   Thu, 20 Jul 2023 13:36:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 4/5] cmdprio: Add support for per I/O priority hint
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, fio@vger.kernel.org,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720013114.28158-1-dlemoal@kernel.org>
 <20230720013114.28158-5-dlemoal@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230720013114.28158-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/19/23 7:31?PM, Damien Le Moal wrote:
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index f30a3c00..d55af6bc 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -157,6 +157,21 @@ static struct fio_option options[] = {
>  		.category = FIO_OPT_C_ENGINE,
>  		.group	= FIO_OPT_G_IOURING,
>  	},
> +	{
> +		.name	= "cmdprio_hint",
> +		.lname	= "Asynchronous I/O priority hint",
> +		.type	= FIO_OPT_INT,
> +		.off1	= offsetof(struct ioring_options,
> +				   cmdprio_options.hint[DDIR_READ]),
> +		.off2	= offsetof(struct ioring_options,
> +				   cmdprio_options.hint[DDIR_WRITE]),
> +		.help	= "Set asynchronous IO priority hint",
> +		.minval	= IOPRIO_MIN_PRIO_HINT,
> +		.maxval	= IOPRIO_MAX_PRIO_HINT,
> +		.interval = 1,
> +		.category = FIO_OPT_C_ENGINE,
> +		.group	= FIO_OPT_G_IOURING,
> +	},
>  	{
>  		.name	= "cmdprio",
>  		.lname	= "Asynchronous I/O priority level",
> @@ -195,6 +210,12 @@ static struct fio_option options[] = {
>  		.type	= FIO_OPT_UNSUPPORTED,
>  		.help	= "Your platform does not support I/O priority classes",
>  	},
> +	{
> +		.name	= "cmdprio_hint",
> +		.lname	= "Asynchronous I/O priority hint",
> +		.type	= FIO_OPT_UNSUPPORTED,
> +		.help	= "Your platform does not support I/O priority classes",
> +	},
>  	{
>  		.name	= "cmdprio",
>  		.lname	= "Asynchronous I/O priority level",

Since neither this nor libaio actually do anything with these values,
why isn't this just a generic option? You could flag the two engines
where it actually works with an engine flag, and check if it's set and
we don't have that flag and error out in the generic code.

-- 
Jens Axboe

