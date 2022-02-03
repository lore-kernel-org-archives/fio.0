Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78807C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 00:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345169AbiBCAyz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 19:54:55 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:21086 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240397AbiBCAyz (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 19:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643849694; x=1675385694;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BbCayGBJuPPeLgE6gpDgHa0VC5iA96lCXElV4XPo4HI=;
  b=B5XoOgdbtKm8cHITq8ROUWW3O8cgO+3wWp6EXCqjWJLTJzaxNfk24oYC
   nrUAAzt+VJhPV0jnvDKNyvSJfA86IyWzO1J3CEo023tNtEmTvQoDMJ/DY
   Yny+vepFjKJCoBlVLEWWRrHkH7rXvFQuL/D/NNqJS8rPGqeZeVNRKw4X+
   +8ad9CcMjsv/i0UsM1Ncyb3uZqLo0tZPVf1h3nFe1usMh3J5CRP9yhfJV
   0BHb6/5ARxOpJ8gNnLQqmgTOqTvHBUMnTs3vUZSZrOYTT2K02NOhNC9ll
   AWVgKn3z3nEzOQyAICDLSHL9g/U6SD4ugiVurz3/ClSLODBbLNDYLQZUp
   w==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="196837068"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 08:42:55 +0800
IronPort-SDR: WQajab1muzpRKNkdZkhzdUCtogfzJ3UV/eQ1niGf/sDdufQhLJXcXUIKAWOSaqFl/1DBgwWlac
 6bYz72w1Nx7wDcdHdFYyCsZvQ7ykepcX+QwXAi4V1EjeFru5anKP62l8rkj0xGMwsEP8nor43m
 4AnX98HTxG0/1cWlzGixQouv+Z27jsmenKc5f54B1ZZTeehR7hbRerit3dlLiakWdsis/VCDJA
 R+VGip0UWUT808wmW2BZol3DZgjXcgXATt46Z499a5iTS5H/oIzQDTBXKeKnLs1TCuTJPLz1cg
 LunO5+Wz10K3JWxUNrs7OGSa
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:14:51 -0800
IronPort-SDR: TTwdhtqhbDKLZ7l4NvblV+6s1p2CFg8medN2ZhAkcAYloAsXGzWLFqXwXky0k8wXUg1ELmNnDi
 ONMdSg0GMqs9uPzV1I0kY4idHKlvCEPRo9zhiH6pzE7O2psjMTRQNsdcnJrORbxQc9InIP8jzD
 kiwW7M3NpfTDs6cdQ13xBqST+tt5tUFEzXXhniMKvNptS32lmPUaO7+reKDAT0fPaAa5FtXYCz
 BuhTYT0ZwVQDGokFRc0DAjJLcKOCx70YL288ufrww17Wz55S2XqulXkPeQ9jopdv7ud+EXZkmK
 DR8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:42:55 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq0JH0MSJz1SVnx
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 16:42:55 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643848974; x=1646440975; bh=BbCayGBJuPPeLgE6gpDgHa0VC5iA96lCXEl
        V4XPo4HI=; b=n4BFiDZZ9LE0zj69XJqNjwh6JwGyEjk90JlI4ZXqxhM2LL4Rqyj
        gn1/Tp/n2InTY4qVUzukzDRbvoHZNVG4It1a/AIznWX8R0uPY4bVnhAwlUac9Cyz
        putHxfAbDYkWHIwKpYYSxAr2SzUQ7HZkDWWYSe7BVrt6TOOafxmUKBNJMTRZbVEr
        NmAIg5Wek4IDSy6jhBGPdHyppVOAYPeHyZJTnviVDh18wrtWzAP8dHVPlnEsvO8e
        FrqvRk1stjZReeABUboHAV4kzvVLMw6Rfb1suXLYSekaFVeKQNe5Z5N1PfR0enUG
        bWLvC7P8XRzY6GoY/7ScR3cfvModoIjYe2w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cXUkRIFEsUlJ for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 16:42:54 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq0JF6HWYz1Rwrw;
        Wed,  2 Feb 2022 16:42:53 -0800 (PST)
Message-ID: <506b1b87-b292-8523-0539-f24e0a3b1321@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 09:42:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 01/17] init: verify option lat_percentiles consistency for
 all jobs in group
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-2-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-2-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> lat_percentiles is used to control if the high/low latency statistics
> (which are saved in ts->io_u_plat_high_prio/ts->io_u_plat_high_prio)

missing io_u_plat_low_prio (io_u_plat_high_prio twice)

> should collect and display total latencies instead of completion latencies.
> 
> When doing group reporting, stat.c:__show_run_stats() happily overwrites
> the dst ts with the setting of each job, which means that the summing can
> take total lat samples for some jobs, and clat samples for some jobs, while
> adding samples into the same group result.
> 
> The output summary will claim that the results are of whatever type the
> final job in the group is set to.
> 
> To make sure that this cannot happen, verify that the option
> lat_percentiles is consistent for all jobs in group.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

With the nit above fixed, this looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  init.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/init.c b/init.c
> index 07daaa84..7d5f2221 100644
> --- a/init.c
> +++ b/init.c
> @@ -1445,6 +1445,26 @@ static bool wait_for_ok(const char *jobname, struct thread_options *o)
>  	return true;
>  }
>  
> +static int verify_per_group_options(struct thread_data *td, const char *jobname)
> +{
> +	struct thread_data *td2;
> +	int i;
> +
> +	for_each_td(td2, i) {
> +		if (td->groupid != td2->groupid)
> +			continue;
> +
> +		if (td->o.stats &&
> +		    td->o.lat_percentiles != td2->o.lat_percentiles) {
> +			log_err("fio: lat_percentiles in job: %s differs from group\n",
> +				jobname);
> +			return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Treat an empty log file name the same as a one not given
>   */
> @@ -1563,6 +1583,10 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
>  	td->groupid = groupid;
>  	prev_group_jobs++;
>  
> +	if (td->o.group_reporting && prev_group_jobs > 1 &&
> +	    verify_per_group_options(td, jobname))
> +		goto err;
> +
>  	if (setup_rate(td))
>  		goto err;
>  


-- 
Damien Le Moal
Western Digital Research
