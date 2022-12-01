Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84699C43217
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 17:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiLARVm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLARVl (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 12:21:41 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80A7AE4D0
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 09:21:40 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id fz10so1647777qtb.3
        for <fio@vger.kernel.org>; Thu, 01 Dec 2022 09:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7+20u6/5zHAehlWeXkPUFsWSKGkr8Macr65NpnXe6m0=;
        b=R4iNFFB1N4GOB8IThfnrwOUUd4pRWNsn8aIvIFdh4PvdacB1VKbgTKPMja8OCbtYB0
         s58bkL+jvIHc2DFlExLVtcA5twwNJbeRV1rfIyIdTt3p2VaTw9Df/sNfnwqEbA9CYE3O
         ur6QESLDmN80SZEHfPcuwVX/7VRVW2REblqXZp7jbSIi6qmqZJlpVD98WVpK18vIg8OK
         5Sq84ADBmcEwnwcYICD38uq/v368zT+SRdCS6xZ/LUUN3dnh9E4iROBPJbC68qTmal2g
         iXwtn6cFGPz7hnL7f6z8P0lM2otuj2/8usHc31zkAWorgBFpA8QxUFejCp8/FzdxFQAP
         8dYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7+20u6/5zHAehlWeXkPUFsWSKGkr8Macr65NpnXe6m0=;
        b=JCSAtF2Kh2S+v0x5CPjDpfrjc5FvbevdW8hGADKpRSe2F0X16tqutM/rQ/SbSvodsZ
         sQNdShkSJQQEh3+aZiws1TITGsf4WDPu11gh9oVQKcxSQHgGzZUo28V+43xDoYjx7VLu
         YC3u4UMFyiuInbyfkSDPoB/a1x82UdkutPbkXtE+l9W/wF4qmBnWJXegaFHL9O3Vvb2e
         YFbCqR4MMLATtJSG1g3RFcvV8JReWzFppTvRxJkJ3Xeb0AYllJrZ5IEi9eDMgfEOdfIr
         TbfKD5YBrsaD+pNxiKnvO1y3w5/MNrPZh6S/HyJEYqYOdfgdLWt8NjuplZDulYNq5Tn9
         I1PA==
X-Gm-Message-State: ANoB5pkGddeyV+Q+Z3tkYiEV7GcTXCM/0d+fsCyGzStdPqs5/LIqTDbz
        17ALIjmOUVeGJWH3CVXIadA/c6yrTxxTxQ==
X-Google-Smtp-Source: AA0mqf6jyyN+hgISlR9InzNzjuULEQ6jsBGfpDPdeoMGJRWb+boAO3K0ViyYqpzOk9RN1vnpf3txRw==
X-Received: by 2002:a05:620a:e1c:b0:6fb:a5cc:208a with SMTP id y28-20020a05620a0e1c00b006fba5cc208amr43556097qkm.231.1669915299641;
        Thu, 01 Dec 2022 09:21:39 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id g8-20020a05620a40c800b006f3e6933bacsm549088qko.113.2022.12.01.09.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 09:21:39 -0800 (PST)
Message-ID: <d3a3b355-ce2b-8f9b-f9eb-7b92cdc91eb2@gmail.com>
Date:   Thu, 1 Dec 2022 12:21:38 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 07/10] engines/libblkio: Add option libblkio_wait_mode
Content-Language: en-US
To:     Alberto Faria <afaria@redhat.com>, fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
 <20221121182902.373491-8-afaria@redhat.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221121182902.373491-8-afaria@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/21/22 13:28, Alberto Faria wrote:
> It allows configuring how the engine waits for request completions,
> instead of always using a blocking blkioq_do_io() call.
> 
> Signed-off-by: Alberto Faria <afaria@redhat.com>
> ---
>   HOWTO.rst          |  14 ++++-
>   engines/libblkio.c | 132 ++++++++++++++++++++++++++++++++++++++++++---
>   fio.1              |  16 +++++-
>   3 files changed, 154 insertions(+), 8 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 7155add6..4b059cb2 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2332,7 +2332,8 @@ with the caveat that when used on the command line, they must come after the
>   
>      [libblkio]
>   
> -	Use poll queues.
> +	Use poll queues. This is incompatible with
> +	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>`.
>   
>      [pvsync2]
>   
> @@ -2884,6 +2885,17 @@ with the caveat that when used on the command line, they must come after the
>   	Submit trims as "write zeroes" requests instead of discard requests.
>   	Default is 0.
>   
> +.. option:: libblkio_wait_mode=str : [libblkio]
> +
> +	How to wait for completions:
> +
> +	**block** (default)
> +		Use a blocking call to ``blkioq_do_io()``.
> +	**eventfd**
> +		Use a blocking call to ``read()`` on the completion eventfd.
> +	**loop**
> +		Use a busy loop with a non-blocking call to ``blkioq_do_io()``.
> +
>   I/O depth
>   ~~~~~~~~~
>   
> diff --git a/engines/libblkio.c b/engines/libblkio.c
> index 79af3aa7..d7666f69 100644
> --- a/engines/libblkio.c
> +++ b/engines/libblkio.c
> @@ -20,6 +20,12 @@
>   #include "../options.h"
>   #include "../parse.h"
>   
> +enum fio_blkio_wait_mode {
> +	FIO_BLKIO_WAIT_MODE_BLOCK,
> +	FIO_BLKIO_WAIT_MODE_EVENTFD,
> +	FIO_BLKIO_WAIT_MODE_LOOP,
> +};
> +
>   struct fio_blkio_options {
>   	void *pad; /* option fields must not have offset 0 */
>   
> @@ -30,6 +36,7 @@ struct fio_blkio_options {
>   	unsigned int hipri;
>   	unsigned int vectored;
>   	unsigned int write_zeroes_on_trim;
> +	enum fio_blkio_wait_mode wait_mode;
>   };
>   
>   static struct fio_option options[] = {
> @@ -89,6 +96,30 @@ static struct fio_option options[] = {
>   		.category = FIO_OPT_C_ENGINE,
>   		.group	= FIO_OPT_G_LIBBLKIO,
>   	},
> +	{
> +		.name	= "libblkio_wait_mode",
> +		.lname	= "How to wait for completions",
> +		.type	= FIO_OPT_STR,
> +		.off1	= offsetof(struct fio_blkio_options, wait_mode),
> +		.help	= "How to wait for completions",
> +		.def	= "block",
> +		.posval = {
> +			  { .ival = "block",
> +			    .oval = FIO_BLKIO_WAIT_MODE_BLOCK,
> +			    .help = "Blocking blkioq_do_io()",
> +			  },
> +			  { .ival = "eventfd",
> +			    .oval = FIO_BLKIO_WAIT_MODE_EVENTFD,
> +			    .help = "Blocking read() on the completion eventfd",
> +			  },
> +			  { .ival = "loop",
> +			    .oval = FIO_BLKIO_WAIT_MODE_LOOP,
> +			    .help = "Busy loop with non-blocking blkioq_do_io()",
> +			  },
> +		},
> +		.category = FIO_OPT_C_ENGINE,
> +		.group	= FIO_OPT_G_LIBBLKIO,
> +	},
>   
>   	{
>   		.name = NULL,
> @@ -237,12 +268,21 @@ static int fio_blkio_setup(struct thread_data *td)
>   	 * again in the init() callback.
>   	 */
>   
> +	const struct fio_blkio_options *options = td->eo;
>   	struct blkio *b;
>   	int ret = 0;
>   	uint64_t capacity;
>   
>   	assert(td->files_index == 1);
>   
> +	/* validate options */
> +
> +	if (options->hipri &&
> +		options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
> +		log_err("fio: option hipri is incompatible with option libblkio_wait_mode=eventfd\n");
> +		return 1;
> +	}
> +
>   	/* get target size */
>   
>   	if (fio_blkio_create_and_connect(td, &b) != 0)
> @@ -268,6 +308,7 @@ out_blkio_destroy:
>   struct fio_blkio_data {
>   	struct blkio *b;
>   	struct blkioq *q;
> +	int completion_fd; /* -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
>   
>   	bool has_mem_region; /* whether mem_region is valid */
>   	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
> @@ -280,6 +321,7 @@ static int fio_blkio_init(struct thread_data *td)
>   {
>   	const struct fio_blkio_options *options = td->eo;
>   	struct fio_blkio_data *data;
> +	int flags;
>   
>   	/* allocate per-thread data struct */
>   
> @@ -324,6 +366,31 @@ static int fio_blkio_init(struct thread_data *td)
>   	else
>   		data->q = blkio_get_queue(data->b, 0);
>   
> +	/* enable completion fd and make it blocking */
> +
> +	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
> +		blkioq_set_completion_fd_enabled(data->q, true);
> +
> +		data->completion_fd = blkioq_get_completion_fd(data->q);
> +
> +		flags = fcntl(data->completion_fd, F_GETFL);
> +		if (flags < 0) {
> +			log_err("fio: fcntl(F_GETFL) failed: %s\n",
> +				strerror(errno));
> +			goto err_blkio_destroy;
> +		}
> +
> +		flags &= ~O_NONBLOCK;
> +
> +		if (fcntl(data->completion_fd, F_SETFL, flags) != 0) {
> +			log_err("fio: fcntl(F_SETFL) failed: %s\n",
> +				strerror(errno));
> +			goto err_blkio_destroy;
> +		}
> +	} else {
> +		data->completion_fd = -1;
> +	}
> +
>   	/* Set data only here so cleanup() does nothing if init() fails. */
>   	td->io_ops_data = data;
>   
> @@ -521,16 +588,69 @@ static enum fio_q_status fio_blkio_queue(struct thread_data *td,
>   static int fio_blkio_getevents(struct thread_data *td, unsigned int min,
>   			       unsigned int max, const struct timespec *t)
>   {
> +	const struct fio_blkio_options *options = td->eo;
>   	struct fio_blkio_data *data = td->io_ops_data;
> -	int n;
> +	int ret, n;
> +	uint64_t event;
>   
> -	n = blkioq_do_io(data->q, data->completions, (int)min, (int)max, NULL);
> -	if (n < 0) {
> -		fio_blkio_log_err(blkioq_do_io);
> +	switch (options->wait_mode) {
> +	case FIO_BLKIO_WAIT_MODE_BLOCK:
> +

Because we already have indentation here the blank lines before and 
after each "case" don't improve readability much. To be consistent with 
the rest of the code base and conserve vertical screen real estate I 
would drop the blank lines.

> +		n = blkioq_do_io(data->q, data->completions, (int)min, (int)max,
> +				 NULL);
> +		if (n < 0) {
> +			fio_blkio_log_err(blkioq_do_io);
> +			return -1;
> +		}
> +
> +		return n;
> +
> +	case FIO_BLKIO_WAIT_MODE_EVENTFD:
> +
> +		n = blkioq_do_io(data->q, data->completions, 0, (int)max, NULL);
> +		if (n < 0) {
> +			fio_blkio_log_err(blkioq_do_io);
> +			return -1;
> +		}
> +
> +		while (n < (int)min) {
> +			ret = read(data->completion_fd, &event, sizeof(event));
> +			if (ret != sizeof(event)) {
> +				log_err("fio: read() on the completion fd returned %d\n",
> +					ret);
> +				return -1;
> +			}
> +
> +			ret = blkioq_do_io(data->q, data->completions + n, 0,
> +					   (int)max - n, NULL);
> +			if (ret < 0) {
> +				fio_blkio_log_err(blkioq_do_io);
> +				return -1;
> +			}
> +
> +			n += ret;
> +		}
> +
> +		return n;
> +
> +	case FIO_BLKIO_WAIT_MODE_LOOP:
> +
> +		for (n = 0; n < (int)min; ) {
> +			ret = blkioq_do_io(data->q, data->completions + n, 0,
> +					   (int)max - n, NULL);
> +			if (ret < 0) {
> +				fio_blkio_log_err(blkioq_do_io);
> +				return -1;
> +			}
> +
> +			n += ret;
> +		}
> +
> +		return n;
> +
> +	default:
>   		return -1;
>   	}
> -
> -	return n;
>   }
>   
>   static struct io_u *fio_blkio_event(struct thread_data *td, int event)
> diff --git a/fio.1 b/fio.1
> index 053c2eda..88bb232f 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2622,7 +2622,7 @@ before starting the \fBstruct blkio\fR. Each property must have the format
>   the engine sets any other properties, so those can be overriden.
>   .TP
>   .BI (libblkio)hipri \fR=\fPbool
> -Use poll queues.
> +Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR.
>   .TP
>   .BI (libblkio)libblkio_vectored \fR=\fPbool
>   Submit vectored read and write requests. Default is 0.
> @@ -2630,6 +2630,20 @@ Submit vectored read and write requests. Default is 0.
>   .BI (libblkio)libblkio_write_zeroes_on_trim \fR=\fPbool
>   Submit trims as "write zeroes" requests instead of discard requests. Default is
>   0.
> +.TP
> +.BI (libblkio)libblkio_wait_mode \fR=\fPstr
> +How to wait for completions:
> +.RS
> +.RS
> +.TP
> +.B block \fR(default)
> +Use a blocking call to \fBblkioq_do_io()\fR.
> +.TP
> +.B eventfd
> +Use a blocking call to \fBread()\fR on the completion eventfd.
> +.TP
> +.B loop
> +Use a busy loop with a non-blocking call to \fBblkioq_do_io()\fR.
>   .SS "I/O depth"
>   .TP
>   .BI iodepth \fR=\fPint

