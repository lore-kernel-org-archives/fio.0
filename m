Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA289C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiBCB0S (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:26:18 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:23822 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiBCB0R (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:26:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643851576; x=1675387576;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iSGiOXSLzgohp33LC0zIme1a18zVV1OdI7k8r1c38cg=;
  b=DCBoictXCmUWJIHk2anmWiaozcR4XxWP4Qee61JyyDhCwURkdKroiMbJ
   h98YodaEPZoiwA3EHbJ0oiD63BXz4ig/Yng30j5HrqQx03UjBFWcM3KIR
   FW9soTnyykQCtVsH1uf5Ya1gX8x9tGuCqp1vCWDQ9EJbsBxQumgVPGf6v
   2jycs0FXpztMvRyRbZ/eDLvacTcN6qA6YB3B7mASDevUir8cavS2foo+P
   5Idq1lgt7993RlVPiNIEEAcYZhXu0KLw/+e+yGbMQrzberdgwHVZeCZFK
   mNlJdQyq5VSokyyjemZSo+vZGegDBhmM9wqdLMhRQkMYy2Hc/6JdPVfTb
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="196839840"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:26:16 +0800
IronPort-SDR: x7ZZqdJRmZ98Kgmp9KZDe1R3U2Yqtk8BdiZIFD+Fgbs0Nwn6jz1iJuEHj7R73ZHlPZfj5+rZbi
 iWiiekRMzaREm8WjdHRsTul0G5D123X6VLpBzmUSNhcNmw2SbNwCsWa3PUtIP128lL3Niy2Syq
 eRIXGsIcXlCSxz2Q4NesVWvIKSdoRL5OapcHBaviW9Np+Sj9q3g/G/t/NqKg7VkOx28l1RyLmP
 2kxO7vfXbn/cHcj4ydj+enqvkHoNYhQaRDHEDC4SUg1xiKrELkT1j29OF8v2VFZTfpop8tzgk1
 /V0N3DwoR37FccWLENAxJ+AQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:59:25 -0800
IronPort-SDR: 6oMH1KDjIMZaP3jkcPWAQ9p/JhYWPORcJBAkqlufQsyxhLgLwtWdspCRfcpdmvC29/uZeGIGea
 W5gLaB2XD81n96FeJRgDZOKzkc1CUT9zZ52rjHWXFcmt08j4Sacakv/Wx3LLCDZqpXEbUiib1W
 VdzMGBgeq2WIG0nA4rH0Htb6qjluvH7IfT7Dev2bEvE/G2EvySaYeq1c5exDeadgcIb1KY0Lk/
 vohqgcxopAehoRc3KVbzR6hIvrgKROjFdhaVBtosWDxdJrF1PxujIOB0Ces/6uacRTzVGpOL9M
 qcA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:26:14 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq1GG1TLQz1SVnx
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:26:14 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643851573; x=1646443574; bh=iSGiOXSLzgohp33LC0zIme1a18zVV1OdI7k
        8r1c38cg=; b=CFEHiF1G+9btm8LUnEfVWXOWPkLRVuvvR2nzUe+vEPoGoIykqdu
        /vPegmh6CcVXy0eSG300GPlPAFurssXXtQ5FnuEKXyLHw6OgNmOoCtACQwZxEGZX
        KBwWiK2BcPkHuxlxbGhp27eQDb4VKjNT3TFNlshhORuyNAO8HMDWsjfazykB44p5
        KQluK7KA7SxmLE0mR20V7+ZRAwYzVucWy7HO8e0pXcOxF+z51JEcd8UXxK8eB1te
        93Tukz3c1NlEz2x9u5iHvdnbxWPtLuJsImhayv0t9ppkSUNj5ELUufEB9jeTN2c7
        u7Vz3NrHUWwENlgljXxvn0KeQV9J4vgf4ig==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id r_aGUzvWFvup for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:26:13 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq1GF2D25z1Rwrw;
        Wed,  2 Feb 2022 17:26:13 -0800 (PST)
Message-ID: <d21eec4b-eb8c-b8c7-f570-5fc2dc7c4c5c@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:26:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 09/17] stat: use enum fio_ddir consistently
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-10-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-10-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Most functions in stat.c uses enum fio_ddir dir both as a parameter
> and as a local variable in functions.
> 
> int ddir is used in a very few places.
> 
> Convert the int ddir uses to enum fio_ddir dir so that the code is
> consistent.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/stat.c b/stat.c
> index 9894ba7c..5aa6d588 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -491,7 +491,8 @@ static struct thread_stat *gen_mixed_ddir_stats_from_ts(struct thread_stat *ts)
>  	return ts_lcl;
>  }
>  
> -static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, int mean)
> +static double convert_agg_kbytes_percent(struct group_run_stats *rs,
> +					 enum fio_ddir ddir, int mean)
>  {
>  	double p_of_agg = 100.0;
>  	if (rs && rs->agg[ddir] > 1024) {
> @@ -504,7 +505,7 @@ static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, i
>  }
>  
>  static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
> -			     int ddir, struct buf_output *out)
> +			     enum fio_ddir ddir, struct buf_output *out)
>  {
>  	unsigned long runt;
>  	unsigned long long min, max, bw, iops;
> @@ -1251,8 +1252,9 @@ static void show_thread_status_normal(struct thread_stat *ts,
>  }
>  
>  static void show_ddir_status_terse(struct thread_stat *ts,
> -				   struct group_run_stats *rs, int ddir,
> -				   int ver, struct buf_output *out)
> +				   struct group_run_stats *rs,
> +				   enum fio_ddir ddir, int ver,
> +				   struct buf_output *out)
>  {
>  	unsigned long long min, max, minv, maxv, bw, iops;
>  	unsigned long long *ovals = NULL;
> @@ -1407,7 +1409,8 @@ static struct json_object *add_ddir_lat_json(struct thread_stat *ts,
>  }
>  
>  static void add_ddir_status_json(struct thread_stat *ts,
> -		struct group_run_stats *rs, int ddir, struct json_object *parent)
> +				 struct group_run_stats *rs, enum fio_ddir ddir,
> +				 struct json_object *parent)
>  {
>  	unsigned long long min, max;
>  	unsigned long long bw_bytes, bw;
> @@ -2353,7 +2356,7 @@ void __show_run_stats(void)
>  	}
>  
>  	for (i = 0; i < groupid + 1; i++) {
> -		int ddir;
> +		enum fio_ddir ddir;
>  
>  		rs = &runstats[i];
>  
> @@ -2861,7 +2864,7 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
>  static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
>  			     bool log_max)
>  {
> -	int ddir;
> +	enum fio_ddir ddir;
>  
>  	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
>  		__add_stat_to_log(iolog, ddir, elapsed, log_max);

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research
