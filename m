Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB87C77B7A
	for <fio@archiver.kernel.org>; Wed,  7 Jun 2023 15:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235862AbjFGPcX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Jun 2023 11:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbjFGPcW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2023 11:32:22 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DB59E
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 08:32:21 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-51f64817809so841089a12.1
        for <fio@vger.kernel.org>; Wed, 07 Jun 2023 08:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686151941; x=1688743941;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0jsJQSrlpaX52IpTl2fdi8T3fpLS0vVz++8YeqKWa3M=;
        b=mlFd+ORxMFS0BxoPTPeNkYZsz5GDN2sCLQjLyk4HUAchMscDmStKmeEbRq8U9yx2rf
         v9ijNxJTLHKVT3C8TvHDvyrUY04hcQYf5AZQYVSb19aiLf16u6FF4WD0GKIKrWRGX4hN
         cVw+w/AG6YbZ8OwjHtE4NkunJTPuFHI8KRO/l425AnLcIU8vibnG3DpaWb57lD2E+r3Y
         hPwAF2wW9uKHdQuIZ+oeEH/FOBy4H7KNS+SVfGWRdNzfVBm5etUCly3g56PY+1GGrizq
         JsN5Cr+EdVyIINgQP4v9tjR9dfv77FbGIEvk7NzNkpiTGzORzPKbNHH6kJumXGP0Wt8m
         1Fjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151941; x=1688743941;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0jsJQSrlpaX52IpTl2fdi8T3fpLS0vVz++8YeqKWa3M=;
        b=cbogciVj1eQZlexBaVguAA5cVXQ1uCw8PoxglLOW+aD8Epttz10totZ3upKCTxa+3u
         bMZG0761NjqGJ8qSHNgRHEA2Upwkjko6AG4/9oViPkBY9IXkIBMxIZ0YF9kCcVX5Wzxf
         YwaErX6BXV03YNNSc0XeTWcUOcYRTxELfoioWm79IQ9332IPRmhGDOYySOd3gG3YKKYl
         1P6p6tvf8hjeIC99g8cB7GgDdsGr2wVwk+LhmIQLl8QL3KypogUGLBZGWkMFiQvblQhL
         9ulgoWv+okMv3XH2kML81kFjUWYumOnD7Gu1O3dcXh7TUdcE532666ZnsntKXSiwdU0e
         Oiww==
X-Gm-Message-State: AC+VfDzj2HnL5Mq4TBZl1yfPI1Gk0M9FO1EqNQQzrsAS0BxlutHYocJo
        xiDAZAuTx4TalL711Yt//yPWiA==
X-Google-Smtp-Source: ACHHUZ4Gc6Lg8AJfKBM+Sf74vBPgKJMKJux7h09NrRSjItBw9ELcrjSQvpCKaz2XAxLgSFfPS+py5Q==
X-Received: by 2002:a05:6a00:1948:b0:662:2d7a:7c68 with SMTP id s8-20020a056a00194800b006622d7a7c68mr2009495pfk.2.1686151940621;
        Wed, 07 Jun 2023 08:32:20 -0700 (PDT)
Received: from ?IPV6:2600:380:c049:5bf4:2666:2ba0:4f97:cce7? ([2600:380:c049:5bf4:2666:2ba0:4f97:cce7])
        by smtp.gmail.com with ESMTPSA id k3-20020aa790c3000000b0064cca73d911sm5847438pfk.103.2023.06.07.08.32.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 08:32:19 -0700 (PDT)
Message-ID: <ea7317bd-46fd-6165-f652-8b47ad7e9853@kernel.dk>
Date:   Wed, 7 Jun 2023 09:32:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 4/7] zbd: fix write zone accounting of trim workload
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
 <20230607083230.1178573-5-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230607083230.1178573-5-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 6/7/23 2:32?AM, Shin'ichiro Kawasaki wrote:
> @@ -339,6 +339,33 @@ static void zbd_write_zone_put(struct thread_data *td, const struct fio_file *f,
>  	z->write = 0;
>  }
>  
> +/**
> + * zbd_reset_zone - reset the write pointer of a single zone and remove the zone
> + *                  from the array of write zones.
> + * @td: FIO thread data.
> + * @f: FIO file associated with the disk for which to reset a write pointer.
> + * @z: Zone to reset.
> + *
> + * Returns 0 upon success and a negative error code upon failure.
> + * The caller must hold z->mutex.
> + */
> +static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
> +			  struct fio_zone_info *z)
> +{
> +	int ret;
> +
> +	ret = __zbd_reset_zone(td, f, z);
> +	if (ret)
> +		goto done;
> +
> +	pthread_mutex_lock(&f->zbd_info->mutex);
> +	zbd_write_zone_put(td, f, z);
> +	pthread_mutex_unlock(&f->zbd_info->mutex);
> +
> +done:
> +	return ret;
> +}

This would look better as:

{
	int ret;

	ret = __zbd_reset_zone(td, f, z);
	if (ret)
		return ret;

	pthread_mutex_lock(&f->zbd_info->mutex);
	zbd_write_zone_put(td, f, z);
	pthread_mutex_unlock(&f->zbd_info->mutex);
	return 0;
}

to avoid that goto. Goto only makes sense if there's common cleanup to
do for multiple error cases, not for a single failure where you can just
return the error.

-- 
Jens Axboe

