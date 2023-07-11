Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5EEC001DD
	for <fio@archiver.kernel.org>; Tue, 11 Jul 2023 14:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjGKOn2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 11 Jul 2023 10:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbjGKOnP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Jul 2023 10:43:15 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93236BC
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 07:43:09 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-635857af3beso29356036d6.0
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 07:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689086588; x=1691678588;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SN0icKo/+WGS/ifAg7hiQS8ItlRfug1S3tcxluoh/nw=;
        b=L/JQKz1YLz3FL8iDZO4kGJdY4kEXYajG89XCoz9Vp/k45Bu/dX4YubtrywCbGobJhc
         lgcuvPF3F0RzP4PeNHNXyNqPMqmsD2kw2M+QunZbpCg/xXE7YXKQwadVidnc/6QRI1Kd
         pM89TIUTndug0GlO5rtSm9Holmd0ohT0rDITfoGdDgHVag7CzOLiICCLsA2r12yR4+dA
         EzoIO/oxoVHCJ/nOKt5FmYSEJRyKAr+IE40vRuM2H30j5ePwiY08Yo4umEfgbfqZ2RhS
         zgOS0yiAoeF6fXvLGzAXiXXo/tKXgH79ucuvCnMmR6lAKThnBtJqStSAplqztK+qhLm4
         gNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689086588; x=1691678588;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SN0icKo/+WGS/ifAg7hiQS8ItlRfug1S3tcxluoh/nw=;
        b=VHaXu8MhstDLhYXWvhWgSnxbNJ/PRpoLaPwc9hS8eu/vPf2Ls3syrS4+/0jwk83f/n
         0jayEKaaerLoM6ZHz/pnwxC+QmmGVk4nZCsh2uRxxCUT7NxoGIzzTfrbWIG1oV/WAgqE
         42n5LtcBd7hC7XsDpfiSyD5jCjumuN0Z2tjg3BsrgNLXwfu0lZgqDDwvSKFaIdBvbGOx
         kG3xmCXOqtbcMWkL8zpm7ea8w58x88tSbyL+DQh3gjAAgH9moOcUWHvie3ajpWMTyKP3
         xkWaMt66F9FA49Kt1BwL3NRMvw1JiCEUb8q675HII8ELuiaYXzKAl5Dd4o9ECiNWkYRb
         OOXw==
X-Gm-Message-State: ABy/qLZALePJz0Ca1uE2huUDrI6lagvtPbTQRPXiBV7NcyRNiqT3A7w3
        tYB/l9ERl2S8SxYHDvxZ5pM=
X-Google-Smtp-Source: APBJJlFLgMb6obOWqVRsj3UiAaJDc/WWlw/cO11cI57NHYuY29+cLBkVM+EN4NPalInFS+5zaoAeTg==
X-Received: by 2002:a0c:cd11:0:b0:637:7671:588f with SMTP id b17-20020a0ccd11000000b006377671588fmr11999231qvm.33.1689086588610;
        Tue, 11 Jul 2023 07:43:08 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id g4-20020a0cf084000000b0062168714c8fsm1121255qvk.120.2023.07.11.07.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 07:43:08 -0700 (PDT)
Message-ID: <b4e47ae7-1333-a47a-16f6-ecdddf462e13@gmail.com>
Date:   Tue, 11 Jul 2023 10:43:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/3] fdp: use macro for max ruhs and fix placement id
 check
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com
References: <20230711125434.14691-1-ankit.kumar@samsung.com>
 <CGME20230711073512epcas5p4d10da8eefbc198953212cbfd5ca83198@epcas5p4.samsung.com>
 <20230711125434.14691-2-ankit.kumar@samsung.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230711125434.14691-2-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/11/23 08:54, Ankit Kumar wrote:
> Use macro for max ruhs.
> Number of reclaim unit handle descriptors are 1 based, whereas the
> input placement id index / indices are 0 based. Add the correct check
> for that.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   engines/io_uring.c | 2 +-
>   fdp.c              | 8 ++++----
>   fdp.h              | 2 ++
>   3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 5021239e..407d65ce 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -1310,7 +1310,7 @@ static int fio_ioring_cmd_fetch_ruhs(struct thread_data *td, struct fio_file *f,
>   	struct nvme_fdp_ruh_status *ruhs;
>   	int bytes, ret, i;
>   
> -	bytes = sizeof(*ruhs) + 128 * sizeof(struct nvme_fdp_ruh_status_desc);
> +	bytes = sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(struct nvme_fdp_ruh_status_desc);
>   	ruhs = scalloc(1, bytes);
>   	if (!ruhs)
>   		return -ENOMEM;
> diff --git a/fdp.c b/fdp.c
> index d92dbc67..72afca01 100644
> --- a/fdp.c
> +++ b/fdp.c
> @@ -45,7 +45,7 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
>   	struct fio_ruhs_info *ruhs, *tmp;
>   	int i, ret;
>   
> -	ruhs = scalloc(1, sizeof(*ruhs) + 128 * sizeof(*ruhs->plis));
> +	ruhs = scalloc(1, sizeof(*ruhs) + FDP_MAX_RUHS * sizeof(*ruhs->plis));
>   	if (!ruhs)
>   		return -ENOMEM;
>   
> @@ -56,8 +56,8 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
>   		goto out;
>   	}
>   
> -	if (ruhs->nr_ruhs > 128)
> -		ruhs->nr_ruhs = 128;
> +	if (ruhs->nr_ruhs > FDP_MAX_RUHS)
> +		ruhs->nr_ruhs = FDP_MAX_RUHS;
>   
>   	if (td->o.fdp_nrpli == 0) {
>   		f->ruhs_info = ruhs;
> @@ -65,7 +65,7 @@ static int init_ruh_info(struct thread_data *td, struct fio_file *f)
>   	}
>   
>   	for (i = 0; i < td->o.fdp_nrpli; i++) {
> -		if (td->o.fdp_plis[i] > ruhs->nr_ruhs) {
> +		if (td->o.fdp_plis[i] >= ruhs->nr_ruhs) {
>   			ret = -EINVAL;
>   			goto out;
>   		}
> diff --git a/fdp.h b/fdp.h
> index 81691f62..4a5e0e54 100644
> --- a/fdp.h
> +++ b/fdp.h
> @@ -3,6 +3,8 @@
>   
>   #include "io_u.h"
>   
> +#define FDP_MAX_RUHS	128
> +
>   struct fio_ruhs_info {
>   	uint32_t nr_ruhs;
>   	uint32_t pli_loc;


Ankit, the commit history will be cleaner if the refactoring change and 
the bug fix were split into separate commits. Would you mind doing that?

Vincent
