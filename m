Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AF5C433EF
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 00:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DED860FBF
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 00:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbhKLAzI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 11 Nov 2021 19:55:08 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45499 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbhKLAzH (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Nov 2021 19:55:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636678337; x=1668214337;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BvR/A7vT5fyUbq1REMYR6bYCXNGcjLuBWwUWq+bgFgY=;
  b=RI3Rx7Qj3dxCraovvJCIivNZxw3XUqBDCTYfwPk1Oj+2aQ0eVcmcUoJw
   FQYWd2z14MA3Gpu8MoHulBLdWYBmB6zY8BupAYF9AT3QOGz/70yKIsYCV
   68ewqXBXlEoF9vUc/dtSICEjhGXVNrVfhf3/3gGPGYqKmu19RGt/CLaij
   rM9nUl+W0dwNrBuSElIeo4tJt5ZuK2TJfV9RsBA6jHOtZIF4Tpy22AvM0
   sND14SEDqTjzmOyDHOqNc/9SEtBZaBDE+zvKMNr9CReuYQ8RMQ2cpHgs3
   agUCKrx4YnleE+Xfw6S2rCmmYuAcBlqSOglsdEZOPITkFpJAfP3MiPcXt
   A==;
X-IronPort-AV: E=Sophos;i="5.87,227,1631548800"; 
   d="scan'208";a="185393720"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 08:52:16 +0800
IronPort-SDR: wWFA/qcchrkk7kxEo5fqTn37Nb5Tpz1I3NiS49fNurMbLq+Kw3TM7vPQ1jiIg1NAsjn3lmps1R
 agyjQ+kFmubEReeG+5VzlXJ8lk1TeHmRHqT3CenFBtR0EMjRLsV+331ICwUFiLMyRuTM+ABazB
 q6ig2To1sWVr68psy5be303a+panfrQuwTd4Ju9mgRk6bnh92CdnNbUAxRh82gOOVd6eWYvDsk
 KNVnt2VV4Tk0tLRepoqC2QTYTAExYmDT1073Fg7Oj10qfBDaAIGp3wx1xkqPIGkEjzHOovZHrH
 u7iWZ9tppSUGSKUJ8ptNdMK4
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 16:27:25 -0800
IronPort-SDR: YwujUG/2U0SW3eD+gKIqX33A4t7B+4vkrNBbFaQ7mYBP8XMckhH/ejzVnx3iYNxB2XM4DA8Ppr
 8BJQzHmCyZXrxBrtVXfjpeJJkjKNPncR7VSWk0zcCPDD9MTpCabSEKFq78v+OLqVJ1FoubRJrP
 ZOP8hJheOEgHFk4G28P9qJA8Bu1WI07m04TqWeDFr1m/ddEJr27yGUTxllztq4HeBkOcNqi4sQ
 6yozmqXxQ7HfysLEkTkd0mvMzpWdoZeyLKzCV00h5GQxnTSPcQrq+Bur3OYJ6CqE0Ls4L+U/2y
 FRU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 16:52:17 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Hr0RN1nq1z1RtVn
        for <fio@vger.kernel.org>; Thu, 11 Nov 2021 16:52:16 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636678335; x=1639270336; bh=BvR/A7vT5fyUbq1REMYR6bYCXNGcjLuBWwU
        Wq+bgFgY=; b=JIgVrINXENz4mKbsg/veofuUEi3Y3iPUvrzAZD7qWnRp1CwHDTQ
        UQ6hpnhKtLftUTrtXFF1hALdN0bIOtt9izIb1P5BngGpZPwGxMibKB8YWGEColoY
        Agt6Rr0GcOWgATaNkNsDZxDFuRAuMTK+3OzJG0x9LmP6WOqUXy0etJW7tLnJ6fjY
        7nKmkGfdmpQTxs7F1hjDhYgQAxZGgoXBHKPxAhubVaQ0uf4a1NRA8kzlho6C8mSp
        12pLZtd820ZBQ+TQqwprnN0BgzRWpM14CQ6liYFr4Bz8hH50CUc2LZ4rtxX4WwX5
        Q33QZkCRJzR81ZDqmm6oxXW//lK7a8c3trw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DPvZ0rcB5lAK for <fio@vger.kernel.org>;
        Thu, 11 Nov 2021 16:52:15 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Hr0RL5bcpz1RtVl;
        Thu, 11 Nov 2021 16:52:14 -0800 (PST)
Message-ID: <50ee78eb-56de-3c81-ae3a-d7857d900120@opensource.wdc.com>
Date:   Fri, 12 Nov 2021 09:52:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v2 6/8] libaio,io_uring: move common cmdprio_prep() code
 to cmdprio
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
 <20211109233804.164786-7-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109233804.164786-7-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/10 8:38, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Move common cmdprio_prep() code to cmdprio.c to avoid code duplication.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  engines/cmdprio.c  | 41 ++++++++++++++++++++++++++++++++++++++++-
>  engines/cmdprio.h  |  3 ++-
>  engines/io_uring.c | 34 ++++++----------------------------
>  engines/libaio.c   | 28 +++++-----------------------
>  4 files changed, 53 insertions(+), 53 deletions(-)
> 
> diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> index 2c764e49..9cad76b5 100644
> --- a/engines/cmdprio.c
> +++ b/engines/cmdprio.c
> @@ -67,7 +67,7 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
>  	return ret;
>  }
>  
> -int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
> +static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
>  {
>  	enum fio_ddir ddir = io_u->ddir;
>  	unsigned int p = cmdprio->percentage[ddir];
> @@ -89,6 +89,45 @@ int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
>  	return 0;
>  }
>  
> +/**
> + * fio_cmdprio_set_ioprio - Generates a random value. If the random value is
> + * within the user specified percentage of I/Os that should use a cmdprio
> + * priority value (rather than the default priority), then this function
> + * updates the io_u with a cmdprio priority value.
> + */

This comment is not very precise in its description. What about this:

/**
 * fio_cmdprio_set_ioprio - Set an io_u ioprio according to cmdprio options
 *
 * Generates a random percentage value to determine if an io_u ioprio needs
 * to be set. If the random percentage value is within the user specified
 * percentage of I/Os that should use a cmdprio priority value (rather than
 * the default priority), then this function updates the io_u with an ioprio
 * value as defined by the cmdprio/cdmprio_class or cmdprio_bssplit options.
 *
 * Return true if the io_u ioprio was changed and false otherwise.
 */

> +bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
> +			    struct io_u *io_u)
> +{
> +	enum fio_ddir ddir = io_u->ddir;
> +	unsigned int p = fio_cmdprio_percentage(cmdprio, io_u);
> +	unsigned int cmdprio_value =
> +		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
> +
> +	if (p && rand_between(&td->prio_state, 0, 99) < p) {
> +		io_u->ioprio = cmdprio_value;
> +		if (!td->ioprio || cmdprio_value < td->ioprio) {
> +			/*
> +			 * The async IO priority is higher (has a lower value)
> +			 * than the default priority (which is either 0 or the
> +			 * value set by "prio" and "prioclass" options).
> +			 */
> +			io_u->flags |= IO_U_F_HIGH_PRIO;
> +		}
> +		return true;
> +	}

Nit: a blank line here would be nice, for readability.

> +	if (td->ioprio && td->ioprio < cmdprio_value) {
> +		/*
> +		 * The IO will be executed with the default priority (which is
> +		 * either 0 or the value set by "prio" and "prioclass options),
> +		 * and this priority is higher (has a lower value) than the
> +		 * async IO priority.
> +		 */
> +		io_u->flags |= IO_U_F_HIGH_PRIO;
> +	}
> +
> +	return false;
> +}
> +
>  int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
>  		     bool *has_cmdprio)
>  {
> diff --git a/engines/cmdprio.h b/engines/cmdprio.h
> index d3265741..732b087e 100644
> --- a/engines/cmdprio.h
> +++ b/engines/cmdprio.h
> @@ -22,7 +22,8 @@ struct cmdprio {
>  int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
>  			      struct cmdprio *cmdprio);
>  
> -int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u);
> +bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
> +			    struct io_u *io_u);
>  
>  int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
>  		     bool *has_cmdprio);
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 6f90e0a7..230f08a5 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -456,37 +456,15 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
>  	return r < 0 ? r : events;
>  }
>  
> -static void fio_ioring_cmdprio_prep(struct thread_data *td, struct io_u *io_u)
> +static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
> +					   struct io_u *io_u)
>  {
> -	struct ioring_options *o = td->eo;
>  	struct ioring_data *ld = td->io_ops_data;
> -	struct io_uring_sqe *sqe = &ld->sqes[io_u->index];
> +	struct ioring_options *o = td->eo;
>  	struct cmdprio *cmdprio = &o->cmdprio;
> -	enum fio_ddir ddir = io_u->ddir;
> -	unsigned int p = fio_cmdprio_percentage(cmdprio, io_u);
> -	unsigned int cmdprio_value =
> -		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
> -
> -	if (p && rand_between(&td->prio_state, 0, 99) < p) {
> -		io_u->ioprio = cmdprio_value;
> -		sqe->ioprio = cmdprio_value;
> -		if (!td->ioprio || cmdprio_value < td->ioprio) {
> -			/*
> -			 * The async IO priority is higher (has a lower value)
> -			 * than the default priority (which is either 0 or the
> -			 * value set by "prio" and "prioclass" options).
> -			 */
> -			io_u->flags |= IO_U_F_HIGH_PRIO;
> -		}
> -	} else if (td->ioprio && td->ioprio < cmdprio_value) {
> -		/*
> -		 * The IO will be executed with the default priority (which is
> -		 * either 0 or the value set by "prio" and "prioclass options),
> -		 * and this priority is higher (has a lower value) than the
> -		 * async IO priority.
> -		 */
> -		io_u->flags |= IO_U_F_HIGH_PRIO;
> -	}
> +
> +	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u))
> +		ld->sqes[io_u->index].ioprio = io_u->ioprio;
>  }
>  
>  static enum fio_q_status fio_ioring_queue(struct thread_data *td,
> diff --git a/engines/libaio.c b/engines/libaio.c
> index 9c14dd88..dc6ad08e 100644
> --- a/engines/libaio.c
> +++ b/engines/libaio.c
> @@ -205,33 +205,15 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
>  	return 0;
>  }
>  
> -static void fio_libaio_cmdprio_prep(struct thread_data *td, struct io_u *io_u)
> +static inline void fio_libaio_cmdprio_prep(struct thread_data *td,
> +					   struct io_u *io_u)
>  {
>  	struct libaio_options *o = td->eo;
>  	struct cmdprio *cmdprio = &o->cmdprio;
> -	enum fio_ddir ddir = io_u->ddir;
> -	unsigned int p = fio_cmdprio_percentage(cmdprio, io_u);
> -	unsigned int cmdprio_value =
> -		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
> -
> -	if (p && rand_between(&td->prio_state, 0, 99) < p) {
> -		io_u->ioprio = cmdprio_value;
> -		io_u->iocb.aio_reqprio = cmdprio_value;
> +
> +	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u)) {
> +		io_u->iocb.aio_reqprio = io_u->ioprio;
>  		io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
> -		if (!td->ioprio || cmdprio_value < td->ioprio) {
> -			/*
> -			 * The async IO priority is higher (has a lower value)
> -			 * than the default context priority.
> -			 */
> -			io_u->flags |= IO_U_F_HIGH_PRIO;
> -		}
> -	} else if (td->ioprio && td->ioprio < cmdprio_value) {
> -		/*
> -		 * The IO will be executed with the default context priority,
> -		 * and this priority is higher (has a lower value) than the
> -		 * async IO priority.
> -		 */
> -		io_u->flags |= IO_U_F_HIGH_PRIO;
>  	}
>  }
>  
> 

With the above comment fix, looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research
