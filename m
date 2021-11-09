Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678BDC433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46CDC61184
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbhKIGOW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 01:14:22 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57796 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238661AbhKIGOW (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 01:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636438296; x=1667974296;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Azsy4YGn01UaFv0rEAdSKa8xOLRtq5tNwERIWS8qWeU=;
  b=KOj2zUZ1Gy6YBLaw0CbM6GCAivO4bYu7+8HfbisP4mp7lTa/eXyJB8iD
   Nc8ZeoAqFb/vKuJpq8R2Fu1E+195EcskZ92P3W/W3mftolA7aI9XCzs5o
   OrYX27fMQ9j7WQbxNJ+QmRjXj51t430HvBFiJZ39DwvPsUxen8UBmGBdq
   CEOYn/kYb6rbNIcrrmSjMtnBSJs0t2eQtJoXeBrBH0NhL+JhlIna5v0LO
   WFtItGybzsNSpUbii9WcTK9Shpxx6VoT1TxDu/RGBfD+LZhzorm8+X3xt
   4OfohEtroeUztJyuiXlHIQ0P5r8VsTNWuL1Xx17GCiNLG+x8yPBIHt6gu
   A==;
X-IronPort-AV: E=Sophos;i="5.87,219,1631548800"; 
   d="scan'208";a="289013914"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 14:11:36 +0800
IronPort-SDR: 8sZqepVA9/0Qm6cWD0qod319A3kLg+AcQxFenw8sBGBmFIci4FvGykF3gWxzF2S1dzpBpycA9U
 /FYtw+Xo8tRc3RNesFx3SxcpHEIggSj3P95GjEqZx1A52rCDCHacE+fWl36JfgpLL+LAg+0Q97
 79SEmo59eqe9tzNewdn5XIYutlhIvbkrl+m2vuAXlQN8LqiaHuBH+WxNP7qEQKxg484s22tb9B
 pVHD+Q+WdeXAs3LAabni2ojKBCgjEfEa/HCVPOPnwM0nGxq1GnqeFH5vwOcEwY9QrHspLck3ko
 u6Fpgc0l8+VJ6v0ZOrqvu8ed
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 21:46:49 -0800
IronPort-SDR: RUYIU+NrWq8AtvScUsbKnuSty16FP3mAbqyaA3V7W2JBLnaO30I78zhVAzKKA+DUwPOgIpaysZ
 jCsnFuvR/NviL4BLyr0sLUlMV5iQUOQAyvrj6eLJIbuYiULDjutYP4QYfoc9ZSJUI7Uwq9iEPI
 2hotdpKGLlPYglXrOhwvJMmPSWiHC4CZAvETMADZI4lG6CkdE2OUViU6YLxp0OAfsS8PuaFJU0
 mBhcrpRKEB3rmIZuh23FGVaYg9bKj7nZT0iBswCBGm2jPI8GFsoeilb4pXgscxh0nEfd80+BvY
 NRU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:11:37 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HpHgD2khnz1RtVp
        for <fio@vger.kernel.org>; Mon,  8 Nov 2021 22:11:36 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636438295; x=1639030296; bh=Azsy4YGn01UaFv0rEAdSKa8xOLRtq5tNwER
        IWS8qWeU=; b=J0yheBRoyrKgPxTPjLZCZdAxFLHfLfYIXu9Pc883IQsoFp50Vbj
        4tjJciAAuF12TpxBbEWL2yq8O2wZJOasOO1+00FP1zJmNiCP8aOqjzs5P2GOT3Np
        XARkfVpFhBiQUe4ZO3WuztZkB2vdvsP8pv7b80RWh4qGgOjHLZBS6OkBMZhHRCec
        PUx/HLE3k1EnnStPiacY/GXRe7QdKXM1tbl2ey4IHy+l7iWSnHoZOTnzWbe5545o
        S6bTQSVTqBbA+QqbI8ZWhuVdx5+39jvlXy45g5izGCAcmKj6kImZyTIJghUXKmjh
        eUfY2W4SVblwoB99xLfOKveHdLcRQ4+I6VQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QUwSCGU5tmx4 for <fio@vger.kernel.org>;
        Mon,  8 Nov 2021 22:11:35 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HpHgB6twdz1RtVl;
        Mon,  8 Nov 2021 22:11:34 -0800 (PST)
Message-ID: <baaa4204-1d15-9bb3-2e5f-6c510c6cfa79@opensource.wdc.com>
Date:   Tue, 9 Nov 2021 15:11:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 2/8] cmdprio: move cmdprio function definitions to a new
 cmdprio.c file
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-3-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109002655.117274-3-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/09 9:28, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Move cmdprio function definitions from the cmdprio.h header file to a new
> cmdprio.c file, such that we can add new static functions to cmdprio.c.
> 
> A follow up patch will add new cmdprio functions which do not need to be
> directly accessible by ioengines.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  Makefile          |   6 +++
>  engines/cmdprio.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++
>  engines/cmdprio.h | 127 ++------------------------------------------
>  3 files changed, 141 insertions(+), 122 deletions(-)
>  create mode 100644 engines/cmdprio.c
> 
> diff --git a/Makefile b/Makefile
> index 4ae5a371..e9028dce 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -98,6 +98,7 @@ else ifdef CONFIG_32BIT
>  endif
>  ifdef CONFIG_LIBAIO
>    libaio_SRCS = engines/libaio.c
> +  cmdprio_SRCS = engines/cmdprio.c
>    libaio_LIBS = -laio
>    ENGINES += libaio
>  endif
> @@ -225,6 +226,7 @@ endif
>  ifeq ($(CONFIG_TARGET_OS), Linux)
>    SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
>  		oslib/linux-dev-lookup.c engines/io_uring.c
> +  cmdprio_SRCS = engines/cmdprio.c
>  ifdef CONFIG_HAS_BLKZONED
>    SOURCE += oslib/linux-blkzoned.c
>  endif
> @@ -281,6 +283,10 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
>    FIO_CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format
>  endif
>  
> +ifdef cmdprio_SRCS
> +  SOURCE += $(cmdprio_SRCS)
> +endif
> +
>  ifdef CONFIG_DYNAMIC_ENGINES
>   DYNAMIC_ENGS := $(ENGINES)
>  define engine_template =
> diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> new file mode 100644
> index 00000000..f5b7342f
> --- /dev/null
> +++ b/engines/cmdprio.c
> @@ -0,0 +1,130 @@
> +/*
> + * IO priority handling helper functions common to the libaio and io_uring
> + * engines.
> + */
> +
> +#include "cmdprio.h"
> +
> +static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_arg,
> +				    enum fio_ddir ddir, char *str, bool data)
> +{
> +	struct cmdprio *cmdprio = cb_arg;
> +	struct split split;
> +	unsigned int i;
> +
> +	if (ddir == DDIR_TRIM)
> +		return 0;
> +
> +	memset(&split, 0, sizeof(split));
> +
> +	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
> +		return 1;
> +	if (!split.nr)
> +		return 0;
> +
> +	cmdprio->bssplit_nr[ddir] = split.nr;
> +	cmdprio->bssplit[ddir] = malloc(split.nr * sizeof(struct bssplit));
> +	if (!cmdprio->bssplit[ddir])
> +		return 1;
> +
> +	for (i = 0; i < split.nr; i++) {
> +		cmdprio->bssplit[ddir][i].bs = split.val1[i];
> +		if (split.val2[i] == -1U) {
> +			cmdprio->bssplit[ddir][i].perc = 0;
> +		} else {
> +			if (split.val2[i] > 100)
> +				cmdprio->bssplit[ddir][i].perc = 100;
> +			else
> +				cmdprio->bssplit[ddir][i].perc = split.val2[i];
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
> +			      struct cmdprio *cmdprio)
> +{
> +	char *str, *p;
> +	int i, ret = 0;
> +
> +	p = str = strdup(input);
> +
> +	strip_blank_front(&str);
> +	strip_blank_end(str);
> +
> +	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false);
> +
> +	if (parse_dryrun()) {
> +		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> +			free(cmdprio->bssplit[i]);
> +			cmdprio->bssplit[i] = NULL;
> +			cmdprio->bssplit_nr[i] = 0;
> +		}
> +	}
> +
> +	free(p);
> +	return ret;
> +}
> +
> +int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
> +{
> +	enum fio_ddir ddir = io_u->ddir;
> +	unsigned int p = cmdprio->percentage[ddir];
> +	int i;
> +
> +	/*
> +	 * If cmdprio_percentage option was specified, then use that
> +	 * percentage. Otherwise, use cmdprio_bssplit percentages depending
> +	 * on the IO size.
> +	 */
> +	if (p)
> +		return p;
> +
> +	for (i = 0; i < cmdprio->bssplit_nr[ddir]; i++) {
> +		if (cmdprio->bssplit[ddir][i].bs == io_u->buflen)
> +			return cmdprio->bssplit[ddir][i].perc;
> +	}
> +
> +	return 0;
> +}
> +
> +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> +		     bool *has_cmdprio)
> +{
> +	struct thread_options *to = &td->o;
> +	bool has_cmdprio_percentage = false;
> +	bool has_cmdprio_bssplit = false;
> +	int i;
> +
> +	/*
> +	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
> +	 * is not set, default to RT priority class.
> +	 */
> +	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> +		if (cmdprio->percentage[i]) {
> +			if (!cmdprio->class[i])
> +				cmdprio->class[i] = IOPRIO_CLASS_RT;
> +			has_cmdprio_percentage = true;
> +		}
> +		if (cmdprio->bssplit_nr[i]) {
> +			if (!cmdprio->class[i])
> +				cmdprio->class[i] = IOPRIO_CLASS_RT;
> +			has_cmdprio_bssplit = true;
> +		}
> +	}
> +
> +	/*
> +	 * Check for option conflicts
> +	 */
> +	if (has_cmdprio_percentage && has_cmdprio_bssplit) {
> +		log_err("%s: cmdprio_percentage and cmdprio_bssplit options "
> +			"are mutually exclusive\n",
> +			to->name);
> +		return 1;
> +	}
> +
> +	*has_cmdprio = has_cmdprio_percentage || has_cmdprio_bssplit;
> +
> +	return 0;
> +}
> diff --git a/engines/cmdprio.h b/engines/cmdprio.h
> index 0edc4365..33a8f5b9 100644
> --- a/engines/cmdprio.h
> +++ b/engines/cmdprio.h
> @@ -16,129 +16,12 @@ struct cmdprio {
>  	struct bssplit *bssplit[DDIR_RWDIR_CNT];
>  };
>  
> -static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_arg,
> -				    enum fio_ddir ddir, char *str, bool data)
> -{
> -	struct cmdprio *cmdprio = cb_arg;
> -	struct split split;
> -	unsigned int i;
> +int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
> +			      struct cmdprio *cmdprio);
>  
> -	if (ddir == DDIR_TRIM)
> -		return 0;
> +int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u);
>  
> -	memset(&split, 0, sizeof(split));
> -
> -	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
> -		return 1;
> -	if (!split.nr)
> -		return 0;
> -
> -	cmdprio->bssplit_nr[ddir] = split.nr;
> -	cmdprio->bssplit[ddir] = malloc(split.nr * sizeof(struct bssplit));
> -	if (!cmdprio->bssplit[ddir])
> -		return 1;
> -
> -	for (i = 0; i < split.nr; i++) {
> -		cmdprio->bssplit[ddir][i].bs = split.val1[i];
> -		if (split.val2[i] == -1U) {
> -			cmdprio->bssplit[ddir][i].perc = 0;
> -		} else {
> -			if (split.val2[i] > 100)
> -				cmdprio->bssplit[ddir][i].perc = 100;
> -			else
> -				cmdprio->bssplit[ddir][i].perc = split.val2[i];
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -static int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
> -				     struct cmdprio *cmdprio)
> -{
> -	char *str, *p;
> -	int i, ret = 0;
> -
> -	p = str = strdup(input);
> -
> -	strip_blank_front(&str);
> -	strip_blank_end(str);
> -
> -	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false);
> -
> -	if (parse_dryrun()) {
> -		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> -			free(cmdprio->bssplit[i]);
> -			cmdprio->bssplit[i] = NULL;
> -			cmdprio->bssplit_nr[i] = 0;
> -		}
> -	}
> -
> -	free(p);
> -	return ret;
> -}
> -
> -static inline int fio_cmdprio_percentage(struct cmdprio *cmdprio,
> -					 struct io_u *io_u)
> -{
> -	enum fio_ddir ddir = io_u->ddir;
> -	unsigned int p = cmdprio->percentage[ddir];
> -	int i;
> -
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
> -	}
> -
> -	return 0;
> -}
> -
> -static int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> -			    bool *has_cmdprio)
> -{
> -	struct thread_options *to = &td->o;
> -	bool has_cmdprio_percentage = false;
> -	bool has_cmdprio_bssplit = false;
> -	int i;
> -
> -	/*
> -	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
> -	 * is not set, default to RT priority class.
> -	 */
> -	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> -		if (cmdprio->percentage[i]) {
> -			if (!cmdprio->class[i])
> -				cmdprio->class[i] = IOPRIO_CLASS_RT;
> -			has_cmdprio_percentage = true;
> -		}
> -		if (cmdprio->bssplit_nr[i]) {
> -			if (!cmdprio->class[i])
> -				cmdprio->class[i] = IOPRIO_CLASS_RT;
> -			has_cmdprio_bssplit = true;
> -		}
> -	}
> -
> -	/*
> -	 * Check for option conflicts
> -	 */
> -	if (has_cmdprio_percentage && has_cmdprio_bssplit) {
> -		log_err("%s: cmdprio_percentage and cmdprio_bssplit options "
> -			"are mutually exclusive\n",
> -			to->name);
> -		return 1;
> -	}
> -
> -	*has_cmdprio = has_cmdprio_percentage || has_cmdprio_bssplit;
> -
> -	return 0;
> -}
> +int fio_cmdprio_init(struct thread_data *td, struct cmdprio *cmdprio,
> +		     bool *has_cmdprio);
>  
>  #endif
> 


-- 
Damien Le Moal
Western Digital Research
