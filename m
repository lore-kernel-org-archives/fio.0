Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5037C43217
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 17:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiLAR35 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLAR34 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 12:29:56 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77445A47DC
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 09:29:55 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id c15so1670213qtw.8
        for <fio@vger.kernel.org>; Thu, 01 Dec 2022 09:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aodGBYdiz5maASn52XyM4hoIjSJdEpGS2AnbI2uQQpI=;
        b=HhkSMuTlgR0kK/6NzZ74WJ1ee4wvUJqz963V5go59jALDZizmPqzV4s1FXzdOLkoL4
         lNVcQ3ZJYjcBRH45kiXPB5RgZBnm9Cuy8/Phk6Q8WSUNe/N97ve4mywkuTy72fAVGlYi
         eTYwhB8HJj6HiRBRx6C7R4ypUOIk2PB2UqvwhVOlrABnG8Zd9g6TMcmNK2wAp1zQR9qW
         FbVOZbsBpce6j4BY8ydco9aHblZ7hdnEoOzFIDN7XwiUhiZARVHru3RcxGAKJb7Z4MYz
         Rd+avd17ZrY2aODsjiy7PdD9Ffsl3ApdjqaOQ0lueUmCixKNz6rRVSXMO7zeTBtL7YON
         T1aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aodGBYdiz5maASn52XyM4hoIjSJdEpGS2AnbI2uQQpI=;
        b=8SPNjr4lbng6UFEbXJv3IGa+YNefEo1PuYnZ6z3dP5BIsAo61Z2PwVHCUrbRJJScXs
         sMqJEXYEIER187IFEmWVpDUnD6Xc95VR7rGhhibKDObCv++HWNx4QVhQxZZXXcjdhC66
         fuguDBqw2AO0OcmYzEPTPAsUA2uoH62+tP4asw6clVLjiUToDaaZl0AqPtL2s9ve0N/s
         MGyNO7SV/yWiffqMUl7r2csM6cIme3yrko1WrrUd6S/RLsWGwdJinzhpNu4VqzGpjP4l
         cGV+7D6zyCSQU5x+3sk1kQMJ7F0f/c8bGuaUDrz5cO4+bVR5V0Hczm29vreMjZLvqQVW
         1liQ==
X-Gm-Message-State: ANoB5pl8WtbV+19TMUO1UDVhtEWJxCXfc4a/MCKZPzG3de2VkAEtAEQN
        C43jJNTtTxFE+1DQtPdArf6BI0gTSpxXMg==
X-Google-Smtp-Source: AA0mqf5N70kl7ojwGSw1MRQmim9HweeTqsRY5QsxnD+xIjlJM1fasK2wGnSyhhRQhWMs7eXFEszaBw==
X-Received: by 2002:ac8:41d2:0:b0:3a6:9088:f9b5 with SMTP id o18-20020ac841d2000000b003a69088f9b5mr5235429qtm.9.1669915794414;
        Thu, 01 Dec 2022 09:29:54 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id g28-20020ac84b7c000000b003a6887e6463sm2807545qts.6.2022.12.01.09.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 09:29:53 -0800 (PST)
Message-ID: <8dad1bd9-480a-1951-af90-e8bb9d0dbff2@gmail.com>
Date:   Thu, 1 Dec 2022 12:29:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 10/10] engines/libblkio: Share a single blkio instance
 among threads in same process
Content-Language: en-US
To:     Alberto Faria <afaria@redhat.com>, fio@vger.kernel.org
Cc:     Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <20221121182902.373491-1-afaria@redhat.com>
 <20221121182902.373491-11-afaria@redhat.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221121182902.373491-11-afaria@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/21/22 13:29, Alberto Faria wrote:
> fio groups all subjobs that set option 'thread' into a single process.
> Have them all share a single `struct blkio` instance, with one `struct
> blkioq` per thread/subjob. This allows benchmarking multi-queue setups.
> 
> Note that `struct blkio` instances cannot be shared across different
> processes.
> 
> Signed-off-by: Alberto Faria <afaria@redhat.com>
> ---
>   HOWTO.rst                                 |   8 +-
>   engines/libblkio.c                        | 250 +++++++++++++++++++---
>   examples/libblkio-io_uring.fio            |  13 +-
>   examples/libblkio-virtio-blk-vfio-pci.fio |  13 +-
>   fio.1                                     |   7 +-
>   5 files changed, 257 insertions(+), 34 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 763f4f51..4e69abfc 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -2199,7 +2199,13 @@ I/O engine
>   			:option:`libblkio_driver`. If
>   			:option:`mem`/:option:`iomem` is not specified, memory
>   			allocation is delegated to libblkio (and so is
> -			guaranteed to work with the selected *driver*).
> +			guaranteed to work with the selected *driver*). One
> +			``struct blkio`` instance is used per process, so all
> +			jobs setting option :option:`thread` will share a single
> +			``struct blkio`` (with one queue per thread) and must
> +			specify compatible options. Note that some drivers don't
> +			allow several processes to access the same device or
> +			file simultaneously, but allow it for threads.
>   
>   I/O engine specific parameters
>   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> diff --git a/engines/libblkio.c b/engines/libblkio.c
> index a80be66f..987dea4f 100644
> --- a/engines/libblkio.c
> +++ b/engines/libblkio.c
> @@ -249,6 +249,105 @@ static int fio_blkio_set_props_from_str(struct blkio *b, const char *opt_name,
>   			blkio_get_error_msg()); \
>   	})
>   
> +static bool possibly_null_strs_equal(const char *a, const char *b)
> +{
> +	return (!a && !b) || (a && b && strcmp(a, b) == 0);
> +}
> +
> +/*
> + * Returns the total number of subjobs using option 'thread' in the entire
> + * workload that have the given value for the 'hipri' option.
> + */
> +static int total_threaded_subjobs(bool hipri)
> +{
> +	struct thread_data *td;
> +	unsigned int i;
> +	int count = 0;
> +
> +	for_each_td(td, i) {
> +		const struct fio_blkio_options *options = td->eo;
> +		if (td->o.use_thread && (bool)options->hipri == hipri)
> +			++count;
> +	}
> +
> +	return count;
> +}

The loop should skip jobs not using the libblkio ioengine because, for 
example, some ioengines don't have any ioengine options.

