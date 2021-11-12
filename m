Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B8DC433EF
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 00:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F824610A0
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 00:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhKLAoX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 11 Nov 2021 19:44:23 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:18080 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbhKLAoW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Nov 2021 19:44:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636677693; x=1668213693;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UmwljDC1OfJY/UydER8U9ey9dCnTAPQTyCtPkSML4eQ=;
  b=M9tW9ZHT0tQ07Hu9o0HgngiwqeotzGeb6tcVqHcG1y0uZfTxStW/r+it
   /xmvxI+oFI9VSEyODO9Hud3cpr/sfH1Amuh1Iw4kvaXmfw40qkd5md7nz
   YZIAHi0oxvzJGuO2zAm8PurboCy89bE1OCGyM90ffvtTExmqfGMGQTFjL
   Rmp+I6hUkWLm6xhaXxnvDK1ES6IribXDB+GvJMe6wIAlgAidTgZy0TU2w
   YBjyDKQng8RM4u6lQJlaT8+3lr73gqF+eU6/1qYBidy96avlzKJwv/3Nd
   hQUOh98+ArIXbszJ0ER2kQXWYyxQCINzA76/Fm7tY5GHojEoU0+b6O56G
   g==;
X-IronPort-AV: E=Sophos;i="5.87,227,1631548800"; 
   d="scan'208";a="186391552"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 08:41:33 +0800
IronPort-SDR: 1/rfYr+Tid0wgxaYbq7cfnY5jB5Hpn6MprM5PlyfHSadLVEtI+pVebarr5IvhQx1UpY+kEVT9p
 bfmIoJ/b0DxQFjEPD1mOJVyEf9eLuxdd6f+xFMJrhzbajHhhMTp5ADpjILU3F56u5zfTgeYQhK
 SntkxCVl8koORo+jX0tqPO+MLOx6AH4YirEx8uIj68sGw+QwgVXHI8/i3k0agXtf/HvYgQccpU
 GsXug2KiFYgwa7CDSRSwC0+6BTqYAAZFw7/4WFDjPSflvsQWdvsvBZMvxoOhsKv/d+/MKhkVRd
 siTjAx4Kl4Dt51zvONhVG3Qe
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 16:16:41 -0800
IronPort-SDR: dP4bgjyqfQow6E8oYkcG829ikJderbF5oaMhO/iT8REThKE+SEuFsqChx1RDk+bCvTEoqxwRhX
 1VopXaKo5Bxfn71ngHZsoyPm/Yw38TARVTqgs7msg0Hqjg6GxjgXtovSaBlzaKVuEgJO8Ku68J
 nMEUSoi/YxGUmimB1XEbM5hqr9til/dI6CqreBbXn0ZKRBq8gR0KwLbJG17MCDFSD0hxkZ/PZk
 h0PvBERkFJ7G0PeZo1L9pp0m2RywMQQmxEsrhQzVHbrZHKBIMpuIBcMyaGMix1Djt13TdG7kOk
 DFE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 16:41:33 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Hr0C03LlZz1RtVn
        for <fio@vger.kernel.org>; Thu, 11 Nov 2021 16:41:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636677692; x=1639269693; bh=UmwljDC1OfJY/UydER8U9ey9dCnTAPQTyCt
        PkSML4eQ=; b=S49hTE8VEFycntulC4uD28NFiukFjb7frq6lo/dmdl2TON1KJ5Q
        9z2m4spJSOweESk4aV9beMXGaslpt0qBjRA7SsP2mRSIExw0NxVrgahMcVJXRibq
        NJy6NcqlLYSEkaJJGtLMA+FXV3WF/UULVQmtEazMeKrBTBdxU17VdYR6JsPM5oo2
        L9AqC0kKbOB1Ntt6EUw5vTfTp7Q49I+lH5A8EgsAKktN1mR7QbyYfrej3KIpWa89
        fT97tNnWfuIQJGtREDvNfFqehVJwGj1AiU5FUQtX9/KlpkXQCQoEmRHpP6qbISue
        aCxUeWuPhjEisSKyXDN4GUomY3TIcdIptwQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EeuFIiE66Fit for <fio@vger.kernel.org>;
        Thu, 11 Nov 2021 16:41:32 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Hr0Bz3cwnz1RtVl;
        Thu, 11 Nov 2021 16:41:31 -0800 (PST)
Message-ID: <2a53e49e-c224-81ee-085c-95c45b4f81a9@opensource.wdc.com>
Date:   Fri, 12 Nov 2021 09:41:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v2 4/8] io_uring: set async IO priority to td->ioprio in
 fio_ioring_prep()
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
 <20211109233804.164786-5-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109233804.164786-5-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/10 8:38, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The default priority (which is either 0 or the value set by "prio" and
> "prioclass" options) is now saved in td->ioprio.
> 
> The simplest thing is therefore to unconditionally set the async IO
> priority to td->ioprio in fio_ioring_prep(), and let fio_ioring_prio_prep()
> only handle the case where cmdprio_percentage/cmdprio_bssplit is enabled.
> 
> Therefore, fio_ioring_prio_prep() doesn't need to care if prio/prioclass
> was enabled or not, we can simply think that fio_ioring_prio_prep()
> might "override" the default priority, whatever the default priority may
> be.
> 
> Doing it this way also has the advantage that the prio_prep() function
> in io_uring will now look identical to the prio_prep() function in
> libaio.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  engines/io_uring.c | 51 ++++++++++++++++++++++------------------------
>  1 file changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 27a4a678..0e66398a 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -338,6 +338,18 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
>  			sqe->rw_flags |= RWF_UNCACHED;
>  		if (o->nowait)
>  			sqe->rw_flags |= RWF_NOWAIT;
> +
> +		/*
> +		 * Since io_uring can have a submission context (sqthread_poll)
> +		 * that is different from the process context, we cannot rely on
> +		 * the IO priority set by ioprio_set() (option prio/prioclass)
> +		 * to be inherited.
> +		 * td->ioprio will have the value of the "default prio", so set
> +		 * this unconditionally. This value might get overriden by

Nit: s/overriden/overridden

With this fixed, looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


> +		 * fio_ioring_prio_prep() if the option cmdprio_percentage or
> +		 * cmdprio_bssplit is used.
> +		 */
> +		sqe->ioprio = td->ioprio;
>  		sqe->off = io_u->offset;
>  	} else if (ddir_sync(io_u->ddir)) {
>  		sqe->ioprio = 0;
> @@ -456,29 +468,25 @@ static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u)
>  		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
>  
>  	if (p && rand_between(&td->prio_state, 0, 99) < p) {
> +		io_u->ioprio = cmdprio_value;
>  		sqe->ioprio = cmdprio_value;
>  		if (!td->ioprio || cmdprio_value < td->ioprio) {
>  			/*
>  			 * The async IO priority is higher (has a lower value)
> -			 * than the priority set by "prio" and "prioclass"
> -			 * options.
> -			 */
> -			io_u->flags |= IO_U_F_HIGH_PRIO;
> -		}
> -	} else {
> -		sqe->ioprio = td->ioprio;
> -		if (cmdprio_value && td->ioprio && td->ioprio < cmdprio_value) {
> -			/*
> -			 * The IO will be executed with the priority set by
> -			 * "prio" and "prioclass" options, and this priority
> -			 * is higher (has a lower value) than the async IO
> -			 * priority.
> +			 * than the default priority (which is either 0 or the
> +			 * value set by "prio" and "prioclass" options).
>  			 */
>  			io_u->flags |= IO_U_F_HIGH_PRIO;
>  		}
> +	} else if (td->ioprio && td->ioprio < cmdprio_value) {
> +		/*
> +		 * The IO will be executed with the default priority (which is
> +		 * either 0 or the value set by "prio" and "prioclass options),
> +		 * and this priority is higher (has a lower value) than the
> +		 * async IO priority.
> +		 */
> +		io_u->flags |= IO_U_F_HIGH_PRIO;
>  	}
> -
> -	io_u->ioprio = sqe->ioprio;
>  }
>  
>  static enum fio_q_status fio_ioring_queue(struct thread_data *td,
> @@ -820,7 +828,6 @@ static int fio_ioring_init(struct thread_data *td)
>  	struct ioring_options *o = td->eo;
>  	struct ioring_data *ld;
>  	struct cmdprio *cmdprio = &o->cmdprio;
> -	bool has_cmdprio = false;
>  	int ret;
>  
>  	/* sqthread submission requires registered files */
> @@ -845,22 +852,12 @@ static int fio_ioring_init(struct thread_data *td)
>  
>  	td->io_ops_data = ld;
>  
> -	ret = fio_cmdprio_init(td, cmdprio, &has_cmdprio);
> +	ret = fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
>  	if (ret) {
>  		td_verror(td, EINVAL, "fio_ioring_init");
>  		return 1;
>  	}
>  
> -	/*
> -	 * Since io_uring can have a submission context (sqthread_poll) that is
> -	 * different from the process context, we cannot rely on the the IO
> -	 * priority set by ioprio_set() (option prio/prioclass) to be inherited.
> -	 * Therefore, we set the sqe->ioprio field when prio/prioclass is used.
> -	 */
> -	ld->use_cmdprio = has_cmdprio ||
> -		fio_option_is_set(&td->o, ioprio_class) ||
> -		fio_option_is_set(&td->o, ioprio);
> -
>  	return 0;
>  }
>  
> 


-- 
Damien Le Moal
Western Digital Research
