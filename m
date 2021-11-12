Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC841C433FE
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 00:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9546561053
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 00:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbhKLBAz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 11 Nov 2021 20:00:55 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:31830 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbhKLBAz (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Nov 2021 20:00:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636678683; x=1668214683;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/jlyExsVfWkq1NgIiNm4oTuWY1Y9hSP8aKSZMvdYpuY=;
  b=i+rcrKF1RoG9PlHChM/BBv7mTPJDXdIjNoNsDCRtKIRSkqhFHWsLnzSf
   eBbDuZzxzOQEw2gSX/TdhYMHAuedb1itWfbLfhV+/HT+dJDQAfpWuK3hb
   CBYBnatOaG1PiWT5f+43ahTVjfTlnMm03DjI2/1A3FzXWSERsoNwtSBMU
   Nm4qaZ0tqSb7y+t9DByiznJTlSp4eEv4nq2ll1WWly53blKkurQQn0xws
   YmjxfoSFR2ZrCD+FfRxtlbGlg2etoEYa0CxJvgfmFizrCxE/9Akm/NDpO
   iRVZBjqVUq8o0GEhDcW06dgksUYhkUCAPMvHl/AkCuQ9NLTc4ZTLCOC8e
   g==;
X-IronPort-AV: E=Sophos;i="5.87,227,1631548800"; 
   d="scan'208";a="190200250"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 08:58:03 +0800
IronPort-SDR: PAxl52qZd4pVgWTxb44unYufMjaIklYBlpJtwHb/ErSvT0J98jd5MK3hDmjems/W3HdEMesahB
 m0p91VJWYf/RUGc0QTo9HCNkY3lC/AOllfhBdtNsJwOHWHIzOVB5ZyNAxLj5GWNQh+Po0OHWu0
 mLR+xsfuMyOwaeTVCVclnxadusRhiRJjBW2OWZDQSpUrZy8TsBuhZl/v0VcEJ8eykk8gK5/d3R
 SspKyDSdxgxvi9ZV/Bno3TFQVSFzqvMGi1Hvpe4pAomgBe6VfrlBnEJBoQ+g9EBMZFG3KiHB5y
 Q4CfvUDu9VsRUgoDRO/yuFBW
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 16:31:41 -0800
IronPort-SDR: PwmCca6qveKaP57LMkr8eLMn6JO87JcsHFxt3uXl6gb6wsV0mdWA8hFi7fmavsagH8ddsPB4+U
 rA+v6Voitc2oYHSBwUI+oCFPLzqF38wfqNNnIYGBGv127ceGQFPd18/Ne67ob95IMqvijZpfjv
 FTpVjuqrxCrpX5qdSOgnQ50sE/dUmvGbk0SaeLfLAoo9bOsek/X+3f0l4x+IzzixUW8nGHvOU9
 1UMxotMF6sEOIHo9TtuXUXt7Bco4tjVuf0wpdFN5DI2iK5c95KswS1z2abNLC+NPSJylj+NomY
 Pl4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 16:58:04 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Hr0Z44ydMz1RtVp
        for <fio@vger.kernel.org>; Thu, 11 Nov 2021 16:58:04 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636678683; x=1639270684; bh=/jlyExsVfWkq1NgIiNm4oTuWY1Y9hSP8aKS
        ZMvdYpuY=; b=IldD6W87rqHuGf8XjRRcmU78jrj9k5dXkNHc2i+5/kj+3Av4DHt
        vJNhKjZViVx2rq1TtMdmwxaI/sG0LUT6e3GKahcWEgTknMI2qqHXAaV8CbyH+sKn
        fMJIRF378AhjZSyUsXhZ7iZqbT7Maakq5MKrSU+yUo44G0aBNxGqFVU/CpW/aGAu
        CtILSXTZJaG3K73GM19s7t/+aV9muboXzciRUBns2XWEHDVFB9OdcDQsAlEtrMuc
        4B6aEVcT8SLv0jnMQIR72ct9HlH9Q/kSFlvgFUngriZy83t4a9pP46zAWozsl6CS
        BAeA2KFdWmtOj+HKDD1ayeoyesxX2EMIDvQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id aJicgAO0S-IR for <fio@vger.kernel.org>;
        Thu, 11 Nov 2021 16:58:03 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Hr0Z31LP9z1RtVl;
        Thu, 11 Nov 2021 16:58:02 -0800 (PST)
Message-ID: <4450ffe3-b438-2f26-9e7d-5ba052a4bc82@opensource.wdc.com>
Date:   Fri, 12 Nov 2021 09:58:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v2 7/8] cmdprio: add mode to make the logic easier to
 reason about
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
 <20211109233804.164786-8-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109233804.164786-8-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/10 8:38, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Add a new field "mode", in order to know if we are determining IO
> priorities according to cmdprio_percentage or to cmdprio_bssplit.
> 
> This makes the logic easier to reason about, and allows us to
> remove the "use_cmdprio" variable from the ioengines themselves.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  engines/cmdprio.c  | 45 +++++++++++++++++++++++++++++----------------
>  engines/cmdprio.h  | 10 ++++++++--
>  engines/io_uring.c |  7 +++----
>  engines/libaio.c   |  7 +++----
>  4 files changed, 43 insertions(+), 26 deletions(-)
> 
> diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> index 9cad76b5..174bed7c 100644
> --- a/engines/cmdprio.c
> +++ b/engines/cmdprio.c
> @@ -70,20 +70,19 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
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
> -	if (p)
> -		return p;
> -
> -	for (i = 0; i < cmdprio->bssplit_nr[ddir]; i++) {
> -		if (cmdprio->bssplit[ddir][i].bs == io_u->buflen)
> -			return cmdprio->bssplit[ddir][i].perc;
> +	switch (cmdprio->mode) {
> +	case CMDPRIO_MODE_PERC:
> +		return cmdprio->percentage[ddir];
> +	case CMDPRIO_MODE_BSSPLIT:
> +		for (i = 0; i < cmdprio->bssplit_nr[ddir]; i++) {
> +			if (cmdprio->bssplit[ddir][i].bs == io_u->buflen)
> +				return cmdprio->bssplit[ddir][i].perc;
> +		}
> +		break;
> +	default:
> +		assert(0);
>  	}
>  
>  	return 0;
> @@ -99,10 +98,20 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
>  			    struct io_u *io_u)
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

This hunk is not useful as the call to fio_cmdprio_percentage() will cover this
buggy case. So let's remove it. No need to clutter the code with it. You may
want to move the above comment under the if to the default case in
fio_cmdprio_percentage() switch.

> +
> +	p = fio_cmdprio_percentage(cmdprio, io_u);
>  	if (p && rand_between(&td->prio_state, 0, 99) < p) {
>  		io_u->ioprio = cmdprio_value;
>  		if (!td->ioprio || cmdprio_value < td->ioprio) {
> @@ -128,8 +137,7 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
>  	return false;
>  }
>  
> -int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> -		     bool *has_cmdprio)
> +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio)
>  {
>  	struct thread_options *to = &td->o;
>  	bool has_cmdprio_percentage = false;
> @@ -163,7 +171,12 @@ int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
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
> index 732b087e..7e4fcf6c 100644
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
>  bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
>  			    struct io_u *io_u);
>  
> -int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> -		     bool *has_cmdprio);
> +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio);
>  
>  #endif
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 230f08a5..979d07d4 100644
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
> index dc6ad08e..53fe7428 100644
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

With the above fix, this is a nice cleanup.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
