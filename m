Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7FCC433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02B5B60F6E
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243270AbhKIGlb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 01:41:31 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:54831 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243263AbhKIGlZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 01:41:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636439919; x=1667975919;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VVQrEZPdoudMrcnrVQ7G+rVeuLp1C6Jvo4w2yQdTAgY=;
  b=Fi1Xt9xraOkgWfo1NCkbJq//Zv1Xn0mwnNExdJPUGcVTdNqgpwZocfvt
   BSUmhYcySjLE9SWnteSOvTn0h7kpR0wavET38wqfaC16EuMS1YusLXKbq
   zDHE+oxzL0MPeBKzyCGV4aI5fNTCjaxwW+xf+0oaEylLeZ+T3WB2gnwHQ
   N/ndXWMccS+AXEhiDqLLWTUl4oHyQRV6S5SSrYaEZhtpVPFpkNkgXea2y
   vRs5h7aPm4QnwSK9HakJ5EGGcT0LPGgE+h3fU8ghz5t5A1qYQir8KS4T9
   eJB6QFVtg2SavzufflrHTJ3luHkVBvNQYh8tD7BZctkwbAYDR57PqPvtT
   A==;
X-IronPort-AV: E=Sophos;i="5.87,219,1631548800"; 
   d="scan'208";a="185094556"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 14:38:39 +0800
IronPort-SDR: fk715AAQz17H/MSX+gfK/fR9afaDeUsBOiGIlVmU/MOGDvAgF1kMHuYZFVZ4q2qCLtpLHcAEtU
 0Kur/sVcT3RDtylypTy4PdrcjmRBnFvwVBBfZNGC4Peiqo7UCu2EQZxoV7EgvHK5Bs2l3UZ4YN
 TUvyUjkxhJ6euuROMU97p9aSwrubuA/iz84p+gqSpIG7vLkL29uhwCbCebtPtEfAFR/HgmP9cv
 ts23q0WPrkCNMpmLJ/ul6GKNB72HTl7Rhp3renZmz1859wG+YOtbIfuHv1krld0AOvBW3+xy5f
 2M9l5z13bly7l1FohL8mlKqE
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:13:52 -0800
IronPort-SDR: T2ZGjp5vRbl+qMvPIfcTS5TdnMkOVGxfCO/acjvdZabrp6ZpS36oQovRAnlfC3TQsgEkWXjxEt
 dr+gDNcowMhzW3mUQijmjKnw0kKe0JJClT5WkxcD1/xteWDb4H6D/u7IqtERxhUe2UfJkOhB95
 Uz6344ol0XSAl+TUSgyPn0uYZsOHqQ5AGRAoxEvxAO3n3af69QQQdyO4EOrctnplSV3AYtSToL
 AhQ05OIJfgHiq1HAMf/bU7DoDY3n6NbmtWShEryFD3zwAHOucyRGbfXP/gmuIBzmHyBXoY0Jpd
 fNI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:38:40 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HpJGR4lRMz1RtVm
        for <fio@vger.kernel.org>; Mon,  8 Nov 2021 22:38:39 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636439919; x=1639031920; bh=VVQrEZPdoudMrcnrVQ7G+rVeuLp1C6Jvo4w
        2yQdTAgY=; b=rupWG2jk2a//gnh4g9V1jtkVbHrAiFxojs+dkdtvr0VCuVeN9Ij
        4Bkz63UKweZ7dzENUJJGpQBSAFTpvb+I5jKoI3ALbhoQJBJVugAbDuWhKbWTLDe4
        At9oBtI8XtDAavU0PHSgKHj4F2HsGva33M9j4bD2IEOgo3Zmd6B+2KM1XQEMHtb+
        tjfzQoH5DgZRF2yxH4/TstfcZvVH80R3cRuQZTaFYgLRHQWEki1c1XYMWY29d4n5
        H0R5KpYS8OeeBkzBZHCmHnHcfkRu/D/GnM6AQ4VuticYq0LbwUSWQ2SBusC9mDsb
        HYXf9wpk9oGXEh/8MmlexnM7kEI/OfUjbqw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id WCsP46dny0lF for <fio@vger.kernel.org>;
        Mon,  8 Nov 2021 22:38:39 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HpJGQ2VLsz1RtVl;
        Mon,  8 Nov 2021 22:38:38 -0800 (PST)
Message-ID: <e9dc1315-540e-f69f-6814-f8c95a2c077e@opensource.wdc.com>
Date:   Tue, 9 Nov 2021 15:38:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 7/8] cmdprio: add mode to make the logic easier to reason
 about
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-8-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109002655.117274-8-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/09 9:28, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Add a new field "mode", in order to know if we are using/running
> cmdprio in cmdprio_percentage or cmdprio_bssplit mode.

...if we are determining IO priorities according to cmdprio_percentage or to
cmdprio_bssplit.

(I think that is clearer)

> 
> This makes the logic easier to reason about, and allows us to
> remove the "use_cmdprio" variable from the ioengines themselves.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  engines/cmdprio.c  | 45 +++++++++++++++++++++++++--------------------
>  engines/cmdprio.h  | 10 ++++++++--
>  engines/io_uring.c |  7 +++----
>  engines/libaio.c   |  7 +++----
>  4 files changed, 39 insertions(+), 30 deletions(-)
> 
> diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> index 01e0a729..cafe21d7 100644
> --- a/engines/cmdprio.c
> +++ b/engines/cmdprio.c
> @@ -70,17 +70,12 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
>  static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
>  {
>  	enum fio_ddir ddir = io_u->ddir;
> -	unsigned int p = cmdprio->percentage[ddir];
>  	int i;
>  
> -	/*
> -	 * If cmdprio_percentage option was specified, then use that
> -	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
> -	 * on the IO size.
> -	 */

Personally, I would keep the comment. It makes it very clear, in human natural
langage, what the relation between cmdprio_percentage and cmdprio_bssplit is.
That is, cmdprio_percentage has precedence.

> -	if (p)
> -		return p;
> +	if (cmdprio->mode == CMDPRIO_MODE_PERC)
> +		return cmdprio->percentage[ddir];
>  
> +	assert(cmdprio->mode == CMDPRIO_MODE_BSSPLIT);

Is this really necessary ? What about using switch()/case with a default that
has the assert for debugging ? This way, the assert will not be uselessly tested
whenever cmdprio_bssplit is used.

>  	for (i = 0; i < cmdprio->bssplit_nr[ddir]; i++) {
>  		if (cmdprio->bssplit[ddir][i].bs == io_u->buflen)
>  			return cmdprio->bssplit[ddir][i].perc;
> @@ -99,10 +94,20 @@ bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
>  				    struct cmdprio *cmdprio, struct io_u *io_u)
>  {
>  	enum fio_ddir ddir = io_u->ddir;
> -	unsigned int p = fio_cmdprio_percentage(cmdprio, io_u);
> +	unsigned int p;
>  	unsigned int cmdprio_value =
>  		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
>  
> +	if (cmdprio->mode == CMDPRIO_MODE_NONE) {
> +		/*
> +		 * An I/O engine should never call this function if cmdprio
> +		 * is not is use.
> +		 */
> +		assert(0);
> +		return false;
> +	}
> +
> +	p = fio_cmdprio_percentage(cmdprio, io_u);
>  	if (p && rand_between(&td->prio_state, 0, 99) < p) {
>  		io_u->ioprio = cmdprio_value;
>  		if (!td->ioprio || cmdprio_value < td->ioprio) {
> @@ -127,8 +132,7 @@ bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
>  	return false;
>  }
>  
> -int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> -		     bool *has_cmdprio)
> +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio)
>  {
>  	struct thread_options *to = &td->o;
>  	bool has_cmdprio_percentage = false;
> @@ -140,16 +144,12 @@ int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
>  	 * is not set, default to RT priority class.
>  	 */
>  	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
> -		if (cmdprio->percentage[i]) {
> -			if (!cmdprio->class[i])
> -				cmdprio->class[i] = IOPRIO_CLASS_RT;

Why do you change this ? If cmdprio->percentage[i] is 0, you do not want to set
the calss to RT. Or is it that cmdprio->percentage[i] cannot be 0 ? (I did not
check the range of the option).

> +		if (!cmdprio->class[i])
> +			cmdprio->class[i] = IOPRIO_CLASS_RT;
> +		if (cmdprio->percentage[i])
>  			has_cmdprio_percentage = true;
> -		}
> -		if (cmdprio->bssplit_nr[i]) {
> -			if (!cmdprio->class[i])
> -				cmdprio->class[i] = IOPRIO_CLASS_RT;
> +		if (cmdprio->bssplit_nr[i])
>  			has_cmdprio_bssplit = true;
> -		}
>  	}
>  
>  	/*
> @@ -162,7 +162,12 @@ int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
>  		return 1;
>  	}
>  
> -	*has_cmdprio = has_cmdprio_percentage || has_cmdprio_bssplit;
> +	if (has_cmdprio_bssplit)
> +		cmdprio->mode = CMDPRIO_MODE_BSSPLIT;
> +	else if (has_cmdprio_percentage)
> +		cmdprio->mode = CMDPRIO_MODE_PERC;
> +	else
> +		cmdprio->mode = CMDPRIO_MODE_NONE;
>  
>  	return 0;
>  }
> diff --git a/engines/cmdprio.h b/engines/cmdprio.h
> index c05679e4..7d14b3a6 100644
> --- a/engines/cmdprio.h
> +++ b/engines/cmdprio.h
> @@ -11,12 +11,19 @@
>  /* read and writes only, no trim */
>  #define CMDPRIO_RWDIR_CNT 2
>  
> +enum {
> +	CMDPRIO_MODE_NONE,
> +	CMDPRIO_MODE_PERC,
> +	CMDPRIO_MODE_BSSPLIT,
> +};
> +
>  struct cmdprio {
>  	unsigned int percentage[CMDPRIO_RWDIR_CNT];
>  	unsigned int class[CMDPRIO_RWDIR_CNT];
>  	unsigned int level[CMDPRIO_RWDIR_CNT];
>  	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
>  	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
> +	unsigned int mode;
>  };
>  
>  int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
> @@ -25,7 +32,6 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
>  bool fio_cmdprio_ioprio_was_updated(struct thread_data *td,
>  				    struct cmdprio *cmdprio, struct io_u *io_u);
>  
> -int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> -		     bool *has_cmdprio);
> +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio);
>  
>  #endif
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 46f4bc2a..f82fa1fd 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -68,8 +68,6 @@ struct ioring_data {
>  	int prepped;
>  
>  	struct ioring_mmap mmap[3];
> -
> -	bool use_cmdprio;
>  };
>  
>  struct ioring_options {
> @@ -472,6 +470,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
>  {
>  	struct ioring_data *ld = td->io_ops_data;
>  	struct io_sq_ring *ring = &ld->sq_ring;
> +	struct ioring_options *o = td->eo;
>  	unsigned tail, next_tail;
>  
>  	fio_ro_check(td, io_u);
> @@ -494,7 +493,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
>  	if (next_tail == atomic_load_acquire(ring->head))
>  		return FIO_Q_BUSY;
>  
> -	if (ld->use_cmdprio)
> +	if (o->cmdprio.mode != CMDPRIO_MODE_NONE)
>  		fio_ioring_cmdprio_prep(td, io_u);
>  
>  	ring->array[tail & ld->sq_ring_mask] = io_u->index;
> @@ -831,7 +830,7 @@ static int fio_ioring_init(struct thread_data *td)
>  
>  	td->io_ops_data = ld;
>  
> -	ret = fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
> +	ret = fio_cmdprio_init(td, cmdprio);
>  	if (ret) {
>  		td_verror(td, EINVAL, "fio_ioring_init");
>  		return 1;
> diff --git a/engines/libaio.c b/engines/libaio.c
> index f0d3df7a..b33461f4 100644
> --- a/engines/libaio.c
> +++ b/engines/libaio.c
> @@ -51,8 +51,6 @@ struct libaio_data {
>  	unsigned int queued;
>  	unsigned int head;
>  	unsigned int tail;
> -
> -	bool use_cmdprio;
>  };
>  
>  struct libaio_options {
> @@ -320,6 +318,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
>  					  struct io_u *io_u)
>  {
>  	struct libaio_data *ld = td->io_ops_data;
> +	struct libaio_options *o = td->eo;
>  
>  	fio_ro_check(td, io_u);
>  
> @@ -350,7 +349,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
>  		return FIO_Q_COMPLETED;
>  	}
>  
> -	if (ld->use_cmdprio)
> +	if (o->cmdprio.mode != CMDPRIO_MODE_NONE)
>  		fio_libaio_cmdprio_prep(td, io_u);
>  
>  	ld->iocbs[ld->head] = &io_u->iocb;
> @@ -507,7 +506,7 @@ static int fio_libaio_init(struct thread_data *td)
>  
>  	td->io_ops_data = ld;
>  
> -	ret = fio_cmdprio_init(td, cmdprio, &ld->use_cmdprio);
> +	ret = fio_cmdprio_init(td, cmdprio);
>  	if (ret) {
>  		td_verror(td, EINVAL, "fio_libaio_init");
>  		return 1;
> 


-- 
Damien Le Moal
Western Digital Research
