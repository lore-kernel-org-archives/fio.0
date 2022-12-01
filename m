Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F274CC43217
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 17:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiLARXP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLARXO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 12:23:14 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B5B1CB23
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 09:23:13 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id c15so1638924qtw.8
        for <fio@vger.kernel.org>; Thu, 01 Dec 2022 09:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NvBkdhlggiBtaeDIm9ONXJ9wH8DOoMua0shmJ+TFQeQ=;
        b=DqJjXBPXCeg2bBYkS4jEAGuf0im4+T1JGzIhfJFHYDaytMmQE+YkOnbhFH5FpayAuq
         h16cO6mtl9A8N+gqpCkGS2+O0JddtUY94jjedBQbYlF6GzeHhTxk7/lw9IGAknRznf1o
         qISGWEQ5ebQ2A50h1Rz6rFi6YLzRIxnlJXvNoc3ug11QkGZMaU6N8/GF3XxLUDSvAQU6
         7PorBim4cqL6qKmQGEdQXVOeBfG5zsGZnCfCKx9tN37E8Kn7v18Q8LtLnXOSLAbGh/wv
         GAOQCIFnNvdwPmGdDZON7VE4BStONe1OK1quyxJQOXBpAamsUrl6mEe+M4amOTCZlJ68
         XXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvBkdhlggiBtaeDIm9ONXJ9wH8DOoMua0shmJ+TFQeQ=;
        b=yxgna3NrwWxqeD37iUxU+xrN8/muT05KM2jx6sCzLi680uF0kbgfan8h22pA0Y2hxo
         px0HD4jMl2wmnKBuu7+zkeVphk7LduRbqCusfrvu9Cyg1a8rlvmK58IWIkCg8giP5Ups
         mXSihBDWS3JIIGpyJ95mue9Jl20yB/yiimCBVBebkgGCYqbwdK2HNO0CgKsOGvsyedpR
         bIjDqo3Oe+0wu7VaQ5m3jBKxp0DMAnw92fbQtHptTM8mHvJ3UvLTaruJdYaYEmNevPIs
         PcvVX8WbhcZOpB4VB/eMpC14xhDDe8KFJgNVf0FeffXB62AabXbYl9BEDfwTl0WR2XDB
         18mQ==
X-Gm-Message-State: ANoB5pknrd1kF0uQkviVdrv8FHTKaZC/dHf5CsiECpM3C7KAqKP0nEjx
        kEl7fpRLngbiF5wgtggt2+rU70MdeYFrbA==
X-Google-Smtp-Source: AA0mqf5fhdWdrrvc6biYnefWPfwgJfnFPP2nXzGQD1ILMpMVjj5bcOvPl5vTWiAMb3lfgs+ZdYWfFg==
X-Received: by 2002:a05:620a:a5b:b0:6f6:7af1:50a5 with SMTP id j27-20020a05620a0a5b00b006f67af150a5mr59343826qka.729.1669915391977;
        Thu, 01 Dec 2022 09:23:11 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id y26-20020a37f61a000000b006bc192d277csm3634749qkj.10.2022.12.01.09.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 09:23:11 -0800 (PST)
Message-ID: <1c23ed4a-b907-242c-62ef-20b4b4c2d271@gmail.com>
Date:   Thu, 1 Dec 2022 12:23:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 08/10] engines/libblkio: Add option
 libblkio_force_enable_completion_eventfd
Content-Language: en-US
To:     Alberto Faria <afaria@redhat.com>, fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
 <20221121182902.373491-9-afaria@redhat.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221121182902.373491-9-afaria@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/21/22 13:29, Alberto Faria wrote:
> When set, the queue's completion fd is enabled even when it isn't used,
> i.e., even if option libblkio_wait_mode is _not_ set to "eventfd".
> 
> Depending on the libblkio driver, this can have an impact on
> performance. This option allows evaluating that overhead.
> 
> Signed-off-by: Alberto Faria <afaria@redhat.com>
> ---
>   HOWTO.rst          |  9 ++++++++-
>   engines/libblkio.c | 21 +++++++++++++++++++--
>   fio.1              | 10 +++++++++-
>   3 files changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 4b059cb2..7b3a3ffc 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2333,7 +2333,8 @@ with the caveat that when used on the command line, they must come after the
>      [libblkio]
>   
>   	Use poll queues. This is incompatible with
> -	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>`.
> +	:option:`libblkio_wait_mode=eventfd <libblkio_wait_mode>` and
> +	:option:`libblkio_force_enable_completion_eventfd`.
>   
>      [pvsync2]
>   
> @@ -2896,6 +2897,12 @@ with the caveat that when used on the command line, they must come after the
>   	**loop**
>   		Use a busy loop with a non-blocking call to ``blkioq_do_io()``.
>   
> +.. option:: libblkio_force_enable_completion_eventfd=bool : [libblkio]

Same comment as for previous patches regarding option types.

> +
> +	Enable the ``struct blkioq``'s completion eventfd even when unused. This
> +	may impact performance. The default is to enable it only if
> +	:option:`libblkio_wait_mode` is **eventfd**.
> +
>   I/O depth
>   ~~~~~~~~~
>   
> diff --git a/engines/libblkio.c b/engines/libblkio.c
> index d7666f69..3ff87e6d 100644
> --- a/engines/libblkio.c
> +++ b/engines/libblkio.c
> @@ -37,6 +37,7 @@ struct fio_blkio_options {
>   	unsigned int vectored;
>   	unsigned int write_zeroes_on_trim;
>   	enum fio_blkio_wait_mode wait_mode;
> +	unsigned int force_enable_completion_eventfd;
>   };
>   
>   static struct fio_option options[] = {
> @@ -120,6 +121,16 @@ static struct fio_option options[] = {
>   		.category = FIO_OPT_C_ENGINE,
>   		.group	= FIO_OPT_G_LIBBLKIO,
>   	},
> +	{
> +		.name	= "libblkio_force_enable_completion_eventfd",
> +		.lname	= "Force enable the completion eventfd, even if unused",
> +		.type	= FIO_OPT_STR_SET,
> +		.off1	= offsetof(struct fio_blkio_options,
> +				   force_enable_completion_eventfd),
> +		.help	= "This can impact performance",
> +		.category = FIO_OPT_C_ENGINE,
> +		.group	= FIO_OPT_G_LIBBLKIO,
> +	},
>   
>   	{
>   		.name = NULL,
> @@ -283,6 +294,11 @@ static int fio_blkio_setup(struct thread_data *td)
>   		return 1;
>   	}
>   
> +	if (options->hipri && options->force_enable_completion_eventfd) {
> +		log_err("fio: option hipri is incompatible with option libblkio_force_enable_completion_eventfd\n");
> +		return 1;
> +	}
> +
>   	/* get target size */
>   
>   	if (fio_blkio_create_and_connect(td, &b) != 0)
> @@ -308,7 +324,7 @@ out_blkio_destroy:
>   struct fio_blkio_data {
>   	struct blkio *b;
>   	struct blkioq *q;
> -	int completion_fd; /* -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
> +	int completion_fd; /* may be -1 if not FIO_BLKIO_WAIT_MODE_EVENTFD */
>   
>   	bool has_mem_region; /* whether mem_region is valid */
>   	struct blkio_mem_region mem_region; /* only if allocated by libblkio */
> @@ -368,7 +384,8 @@ static int fio_blkio_init(struct thread_data *td)
>   
>   	/* enable completion fd and make it blocking */
>   
> -	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD) {
> +	if (options->wait_mode == FIO_BLKIO_WAIT_MODE_EVENTFD ||
> +		options->force_enable_completion_eventfd) {
>   		blkioq_set_completion_fd_enabled(data->q, true);
>   
>   		data->completion_fd = blkioq_get_completion_fd(data->q);
> diff --git a/fio.1 b/fio.1
> index 88bb232f..e2f92bd1 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2622,7 +2622,8 @@ before starting the \fBstruct blkio\fR. Each property must have the format
>   the engine sets any other properties, so those can be overriden.
>   .TP
>   .BI (libblkio)hipri \fR=\fPbool
> -Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR.
> +Use poll queues. This is incompatible with \fBlibblkio_wait_mode=eventfd\fR and
> +\fBlibblkio_force_enable_completion_eventfd\fR.
>   .TP
>   .BI (libblkio)libblkio_vectored \fR=\fPbool
>   Submit vectored read and write requests. Default is 0.
> @@ -2644,6 +2645,13 @@ Use a blocking call to \fBread()\fR on the completion eventfd.
>   .TP
>   .B loop
>   Use a busy loop with a non-blocking call to \fBblkioq_do_io()\fR.
> +.RE
> +.RE
> +.TP
> +.BI (libblkio)libblkio_force_enable_completion_eventfd \fR=\fPbool
> +Enable the \fBstruct blkioq\fR's completion eventfd even when unused. This may
> +impact performance. The default is to enable it only if \fBlibblkio_wait_mode\fR
> +is \fBeventfd\fR.
>   .SS "I/O depth"
>   .TP
>   .BI iodepth \fR=\fPint

