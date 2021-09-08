Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74555C433F5
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 12:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ECE561157
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 12:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349379AbhIHMvr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 08:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349243AbhIHMvq (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 08:51:46 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E0CC061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 05:50:38 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id x5so2180411ill.3
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 05:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Lw0rCiJVDLOtYg5yAzNUxDDLVhwbO5n2mDorXMziCC8=;
        b=uKYf+ez5QQvs+ziQiPNU//qiNFm35LLP9QYLraMGl9XGcB/FXDVGoV6nZzHPsA6VXt
         nDEP0LS2cqQqBb0Jq+SPOf5RrMopNxuKjBx73Iq5AE9OcFE+xgKygq8iWNt/blQwOKrP
         XOw5aUGfEpOvRov7rJ1KuHdswQiwZIZuqUcPTl+34vAKcXVet1aiMmZ3Xj6nDyb6G3lm
         QlbfXfWTilLlu25IztpsoCfHJGvszGLfmuz1anmi4hnmQPatxb6gwqEwZ/GseS1VKqyR
         jC709hHfxGT1bAx8HCSQ9RxT9NgmytVcdmiEGeYCo3s2UwB1m/ZTm3vMX4RI5TdeBvrA
         9Jwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lw0rCiJVDLOtYg5yAzNUxDDLVhwbO5n2mDorXMziCC8=;
        b=nZ1eURrI6n67ubMadwJ7BhDOu+sBYrvEZUmnSnol2R+SRT6BfGcXeqo/c1CMzNDJDs
         XpmJn/CEjTCJYv61inUrhHfbX1EuNdLuWAKUK14ZH8mUVeKmF68mEKXIBBKTNZuxQddo
         x3Fwx+D8B3gHL/XvNLiVZyswD/HoVHy7ffbVnKflGsGcfV+edMsCP+qFr+NeXznGsAXu
         91pqcVOTtNqEmjsbod4xDZUvEbRmgN3NBrprpD/x9HJ7EDxpuWoAL3yJiv7QPe5cwhV3
         0zDjjApe9IOS74EB+2wT6O9J1HKtQDhLP5/3tyiQ/6H7PB/CIJ8tFWHCXaQao47uUXii
         N3Rg==
X-Gm-Message-State: AOAM533CXsbcEUan2CVD7bK+QAvByllTNfAI9UQdU72sSaOehmmqeRSA
        zXWmq30Pvo8tnNbgQiVxdk7Xo4pc4wAzsw==
X-Google-Smtp-Source: ABdhPJzsJF1GlACOv1nPGn/IcpZaY+TaT0kV8PFCNfVCuGpohpwW929hyCIPCcs+R00mC3X2Q4LWXQ==
X-Received: by 2002:a05:6e02:20cd:: with SMTP id 13mr2823108ilq.156.1631105437654;
        Wed, 08 Sep 2021 05:50:37 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a5sm1202407ilf.27.2021.09.08.05.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 05:50:37 -0700 (PDT)
Subject: Re: [PATCH 2/2] t/io_uring: allow flexible IO threads assignment
To:     Andrzej Jakowski <andrzej.jakowski@intel.com>, fio@vger.kernel.org
References: <1631074245-16080-1-git-send-email-andrzej.jakowski@intel.com>
 <1631074245-16080-2-git-send-email-andrzej.jakowski@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <184f044a-7e76-5941-cb0b-74de26c1f5ab@kernel.dk>
Date:   Wed, 8 Sep 2021 06:50:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1631074245-16080-2-git-send-email-andrzej.jakowski@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/7/21 10:10 PM, Andrzej Jakowski wrote:
> This patch allows to flexibly assign IO threads to fileset. When
> you specify:
> 
> t/io_uring -n 5 /dev/dev1 dev/dev2
> 
> First file/device will get 3 IO threads and second file/device
> remaining 2 IO threads. When there is more files then IO threads,
> IO thread may get assigned multiple files/devices.
> 
> Signed-off-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
> ---
>  t/io_uring.c | 51 ++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 34 insertions(+), 17 deletions(-)
> 
> diff --git a/t/io_uring.c b/t/io_uring.c
> index 28c76b0..6a06799 100644
> --- a/t/io_uring.c
> +++ b/t/io_uring.c
> @@ -556,7 +556,8 @@ int main(int argc, char *argv[])
>  {
>  	struct submitter *s;
>  	unsigned long done, calls, reap;
> -	int err, i, j, flags, fd, opt;
> +	int err, i, j, flags, fd, opt, threads_per_f, threads_rem = 0, nfiles;
> +	struct file f;
>  	char *fdepths;
>  	void *ret;
>  
> @@ -613,37 +614,53 @@ int main(int argc, char *argv[])
>  
>  	j = 0;
>  	i = optind;
> +	nfiles = argc - i;
> +	threads_per_f = nthreads / nfiles;

Can nfiles be zero?

-- 
Jens Axboe

