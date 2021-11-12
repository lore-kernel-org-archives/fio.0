Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213AFC433F5
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 01:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB70661183
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 01:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhKLBPv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 11 Nov 2021 20:15:51 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:47389 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbhKLBPv (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Nov 2021 20:15:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636679581; x=1668215581;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ia0MkIAp6VPSOr9WOXmATIm//tk42n46DiTXOK86I+E=;
  b=p+/ZADE/xqpF9YK6v1hEn0pnb+oIx/Gchx7SaqrKR87EGQpkYiKWaRwA
   QdtWPuGeoRbLVxSIc5SKLy4f7zNPxYEmrAqEtayqk4lvjK8+zsxuWDP5D
   b7sKxA1J0cTn6ulKI2WQEAcHdBlI19mpaIG2+riEHg/8mbaEifVpsHEds
   70a8mW0Gd6hIquvB2rD2/5s8KuoODLtrakEoFUDwUEukfiWXG5wDwmnb3
   sVaJ0YQoYBolxL5iG5tf1a7Ti+2670xTAEkmffvfbDs0mNxVtWTPEUMfr
   YdW8YxFtUtZxtmhnZBqkQC9HX3sjEKY+1c3jsrZiii5ou0tCvU7/nwxCK
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,227,1631548800"; 
   d="scan'208";a="184397401"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 09:13:01 +0800
IronPort-SDR: aZ4I36no6Y1JDdhLWojSH0u0uMWEH2hgwqjfHllyrOZdIE9grGGDey/eTOZfX/a8jMjxsOZAus
 ORFepN2GFmIYAxAsol67xGxCJj83TLNqeJrUJPp9JYjVSdxBoz+OHPEz2JpPI/+2eWUs4KQRHN
 k0zMfoggPKkvfuXK+HICZiysIFZa2PcpasTqQJyZOwRKwi+KsMWBHpJn4PYg/+jNiTJTHQ5J15
 rFsCpBrCrf/YI4Gl0cPGgtoJ7LaZsXITEw5U8BnJlTs34sD9x/Ee1uc6kr1iSviweMq9EWbIB+
 12OXDW1SF2nJR7lHrsTOOOlB
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 16:48:10 -0800
IronPort-SDR: EVJ08buPxtV2ntNh2jE1t7eyab6+HpphFvvGqZG9AfGLXHEcc1pP2HOoC2Wqm/Dtmcya6PnDXQ
 zN3ocfDBmIIZgo7CEmwGOnoeQv4D2/tbJkS7HbdiWZvdRnC+r8BIoYJYC6GG/+8lTYd3g9RjFg
 kOlkZXiRHcvjWjkfpLqfxlCzgiubcgw1/tIEtmBNP60nKmdaj5blqqrwrMsqoyrE+xHgLPsbqa
 i6flLCR8Bqc1eruZ7WsdbtJ9I3/8vsZ6iUMPRV9NCeDTyvTW73MfKNBhUARhlJs6C7drCRRofO
 56g=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 17:13:01 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Hr0vJ744Rz1RtVn
        for <fio@vger.kernel.org>; Thu, 11 Nov 2021 17:13:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636679580; x=1639271581; bh=Ia0MkIAp6VPSOr9WOXmATIm//tk42n46DiT
        XOK86I+E=; b=gvcMKD7bYo7WxOUYxJbDmdVaM70AM+UCmjx2hQO+UJKtmBXJqpc
        NqtckpTFeg5VvmIw2hs0PFkazeF7Pl4ecA/HQVk40GfT1/FtmrB3h60d2PZKDan3
        zJ39Y1+5zOfCgJ+hD65hf/bAoR4QvjgaOkp0yXHNrM1b5XFbnchGL5UMFtZPJEbO
        xs4YyCrkR66he4Vj64PE03aH6rI6NZ/nqb0Br0UWxxlImRBK2chSoIwFRAU/+1H3
        J8SnnnWb262Oo0aSIeAHOrzXkAFNrcgANxq1XFffkKp33gXiwIhg8Kzj7wNaQA0z
        J66NsaQDyPadAKHHYslXmctxK7EiicyFpuA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RcyG45AGe3m8 for <fio@vger.kernel.org>;
        Thu, 11 Nov 2021 17:13:00 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Hr0vH3ZWqz1RtVl;
        Thu, 11 Nov 2021 17:12:59 -0800 (PST)
Message-ID: <e49b93ca-d547-6825-7d3c-ee8e2681400f@opensource.wdc.com>
Date:   Fri, 12 Nov 2021 10:12:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v2 8/8] libaio,io_uring: make it possible to cleanup
 cmdprio malloced data
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
 <20211109233804.164786-9-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109233804.164786-9-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/10 8:38, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The way that fio currently handles engine options:
> options_free() will only every call free() on an option that has type

...will call free() only for options that have the type...

> FIO_OPT_STR_STORE. This means that any option that has a pointer in
> either td->o or td->eo, which is not of type FIO_OPT_STR_STORE will
> leak memory. This is true even for numjobs == 1.
> 
> When running with numjobs > 1, fio_options_mem_dupe() will memcpy
> td->eo into the new td. Since off1 of the pointers in the first td
> has already been set, the pointers in the new td will point to the
> same data. (Regardless, options_free() will never try to free the
> memory, for neither td.) Neither can we manually free the memory in
> cleanup(), since the other td will still point to the same memory,
> so this would lead to a double free.
> 
> These memory leaks are reported by e.g. valgrind.
> 
> The most obvious way to solve this is to put dynamically allocated
> memory in {ioring,libaio}_data instead of {ioring,libaio}_options.
> 
> This solves the problem since {ioring,libaio}_data is dynamically
> allocated by each td during the ioengine init callback, and is freed
> when the ioengine cleanup callback for that td is called.
> 
> The downside of this is that the parsing has to be done in
> fio_cmdprio_init() instead of in the option .cb callback, since the
> .cb callback is called before {ioring,libaio}_data is available.
> 
> This patch keeps the static cmdprio options in
> {ioring,libaio}_options, but moves the dynamically allocated memory
> needed by cmdprio to {ioring,libaio}_data.
> 
> No cmdprio related memory leaks are reported after this patch.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  engines/cmdprio.c  | 106 ++++++++++++++++++++++++++++++++++-----------
>  engines/cmdprio.h  |  15 ++++---
>  engines/io_uring.c |  41 +++++++-----------
>  engines/libaio.c   |  43 ++++++++----------
>  4 files changed, 124 insertions(+), 81 deletions(-)
> 
> diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> index 174bed7c..7ff39d93 100644
> --- a/engines/cmdprio.c
> +++ b/engines/cmdprio.c
> @@ -46,22 +46,15 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
>  			      struct cmdprio *cmdprio)
>  {
>  	char *str, *p;
> -	int i, ret = 0;
> +	int ret = 0;
>  
>  	p = str = strdup(input);
>  
>  	strip_blank_front(&str);
>  	strip_blank_end(str);
>  
> -	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false);
> -
> -	if (parse_dryrun()) {
> -		for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
> -			free(cmdprio->bssplit[i]);
> -			cmdprio->bssplit[i] = NULL;
> -			cmdprio->bssplit_nr[i] = 0;
> -		}
> -	}
> +	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio,
> +			      false);
>  
>  	free(p);
>  	return ret;
> @@ -70,11 +63,12 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
>  static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
>  {
>  	enum fio_ddir ddir = io_u->ddir;
> +	struct cmdprio_options *options = cmdprio->options;
>  	int i;
>  
>  	switch (cmdprio->mode) {
>  	case CMDPRIO_MODE_PERC:
> -		return cmdprio->percentage[ddir];
> +		return options->percentage[ddir];
>  	case CMDPRIO_MODE_BSSPLIT:
>  		for (i = 0; i < cmdprio->bssplit_nr[ddir]; i++) {
>  			if (cmdprio->bssplit[ddir][i].bs == io_u->buflen)
> @@ -98,9 +92,10 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
>  			    struct io_u *io_u)
>  {
>  	enum fio_ddir ddir = io_u->ddir;
> +	struct cmdprio_options *options = cmdprio->options;
>  	unsigned int p;
>  	unsigned int cmdprio_value =
> -		ioprio_value(cmdprio->class[ddir], cmdprio->level[ddir]);
> +		ioprio_value(options->class[ddir], options->level[ddir]);
>  
>  	if (cmdprio->mode == CMDPRIO_MODE_NONE) {
>  		/*
> @@ -137,30 +132,85 @@ bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
>  	return false;
>  }
>  
> -int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio)
> +static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
> +					     struct cmdprio *cmdprio)
>  {
> -	struct thread_options *to = &td->o;
> -	bool has_cmdprio_percentage = false;
> -	bool has_cmdprio_bssplit = false;
> +	struct cmdprio_options *options = cmdprio->options;
> +	int ret;
> +
> +	ret = fio_cmdprio_bssplit_parse(td, options->bssplit_str, cmdprio);
> +	if (ret)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	fio_cmdprio_cleanup(cmdprio);
> +
> +	return ret;
> +}
> +
> +static int fio_cmdprio_gen_data_structs(struct thread_data *td,
> +					struct cmdprio *cmdprio)

You could call this fio_cmdprio_parse_and_gen(), or simply
fio_cmdprio_parse() ?

> +{
> +	struct cmdprio_options *options = cmdprio->options;
> +	int ret = 1;
>  	int i;
>  
> +	if (cmdprio->mode == CMDPRIO_MODE_BSSPLIT)
> +		ret = fio_cmdprio_parse_and_gen_bssplit(td, cmdprio);
> +	else if (cmdprio->mode == CMDPRIO_MODE_PERC)
> +		ret = 0;

What about:

	int ret;

	if (cmdprio->mode == CMDPRIO_MODE_NONE)
		return 1;

	if (cmdprio->mode == CMDPRIO_MODE_BSSPLIT) {
		ret = fio_cmdprio_parse_and_gen_bssplit(td, cmdprio);
		if (ret)
			return ret;
	}

And then "return 0;" at the end.

That is easier to follow this way, no ?

> +
>  	/*
>  	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
>  	 * is not set, default to RT priority class.
>  	 */
>  	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
> -		if (cmdprio->percentage[i]) {
> -			if (!cmdprio->class[i])
> -				cmdprio->class[i] = IOPRIO_CLASS_RT;
> -			has_cmdprio_percentage = true;
> -		}
> -		if (cmdprio->bssplit_nr[i]) {
> -			if (!cmdprio->class[i])
> -				cmdprio->class[i] = IOPRIO_CLASS_RT;
> -			has_cmdprio_bssplit = true;
> +		if (options->percentage[i] || cmdprio->bssplit_nr[i]) {
> +			if (!options->class[i])
> +				options->class[i] = IOPRIO_CLASS_RT;
>  		}
>  	}
>  
> +	return ret;
> +}
> +
> +void fio_cmdprio_cleanup(struct cmdprio *cmdprio)
> +{
> +	int ddir;
> +
> +	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
> +		free(cmdprio->bssplit[ddir]);
> +		cmdprio->bssplit[ddir] = NULL;
> +		cmdprio->bssplit_nr[ddir] = 0;
> +	}
> +
> +	/*
> +	 * options points to a cmdprio_options struct that is part of td->eo.
> +	 * td->eo itself will be freed by free_ioengine().
> +	 */
> +	cmdprio->options = NULL;
> +}
> +
> +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> +		     struct cmdprio_options *options)
> +{
> +	struct thread_options *to = &td->o;
> +	bool has_cmdprio_percentage = false;
> +	bool has_cmdprio_bssplit = false;
> +	int i;
> +
> +	cmdprio->options = options;
> +
> +	if (options->bssplit_str && strlen(options->bssplit_str))
> +		has_cmdprio_bssplit = true;
> +
> +	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
> +		if (options->percentage[i])
> +			has_cmdprio_percentage = true;
> +	}
> +
>  	/*
>  	 * Check for option conflicts
>  	 */
> @@ -178,5 +228,9 @@ int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio)
>  	else
>  		cmdprio->mode = CMDPRIO_MODE_NONE;
>  
> -	return 0;
> +	/* Nothing left to do if cmdprio is not used */
> +	if (cmdprio->mode == CMDPRIO_MODE_NONE)
> +		return 0;
> +
> +	return fio_cmdprio_gen_data_structs(td, cmdprio);
>  }
> diff --git a/engines/cmdprio.h b/engines/cmdprio.h
> index 7e4fcf6c..0c7bd6cf 100644
> --- a/engines/cmdprio.h
> +++ b/engines/cmdprio.h
> @@ -17,21 +17,26 @@ enum {
>  	CMDPRIO_MODE_BSSPLIT,
>  };
>  
> -struct cmdprio {
> +struct cmdprio_options {
>  	unsigned int percentage[CMDPRIO_RWDIR_CNT];
>  	unsigned int class[CMDPRIO_RWDIR_CNT];
>  	unsigned int level[CMDPRIO_RWDIR_CNT];
> +	char *bssplit_str;
> +};
> +
> +struct cmdprio {
> +	struct cmdprio_options *options;
>  	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
>  	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
>  	unsigned int mode;
>  };
>  
> -int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
> -			      struct cmdprio *cmdprio);
> -
>  bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
>  			    struct io_u *io_u);
>  
> -int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio);
> +void fio_cmdprio_cleanup(struct cmdprio *cmdprio);
> +
> +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> +		     struct cmdprio_options *options);
>  
>  #endif
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index 979d07d4..b2308b94 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -68,12 +68,14 @@ struct ioring_data {
>  	int prepped;
>  
>  	struct ioring_mmap mmap[3];
> +
> +	struct cmdprio cmdprio;
>  };
>  
>  struct ioring_options {
>  	struct thread_data *td;
>  	unsigned int hipri;
> -	struct cmdprio cmdprio;
> +	struct cmdprio_options cmdprio_options;
>  	unsigned int fixedbufs;
>  	unsigned int registerfiles;
>  	unsigned int sqpoll_thread;
> @@ -104,15 +106,6 @@ static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
>  	return 0;
>  }
>  
> -static int str_cmdprio_bssplit_cb(void *data, const char *input)
> -{
> -	struct ioring_options *o = data;
> -	struct thread_data *td = o->td;
> -	struct cmdprio *cmdprio = &o->cmdprio;
> -
> -	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
> -}
> -
>  static struct fio_option options[] = {
>  	{
>  		.name	= "hipri",
> @@ -129,9 +122,9 @@ static struct fio_option options[] = {
>  		.lname	= "high priority percentage",
>  		.type	= FIO_OPT_INT,
>  		.off1	= offsetof(struct ioring_options,
> -				   cmdprio.percentage[DDIR_READ]),
> +				   cmdprio_options.percentage[DDIR_READ]),
>  		.off2	= offsetof(struct ioring_options,
> -				   cmdprio.percentage[DDIR_WRITE]),
> +				   cmdprio_options.percentage[DDIR_WRITE]),
>  		.minval	= 0,
>  		.maxval	= 100,
>  		.help	= "Send high priority I/O this percentage of the time",
> @@ -143,9 +136,9 @@ static struct fio_option options[] = {
>  		.lname	= "Asynchronous I/O priority class",
>  		.type	= FIO_OPT_INT,
>  		.off1	= offsetof(struct ioring_options,
> -				   cmdprio.class[DDIR_READ]),
> +				   cmdprio_options.class[DDIR_READ]),
>  		.off2	= offsetof(struct ioring_options,
> -				   cmdprio.class[DDIR_WRITE]),
> +				   cmdprio_options.class[DDIR_WRITE]),
>  		.help	= "Set asynchronous IO priority class",
>  		.minval	= IOPRIO_MIN_PRIO_CLASS + 1,
>  		.maxval	= IOPRIO_MAX_PRIO_CLASS,
> @@ -158,9 +151,9 @@ static struct fio_option options[] = {
>  		.lname	= "Asynchronous I/O priority level",
>  		.type	= FIO_OPT_INT,
>  		.off1	= offsetof(struct ioring_options,
> -				   cmdprio.level[DDIR_READ]),
> +				   cmdprio_options.level[DDIR_READ]),
>  		.off2	= offsetof(struct ioring_options,
> -				   cmdprio.level[DDIR_WRITE]),
> +				   cmdprio_options.level[DDIR_WRITE]),
>  		.help	= "Set asynchronous IO priority level",
>  		.minval	= IOPRIO_MIN_PRIO,
>  		.maxval	= IOPRIO_MAX_PRIO,
> @@ -171,9 +164,9 @@ static struct fio_option options[] = {
>  	{
>  		.name   = "cmdprio_bssplit",
>  		.lname  = "Priority percentage block size split",
> -		.type   = FIO_OPT_STR_ULL,
> -		.cb     = str_cmdprio_bssplit_cb,
> -		.off1   = offsetof(struct ioring_options, cmdprio.bssplit),
> +		.type   = FIO_OPT_STR_STORE,
> +		.off1   = offsetof(struct ioring_options,
> +				   cmdprio_options.bssplit_str),
>  		.help   = "Set priority percentages for different block sizes",
>  		.category = FIO_OPT_C_ENGINE,
>  		.group	= FIO_OPT_G_IOURING,
> @@ -458,8 +451,7 @@ static inline void fio_ioring_cmdprio_prep(struct thread_data *td,
>  					   struct io_u *io_u)
>  {
>  	struct ioring_data *ld = td->io_ops_data;
> -	struct ioring_options *o = td->eo;
> -	struct cmdprio *cmdprio = &o->cmdprio;
> +	struct cmdprio *cmdprio = &ld->cmdprio;
>  
>  	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u))
>  		ld->sqes[io_u->index].ioprio = io_u->ioprio;
> @@ -470,7 +462,6 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
>  {
>  	struct ioring_data *ld = td->io_ops_data;
>  	struct io_sq_ring *ring = &ld->sq_ring;
> -	struct ioring_options *o = td->eo;
>  	unsigned tail, next_tail;
>  
>  	fio_ro_check(td, io_u);
> @@ -493,7 +484,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
>  	if (next_tail == atomic_load_acquire(ring->head))
>  		return FIO_Q_BUSY;
>  
> -	if (o->cmdprio.mode != CMDPRIO_MODE_NONE)
> +	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
>  		fio_ioring_cmdprio_prep(td, io_u);
>  
>  	ring->array[tail & ld->sq_ring_mask] = io_u->index;
> @@ -599,6 +590,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
>  		if (!(td->flags & TD_F_CHILD))
>  			fio_ioring_unmap(ld);
>  
> +		fio_cmdprio_cleanup(&ld->cmdprio);
>  		free(ld->io_u_index);
>  		free(ld->iovecs);
>  		free(ld->fds);
> @@ -805,7 +797,6 @@ static int fio_ioring_init(struct thread_data *td)
>  {
>  	struct ioring_options *o = td->eo;
>  	struct ioring_data *ld;
> -	struct cmdprio *cmdprio = &o->cmdprio;
>  	int ret;
>  
>  	/* sqthread submission requires registered files */
> @@ -830,7 +821,7 @@ static int fio_ioring_init(struct thread_data *td)
>  
>  	td->io_ops_data = ld;
>  
> -	ret = fio_cmdprio_init(td, cmdprio);
> +	ret = fio_cmdprio_init(td, &ld->cmdprio, &o->cmdprio_options);
>  	if (ret) {
>  		td_verror(td, EINVAL, "fio_ioring_init");
>  		return 1;
> diff --git a/engines/libaio.c b/engines/libaio.c
> index 53fe7428..9c278d06 100644
> --- a/engines/libaio.c
> +++ b/engines/libaio.c
> @@ -51,24 +51,17 @@ struct libaio_data {
>  	unsigned int queued;
>  	unsigned int head;
>  	unsigned int tail;
> +
> +	struct cmdprio cmdprio;
>  };
>  
>  struct libaio_options {
>  	struct thread_data *td;
>  	unsigned int userspace_reap;
> -	struct cmdprio cmdprio;
> +	struct cmdprio_options cmdprio_options;
>  	unsigned int nowait;
>  };
>  
> -static int str_cmdprio_bssplit_cb(void *data, const char *input)
> -{
> -	struct libaio_options *o = data;
> -	struct thread_data *td = o->td;
> -	struct cmdprio *cmdprio = &o->cmdprio;
> -
> -	return fio_cmdprio_bssplit_parse(td, input, cmdprio);
> -}
> -
>  static struct fio_option options[] = {
>  	{
>  		.name	= "userspace_reap",
> @@ -85,9 +78,9 @@ static struct fio_option options[] = {
>  		.lname	= "high priority percentage",
>  		.type	= FIO_OPT_INT,
>  		.off1	= offsetof(struct libaio_options,
> -				   cmdprio.percentage[DDIR_READ]),
> +				   cmdprio_options.percentage[DDIR_READ]),
>  		.off2	= offsetof(struct libaio_options,
> -				   cmdprio.percentage[DDIR_WRITE]),
> +				   cmdprio_options.percentage[DDIR_WRITE]),
>  		.minval	= 0,
>  		.maxval	= 100,
>  		.help	= "Send high priority I/O this percentage of the time",
> @@ -99,9 +92,9 @@ static struct fio_option options[] = {
>  		.lname	= "Asynchronous I/O priority class",
>  		.type	= FIO_OPT_INT,
>  		.off1	= offsetof(struct libaio_options,
> -				   cmdprio.class[DDIR_READ]),
> +				   cmdprio_options.class[DDIR_READ]),
>  		.off2	= offsetof(struct libaio_options,
> -				   cmdprio.class[DDIR_WRITE]),
> +				   cmdprio_options.class[DDIR_WRITE]),
>  		.help	= "Set asynchronous IO priority class",
>  		.minval	= IOPRIO_MIN_PRIO_CLASS + 1,
>  		.maxval	= IOPRIO_MAX_PRIO_CLASS,
> @@ -114,9 +107,9 @@ static struct fio_option options[] = {
>  		.lname	= "Asynchronous I/O priority level",
>  		.type	= FIO_OPT_INT,
>  		.off1	= offsetof(struct libaio_options,
> -				   cmdprio.level[DDIR_READ]),
> +				   cmdprio_options.level[DDIR_READ]),
>  		.off2	= offsetof(struct libaio_options,
> -				   cmdprio.level[DDIR_WRITE]),
> +				   cmdprio_options.level[DDIR_WRITE]),
>  		.help	= "Set asynchronous IO priority level",
>  		.minval	= IOPRIO_MIN_PRIO,
>  		.maxval	= IOPRIO_MAX_PRIO,
> @@ -127,9 +120,9 @@ static struct fio_option options[] = {
>  	{
>  		.name   = "cmdprio_bssplit",
>  		.lname  = "Priority percentage block size split",
> -		.type   = FIO_OPT_STR_ULL,
> -		.cb     = str_cmdprio_bssplit_cb,
> -		.off1   = offsetof(struct libaio_options, cmdprio.bssplit),
> +		.type   = FIO_OPT_STR_STORE,
> +		.off1   = offsetof(struct libaio_options,
> +				   cmdprio_options.bssplit_str),
>  		.help   = "Set priority percentages for different block sizes",
>  		.category = FIO_OPT_C_ENGINE,
>  		.group	= FIO_OPT_G_LIBAIO,
> @@ -206,8 +199,8 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
>  static inline void fio_libaio_cmdprio_prep(struct thread_data *td,
>  					   struct io_u *io_u)
>  {
> -	struct libaio_options *o = td->eo;
> -	struct cmdprio *cmdprio = &o->cmdprio;
> +	struct libaio_data *ld = td->io_ops_data;
> +	struct cmdprio *cmdprio = &ld->cmdprio;
>  
>  	if (fio_cmdprio_set_ioprio(td, cmdprio, io_u)) {
>  		io_u->iocb.aio_reqprio = io_u->ioprio;
> @@ -318,7 +311,6 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
>  					  struct io_u *io_u)
>  {
>  	struct libaio_data *ld = td->io_ops_data;
> -	struct libaio_options *o = td->eo;
>  
>  	fio_ro_check(td, io_u);
>  
> @@ -349,7 +341,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
>  		return FIO_Q_COMPLETED;
>  	}
>  
> -	if (o->cmdprio.mode != CMDPRIO_MODE_NONE)
> +	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
>  		fio_libaio_cmdprio_prep(td, io_u);
>  
>  	ld->iocbs[ld->head] = &io_u->iocb;
> @@ -468,6 +460,8 @@ static void fio_libaio_cleanup(struct thread_data *td)
>  		 */
>  		if (!(td->flags & TD_F_CHILD))
>  			io_destroy(ld->aio_ctx);
> +
> +		fio_cmdprio_cleanup(&ld->cmdprio);
>  		free(ld->aio_events);
>  		free(ld->iocbs);
>  		free(ld->io_us);
> @@ -493,7 +487,6 @@ static int fio_libaio_init(struct thread_data *td)
>  {
>  	struct libaio_data *ld;
>  	struct libaio_options *o = td->eo;
> -	struct cmdprio *cmdprio = &o->cmdprio;
>  	int ret;
>  
>  	ld = calloc(1, sizeof(*ld));
> @@ -506,7 +499,7 @@ static int fio_libaio_init(struct thread_data *td)
>  
>  	td->io_ops_data = ld;
>  
> -	ret = fio_cmdprio_init(td, cmdprio);
> +	ret = fio_cmdprio_init(td, &ld->cmdprio, &o->cmdprio_options);
>  	if (ret) {
>  		td_verror(td, EINVAL, "fio_libaio_init");
>  		return 1;
> 


-- 
Damien Le Moal
Western Digital Research
