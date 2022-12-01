Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3BCC4321E
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 17:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiLARCB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiLARCA (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 12:02:00 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E9AA555A
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 09:01:59 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id jr1so1539248qtb.7
        for <fio@vger.kernel.org>; Thu, 01 Dec 2022 09:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fXSbYJNJ6/6fotru4b//cSDcH5iMHawKXO34ZkZiACI=;
        b=YYitOuuyX4DfkXTMACTJjTSFNT2hYJVmBB41XSFYBoXS+sGYXRK3/72zzkZYhC/F+Y
         XgfIKpZ+simfOCtd25YrrvhpMWzG17AN6vNRtbcAxHZGFYOJA68dTl6db9PJVWGernYW
         ItSM6Kr5t3reMo6mzDGLqYXSSxxkeNle0RIQVYQJfPnH32HkWeMoNBo+uD/L5ArEjd/0
         9eG6HDBwJO5WRlEM5i3YQTDAxR10LIfpnkxGnaXGrDn4bHI3UNLwku2lURTC9xU/OjA0
         d2myH3KhLnARLwYN5IZZMJtr2ZPQRJXWDjj3pblAUmxtJJ95U2tRbqmRaQ5M3SC9V/t7
         Ed1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fXSbYJNJ6/6fotru4b//cSDcH5iMHawKXO34ZkZiACI=;
        b=19INbEkk9X594A2f37FhsRZbbQs78h2PjHba5l+rSZeVqnymkJnIGhtuKDj61u/Fdf
         MxJS8uV+lW0sj/oZqLP0Kx00YYWwhhn/lXEE0kAFV0IHMBpwrR25T4peLyNTvDAjGW2W
         LDBZmFQ2P0dVMyz9OUovRNIJrWKdjZRo3ZbEyiDqosHBm2MGYiuTELxW8NN35eArOoPj
         fQfXTINjiPUWpNx7878IZM+OW/wRPsIbDT8hGn7wlguRmvEFRuCZ6MXSJq0lkedAYEmo
         LAPr3nCF4ulQZogq17VKAQOr8Gb/fyUfHtmmyoeRMbuPLh6TUdVaT1905A6RvWCZBQT+
         X/ww==
X-Gm-Message-State: ANoB5plZI0PdlbpijRTYgagAEQsasHJwYwAJXNx8gn5soAnFc8GpmJ1U
        4YyhdHdocXBAfVSWXSDYZ/o=
X-Google-Smtp-Source: AA0mqf6PWv2ix0J0jCkPe4lIi5I9QDC2ol63oIuYhbjNuGHdFq7Bu8zT+Za41XJtgvGR3F5DjyLZoQ==
X-Received: by 2002:ac8:66d6:0:b0:3a5:f871:572c with SMTP id m22-20020ac866d6000000b003a5f871572cmr48348838qtp.230.1669914117966;
        Thu, 01 Dec 2022 09:01:57 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id y14-20020a37f60e000000b006fbaf9c1b70sm3548281qkj.133.2022.12.01.09.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 09:01:57 -0800 (PST)
Message-ID: <89ebb472-bcdc-5c35-8ab7-065c0b984130@gmail.com>
Date:   Thu, 1 Dec 2022 12:01:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 04/10] engines/libblkio: Add support for poll queues
Content-Language: en-US
To:     Alberto Faria <afaria@redhat.com>, fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
 <20221121182902.373491-5-afaria@redhat.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221121182902.373491-5-afaria@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/21/22 13:28, Alberto Faria wrote:
> Configure a poll queue instead of a "regular" queue when option hipri is
> set.
> 
> Signed-off-by: Alberto Faria <afaria@redhat.com>
> ---
>   HOWTO.rst          |  4 ++++
>   engines/libblkio.c | 26 ++++++++++++++++++++++++--
>   fio.1              |  3 +++
>   3 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index fb27d3d3..cdea3258 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2330,6 +2330,10 @@ with the caveat that when used on the command line, they must come after the
>           by the application. The benefits are more efficient IO for high IOPS
>           scenarios, and lower latencies for low queue depth IO.
>   
> +   [libblkio]
> +
> +	Use poll queues.
> +
>      [pvsync2]
>   
>   	Set RWF_HIPRI on I/O, indicating to the kernel that it's of higher priority
> diff --git a/engines/libblkio.c b/engines/libblkio.c
> index 54fd9ff6..d2ade3f1 100644
> --- a/engines/libblkio.c
> +++ b/engines/libblkio.c
> @@ -26,6 +26,8 @@ struct fio_blkio_options {
>   	char *driver;
>   	char *pre_connect_props;
>   	char *pre_start_props;
> +
> +	unsigned int hipri;
>   };
>   
>   static struct fio_option options[] = {
> @@ -57,6 +59,16 @@ static struct fio_option options[] = {
>   		.group	= FIO_OPT_G_LIBBLKIO,
>   	},
>   
> +	{
> +		.name	= "hipri",
> +		.lname	= "Use poll queues",
> +		.type	= FIO_OPT_STR_SET,
> +		.off1	= offsetof(struct fio_blkio_options, hipri),
> +		.help	= "Use poll queues",
> +		.category = FIO_OPT_C_ENGINE,
> +		.group	= FIO_OPT_G_LIBBLKIO,
> +	},
> +

Some of these elements have blank lines before or after the { } and 
others do not. For consistency I would eliminate the blank lines before 
and after the { and }.

>   	{
>   		.name = NULL,
>   	},
> @@ -244,6 +256,7 @@ struct fio_blkio_data {
>   
>   static int fio_blkio_init(struct thread_data *td)
>   {
> +	const struct fio_blkio_options *options = td->eo;
>   	struct fio_blkio_data *data;
>   
>   	/* allocate per-thread data struct */
> @@ -265,7 +278,13 @@ static int fio_blkio_init(struct thread_data *td)
>   	if (fio_blkio_create_and_connect(td, &data->b) != 0)
>   		goto err_free;
>   
> -	if (blkio_set_int(data->b, "num-queues", 1) != 0) {
> +	if (blkio_set_int(data->b, "num-queues", options->hipri ? 0 : 1) != 0) {
> +		fio_blkio_log_err(blkio_set_int);
> +		goto err_blkio_destroy;
> +	}
> +
> +	if (blkio_set_int(data->b, "num-poll-queues",
> +			  options->hipri ? 1 : 0) != 0) {
>   		fio_blkio_log_err(blkio_set_int);
>   		goto err_blkio_destroy;
>   	}
> @@ -277,7 +296,10 @@ static int fio_blkio_init(struct thread_data *td)
>   
>   	/* get queue */
>   
> -	data->q = blkio_get_queue(data->b, 0);
> +	if (options->hipri)
> +		data->q = blkio_get_poll_queue(data->b, 0);
> +	else
> +		data->q = blkio_get_queue(data->b, 0);
>   
>   	/* Set data only here so cleanup() does nothing if init() fails. */
>   	td->io_ops_data = data;
> diff --git a/fio.1 b/fio.1
> index 12eeb013..7c1b315a 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2620,6 +2620,9 @@ A colon-separated list of libblkio properties to be set after connecting but
>   before starting the \fBstruct blkio\fR. Each property must have the format
>   \fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are set after
>   the engine sets any other properties, so those can be overriden.
> +.TP
> +.BI (libblkio)hipri \fR=\fPbool

The type for hipri is FIO_OPT_STR_SET which is different from a boolean. 
If it were a boolean fio would accept only hipri=0 or hipri=1. For 
FIO_OPT_STR_SET fio accepts hipri=<any number>, or just hipri with no 
value (same meaning as hipri=1), with 0 representing false.

For FIO_OPT_STR_SET options (e.g., thread, time_based) the convention in 
the man page is to not specify a type.
