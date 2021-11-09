Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EE8C433F5
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D70816152A
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243135AbhKIGTr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 01:19:47 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10861 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243132AbhKIGTq (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 01:19:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636438621; x=1667974621;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mT2UHs6ioLlo4yVgUV6bwQlywbBEEyNBAsMY+MHFSVg=;
  b=jZ/y53dpOKGmDoXeJ8yKB6WHUe7KLtSjqFk4/OIDlBCKRdIFy73eOqb5
   4CYIZm/2EF96fM008UPgAKww8VdSdQTip6BuCQKGXVCr6yQJ9zUIMp48I
   qr3GI3HnTHbbK/d/93OxDlu2dUpXcE6p+/EQhKRiibic9OoeFRrqTHVpz
   Gn8hnCdsRoGddObtGsghNOo6beJgek9Q+HyWLnV575SHbvWgeJOZCOcZP
   7QMTZpiCpUadZdgippZzWIiWDQb/7LL43iPZz85abjuHd+PnlbDqvkZGj
   Kp8iiwRBAPwrUffJI/x3Iba0l5/HByuZk2f+B8hti1wlOS1lsr1xv4cyk
   A==;
X-IronPort-AV: E=Sophos;i="5.87,219,1631548800"; 
   d="scan'208";a="184094785"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 14:17:00 +0800
IronPort-SDR: uE7Cy16nTWO1ccgw7DJVh8wagaUKuia/M7ZWmOtG1PDcKHiSRcEPAhPtMvNWpjeLwbOaTapsWo
 S8zTzIjQkRZPw0q4LCE7a8gND8dbb22caY5ESTbd8rikd5kqT+WunB9aouaON7bjivaW+hZ8zq
 lOh3YIFohOqlEl5VMfZxWAML1eZXdgzMUzKFE5GQXe8+FdIJemf5+/2KzYjUM6WwJtBK380Zq2
 6kCjwTULDmOLWlJvhJ5SaXdRYaYN22UOgZDuFyv+LpYk1MY7WiyRoPtJOTr1IFawGbZigjnjf5
 7Mvkum/YQnUX4zLT8CH4a0x2
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 21:50:40 -0800
IronPort-SDR: BF39STY32jVADvONqUntj8B4krUimo0A8P/UAMO/tJJSzy7YjTW5AxJBnvjBLAlwexrH6Mfccb
 VeUpZqNxML7y9jnUzbBQF/T8JpPtGU9OZx65qyXbQSvBWJBqVbZQzA0O+KLEPGiVY0ULTTgiDO
 lhVnxQUXiH81aq4zDGgMxTubz4nONL1RsykaEIc9GCj0EthLPIKrptfsmqWTNaUuxG4sYoUKgy
 tQFDzVAAADHW2y7L1Z+DvabX8qTxKurQ/Bklh3ROFOpYCubTtY4HsaFv86CL/Ycdf5eH+eumO2
 CEI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:17:01 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HpHnS4JCjz1RtVn
        for <fio@vger.kernel.org>; Mon,  8 Nov 2021 22:17:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636438620; x=1639030621; bh=mT2UHs6ioLlo4yVgUV6bwQlywbBEEyNBAsM
        Y+MHFSVg=; b=lKcRivayv7yb4F0Z06I8f7FZHMl9IUlSIyoKHqzQKSVyQ4l1zk9
        e0vt/6erMFAJt5dBafYN2bXFbD1KDYuF1WzC2s6RrMuSXq1XoSIKUtg1C738+z+x
        DNOB/ylshFC01dEAJExwAnUDwByWGP7DQkP432Kwk3B75wxV1ssHGiPqXhwPfGJJ
        uJjOrEkFGnUC2RX3X1URYkLl9khQy4Jq+pzRORKlfvhiAfuhx8RROmyzrUGiRJ3a
        8443Sl/j0qSHzD4wUV8ZaGT2d+PZ5etunGvFU1BMeSsb1UcWdAhLd3MgrVO8ednu
        Xw1wKeenMU9zqopsNLDnp6F7CdEvEAf+Wtg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oyWbQpRJNptf for <fio@vger.kernel.org>;
        Mon,  8 Nov 2021 22:17:00 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HpHnR32yRz1RtVl;
        Mon,  8 Nov 2021 22:16:59 -0800 (PST)
Message-ID: <61ed0026-faaf-072d-567f-6b964ad8899a@opensource.wdc.com>
Date:   Tue, 9 Nov 2021 15:16:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 4/8] io_uring: set async IO priority to td->ioprio in
 fio_ioring_prep()
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-5-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109002655.117274-5-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/09 9:28, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The default priority (which is either 0 or the value set by "prio" and
> "prioclass" options) is now saved in td->ioprio.
> 
> The simplest thing is therefore to unconditionally set the async IO
> priority to td->ioprio fio_ioring_prep(), and let fio_ioring_prio_prep()

...to td->ioprio in fio_ioring_prep(), ...

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
> index 27a4a678..8f3d6c39 100644
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
> +		 * the the IO priority set by ioprio_set()

You have two "the" here.

> +		 * (option prio/prioclass) to be inherited.
> +		 * td->ioprio will have the value of the "default prio", so set
> +		 * this unconditionally. This value might get overriden by
> +		 * fio_ioring_prio_prep() if cmdprio_percentage/cmdprio_bssplit
> +		 * is enabled.

...if the options cmdprio_percentage or cmdprio_bssplit are used.

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
