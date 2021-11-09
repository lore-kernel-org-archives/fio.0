Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82860C433F5
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68AC1611C5
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbhKIGWX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 01:22:23 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:53346 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhKIGWW (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 01:22:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636438774; x=1667974774;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Z3wuvVOoy8YRxbrcFbC5V66xyjL6vP1VjWntTznAf24=;
  b=LoDgLZ9DorFJ098Jv8XaPmENOtsn8OnJal4dhIZ/CTnTqHtU/R6gb359
   HBdPEtFB5eaXyM1WwAlIgGyY95Wms0LO8WvBF0ouOUq0vqPJ8cOdnc8PP
   tVsDbPZn7IuS0NsF01p+22wZu8ogWQxO7RuBwHbYZTiJN+1fYK4O1TrPG
   p/u1IfTsGDZeCMolTDf27ILMCW5X+rltYPy9kp00c4Cq9o7wwsymiOoyv
   e4DC6edhbcWassLBZDiRW+YwLx1t3LvClZBaairfCpfOVny9ifxSahiEp
   jwaN+jtK+bZA+35tl4g6hvpKZKWP8Y60Y4WUIHgx6rmowrjHVCu/AyOI5
   w==;
X-IronPort-AV: E=Sophos;i="5.87,219,1631548800"; 
   d="scan'208";a="185093284"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 14:19:34 +0800
IronPort-SDR: sG8+lG2HJY3nhUoHH+Bw0PQhXl8E7hgUWYoGbSrHPNYk6P7dCTy4MGvOVC4lhY+IEVGEwnunxn
 JJK2UFLYGLcwYhvCX9+Vaht+LF3qRXkrBuLUYnYXGY634Qy6AQyaef7ZGsoeV9rozomHa4poS6
 vrzp7YAc4mXbHCixh3pAoYv8/yUV6eq5bEDN/JH0dM0ZQWVXzj/1H/+ieVjKLBAGnovBNwCGho
 OX1PB1Yz6zZJ77opuGrmD0MrOz1e9VW42VIFRyPX9LC0smrxaXXhcDpZxzzTS0737uS8D+rjRw
 AIDzMqseOlV8xjfcxfB5C1Gw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 21:54:48 -0800
IronPort-SDR: P6SMH0qw64i3O4zuKfFIBVDCW0RavoMdL8ba3GsNiLIGMWD12sObySArIkbLoJGMyhlOpr8maJ
 TA2gjO52b2p/+Bj7qS6Zh3I+E1k38419NQ74sLuT0oYPpt4SlFbOe45UsS3DnyOQVkGdg0HcTo
 ME3Q12+eaE/YEDdHgaw1IlKO5tP4e2MkefIsr17zuBnWqR+wXIfymypkb+nlms9pzaVSSQJzws
 JBTJBGheXIvHUAWC6aZqo4NKFBZ/6X95ekZP8bXkax0GrAiGLGI5Sw9xYvCCOVrd+xf4J3ZqPk
 O5c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:19:37 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HpHrR3nKnz1RtVm
        for <fio@vger.kernel.org>; Mon,  8 Nov 2021 22:19:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636438775; x=1639030776; bh=Z3wuvVOoy8YRxbrcFbC5V66xyjL6vP1VjWn
        tTznAf24=; b=tDgQOeq5TjVldMuwYEdNhrRe2doPoArwEi+XaDmDd0iTO4qTbe+
        /60YaebTaYJkJx7cGMZVXFQRgVjR0UUVXYMNCMgoSXJdr2yZPJp7p+lzRIxyXW4v
        QE+AfxSBXuvL3y0oCukqpgWomHKwpp+OjSUboBRB5MhfyZ2jyzg9noX0JSjhfxDb
        dNQTUTS/Dc7b5vviCqWDQjYk+Wt41PK10xaizh+MhACngMqm8EFdc5i/MsQT2dO5
        jmwaDZuzTGw9sSJDColzUwrv8Cmzf95GYd2/rwM70sHaamCWC3zeH9z8Wpii/hqw
        s0id8dp9K8lwb2herYuUSHdzpOGgP/Ioq1Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tHH4mYewTaR1 for <fio@vger.kernel.org>;
        Mon,  8 Nov 2021 22:19:35 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HpHrQ4TL0z1RtVl;
        Mon,  8 Nov 2021 22:19:34 -0800 (PST)
Message-ID: <060cee13-1e93-69e5-e4c5-11ffb4643352@opensource.wdc.com>
Date:   Tue, 9 Nov 2021 15:19:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 5/8] libaio,io_uring: rename prio_prep() to include
 cmdprio in the name
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-6-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109002655.117274-6-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/09 9:28, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The default priority (which is either 0 or the value set by "prio" and
> "prioclass" options, will now be used regardless if prio_prep() is
> called or not. This is true for both libaio and io_uring.
> 
> The way to think about it is that prio_prep() is only called if
> cmdprio_percentage/cmdprio_bssplit is used.
> 
> prio_prep() might then override the default priority, if the random
> value happens to say that this I/O should use the cmdprio_value,
> rather than the default priority.
> 
> Rename the prio_prep() functions to highlight that these functions
> are now only called if cmdprio is used. (If only option
> "prio"/"prioclass" is used, that is handled elsewhere.)
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  engines/io_uring.c | 9 +++++----
>  engines/libaio.c   | 4 ++--
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 8f3d6c39..de1e6cc9 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -346,8 +346,8 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
>  		 * (option prio/prioclass) to be inherited.
>  		 * td->ioprio will have the value of the "default prio", so set
>  		 * this unconditionally. This value might get overriden by
> -		 * fio_ioring_prio_prep() if cmdprio_percentage/cmdprio_bssplit
> -		 * is enabled.
> +		 * fio_ioring_cmdprio_prep() if
> +		 * cmdprio_percentage/cmdprio_bssplit is enabled.
>  		 */
>  		sqe->ioprio = td->ioprio;
>  		sqe->off = io_u->offset;
> @@ -456,7 +456,7 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
>  	return r < 0 ? r : events;
>  }
>  
> -static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u)
> +static void fio_ioring_cmdprio_prep(struct thread_data *td, struct io_u *io_u)
>  {
>  	struct ioring_options *o = td->eo;
>  	struct ioring_data *ld = td->io_ops_data;
> @@ -517,7 +517,8 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
>  		return FIO_Q_BUSY;
>  
>  	if (ld->use_cmdprio)
> -		fio_ioring_prio_prep(td, io_u);
> +		fio_ioring_cmdprio_prep(td, io_u);
> +
>  	ring->array[tail & ld->sq_ring_mask] = io_u->index;
>  	atomic_store_release(ring->tail, next_tail);
>  
> diff --git a/engines/libaio.c b/engines/libaio.c
> index dd655355..9c14dd88 100644
> --- a/engines/libaio.c
> +++ b/engines/libaio.c
> @@ -205,7 +205,7 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
>  	return 0;
>  }
>  
> -static void fio_libaio_prio_prep(struct thread_data *td, struct io_u *io_u)
> +static void fio_libaio_cmdprio_prep(struct thread_data *td, struct io_u *io_u)
>  {
>  	struct libaio_options *o = td->eo;
>  	struct cmdprio *cmdprio = &o->cmdprio;
> @@ -369,7 +369,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
>  	}
>  
>  	if (ld->use_cmdprio)
> -		fio_libaio_prio_prep(td, io_u);
> +		fio_libaio_cmdprio_prep(td, io_u);
>  
>  	ld->iocbs[ld->head] = &io_u->iocb;
>  	ld->io_us[ld->head] = io_u;
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
