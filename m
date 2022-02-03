Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57209C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241100AbiBCBVY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:21:24 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63312 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234817AbiBCBVY (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:21:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643851283; x=1675387283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uf4ts7pgVFlmdqjxqRiUWKc/xJ2Wpwmo1217sdcVJuw=;
  b=UYbjY9btkIDHr2MO/0vm/nkG4he55N22CBbYHoJGcYRNd9CBxYmiTNaB
   7dMA/iZLL6cVEFIhtf0slEgOp0fLwPHIq/0BuP4ePRZVS8kp4T2LyEbSJ
   tixRqxoAMxpiyMwCHwoPlUojlXddJZ/9p3y5YdFzlMch8UCjfzjqDJlRz
   eoMy8mQEWRr+F6Z28dudeZmDRiM+eEraZDU0ckOx0cEGC6Ix4C+gII6fb
   EfLCq3Sf8rCRCUy1Dc/Z4/ojz21Pc5n/oGgArZjYB89OPtm89/Dv7Sd9m
   WMVvoov/aSELjysbt9ztafDDexNKdwdLk/NAYLCP7glHOlP+djO8EHeCz
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="192028720"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:21:23 +0800
IronPort-SDR: 10hJrgAHHhLn1N4PWt6o32+rxey3GtXR8DjJ49wroh9uwF2dPB4sK5MjLuTMIA4jxP/uF/0USS
 iZeuqwg0F/zMevGA6SA2WS8upeSzXjZbITDH+LrWdcgjSWbZCPcjY+KwfQA6eALCNqW5peFBbi
 mo446GNHQWrG5X59IFgUzEdy5UdEp7e/vC4bj6S3NP71VHYrkJf49QAAdqRGT4GKKlyGvQuhQf
 Jk/c0xsVGHXmUYfiQI6n0uMbxsx60naCXb5ucUa4FBApanpIZm0MWaojb3fguhqbuOnau4qXyR
 GJuYR3orbl1I5XCsn3CT81q3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:54:32 -0800
IronPort-SDR: YGFvAc89kZ/joAYL+hkzivQcehFRzCVw5GskbcccWMABdPEE7Cp3rGnX190pLrlMR+bs0RdvF/
 NueqLBxN8/jJe1C7JO/0nS3uK+mf4NYvDV3iWNEPqZaY1Yi2CLSUW+OArAXfhOrkdhF18uLWvO
 ccP6khTLqjQFsTwhWCJ9roBRKjuvPvcYV2rHTIZOZ2HfEx1lgZjqi9h1VBf0oiLybRX3+qILFs
 GzyHcr8Nvt5Z6S5/4zhWkKTECWBC5XyxKhHCWC57HcFay0HugWdHHqfDr3Y/0TIFMVVeqlymDw
 +IA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:21:24 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq18g3yXKz1SHwl
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:21:23 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643851282; x=1646443283; bh=uf4ts7pgVFlmdqjxqRiUWKc/xJ2Wpwmo121
        7sdcVJuw=; b=fobHwEzLSOFMA+KeMPlbJPSNP1tS8/hB9yW6GxJf+O3vpzGI9lg
        nibwVqgWFXfU9zmosBUKb6Qc8N+VvEpbzGv1RPmfzquCDY4q6zy4HcrYN/J69QkN
        QP54qTWnDsNRRVM3xKe2Quz//VMa/J7v+3S9GK9He/wQSj1rU0vHidJC0bR9hsix
        G/B80nkDZsX+RMTbp0+1Vy0VvSDMQKS9wpgBVh5JWrCSX7AcASnc6/WRfZufC7BU
        SqCV17beQsG53/7xd9MaUS7xbZ9QXMKVUYvSHTxi/rby0/2pFvpzFQl5tCHzNwfh
        DCwsBB04vrSwU++s8YCeTp7bTQ5bufi3Ktg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fzmDYNXd9oH3 for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:21:22 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq18f09xMz1Rwrw;
        Wed,  2 Feb 2022 17:21:21 -0800 (PST)
Message-ID: <6b81306a-dced-5bda-7921-3c1534ce3bd4@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:21:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 07/17] cmdprio: add support for a new cmdprio_bssplit
 entry format
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-8-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-8-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Add support for a new cmdprio_bssplit format, while keeping support for the
> old format, by migrating to the split_parse_prio_ddir() parsing function.
> 
> In this new format, a priority class and priority level is defined inside
> each entry itself. In comparison with the old format, the new format does
> not restrict all entries to share the same priority class and priority
> level.
> 
> Therefore, this new format is very useful if you need to submit I/Os with
> multiple IO priority class + IO priority level combinations, e.g. when
> testing or verifying an IO scheduler.
> 
> cmdprio will allocate a clat_prio_stat array that holds all unique
> priorities (including the default priority). Finally, it will set the
> clat_prio pointer in the struct thread_stat (td->ts.clat_prio) to the
> newly allocated array.
> 
> We also add a clat_prio_stat index to io_u.h, that will inform which array
> element (which priority value) this specific I/O was submitted with.
> The clat_prio_stat index will be used by the stat.c code, to avoid a costly
> search operation to find the correct array element to use, for each and
> every add_sample().
> 
> Note that while this patch will send down the correct I/O pattern to the
> drive (potentially using multiple different priorities), it will not
> display the cmdprio_{bssplit,percentage} stats correctly until a later
> commit in the series (which changes stat.c to report clat stats on a per
> priority granularity). This was done to ease reviewing.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  HOWTO             |  26 ++-
>  backend.c         |   3 +
>  engines/cmdprio.c | 440 ++++++++++++++++++++++++++++++++++++++--------
>  engines/cmdprio.h |  22 ++-
>  fio.1             |  32 +++-
>  io_u.c            |   1 +
>  io_u.h            |   1 +
>  7 files changed, 440 insertions(+), 85 deletions(-)
> 
> diff --git a/HOWTO b/HOWTO
> index c72ec8cd..cb794b0d 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -2212,10 +2212,28 @@ with the caveat that when used on the command line, they must come after the
>  	depending on the block size of the IO. This option is useful only
>  	when used together with the :option:`bssplit` option, that is,
>  	multiple different block sizes are used for reads and writes.
> -	The format for this option is the same as the format of the
> -	:option:`bssplit` option, with the exception that values for
> -	trim IOs are ignored. This option is mutually exclusive with the
> -	:option:`cmdprio_percentage` option.
> +
> +	The first accepted format for this option is the same as the format of
> +	the :option:`bssplit` option:
> +
> +		cmdprio_bssplit=blocksize/percentage:blocksize/percentage
> +
> +	In this case, each entry will use the priority class and priority
> +	level defined by the options :option:`cmdprio_class` and
> +	:option:`cmdprio` respectively.
> +
> +	The second accepted format for this option is:
> +
> +		cmdprio_bssplit=blocksize/percentage/class/level:blocksize/percentage/class/level
> +
> +	In this case, the priority class and priority level is defined inside
> +	each entry. In comparison with the first accepted format, the second
> +	accepted format does not restrict all entries to have the same priority
> +	class and priority level.
> +
> +	For both formats, only the read and write data directions are supported,
> +	values for trim IOs are ignored. This option is mutually exclusive with
> +	the :option:`cmdprio_percentage` option.
>  
>  .. option:: fixedbufs : [io_uring]
>  
> diff --git a/backend.c b/backend.c
> index abaaeeb8..933d8414 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -2613,6 +2613,9 @@ int fio_backend(struct sk_out *sk_out)
>  	}
>  
>  	for_each_td(td, i) {
> +		struct thread_stat *ts = &td->ts;
> +
> +		free_clat_prio_stats(ts);
>  		steadystate_free(td);
>  		fio_options_free(td);
>  		fio_dump_options_free(td);
> diff --git a/engines/cmdprio.c b/engines/cmdprio.c
> index 92b752ae..fd78d401 100644
> --- a/engines/cmdprio.c
> +++ b/engines/cmdprio.c
> @@ -5,45 +5,201 @@
>  
>  #include "cmdprio.h"
>  
> -static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_arg,
> -				    enum fio_ddir ddir, char *str, bool data)
> +/*
> + * Temporary array used during parsing. Will be freed after the corresponding
> + * struct bsprio_desc has been generated and saved in cmdprio->bsprio_desc.
> + */
> +struct cmdprio_parse_result {
> +	struct split_prio *entries;
> +	int nr_entries;
> +};
> +
> +/*
> + * Temporary array used during init. Will be freed after the corresponding
> + * struct clat_prio_stat array has been saved in td->ts.clat_prio and the
> + * matching clat_prio_indexes have been saved in each struct cmdprio_prio.
> + */
> +struct cmdprio_values {
> +	unsigned int *prios;
> +	int nr_prios;
> +};
> +
> +static int find_clat_prio_index(unsigned int *all_prios, int nr_prios,
> +				int32_t prio)
>  {
> -	struct cmdprio *cmdprio = cb_arg;
> -	struct split split;
> -	unsigned int i;
> +	int i;
>  
> -	if (ddir == DDIR_TRIM)
> -		return 0;
> +	for (i = 0; i < nr_prios; i++) {
> +		if (all_prios[i] == prio)
> +			return i;
> +	}
>  
> -	memset(&split, 0, sizeof(split));
> +	return -1;
> +}
>  
> -	if (split_parse_ddir(to, &split, str, data, BSSPLIT_MAX))
> +/**
> + * assign_clat_prio_index - In order to avoid stat.c the need to loop through
> + * all possible priorities each time add_clat_sample() / add_lat_sample() is
> + * called, save which index to use in each cmdprio_prio. This will later be
> + * propagated to the io_u, if the specific io_u was determined to use a cmdprio
> + * priority value.
> + */
> +static void assign_clat_prio_index(struct cmdprio_prio *prio,
> +				   struct cmdprio_values *values)
> +{
> +	int clat_prio_index = find_clat_prio_index(values->prios,
> +						   values->nr_prios,
> +						   prio->prio);
> +	if (clat_prio_index == -1) {
> +		clat_prio_index = values->nr_prios;
> +		values->prios[clat_prio_index] = prio->prio;
> +		values->nr_prios++;
> +	}
> +	prio->clat_prio_index = clat_prio_index;
> +}
> +
> +/**
> + * init_cmdprio_values - Allocate a temporary array that can hold all unique
> + * priorities (per ddir), so that we can assign_clat_prio_index() for each
> + * cmdprio_prio during setup. This temporary array is freed after setup.
> + */
> +static int init_cmdprio_values(struct cmdprio_values *values,
> +			       int max_unique_prios, struct thread_stat *ts)
> +{
> +	values->prios = calloc(max_unique_prios + 1,
> +			       sizeof(*values->prios));
> +	if (!values->prios)
>  		return 1;
> -	if (!split.nr)
> -		return 0;
>  
> -	cmdprio->bssplit_nr[ddir] = split.nr;
> -	cmdprio->bssplit[ddir] = malloc(split.nr * sizeof(struct bssplit));
> -	if (!cmdprio->bssplit[ddir])
> +	/* td->ioprio/ts->ioprio is always stored at index 0. */
> +	values->prios[0] = ts->ioprio;
> +	values->nr_prios++;
> +
> +	return 0;
> +}
> +
> +/**
> + * init_ts_clat_prio - Allocates and fills a clat_prio_stat array which holds
> + * all unique priorities (per ddir).
> + */
> +static int init_ts_clat_prio(struct thread_stat *ts, enum fio_ddir ddir,
> +			     struct cmdprio_values *values)
> +{
> +	int i;
> +
> +	if (alloc_clat_prio_stat_ddir(ts, ddir, values->nr_prios))
> +		return 1;
> +
> +	for (i = 0; i < values->nr_prios; i++)
> +		ts->clat_prio[ddir][i].ioprio = values->prios[i];
> +
> +	return 0;
> +}
> +
> +static int fio_cmdprio_fill_bsprio(struct cmdprio_bsprio *bsprio,
> +				   struct split_prio *entries,
> +				   struct cmdprio_values *values,
> +				   int implicit_cmdprio, int start, int end)
> +{
> +	struct cmdprio_prio *prio;
> +	int i = end - start + 1;
> +
> +	bsprio->prios = calloc(i, sizeof(*bsprio->prios));
> +	if (!bsprio->prios)
>  		return 1;
>  
> -	for (i = 0; i < split.nr; i++) {
> -		cmdprio->bssplit[ddir][i].bs = split.val1[i];
> -		if (split.val2[i] == -1U) {
> -			cmdprio->bssplit[ddir][i].perc = 0;
> -		} else {
> -			if (split.val2[i] > 100)
> -				cmdprio->bssplit[ddir][i].perc = 100;
> -			else
> -				cmdprio->bssplit[ddir][i].perc = split.val2[i];
> +	bsprio->bs = entries[start].bs;
> +	bsprio->nr_prios = 0;
> +	for (i = start; i <= end; i++) {
> +		prio = &bsprio->prios[bsprio->nr_prios];
> +		prio->perc = entries[i].perc;
> +		if (entries[i].prio == -1)
> +			prio->prio = implicit_cmdprio;
> +		else
> +			prio->prio = entries[i].prio;
> +		assign_clat_prio_index(prio, values);
> +		bsprio->tot_perc += entries[i].perc;
> +		if (bsprio->tot_perc > 100) {
> +			log_err("fio: cmdprio_bssplit total percentage "
> +				"for bs: %"PRIu64" exceeds 100\n",
> +				bsprio->bs);
> +			free(bsprio->prios);
> +			return 1;
>  		}
> +		bsprio->nr_prios++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +fio_cmdprio_generate_bsprio_desc(struct cmdprio_bsprio_desc *bsprio_desc,
> +				 struct cmdprio_parse_result *parse_res,
> +				 struct cmdprio_values *values,
> +				 int implicit_cmdprio)
> +{
> +	struct split_prio *entries = parse_res->entries;
> +	int nr_entries = parse_res->nr_entries;
> +	struct cmdprio_bsprio *bsprio;
> +	int i, start, count = 0;
> +
> +	/*
> +	 * The parsed result is sorted by blocksize, so count only the number
> +	 * of different blocksizes, to know how many cmdprio_bsprio we need.
> +	 */
> +	for (i = 0; i < nr_entries; i++) {
> +		while (i + 1 < nr_entries && entries[i].bs == entries[i + 1].bs)
> +			i++;
> +		count++;
>  	}
>  
> +	bsprio_desc->bsprios = calloc(count, sizeof(*bsprio_desc->bsprios));
> +	if (!bsprio_desc->bsprios)
> +		return 1;
> +
> +	start = 0;
> +	bsprio_desc->nr_bsprios = 0;
> +	for (i = 0; i < nr_entries; i++) {
> +		while (i + 1 < nr_entries && entries[i].bs == entries[i + 1].bs)
> +			i++;
> +		bsprio = &bsprio_desc->bsprios[bsprio_desc->nr_bsprios];
> +		/*
> +		 * All parsed entries with the same blocksize get saved in the
> +		 * same cmdprio_bsprio, to expedite the search in the hot path.
> +		 */
> +		if (fio_cmdprio_fill_bsprio(bsprio, entries, values,
> +					    implicit_cmdprio, start, i))
> +			/*
> +			 * We do not free bsprio_desc->bsprios here. The calling
> +			 * function should call fio_cmdprio_cleanup() on error.
> +			 */

Nit: I would move this comment above the calloc() for
bsprio_desc->bsprios, stating how it will be freed.

> +			return 1;
> +
> +		start = i + 1;
> +		bsprio_desc->nr_bsprios++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int fio_cmdprio_bssplit_ddir(struct thread_options *to, void *cb_arg,
> +				    enum fio_ddir ddir, char *str, bool data)
> +{
> +	struct cmdprio_parse_result *parse_res_arr = cb_arg;
> +	struct cmdprio_parse_result *parse_res = &parse_res_arr[ddir];
> +
> +	if (ddir == DDIR_TRIM)
> +		return 0;
> +
> +	if (split_parse_prio_ddir(to, &parse_res->entries,
> +				  &parse_res->nr_entries, str))
> +		return 1;
> +
>  	return 0;
>  }
>  
> -int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
> -			      struct cmdprio *cmdprio)
> +static int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
> +				     struct cmdprio_parse_result *parse_res)
>  {
>  	char *str, *p;
>  	int ret = 0;
> @@ -53,26 +209,39 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
>  	strip_blank_front(&str);
>  	strip_blank_end(str);
>  
> -	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio,
> +	ret = str_split_parse(td, str, fio_cmdprio_bssplit_ddir, parse_res,
>  			      false);
>  
>  	free(p);
>  	return ret;
>  }
>  
> -static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
> +/**
> + * fio_cmdprio_percentage - Returns the percentage of I/Os that should
> + * use a cmdprio priority value (rather than the default context priority).
> + *
> + * For CMDPRIO_MODE_BSSPLIT, if the percentage is non-zero, we will also
> + * return the matching bsprio, to avoid the same linear search elsewhere.
> + * For CMDPRIO_MODE_PERC, we will never return a bsprio.
> + */
> +static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u,
> +				  struct cmdprio_bsprio **bsprio)
>  {
> +	struct cmdprio_bsprio *bsprio_entry;
>  	enum fio_ddir ddir = io_u->ddir;
> -	struct cmdprio_options *options = cmdprio->options;
>  	int i;
>  
>  	switch (cmdprio->mode) {
>  	case CMDPRIO_MODE_PERC:
> -		return options->percentage[ddir];
> +		*bsprio = NULL;
> +		return cmdprio->perc_entry[ddir].perc;
>  	case CMDPRIO_MODE_BSSPLIT:
> -		for (i = 0; i < cmdprio->bssplit_nr[ddir]; i++) {
> -			if (cmdprio->bssplit[ddir][i].bs == io_u->buflen)
> -				return cmdprio->bssplit[ddir][i].perc;
> +		for (i = 0; i < cmdprio->bsprio_desc[ddir].nr_bsprios; i++) {
> +			bsprio_entry = &cmdprio->bsprio_desc[ddir].bsprios[i];
> +			if (bsprio_entry->bs == io_u->buflen) {
> +				*bsprio = bsprio_entry;
> +				return bsprio_entry->tot_perc;
> +			}
>  		}
>  		break;
>  	default:
> @@ -83,6 +252,11 @@ static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
>  		assert(0);
>  	}
>  
> +	/*
> +	 * This is totally fine, the given blocksize simply does not
> +	 * have any (non-zero) cmdprio_bssplit entries defined.
> +	 */
> +	*bsprio = NULL;
>  	return 0;
>  }
>  
> @@ -100,52 +274,162 @@ static int fio_cmdprio_percentage(struct cmdprio *cmdprio, struct io_u *io_u)
>  bool fio_cmdprio_set_ioprio(struct thread_data *td, struct cmdprio *cmdprio,
>  			    struct io_u *io_u)
>  {
> -	enum fio_ddir ddir = io_u->ddir;
> -	struct cmdprio_options *options = cmdprio->options;
> -	unsigned int p;
> -	unsigned int cmdprio_value =
> -		ioprio_value(options->class[ddir], options->level[ddir]);
> -
> -	p = fio_cmdprio_percentage(cmdprio, io_u);
> -	if (p && rand_between(&td->prio_state, 0, 99) < p) {
> -		io_u->ioprio = cmdprio_value;
> -		if (!td->ioprio || cmdprio_value < td->ioprio) {
> -			/*
> -			 * The async IO priority is higher (has a lower value)
> -			 * than the default priority (which is either 0 or the
> -			 * value set by "prio" and "prioclass" options).
> -			 */
> -			io_u->flags |= IO_U_F_HIGH_PRIO;
> -		}
> +	struct cmdprio_bsprio *bsprio;
> +	unsigned int p, rand;
> +	uint32_t perc = 0;
> +	int i;
> +
> +	p = fio_cmdprio_percentage(cmdprio, io_u, &bsprio);
> +	if (!p)
> +		return false;
> +
> +	rand = rand_between(&td->prio_state, 0, 99);
> +	if (rand >= p)
> +		return false;
> +
> +	switch (cmdprio->mode) {
> +	case CMDPRIO_MODE_PERC:
> +		io_u->ioprio = cmdprio->perc_entry[io_u->ddir].prio;
> +		io_u->clat_prio_index =
> +			cmdprio->perc_entry[io_u->ddir].clat_prio_index;
>  		return true;
> +	case CMDPRIO_MODE_BSSPLIT:
> +		assert(bsprio);
> +		for (i = 0; i < bsprio->nr_prios; i++) {
> +			struct cmdprio_prio *prio = &bsprio->prios[i];
> +
> +			perc += prio->perc;
> +			if (rand < perc) {
> +				io_u->ioprio = prio->prio;
> +				io_u->clat_prio_index = prio->clat_prio_index;
> +				return true;
> +			}
> +		}
> +		break;
> +	default:
> +		assert(0);
>  	}
>  
> -	if (td->ioprio && td->ioprio < cmdprio_value) {
> +	/* When rand < p (total perc), we should always find a cmdprio_prio. */
> +	assert(0);
> +	return false;
> +}
> +
> +static int fio_cmdprio_gen_perc(struct thread_data *td, struct cmdprio *cmdprio)
> +{
> +	struct cmdprio_options *options = cmdprio->options;
> +	struct cmdprio_prio *prio;
> +	struct cmdprio_values values[CMDPRIO_RWDIR_CNT] = {0};
> +	struct thread_stat *ts = &td->ts;
> +	enum fio_ddir ddir;
> +	int ret;
> +
> +	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
>  		/*
> -		 * The IO will be executed with the default priority (which is
> -		 * either 0 or the value set by "prio" and "prioclass options),
> -		 * and this priority is higher (has a lower value) than the
> -		 * async IO priority.
> +		 * Do not allocate a clat_prio array nor set the cmdprio struct
> +		 * if zero percent of the I/Os (for the ddir) should use a
> +		 * cmdprio priority value, or when the ddir is not enabled.
>  		 */
> -		io_u->flags |= IO_U_F_HIGH_PRIO;
> +		if (!options->percentage[ddir] ||
> +		    (ddir == DDIR_READ && !td_read(td)) ||
> +		    (ddir == DDIR_WRITE && !td_write(td)))
> +			continue;
> +
> +		ret = init_cmdprio_values(&values[ddir], 1, ts);
> +		if (ret)
> +			goto err;
> +
> +		prio = &cmdprio->perc_entry[ddir];
> +		prio->perc = options->percentage[ddir];
> +		prio->prio = ioprio_value(options->class[ddir],
> +					  options->level[ddir]);
> +		assign_clat_prio_index(prio, &values[ddir]);
> +
> +		ret = init_ts_clat_prio(ts, ddir, &values[ddir]);
> +		if (ret)
> +			goto err;
> +
> +		free(values[ddir].prios);
> +		values[ddir].prios = NULL;
> +		values[ddir].nr_prios = 0;
>  	}
>  
> -	return false;
> +	return 0;
> +
> +err:
> +	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++)
> +		free(values[ddir].prios);
> +	free_clat_prio_stats(ts);
> +
> +	return ret;
>  }
>  
>  static int fio_cmdprio_parse_and_gen_bssplit(struct thread_data *td,
>  					     struct cmdprio *cmdprio)
>  {
>  	struct cmdprio_options *options = cmdprio->options;
> -	int ret;
> -
> -	ret = fio_cmdprio_bssplit_parse(td, options->bssplit_str, cmdprio);
> +	struct cmdprio_parse_result parse_res[CMDPRIO_RWDIR_CNT] = {0};
> +	struct cmdprio_values values[CMDPRIO_RWDIR_CNT] = {0};
> +	struct thread_stat *ts = &td->ts;
> +	int ret, implicit_cmdprio;
> +	enum fio_ddir ddir;
> +
> +	ret = fio_cmdprio_bssplit_parse(td, options->bssplit_str,
> +					&parse_res[0]);
>  	if (ret)
>  		goto err;
>  
> +	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
> +		/*
> +		 * Do not allocate a clat_prio array nor set the cmdprio structs
> +		 * if there are no non-zero entries (for the ddir), or when the
> +		 * ddir is not enabled.
> +		 */
> +		if (!parse_res[ddir].nr_entries ||
> +		    (ddir == DDIR_READ && !td_read(td)) ||
> +		    (ddir == DDIR_WRITE && !td_write(td))) {
> +			free(parse_res[ddir].entries);
> +			parse_res[ddir].entries = NULL;
> +			parse_res[ddir].nr_entries = 0;
> +			continue;
> +		}
> +
> +		ret = init_cmdprio_values(&values[ddir],
> +					  parse_res[ddir].nr_entries, ts);
> +		if (ret)
> +			goto err;
> +
> +		implicit_cmdprio = ioprio_value(options->class[ddir],
> +						options->level[ddir]);
> +
> +		ret = fio_cmdprio_generate_bsprio_desc(&cmdprio->bsprio_desc[ddir],
> +						       &parse_res[ddir],
> +						       &values[ddir],
> +						       implicit_cmdprio);
> +		if (ret)
> +			goto err;
> +
> +		free(parse_res[ddir].entries);
> +		parse_res[ddir].entries = NULL;
> +		parse_res[ddir].nr_entries = 0;
> +
> +		ret = init_ts_clat_prio(ts, ddir, &values[ddir]);
> +		if (ret)
> +			goto err;
> +
> +		free(values[ddir].prios);
> +		values[ddir].prios = NULL;
> +		values[ddir].nr_prios = 0;
> +	}
> +
>  	return 0;
>  
>  err:
> +	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
> +		free(parse_res[ddir].entries);
> +		free(values[ddir].prios);
> +	}
> +	free_clat_prio_stats(ts);
>  	fio_cmdprio_cleanup(cmdprio);
>  
>  	return ret;
> @@ -157,40 +441,46 @@ static int fio_cmdprio_parse_and_gen(struct thread_data *td,
>  	struct cmdprio_options *options = cmdprio->options;
>  	int i, ret;
>  
> +	/*
> +	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
> +	 * is not set, default to RT priority class.
> +	 */
> +	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
> +		/*
> +		 * A cmdprio value is only used when fio_cmdprio_percentage()
> +		 * returns non-zero, so it is safe to set a class even for a
> +		 * DDIR that will never use it.
> +		 */
> +		if (!options->class[i])
> +			options->class[i] = IOPRIO_CLASS_RT;
> +	}
> +
>  	switch (cmdprio->mode) {
>  	case CMDPRIO_MODE_BSSPLIT:
>  		ret = fio_cmdprio_parse_and_gen_bssplit(td, cmdprio);
>  		break;
>  	case CMDPRIO_MODE_PERC:
> -		ret = 0;
> +		ret = fio_cmdprio_gen_perc(td, cmdprio);
>  		break;
>  	default:
>  		assert(0);
>  		return 1;
>  	}
>  
> -	/*
> -	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
> -	 * is not set, default to RT priority class.
> -	 */
> -	for (i = 0; i < CMDPRIO_RWDIR_CNT; i++) {
> -		if (options->percentage[i] || cmdprio->bssplit_nr[i]) {
> -			if (!options->class[i])
> -				options->class[i] = IOPRIO_CLASS_RT;
> -		}
> -	}
> -
>  	return ret;
>  }
>  
>  void fio_cmdprio_cleanup(struct cmdprio *cmdprio)
>  {
> -	int ddir;
> +	enum fio_ddir ddir;
> +	int i;
>  
>  	for (ddir = 0; ddir < CMDPRIO_RWDIR_CNT; ddir++) {
> -		free(cmdprio->bssplit[ddir]);
> -		cmdprio->bssplit[ddir] = NULL;
> -		cmdprio->bssplit_nr[ddir] = 0;
> +		for (i = 0; i < cmdprio->bsprio_desc[ddir].nr_bsprios; i++)
> +			free(cmdprio->bsprio_desc[ddir].bsprios[i].prios);
> +		free(cmdprio->bsprio_desc[ddir].bsprios);
> +		cmdprio->bsprio_desc[ddir].bsprios = NULL;
> +		cmdprio->bsprio_desc[ddir].nr_bsprios = 0;
>  	}
>  
>  	/*
> diff --git a/engines/cmdprio.h b/engines/cmdprio.h
> index 0c7bd6cf..755da8d0 100644
> --- a/engines/cmdprio.h
> +++ b/engines/cmdprio.h
> @@ -17,6 +17,24 @@ enum {
>  	CMDPRIO_MODE_BSSPLIT,
>  };
>  
> +struct cmdprio_prio {
> +	int32_t prio;
> +	uint32_t perc;
> +	uint16_t clat_prio_index;
> +};
> +
> +struct cmdprio_bsprio {
> +	uint64_t bs;
> +	uint32_t tot_perc;
> +	unsigned int nr_prios;
> +	struct cmdprio_prio *prios;
> +};
> +
> +struct cmdprio_bsprio_desc {
> +	struct cmdprio_bsprio *bsprios;
> +	unsigned int nr_bsprios;
> +};
> +
>  struct cmdprio_options {
>  	unsigned int percentage[CMDPRIO_RWDIR_CNT];
>  	unsigned int class[CMDPRIO_RWDIR_CNT];
> @@ -26,8 +44,8 @@ struct cmdprio_options {
>  
>  struct cmdprio {
>  	struct cmdprio_options *options;
> -	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
> -	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
> +	struct cmdprio_prio perc_entry[CMDPRIO_RWDIR_CNT];
> +	struct cmdprio_bsprio_desc bsprio_desc[CMDPRIO_RWDIR_CNT];
>  	unsigned int mode;
>  };
>  
> diff --git a/fio.1 b/fio.1
> index b87d2309..3c26a48d 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -1995,10 +1995,34 @@ To get a finer control over I/O priority, this option allows specifying
>  the percentage of IOs that must have a priority set depending on the block
>  size of the IO. This option is useful only when used together with the option
>  \fBbssplit\fR, that is, multiple different block sizes are used for reads and
> -writes. The format for this option is the same as the format of the
> -\fBbssplit\fR option, with the exception that values for trim IOs are
> -ignored. This option is mutually exclusive with the \fBcmdprio_percentage\fR
> -option.
> +writes.
> +.RS
> +.P
> +The first accepted format for this option is the same as the format of the
> +\fBbssplit\fR option:
> +.RS
> +.P
> +cmdprio_bssplit=blocksize/percentage:blocksize/percentage
> +.RE
> +.P
> +In this case, each entry will use the priority class and priority level defined
> +by the options \fBcmdprio_class\fR and \fBcmdprio\fR respectively.
> +.P
> +The second accepted format for this option is:
> +.RS
> +.P
> +cmdprio_bssplit=blocksize/percentage/class/level:blocksize/percentage/class/level
> +.RE
> +.P
> +In this case, the priority class and priority level is defined inside each
> +entry. In comparison with the first accepted format, the second accepted format
> +does not restrict all entries to have the same priority class and priority
> +level.
> +.P
> +For both formats, only the read and write data directions are supported, values
> +for trim IOs are ignored. This option is mutually exclusive with the
> +\fBcmdprio_percentage\fR option.
> +.RE
>  .TP
>  .BI (io_uring)fixedbufs
>  If fio is asked to do direct IO, then Linux will map pages for each IO call, and
> diff --git a/io_u.c b/io_u.c
> index 3c72d63d..656b4610 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -1803,6 +1803,7 @@ struct io_u *get_io_u(struct thread_data *td)
>  	 * Remember the issuing context priority. The IO engine may change this.
>  	 */
>  	io_u->ioprio = td->ioprio;
> +	io_u->clat_prio_index = 0;
>  out:
>  	assert(io_u->file);
>  	if (!td_io_prep(td, io_u)) {
> diff --git a/io_u.h b/io_u.h
> index bdbac525..d88d5f2c 100644
> --- a/io_u.h
> +++ b/io_u.h
> @@ -50,6 +50,7 @@ struct io_u {
>  	 * IO priority.
>  	 */
>  	unsigned short ioprio;
> +	unsigned short clat_prio_index;
>  
>  	/*
>  	 * Allocated/set buffer and length

With the nit fixed, looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
