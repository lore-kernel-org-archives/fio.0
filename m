Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C6CC43217
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 17:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLARNg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiLARNf (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 12:13:35 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C91CAC6F4
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 09:13:34 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id x28so490175qtv.13
        for <fio@vger.kernel.org>; Thu, 01 Dec 2022 09:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I3matE3dUBX/F3gUcE4twTrNLQCcLnh+02gBvEpd1jg=;
        b=gp0aXhhL4fQT2z1HxM2+/Vpu5tYNb/AdA86HFITQKXcVrBFo2K3WjLMmFuIaCnpcxu
         7ecco9L1TlnFIBj8bIUNq2XAZeanLypRikHU2hyWZfhnXHCzFIBDbE7hjg/Any/GMmTe
         LlpW5NJAEnbpYeSCl9pfn/7DYzeZNDhWoCqAYadJFpy3DaGNzF+eDNpy2p3H61I+bQzM
         MYN+ZcFjhjdttpVN1GY0G8mofP4iVCpGMVh1QDRmvOAnYaj3KLQfykoRj+E7/i+336WG
         FelJfdwgXw99jgvM4MS6zkiHpsA8QqAjrq/9/vbPoHAdzPM9+ypyzlNKJqsNLJ42Yd3g
         zOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I3matE3dUBX/F3gUcE4twTrNLQCcLnh+02gBvEpd1jg=;
        b=GrxnkHIncnjXGhPIgSXGgXhn0+LRV+mM7EjNB3bIz1FveQhnZFmhMNWgIHH0vTFSz3
         k81skLvRGz5spMEgfXByDazTcut9f2bFE+RFEauCz5t/dsr2b1N5ezOP8x5DnhwrW3Lv
         CjbxJejM2jOudTk2St4SJhQcJaThl77aWipgQymgM6/WqVZntke3dQ3+IWYLPVZU3CzZ
         jjQtN9cE21+5PRsBzt/S0CJjVbWJY0cb4wY7yyz935nzYK2zZx69ash5Td7QU5fhzTrK
         GXVlavsz1ruBQKVMt/d9kURbAg+rwO1zXZG7D1LKzOF+KboSuiXS8S1vhPXdVaE46gVe
         A+SA==
X-Gm-Message-State: ANoB5pm6BgkczdBf0/VucZQM0ghpvbN3LnYox1MTY9iqXlblxpqhHkEj
        WYMbPrgvV5daPXEMhXbN7qI=
X-Google-Smtp-Source: AA0mqf5IjgVIyUuQmi9xX/xb7cFgwF11qQJwkr89JD+xDj3jvtrmrgpRplZDHJh6U6EcQr7hzOvFnQ==
X-Received: by 2002:a05:620a:16a7:b0:6ea:3fa0:bbfb with SMTP id s7-20020a05620a16a700b006ea3fa0bbfbmr42321321qkj.473.1669914813503;
        Thu, 01 Dec 2022 09:13:33 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id h13-20020a05620a244d00b006fba44843a5sm3852460qkn.52.2022.12.01.09.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 09:13:33 -0800 (PST)
Message-ID: <e0d9ba14-ae7f-86a8-a3b3-5b2948f6a304@gmail.com>
Date:   Thu, 1 Dec 2022 12:13:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 06/10] engines/libblkio: Add option
 libblkio_write_zeroes_on_trim
Content-Language: en-US
To:     Alberto Faria <afaria@redhat.com>, fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
 <20221121182902.373491-7-afaria@redhat.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221121182902.373491-7-afaria@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/21/22 13:28, Alberto Faria wrote:
> When set, trim IOs will be submitted as blkioq_write_zeroes() requests
> instead of blkioq_discard() requests.
> 
> Signed-off-by: Alberto Faria <afaria@redhat.com>
> ---
>   HOWTO.rst          |  5 +++++
>   engines/libblkio.c | 20 ++++++++++++++++++--
>   fio.1              |  4 ++++
>   3 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index b9c7c8df..7155add6 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2879,6 +2879,11 @@ with the caveat that when used on the command line, they must come after the
>   
>   	Submit vectored read and write requests. Default is 0.
>   
> +.. option:: libblkio_write_zeroes_on_trim=bool : [libblkio]

Same comment here as for libblkio_vectored regarding option types.

> +
> +	Submit trims as "write zeroes" requests instead of discard requests.
> +	Default is 0.
> +
>   I/O depth
>   ~~~~~~~~~
>   
> diff --git a/engines/libblkio.c b/engines/libblkio.c
> index dcf701ad..79af3aa7 100644
> --- a/engines/libblkio.c
> +++ b/engines/libblkio.c
> @@ -29,6 +29,7 @@ struct fio_blkio_options {
>   
>   	unsigned int hipri;
>   	unsigned int vectored;
> +	unsigned int write_zeroes_on_trim;
>   };
>   
>   static struct fio_option options[] = {
> @@ -78,6 +79,16 @@ static struct fio_option options[] = {
>   		.category = FIO_OPT_C_ENGINE,
>   		.group	= FIO_OPT_G_LIBBLKIO,
>   	},
> +	{
> +		.name	= "libblkio_write_zeroes_on_trim",
> +		.lname	= "Use blkioq_write_zeroes() for TRIM",
> +		.type	= FIO_OPT_STR_SET,
> +		.off1	= offsetof(struct fio_blkio_options,
> +				   write_zeroes_on_trim),
> +		.help	= "Use blkioq_write_zeroes() for TRIM instead of blkioq_discard()",
> +		.category = FIO_OPT_C_ENGINE,
> +		.group	= FIO_OPT_G_LIBBLKIO,
> +	},
>   
>   	{
>   		.name = NULL,
> @@ -484,8 +495,13 @@ static enum fio_q_status fio_blkio_queue(struct thread_data *td,
>   			break;
>   
>   		case DDIR_TRIM:
> -			blkioq_discard(data->q, io_u->offset, io_u->xfer_buflen,
> -				       io_u, 0);
> +			if (options->write_zeroes_on_trim) {
> +				blkioq_write_zeroes(data->q, io_u->offset,
> +						    io_u->xfer_buflen, io_u, 0);
> +			} else {
> +				blkioq_discard(data->q, io_u->offset,
> +					       io_u->xfer_buflen, io_u, 0);
> +			}
>   		        break;
>   
>   		case DDIR_SYNC:
> diff --git a/fio.1 b/fio.1
> index a403b415..053c2eda 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -2626,6 +2626,10 @@ Use poll queues.
>   .TP
>   .BI (libblkio)libblkio_vectored \fR=\fPbool
>   Submit vectored read and write requests. Default is 0.
> +.TP
> +.BI (libblkio)libblkio_write_zeroes_on_trim \fR=\fPbool
> +Submit trims as "write zeroes" requests instead of discard requests. Default is
> +0.
>   .SS "I/O depth"
>   .TP
>   .BI iodepth \fR=\fPint

