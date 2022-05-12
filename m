Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE01C433F5
	for <fio@archiver.kernel.org>; Thu, 12 May 2022 16:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356489AbiELQyr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 May 2022 12:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356716AbiELQyr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 May 2022 12:54:47 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70C5268669
        for <fio@vger.kernel.org>; Thu, 12 May 2022 09:54:44 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id o190so5996559iof.10
        for <fio@vger.kernel.org>; Thu, 12 May 2022 09:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UKhmd335kQgjiMaXmtA8s5aPI0NV040m7EKrqeMdxMs=;
        b=BSwvYcRmsGdJETn8iqVwvnIpw2qBWrZ6tdAaSFWyRrrvErTfW4qzuyxSxT/rEMjxpY
         vX3gh+hT4cYLKtveJQJVh9LJYPqisd6IxQK3QxyNiRZ8grQD2nomPl5wdrHgm8U7djV+
         s7eufvJWjaFEubXONJU/X5Ioe5ux9bxJd4ee6cIRnG2yRr6VL3h+aJNv97OYxObmWZIT
         rGqNxRBH0Vv6BBd/J5Kt9wfLvCqP+lqh9rTFmIwzyyn4kBrQLrfSX9Gx4B1+No28HgW7
         Qp8R429/jWMqvzqlShOeNMMhEblG6W8g1RDjWUU4uqTZue4Kid8cNbNmDAKKiFAvkFrx
         m7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UKhmd335kQgjiMaXmtA8s5aPI0NV040m7EKrqeMdxMs=;
        b=3mve45/mRyqHlfmtu0pPn/WsQj5l/n+4QSH2hkxUJ+57AI4T4ucwAD4td2JG6uGmFJ
         74rwUbp5g2YkXBuyG6sfggLX059uofMUp79ScDJiAqOPqAHZyZIsgEVzLPS1qbDFH1vQ
         bJPdKBRMZb9oVAY/GlHWd+Ase3dDElrhXD4EM/mxa83s3iv4EyvL0K1+xaQ0eTSdddMx
         0MhRqOguX2/U2HNvlwqzYnIsIcSrnLZFC9zDRd9BOx3ETwkNauSsED/liBbCEo/MB9jC
         /RIxJhRAifC4wTgzbB9B40d/qJGsDlrnsLLtoWtqUocQeC8k6z9vagflllDSGYzhMkMC
         ZfUA==
X-Gm-Message-State: AOAM533gnq+njcUpEOrUV3hvIQ1Y80+OKuPhLXQ0zPzzEx6BIyQXCyq8
        TKMD+RsE0Jc/2SHAufKlbPEFyolsH9Cbxw==
X-Google-Smtp-Source: ABdhPJx4dW4z1zbBTDyrF6Pnx4J/qo3AM2BR4dyLfb8cs3p85Ouq3Ft/V/E0zh48LU8UpZErDxSYyw==
X-Received: by 2002:a05:6602:1614:b0:65a:c414:5aa0 with SMTP id x20-20020a056602161400b0065ac4145aa0mr475633iow.60.1652374484273;
        Thu, 12 May 2022 09:54:44 -0700 (PDT)
Received: from [192.168.1.170] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w197-20020a022ace000000b0032b5e4281d3sm9811jaw.62.2022.05.12.09.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 09:54:43 -0700 (PDT)
Message-ID: <7c486e95-e0bc-a991-67b3-97cbbfe9e20b@kernel.dk>
Date:   Thu, 12 May 2022 10:54:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 2/3] json: Change `if (!strlen(str))` to `if (!str[0])`
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220512164333.46516-1-ammarfaizi2@gnuweeb.org>
 <20220512164333.46516-3-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220512164333.46516-3-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/12/22 10:43, Ammar Faizi wrote:
> No need to traverse the whole string. Using `!strlen(str)` as a
> *conditional expression* is effectively the same with `!str[0]`.
> 
> Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  json.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/json.c b/json.c
> index cd3d5d74..8b650721 100644
> --- a/json.c
> +++ b/json.c
> @@ -56,7 +56,7 @@ static char *strdup_escape(const char *str)
>  	char *p, *ret;
>  	int escapes;
>  
> -	if (!strlen(str))
> +	if (!str[0])
>  		return NULL;

This seems like a useless optimization, strlen() should already be
doing this.

-- 
Jens Axboe

