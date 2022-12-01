Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21420C43217
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 17:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiLARL4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiLARLz (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 12:11:55 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D6EA8FFE
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 09:11:54 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id e15so1602914qts.1
        for <fio@vger.kernel.org>; Thu, 01 Dec 2022 09:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fN/9LdOidGr47Fwd9CEWOsUkCdcPOS9fivUlfUsQ62s=;
        b=SbZrWLMWQyN/UJ1u1jPuZLkvKluBcJUqr3QtGiLI/rWDTeFJFlmk1t9n89QyS91Tu2
         oMmdy+nvB6va8caBJBoNVtWm3AxDej/x7F2I43/a9LS+nRnI6dOVJX5R5VwG76SM0SVr
         uVJGYbQsbqXiiFYfjwOua30e5pMJLzIqzrezJfYo7WoxmuMdKSXrXtXNfivQWMixSxlQ
         w/POhShw0HlW2+8I69M1olmOqkfOo8ATCVFLbeZOct5p1CA6hKrUDc5IYUxSLl0+TEVj
         +zQVm5GJALz7sWR+tsKl33sj1kid6Fc5xLLd3HEumFvDlJuY52W3H2tuzWac/bWAF3kn
         wjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fN/9LdOidGr47Fwd9CEWOsUkCdcPOS9fivUlfUsQ62s=;
        b=REAKYoOSKq4JvWIIFwPTMVC3A2mPAaX7R7LztdMYtMX900gMWAuTXvuZ05DaXdMVzq
         5xl61eWlgBz4W9Kr8aYJOYO0xNSTY6a2KFrYTdR6W1ytVzzU38zcckcmqxyBhjmuEt7r
         kr+FyZR0rQY1/hE2JoEnKdHbzUTIqF4N4adNl6Ol/vI1+smDdQsTvSJ3OmlTy+z2q1bC
         sK+nJNv921Oa6Kz9WgAnabT520je7wc22svmNIg0dFGGbFhJZ1rAsspIUyDTPdTbfYFm
         icaN5E06c9BFG2va/rc6kNbLohNWx0G/jS6a7BQfZCgruUxndLr9KtZHADL/m3SxT0LI
         u+Jw==
X-Gm-Message-State: ANoB5pn4Wp7Hc/TNLwkmPSIVdbZW6NgehmE4wlD650y8oZKMYFG+0mk7
        uSjHBlCqpKU3FKWcXHYLtFynXPNvo1R7fQ==
X-Google-Smtp-Source: AA0mqf6YJj8ucK7k+0BVfmL0s4FoI5EaV0A5rdq2kdghsu1RnRYoO00zt7O2I6L1PswxTGjVZA8eig==
X-Received: by 2002:ac8:67c5:0:b0:3a4:f665:7791 with SMTP id r5-20020ac867c5000000b003a4f6657791mr63409975qtp.380.1669914713597;
        Thu, 01 Dec 2022 09:11:53 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id s18-20020a05620a29d200b006f9ddaaf01esm3919899qkp.102.2022.12.01.09.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 09:11:53 -0800 (PST)
Message-ID: <2fbfff28-30a4-97bd-fd2b-e48bb8b837d4@gmail.com>
Date:   Thu, 1 Dec 2022 12:11:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 05/10] engines/libblkio: Add option libblkio_vectored
Content-Language: en-US
To:     Alberto Faria <afaria@redhat.com>, fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
 <20221121182902.373491-6-afaria@redhat.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221121182902.373491-6-afaria@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/21/22 13:28, Alberto Faria wrote:
> When enabled, read and write requests are submitted as vectored requests
> using blkioq_{readv,writev}(), instead of using blkioq_{read,write}().
> 
> Signed-off-by: Alberto Faria <afaria@redhat.com>
> ---
>   HOWTO.rst          |  4 ++++
>   engines/libblkio.c | 46 +++++++++++++++++++++++++++++++++++++++++-----
>   fio.1              |  3 +++
>   3 files changed, 48 insertions(+), 5 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index cdea3258..b9c7c8df 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2875,6 +2875,10 @@ with the caveat that when used on the command line, they must come after the
>   	set after the engine sets any other properties, so those can be
>   	overriden.
>   
> +.. option:: libblkio_vectored=bool : [libblkio]

See my response to the hipri patch regarding the difference between 
booleans and FIO_OPT_STR_SET. I don't have strong feelings regarding 
whether this should be a boolean or FIO_OPT_STR_SET but if the type 
listed in the HOWTO and manpage is boolean then the type in the options 
struct should be FIO_OPT_BOOL. No type should be listed when it's 
FIO_OPT_STR_SET.

> +
> +	Submit vectored read and write requests. Default is 0.
> +
>   I/O depth
>   ~~~~~~~~~
>   
> diff --git a/engines/libblkio.c b/engines/libblkio.c
> index d2ade3f1..dcf701ad 100644
> --- a/engines/libblkio.c
> +++ b/engines/libblkio.c
> @@ -28,6 +28,7 @@ struct fio_blkio_options {
>   	char *pre_start_props;
>   
>   	unsigned int hipri;
> +	unsigned int vectored;
>   };
>   
>   static struct fio_option options[] = {
> @@ -68,6 +69,15 @@ static struct fio_option options[] = {
>   		.category = FIO_OPT_C_ENGINE,
>   		.group	= FIO_OPT_G_LIBBLKIO,
>   	},
> +	{
> +		.name	= "libblkio_vectored",
> +		.lname	= "Use blkioq_{readv,writev}()",
> +		.type	= FIO_OPT_STR_SET,
> +		.off1	= offsetof(struct fio_blkio_options, vectored),
> +		.help	= "Use blkioq_{readv,writev}() instead of blkioq_{read,write}()",
> +		.category = FIO_OPT_C_ENGINE,
> +		.group	= FIO_OPT_G_LIBBLKIO,
> +	},
>   
>   	{
>   		.name = NULL,
> @@ -251,6 +261,7 @@ struct fio_blkio_data {
>   	bool has_mem_region; /* whether mem_region is valid */
>   	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
>   
> +	struct iovec *iovecs; /* for vectored requests */
>   	struct blkio_completion *completions;
>   };
>   
> @@ -267,8 +278,9 @@ static int fio_blkio_init(struct thread_data *td)
>   		goto err_free;
>   	}
>   
> +	data->iovecs = calloc(td->o.iodepth, sizeof(data->iovecs[0]));
>   	data->completions = calloc(td->o.iodepth, sizeof(data->completions[0]));
> -	if (!data->completions) {
> +	if (!data->iovecs || !data->completions) {
>   		log_err("fio: calloc() failed\n");
>   		goto err_free;
>   	}
> @@ -310,6 +322,7 @@ err_blkio_destroy:
>   	blkio_destroy(&data->b);
>   err_free:
>   	free(data->completions);
> +	free(data->iovecs);
>   	free(data);
>   	return 1;
>   }
> @@ -362,6 +375,7 @@ static void fio_blkio_cleanup(struct thread_data *td)
>   	if (data) {
>   		blkio_destroy(&data->b);
>   		free(data->completions);
> +		free(data->iovecs);
>   		free(data);
>   	}
>   }
> @@ -432,19 +446,41 @@ static int fio_blkio_open_file(struct thread_data *td, struct fio_file *f)
>   static enum fio_q_status fio_blkio_queue(struct thread_data *td,
>   					 struct io_u *io_u)
>   {
> +	const struct fio_blkio_options *options = td->eo;
>   	struct fio_blkio_data *data = td->io_ops_data;
>   
>   	fio_ro_check(td, io_u);
>   
>   	switch (io_u->ddir) {
>   		case DDIR_READ:
> -			blkioq_read(data->q, io_u->offset, io_u->xfer_buf,
> -				    (size_t)io_u->xfer_buflen, io_u, 0);
> +			if (options->vectored) {
> +				struct iovec *iov = &data->iovecs[io_u->index];
> +				iov->iov_base = io_u->xfer_buf;
> +				iov->iov_len = (size_t)io_u->xfer_buflen;
> +
> +				blkioq_readv(data->q, io_u->offset, iov, 1,
> +					     io_u, 0);
> +			} else {
> +				blkioq_read(data->q, io_u->offset,
> +					    io_u->xfer_buf,
> +					    (size_t)io_u->xfer_buflen, io_u, 0);
> +			}
>   			break;
>   
>   		case DDIR_WRITE:
> -			blkioq_write(data->q, io_u->offset, io_u->xfer_buf,
> -				     (size_t)io_u->xfer_buflen, io_u, 0);
> +			if (options->vectored) {
> +				struct iovec *iov = &data->iovecs[io_u->index];
> +				iov->iov_base = io_u->xfer_buf;
> +				iov->iov_len = (size_t)io_u->xfer_buflen;
> +
> +				blkioq_writev(data->q, io_u->offset, iov, 1,
> +					      io_u, 0);
> +			} else {
> +				blkioq_write(data->q, io_u->offset,
> +					     io_u->xfer_buf,
> +					     (size_t)io_u->xfer_buflen, io_u,
> +					     0);
> +			}
>   			break;
>   
>   		case DDIR_TRIM:
> diff --git a/fio.1 b/fio.1
> index 7c1b315a..a403b415 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2623,6 +2623,9 @@ the engine sets any other properties, so those can be overriden.
>   .TP
>   .BI (libblkio)hipri \fR=\fPbool
>   Use poll queues.
> +.TP
> +.BI (libblkio)libblkio_vectored \fR=\fPbool
> +Submit vectored read and write requests. Default is 0.
>   .SS "I/O depth"
>   .TP
>   .BI iodepth \fR=\fPint

