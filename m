Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1FEECAAD8
	for <fio@archiver.kernel.org>; Tue, 13 Sep 2022 17:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiIMRVh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 13 Sep 2022 13:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiIMRVJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Sep 2022 13:21:09 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB949A9B7
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 09:07:59 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id r20so8296704qtn.12
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 09:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=OZBBL9fS/XfUpNNFiSraIM7FCkR766E9spkRsz2Td/o=;
        b=OuPNnCSNmjvg2OoAVJPmrblzQoLPT0O4/UVIgucvhdLab6LnD8aZxG7gu39aCi5Lnk
         fwOxFErhog8w7gDyhYqW3pZU2/0jF6fpps+PoDhsI99VdMvdG94xe1dGS+99Rnjwb6Ud
         kg0RvS0V8VYdnxgLqUxsxj0Auimej64cT3uS/w/OQP12ti9YkkdlR+yvbR1iJofE/Ncp
         t2r3lNOvXg6rzbCdIfUoJMGRhOBR3CP4So3vBYjU2UrUgZNAefJy1whqCXsGBtNe8NJE
         /Ya8PHFM1YKd/aR5quNAILMEJq/CH1k5HZWvFpYEhHJWacVL3yCiTOd91VDnSfByykFd
         93hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=OZBBL9fS/XfUpNNFiSraIM7FCkR766E9spkRsz2Td/o=;
        b=uRuzfkerF4f5rN2Qd8BicrYnOEChoA50mOYqvLZUcjPlRVAeYmcAr0YWML/Clb32nh
         pKQJyvPfm/2d4Ifn7iAp7DZn3Cp9TSuJEbxZanAE9B7WAafofs/e+oyqG0qhNafJyZf3
         EQp69AOoxs272yMjEiB7AfK2oxwFKQDj95h82SEPjPOvOycVL/XlYb/Zkc5e1jcHU8Pq
         yarLAl9kBSquDDgPctTtR7FvIz2wLCJKANj7jeuQ5gA1GaKV6Mte06astLX/yORtmDiz
         hKw8XemTkbIDSnYAja/mjXcEcFAfnUXtrkQh9SHTAb/iIR+I4+xse78Ex7Xb9KzBVYSE
         UGKQ==
X-Gm-Message-State: ACgBeo3kJepzbZBcICRoXrrbjBNZ14rIJvWqsqK6t2WbMVUeOQFN1tpP
        EQnzXv0qaMw6Exym7hEAw+M=
X-Google-Smtp-Source: AA6agR5MyvapSn2LZIuw6lLuevc/efXVzmwmXOQIp/wyIGY1Lk24I1IjUnWZG7iLyJGmIYJvdV/WWQ==
X-Received: by 2002:ac8:5f46:0:b0:35b:b279:1d76 with SMTP id y6-20020ac85f46000000b0035bb2791d76mr10197867qta.98.1663085277691;
        Tue, 13 Sep 2022 09:07:57 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id w14-20020a05620a0e8e00b006b5c061844fsm9603089qkm.49.2022.09.13.09.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 09:07:56 -0700 (PDT)
Message-ID: <8b947201-1c71-d151-4748-0e80cfda4d04@gmail.com>
Date:   Tue, 13 Sep 2022 12:07:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/1] backend: number of ios not as expected for trimwrite
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org
References: <20220913104527.18734-1-ankit.kumar@samsung.com>
 <CGME20220913105532epcas5p43dcd5a649dbad6bc6d39574677cb73b9@epcas5p4.samsung.com>
 <20220913104527.18734-2-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20220913104527.18734-2-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/13/22 06:45, Ankit Kumar wrote:
> number_ios should be twice for trimwrite, just like size or
> io_size. Update the documentation for "rw=trimwrite" to explain the
> changes.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   HOWTO.rst | 6 +++++-
>   backend.c | 6 ++++--
>   fio.1     | 5 ++++-
>   3 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 2c6c6dbe..924f5ed9 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -1129,7 +1129,11 @@ I/O type
>   				Random mixed reads and writes.
>   		**trimwrite**
>   				Sequential trim+write sequences. Blocks will be trimmed first,
> -				then the same blocks will be written to.
> +				then the same blocks will be written to. So if ``io_size=64K``
> +				is specified, Fio will trim a total of 64K bytes and also
> +				write 64K bytes on the same trimmed blocks. This behaviour
> +				will be consistent with ``number_ios`` or other Fio options
> +				limiting the total bytes or number of I/O's.
>   
>   	Fio defaults to read if the option is not specified.  For the mixed I/O
>   	types, the default is to split them 50/50.  For certain types of I/O the
> diff --git a/backend.c b/backend.c
> index fe614f6e..ec535bcc 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -971,9 +971,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
>   		total_bytes += td->o.size;
>   
>   	/* In trimwrite mode, each byte is trimmed and then written, so
> -	 * allow total_bytes to be twice as big */
> -	if (td_trimwrite(td))
> +	 * allow total_bytes or number of ios to be twice as big */
> +	if (td_trimwrite(td)) {
>   		total_bytes += td->total_io_size;
> +		td->o.number_ios *= 2;
> +	}
>   
>   	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
>   		(!flist_empty(&td->trim_list)) || !io_issue_bytes_exceeded(td) ||
> diff --git a/fio.1 b/fio.1
> index 67d7c710..c67bd464 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -900,7 +900,10 @@ Random mixed reads and writes.
>   .TP
>   .B trimwrite
>   Sequential trim+write sequences. Blocks will be trimmed first,
> -then the same blocks will be written to.
> +then the same blocks will be written to. So if `io_size=64K' is specified,
> +Fio will trim a total of 64K bytes and also write 64K bytes on the same
> +trimmed blocks. This behaviour will be consistent with `number_ios' or
> +other Fio options limiting the total bytes or number of I/O's.
>   .RE
>   .P
>   Fio defaults to read if the option is not specified. For the mixed I/O

This is the right behavior because io_size and number_ios should be 
consistent. But this will require folks who have worked around the 
inconsistent behavior to adjust. I'll let Jens make the final call on 
this one.

Reviewed-by: Vincent Fu <vincent.fu@samsung.com>
