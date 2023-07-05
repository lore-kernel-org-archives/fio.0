Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB9EEB64DD
	for <fio@archiver.kernel.org>; Wed,  5 Jul 2023 21:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjGEV6M (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Jul 2023 17:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbjGEV6H (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2023 17:58:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118879F
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 14:58:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E7D6176B
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 21:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EEBC433C8;
        Wed,  5 Jul 2023 21:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688594285;
        bh=VxO8iIwm8m74NbH5G3WHEtM38djPLhjZMkI9Zb0PtxU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GqGtYeulSVQQCc5Y0nNRbzvUbUTpITWp9zyhoorO/qRZ+z6QSHz5jlmFWEjX4HPWu
         ZrSWpS0KFqAjM4dQD87nEDTOLYIm5QF/XBn9vyxcgsD1SOCSZIj+QJbSe1sNx9ZGh3
         PjJmzA8L9i/KzF/swfj6bdXtW8HoyskWJPgJ6vHbK0wUGJSZrw+39hqbG++Bis0rN5
         d3saS7oF/psQzcyH1MzR0MjiJ4M4hNwS9X/f6UI3MlojH0uesjuF2i7R/oE7+ZXwB5
         qXExuZGwyMPKM4DsM3zQZiH0QSPbCci1RT63iEiq211ZanAMZUDYdVClRnR6+MQDVn
         s9LcG1tYaNPMw==
Message-ID: <34a1a73d-9edf-b3db-e9d5-e912febdb869@kernel.org>
Date:   Thu, 6 Jul 2023 06:58:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] zbd: Support finishing zones on Android
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     fio@vger.kernel.org,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20230705212915.3373438-1-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230705212915.3373438-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/6/23 06:29, Bart Van Assche wrote:
> BLKFINISHZONE is missing from older versions of the Android NDK header
> files. Hence, define BLKFINISHZONE if it has not been defined and detect
> at runtime whether or not the kernel supports finishing zones.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Late as Jens already applied the patch, but anyway, looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  oslib/linux-blkzoned.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
> index c3130d0e2a1b..722e09925b3d 100644
> --- a/oslib/linux-blkzoned.c
> +++ b/oslib/linux-blkzoned.c
> @@ -22,6 +22,9 @@
>  #include "zbd_types.h"
>  
>  #include <linux/blkzoned.h>
> +#ifndef BLKFINISHZONE
> +#define BLKFINISHZONE _IOW(0x12, 136, struct blk_zone_range)
> +#endif
>  
>  /*
>   * If the uapi headers installed on the system lacks zone capacity support,
> @@ -312,7 +315,6 @@ int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
>  int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
>  			 uint64_t offset, uint64_t length)
>  {
> -#ifdef BLKFINISHZONE
>  	struct blk_zone_range zr = {
>  		.sector         = offset >> 9,
>  		.nr_sectors     = length >> 9,
> @@ -327,21 +329,19 @@ int blkzoned_finish_zone(struct thread_data *td, struct fio_file *f,
>  			return -errno;
>  	}
>  
> -	if (ioctl(fd, BLKFINISHZONE, &zr) < 0)
> +	if (ioctl(fd, BLKFINISHZONE, &zr) < 0) {
>  		ret = -errno;
> +		/*
> +		 * Kernel versions older than 5.5 do not support BLKFINISHZONE
> +		 * and return the ENOTTY error code. These old kernels only
> +		 * support block devices that close zones automatically.
> +		 */
> +		if (ret == ENOTTY)
> +			ret = 0;
> +	}
>  
>  	if (f->fd < 0)
>  		close(fd);
>  
>  	return ret;
> -#else
> -	/*
> -	 * Kernel versions older than 5.5 does not support BLKFINISHZONE. These
> -	 * old kernels assumed zones are closed automatically at max_open_zones
> -	 * limit. Also they did not support max_active_zones limit. Then there
> -	 * was no need to finish zones to avoid errors caused by max_open_zones
> -	 * or max_active_zones. For those old versions, just do nothing.
> -	 */
> -	return 0;
> -#endif
>  }

-- 
Damien Le Moal
Western Digital Research

