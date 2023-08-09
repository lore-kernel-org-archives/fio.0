Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB8CC0015E
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 15:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjHIPNp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 11:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjHIPNo (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 11:13:44 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C091FD4
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 08:13:44 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-63cf6b21035so43940706d6.1
        for <fio@vger.kernel.org>; Wed, 09 Aug 2023 08:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691594023; x=1692198823;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v+KqkXzvfBcmBF79NffXHZQQBAPBMOK8mfV/u1OwUUs=;
        b=cx/ZiJJJlCdnjcIWpk+wG7BBuI8Dx6xpsOQvx6gZkGxEwttHOdXluQxRxVfCUolllu
         dna7BH49h4ebS44V8jd2FvJFH4tvXFdmur+wlUhp62WVF4Cu/DWygg9tUE7bz1nz9Py9
         AUm7+X79Gzgk70Y6WaK/ADZ/ZcmWYZfSPkdwvOI9GkgafjkAEwTHz/6Vu3Pm/FTBod2M
         m9lh/sEzH3Dn6B/KM23Yx6sALt6Zk7Mw6gsA79l3WiEDgCxGOzz1OoMdIVKc7SfY+nfE
         XVtm1p6jVV2Bye+XbW4RJPIIeRx8ZEtWhS9n/9NkuUMFssLy7PM8IP+uHYVJOUFIoJuN
         6mEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691594023; x=1692198823;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v+KqkXzvfBcmBF79NffXHZQQBAPBMOK8mfV/u1OwUUs=;
        b=fphpALaVIEfnqyB5cvasgBbcJXegGdGEP4dqYP7Wx35gQL/grJqyzG3gkicic0Kv33
         t88p4ltZWdyPCoZUjNs9aufEEOrFFggil6m6m9NoHkTGlPF0thd50JIW5mZ5FuXq5pzZ
         WzJV24/8TmbhD/nkN7LlwrfYjUGFiORU3jYZTZYGnDuvtnAkimL+hY3wYFxkh32lKUjI
         OruBgPMVW7zmE0o88Q6UflF38GbUWo8zsVHiHfngIJ+ZgGh4sOedrYdM9YNvx4+kQjSp
         D+CZaSbn7Vgpv+f/LlLLdAO92qbVWHasW1HNxOFQqbN9YDxcsjWbg6Bd+JQXTWeuE6K8
         wxMg==
X-Gm-Message-State: AOJu0Yyo7f/azmBfM//hikVeXulFdoIjqO/pmrTxdcG4zuGG/YR9ipXa
        TflXe1J5ZSqSw3Ih4lwP9do=
X-Google-Smtp-Source: AGHT+IHxouLeIA8w7ZLxU+cwGHPBPYjrc7MBM8iqdPMNaRTnx++vroBd3oyuEVRyJdWkpO1nQwqY+A==
X-Received: by 2002:a0c:a9d6:0:b0:63f:7b1a:4368 with SMTP id c22-20020a0ca9d6000000b0063f7b1a4368mr2946846qvb.11.1691594023567;
        Wed, 09 Aug 2023 08:13:43 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id l1-20020a0c9781000000b0062fffa42cc5sm4567408qvd.79.2023.08.09.08.13.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 08:13:42 -0700 (PDT)
Message-ID: <9fe9a2e5-3d0b-9a6f-e136-edb0a64117e0@gmail.com>
Date:   Wed, 9 Aug 2023 11:13:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 01/10] engines:io_uring: add missing error during open
 file
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
 <CGME20230809055413epcas5p2b3c6bfe3a2a8e7aef81b4a6c9b2e7a28@epcas5p2.samsung.com>
 <20230809111314.76947-2-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230809111314.76947-2-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/9/23 07:13, Ankit Kumar wrote:
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   engines/io_uring.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index b361e6a5..135b982d 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -1119,6 +1119,7 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
>   						"(LBA data size + Metadata size)\n");
>   				else
>   					log_err("block size must be a multiple of LBA data size\n");
> +				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
>   				return 1;
>   			}
>                   }

Please add a commit message like:

This change ensures the error is propogated to upper layers to make fio 
exit with a non-zero return code.
