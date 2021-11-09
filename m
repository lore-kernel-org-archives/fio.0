Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8696FC433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD5C61027
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhKIGcW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 01:32:22 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10321 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhKIGcW (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 01:32:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636439376; x=1667975376;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5Otbm4VK8GWcaLEqeAHPVaKWrvPosNwzFrv/TiWEG9w=;
  b=OF0GBGBsM7fjYd7vIfZvrCjidqApBokoq9e4+ngyJSOprcIkJLwwD1ig
   A1bK/srBm1C24a5sy2M93s3B69jIDysz9zi4pYSdS5bzjZKSUyZRx13aC
   Yhcrz1H/U3RDYm3sjmxUc4ORNiJVqWixcFjd7J0UOx66LaLfkObMrwTNc
   EeP8bkumU9qfHrQB9qHo5bcXjAG22GSGq/aWeX4U9z+PJ+pnCKGinUpn0
   B2VTudcSd9cKa+j6JynZejQYMuvI1D0xS9ybu7+bqBqtRnjcI+rIBO+Dp
   3lN9nJOUzWo4pw4ghf2V4DSn4zjZra7xdQIvSL6R2+Tt1h0jK02/zG6l5
   A==;
X-IronPort-AV: E=Sophos;i="5.87,219,1631548800"; 
   d="scan'208";a="184095587"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 14:29:36 +0800
IronPort-SDR: aNg0Kgv1Qbe1GNPlOKbVL9AG/PeVWQkP0+xWGSoafacdNBeTRgLyQaEnVLsU14LrLsgVBPYgzO
 XRA8ICuanyAq3uHg6XhEM1pLyusTEJSlvhGPHnkheqVvzxy8tvKAWjwbvWY+py6+z0henE5nn7
 ReRlKMFPTgqjxv/WZAb5pk/FG6Yhm7mGkOX8dEMMeR94iIeNlyJgeqzxbrR0u2js3QSYLrVKyI
 x589g7JMnjnBobjiWsQ81QbLs56phcLGaXACqXtPDdbeFeXyFtB4SawqFujay/BCm488d6ipm2
 e+bCsOjnc29VHbjTtLbRzwwF
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:03:16 -0800
IronPort-SDR: r0qOBUUxAZvxBbvRLcytOSnk5/6gvhIojx0FIy5Z/J7t7Ufj/psiUysoEcmMB8pcHx6GX4577q
 TWVCEzZigJYyfjGSkVzdQKe1IgmowXJT5KKetou4zAxOyhdcRoftSCK8TAfUTSqptBmD1AaPkG
 LVCemLyCU+6/Nh7gZxN9LjYjawJkVLcBWgb6Bug90ohuhNkLfhPBkVV0TnNUp+oTD1L4Fgo8SL
 qiBdZ3eM5X389arFfX4BHng9gqbw4JzVkjveKENgq0Bx0hNY+M+OmhLDV0wxSvFcz5aAJe2d+x
 khE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:29:36 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HpJ403K8Pz1RtVn
        for <fio@vger.kernel.org>; Mon,  8 Nov 2021 22:29:36 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636439375; x=1639031376; bh=5Otbm4VK8GWcaLEqeAHPVaKWrvPosNwzFrv
        /TiWEG9w=; b=aH0etPrQN3cnLMsRFjSe86Tg6wwRmSwttQU2BDuzOpUeUXkmdrL
        m0wPhrvdL83i58v10U2+TSPjeE6nfFg7ZQhyI4JzOaVqXmm3rG1dgi3LNvsRISys
        PuUG++PRunRc+of/As6V3KnhioxPoa9NtQ4MIoikDO79/cO23chNwsLqSIc1cJ+u
        NuSPxD3o49GGC1vpbRnUOzioMx+8x8yeXYxXd8EfeyU8H9h+Cx1L2nvUKyeOMA+A
        rgFpRxXQwIxQvnvLeM6xQaWxY7sSi0oLRDqJgqGCSAZyn5xldHZ0CQ29cZkpG5T3
        0Uvci3BEwXYmpuCJyD1N0hts+7TOudS26RQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qny_KIOywSjw for <fio@vger.kernel.org>;
        Mon,  8 Nov 2021 22:29:35 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HpJ3z37NHz1RtVl;
        Mon,  8 Nov 2021 22:29:35 -0800 (PST)
Message-ID: <c3f0c6f5-8df7-98c2-1728-49d75f0f2839@opensource.wdc.com>
Date:   Tue, 9 Nov 2021 15:29:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 6/8] libaio,io_uring: move common cmdprio_prep() code to
 cmdprio
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-7-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109002655.117274-7-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/09 9:28, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Move common cmdprio_prep() code to cmdprio.c to avoid code duplication.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  engines/cmdprio.c  | 40 +++++++++++++++++++++++++++++++++++++++-
>  engines/cmdprio.h  |  3 ++-
>  engines/io_uring.c | 32 +++++---------------------------
>  engines/libaio.c   | 26 ++++----------------------
>  4 files changed, 50 insertions(+), 51 deletions(-)
> 
> diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> index 2c764e49..01e0a729 100644
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
> @@ -89,6 +89,44 @@ int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
>  	return 0;
>  }
>  
> +/**
> + * fio_cmdprio_ioprio_was_updated - Generates a random value. If the random
> + * value is within the user specified percentage of I/Os that should use a
> + * cmdprio priority value (rather than the default priority), then this
> + * function updates the io_u with a cmdprio priority value.
> + */
> +bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
> +				    struct cmdprio *cmdprio, struct io_u *io_u)

What about simply calling this fio_set_cmdprio() or fio_cmdprio_set_ioprio() ?
That is a lot shorter and the name matches the return true/false depending on if
the io_u->ioprio was set (changed) or not.

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
> +	} else if (td->ioprio && td->ioprio < cmdprio_value) {

No need for the else here.

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
> index d3265741..c05679e4 100644
> --- a/engines/cmdprio.h
> +++ b/engines/cmdprio.h
> @@ -22,7 +22,8 @@ struct cmdprio {
>  int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
>  			      struct cmdprio *cmdprio);
>  
> -int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u);
> +bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
> +				    struct cmdprio *cmdprio, struct io_u *io_u);
>  
>  int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
>  		     bool *has_cmdprio);
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index de1e6cc9..46f4bc2a 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -458,35 +458,13 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
>  
>  static void fio_ioring_cmdprio_prep(struct thread_data *td, struct io_u *io_u)
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
> +	bool ioprio_updated = fio_cmdprio_ioprio_was_updated(td, cmdprio, io_u);
> +
> +	if (ioprio_updated)
> +		ld->sqes[io_u->index].ioprio = io_u->ioprio;

I do not see why ioprio_updated is needed. Also, since the sqes initialization
also needs to be done with the defualt priority, can't this be moved outside of
this function to be common with the default prio case ?

>  }
>  
>  static enum fio_q_status fio_ioring_queue(struct thread_data *td,
> diff --git a/engines/libaio.c b/engines/libaio.c
> index 9c14dd88..f0d3df7a 100644
> --- a/engines/libaio.c
> +++ b/engines/libaio.c
> @@ -209,29 +209,11 @@ static void fio_libaio_cmdprio_prep(struct thread_data *td, struct io_u *io_u)
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
> +	bool ioprio_updated = fio_cmdprio_ioprio_was_updated(td, cmdprio, io_u);
> +
> +	if (ioprio_updated) {

With fio_cmdprio_ioprio_was_updated() renamed as proposed above, I think you can
get rid of the local boolean and simply do:

	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u)) {
		io_u->iocb.aio_reqprio = io_u->ioprio;
		io_u->iocb.u.c.flags |= IOCB_FLAG_IOPRIO;
	}

And I wonder if the fio_libaio_cmdprio_prep() helper is really useful given that
it is reduced to the above tiny code. Same for io_uring.

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


-- 
Damien Le Moal
Western Digital Research
