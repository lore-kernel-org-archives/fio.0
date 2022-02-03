Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1305C433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347916AbiBCBOB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:14:01 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:28554 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbiBCBOB (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:14:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643850841; x=1675386841;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5mx5JqBQ2Xv581fD2mv5LTXqvWsCdEnxvRwoC5DBnbc=;
  b=R4Y2VxpfFzMaRsNs+sUjl1c2lL7UO7Xh3Q2gra98EgSsHVnKlEzCd1qS
   wegRjlZLMPeBTHetr6i45tEuyIY/lUCLEQph2bDMgxLEJgVvYkoeatge4
   OHBNscvHfFC0Fx0gQbJPM5zlHNjfFT3LDxyVC+FTVDa6pdsXb40C36E/k
   IcyO2CBoqzKnUy4kLlKJLKyC2LFdp17KoAfQ8aP04T9inEB2PplEb/+a5
   i76fPoqBuioO/onOAkxdYPjQo/xhNHEzShmWRG9rItij7xkWMRNowjQsb
   SpV/xsYs2HrpHau3jQ1F8q24DimNsJZwWCdw7lQplMfrEq9p35eBLVk24
   g==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="303931419"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:04:40 +0800
IronPort-SDR: VrrhevtL/OzbzX979JgzIDni0j1ZKiQ0fxkA2UxcVL3m9q7N1YdJww5mpCu/Q4UQD923jRiTwK
 eqvv+BmXuj31FbyeGHZ/3t8akA1cH4grB/v76jOtd6lGSrbAzgZBuIZkFBBpUYlaN/tklHdQrE
 nWp2UfgP5T0GRxLrdoho0tXZY5umLMk5vxU3vMx+OYTrhC0Xkp/iV/GLUtWpHXETHj6BtXk/iR
 IuCOgyAtqf5EEc1zfv1GpNjcwSKZcpXtXo9+830oCVCGx5kyvHx/2QPeWysSW7FQowP4slLZSy
 mk4VfS2ta66gITqdAbrdP8W4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:36:36 -0800
IronPort-SDR: Q/srFG73EGjnHy71Gd+AMZOLsAhEOoIhpCAfcsQYLwb7JUw+uXeUIlJAXVdme2FowHdCiDtA6R
 8kS1mPv3Bys63Aozk+2SKTURzpkttJlIVhW6jGd0su+ZbRvLOROshCQtrB3hC2gEKfc0niHZpq
 mARe0ehIjhghK+GmWQ/OrOUPuXkOlvmj7dlpsVkow67n7d0C2qPxw5+rkpWEl8OpP2X4OITidZ
 N/cQXb1Jm5URk+C7iKPLW6Z4/x1V1UC1M+iDKJT190z5hOSf1FTiFYP4nj/KTXba6dQo6Y/Nij
 fqw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:04:40 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq0nN4kbsz1SVny
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:04:40 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643850280; x=1646442281; bh=5mx5JqBQ2Xv581fD2mv5LTXqvWsCdEnxvRw
        oC5DBnbc=; b=Zb92l6ZXnu6Z9MeoZdqqQuHn35Qh1/P5SRrJVOFmQpzUQK0o3uf
        BLjd+1VwSOBTtiViWcsLHDpqjXQDlNcjSZOJ2ba3In00F4GboJecNAT471lFDfQk
        83+mlurb3WCDlcNkpSgRUWeiMXvbfNBPoym5UULk3NJO7xYDIrIHcfli/clWXxjR
        ROFI+KN3Hx75laUEcvkrxV7LcIESufp5CqOJ4vFoJbat78YiLG8da7PGnVUIvOiM
        KBrS6pgGk+JiAM9GMUMV8/4oYYsYstXs3uyHOwqW1p/5y20xdfNWwlmsWXJFaeM+
        mZCmcH+YlCvciqxaFvesedZZEggVRg+CMSg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QorInnjJ61QN for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:04:40 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq0nM4NGMz1Rwrw;
        Wed,  2 Feb 2022 17:04:39 -0800 (PST)
Message-ID: <eb127b06-7800-aa0a-8a86-869c28a14a37@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:04:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 06/17] options: add a parsing function for an additional
 cmdprio_bssplit format
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-7-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-7-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The cmdprio_bssplit ioengine option for io_uring/libaio is currently parsed
> using split_parse_ddir(). While this function works fine for parsing the
> existing cmdprio_bssplit entry format, it forces every cmdprio_bssplit
> entry to use the priority defined by cmdprio and cmdprio_class. This means
> that there will only ever be at most two different priority values used in
> the job.
> 
> To enable us to use more than two different priority values, add a new
> parsing function, split_parse_prio_ddir(), that will support parsing the
> existing cmdprio_bssplit entry format (blocksize/percentage), and a new
> cmdprio_bssplit entry format (blocksize/percentage/prioclass/priolevel).
> 
> Since IO engines can be compiled as plugins, having the parse function in
> options.c avoids potential problems with ioengines having different
> versions of the same parsing function.
> 
> A follow up patch will change to the new parsing function.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  options.c        | 126 +++++++++++++++++++++++++++++++++++++++++++++++
>  thread_options.h |  10 ++++
>  2 files changed, 136 insertions(+)
> 
> diff --git a/options.c b/options.c
> index 102bcf56..4f2ce0d0 100644
> --- a/options.c
> +++ b/options.c
> @@ -278,6 +278,132 @@ static int str_bssplit_cb(void *data, const char *input)
>  	return ret;
>  }
>  
> +static int parse_cmdprio_bssplit_entry(struct thread_options *o,
> +				       struct split_prio *entry, char *str)
> +{
> +	int matches = 0;
> +	char *bs_str = NULL;
> +	long long bs_val;
> +	unsigned int perc = 0, class, level;
> +
> +	/*
> +	 * valid entry formats:
> +	 * bs/ - %s/ - set perc to 0, prio to -1.
> +	 * bs/perc - %s/%u - set prio to -1.
> +	 * bs/perc/class/level - %s/%u/%u/%u
> +	 */
> +	matches = sscanf(str, "%m[^/]/%u/%u/%u", &bs_str, &perc, &class, &level);
> +	if (matches < 1) {
> +		log_err("fio: invalid cmdprio_bssplit format\n");
> +		return 1;
> +	}
> +
> +	if (str_to_decimal(bs_str, &bs_val, 1, o, 0, 0)) {
> +		log_err("fio: split conversion failed\n");
> +		free(bs_str);
> +		return 1;
> +	}
> +	free(bs_str);
> +
> +	entry->bs = bs_val;
> +	entry->perc = min(perc, 100u);
> +	entry->prio = -1;
> +	switch (matches) {
> +	case 1: /* bs/ case */
> +	case 2: /* bs/perc case */
> +		break;
> +	case 4: /* bs/perc/class/level case */
> +#ifdef FIO_HAVE_IOPRIO_CLASS
> +		class = min(class, (unsigned int) IOPRIO_MAX_PRIO_CLASS);
> +#endif
> +#ifdef FIO_HAVE_IOPRIO
> +		level = min(level, (unsigned int) IOPRIO_MAX_PRIO);
> +#endif
> +		entry->prio = ioprio_value(class, level);

For the !FIO_HAVE_IOPRIO_CLASS and/or !FIO_HAVE_IOPRIO cases, class and
level will be used as-is... I wonder if they should be set to 0 ?
Or may be more simply, in os/os.h, conditionally define
IOPRIO_MAX_PRIO_CLASS to 0 if FIO_HAVE_IOPRIO_CLASS is false. Same for
IOPRIO_MAX_PRIO. That will avoid the #ifdef here.

> +		break;
> +	default:
> +		log_err("fio: invalid cmdprio_bssplit format\n");
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Returns a negative integer if the first argument should be before the second
> + * argument in the sorted list. A positive integer if the first argument should
> + * be after the second argument in the sorted list. A zero if they are equal.
> + */
> +static int fio_split_prio_cmp(const void *p1, const void *p2)
> +{
> +	const struct split_prio *tmp1 = p1;
> +	const struct split_prio *tmp2 = p2;
> +
> +	if (tmp1->bs > tmp2->bs)
> +		return 1;
> +	if (tmp1->bs < tmp2->bs)
> +		return -1;
> +	return 0;
> +}
> +
> +int split_parse_prio_ddir(struct thread_options *o, struct split_prio **entries,
> +			  int *nr_entries, char *str)
> +{
> +	struct split_prio *tmp_entries;
> +	unsigned int nr_bssplits;
> +	char *str_cpy, *p, *fname;
> +
> +	/* strsep modifies the string, dup it so that we can use strsep twice */
> +	p = str_cpy = strdup(str);
> +	if (!p)
> +		return 1;
> +
> +	nr_bssplits = 0;
> +	while ((fname = strsep(&str_cpy, ":")) != NULL) {
> +		if (!strlen(fname))
> +			break;
> +		nr_bssplits++;
> +	}
> +	free(p);
> +
> +	if (nr_bssplits > BSSPLIT_MAX) {
> +		log_err("fio: too many cmdprio_bssplit entries\n");
> +		return 1;
> +	}
> +
> +	tmp_entries = calloc(nr_bssplits, sizeof(*tmp_entries));
> +	if (!tmp_entries)
> +		return 1;
> +
> +	nr_bssplits = 0;
> +	while ((fname = strsep(&str, ":")) != NULL) {
> +		struct split_prio *entry;
> +
> +		if (!strlen(fname))
> +			break;
> +
> +		entry = &tmp_entries[nr_bssplits];
> +
> +		if (parse_cmdprio_bssplit_entry(o, entry, fname)) {
> +			log_err("fio: failed to parse cmdprio_bssplit entry\n");
> +			free(tmp_entries);
> +			return 1;
> +		}
> +
> +		/* skip zero perc entries, they provide no useful information */
> +		if (entry->perc)
> +			nr_bssplits++;
> +	}
> +
> +	qsort(tmp_entries, nr_bssplits, sizeof(*tmp_entries),
> +	      fio_split_prio_cmp);
> +
> +	*entries = tmp_entries;
> +	*nr_entries = nr_bssplits;
> +
> +	return 0;
> +}
> +
>  static int str2error(char *str)
>  {
>  	const char *err[] = { "EPERM", "ENOENT", "ESRCH", "EINTR", "EIO",
> diff --git a/thread_options.h b/thread_options.h
> index 8f4c8a59..ace658b7 100644
> --- a/thread_options.h
> +++ b/thread_options.h
> @@ -50,6 +50,12 @@ struct split {
>  	unsigned long long val2[ZONESPLIT_MAX];
>  };
>  
> +struct split_prio {
> +	uint64_t bs;
> +	int32_t prio;
> +	uint32_t perc;
> +};
> +
>  struct bssplit {
>  	uint64_t bs;
>  	uint32_t perc;
> @@ -702,4 +708,8 @@ extern int str_split_parse(struct thread_data *td, char *str,
>  extern int split_parse_ddir(struct thread_options *o, struct split *split,
>  			    char *str, bool absolute, unsigned int max_splits);
>  
> +extern int split_parse_prio_ddir(struct thread_options *o,
> +				 struct split_prio **entries, int *nr_entries,
> +				 char *str);
> +
>  #endif


-- 
Damien Le Moal
Western Digital Research
