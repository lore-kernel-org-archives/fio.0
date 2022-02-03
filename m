Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E30C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347979AbiBCBne (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:43:34 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:61151 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbiBCBnc (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:43:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643852612; x=1675388612;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0RyoFfdhFjsjSGFr06GeckUw4mpyrgDukQlsh4XYvgU=;
  b=NZ4akjgNVusz9kPNbw8XHBQoG0nnQYSZKeBgy3BbkPy6oXB+OPMfwrPR
   I7DNJqmXM6/gG2nsUNJXoVtqK7V9OULpf/xqGyxBKehs5p2n45BUgLb6D
   AGyTvCAweZiBt8gtBwP0iYkVyjjK0z33wBuGEgkvnv/2fLaE4RncjB5VE
   8ODN/G/sWPun5s0BIuBtRJ50wmrXdDAJftZSQOXEn/ib3IpQ0MbDukTw8
   o5cOSr9Uc0UeLnCHLYsMGG+SnU5HgDUjv4Cn5ZMvo66CpJTcf2rbrFzzh
   BlykAwMIJ8v61XN6oSk3l6hG3N4/IUF0itc2rPOFzhzQG9lbFrqeUrZoS
   w==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="193017137"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:43:32 +0800
IronPort-SDR: IsxNlPcK+X3BIK2vBWLnHAzhjr0LVk6FCVG72RKEvg/RGsqiL6O7XsPIXf9Kpz5pVHNR5/Z1yM
 etpe+ykF0XAYt1DAYqt3S1Z9fl9aqKz+pDY/opQ5YLczge/hmkctVoVNVkKl7IKWjXAVtlj1En
 jzhqW+vHxEWKV/33K5ih4Pb8PAtR9Q5xjvc3zjkrbJIK9+9iZaqefM4yq2waacRiTSo6/TfKiu
 v1+M2Os2VQr1DloaneDir4Z8BWBk64W3o6OyJDKB4qEs3z/Yq5oZlyX9C92v1RrDnyGhfSwMoZ
 aBwzditf0zR8ezLAmHm61ppG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:15:28 -0800
IronPort-SDR: dyk/Gx6vk948fToTUDqW/zzXEGnzn6Wu0rap3PCqyKSiYARj8Ml4LrC2NjaHKfjt8SKVjoRyFy
 0DZmPkpwSpjd93lOIOYUKVJK+qU8xzEoQGbiyXeT7A/W3274MBZ1V+UPBAG5CAUuOVrExjbglH
 Ds/1UA4LHoS1rtVmg+LffRLaxAMXgKsSFsR1kyBGFCtn+U/2PZW6CoB6sG4u8r6IFz/GHd9+HA
 xppLGMaSuoM+ABIcxJFODSqYCipYzMzY9S0VFmnnIllKBmfp/qdzkB5kzgkAnS83oXEIsNGsbu
 RfU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:43:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq1fC6BNhz1SVny
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:43:31 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643852611; x=1646444612; bh=0RyoFfdhFjsjSGFr06GeckUw4mpyrgDukQl
        sh4XYvgU=; b=DjH2eWFHqjzN2lcNGWqGpf5Bnhj4JXtjqXZyBvIbARJuM2d4H+l
        W2x14hQ0BOUQ7uT94c/NRE01VlRYbs6TGRLsaFVsvJJV4f2ry24dndccWHDtfdE7
        JGVaot2qRztBzkJSTUIYA3azkwnXPkAmsGlwnDZrg1ApN1gtpsH8n96UzOtuWaOv
        IYQJudziJEcOurKfxqbBMOiLumbDHl8FykW+YKuvNESroaaP3sUZxvnqnluvQH/r
        IPPI0vJ7wkVNqdl8K686+qs4BCBPnPsfOiZ+aW1CGRR7jrPtOAv8sDeZ29iSU/7m
        A8TwHpydfLckJWSvScZaLaIXs/H0nFzy5sg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gg2BCe4iabaZ for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:43:31 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq1fB3L3rz1Rwrw;
        Wed,  2 Feb 2022 17:43:30 -0800 (PST)
Message-ID: <071d74c2-3a07-3792-1f79-a1358387eb2f@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:43:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 14/17] stat: convert json output to a new per priority
 granularity format
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-15-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-15-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The JSON output will no longer contain high_prio/low_prio entries, but will
> instead include a new list "prios", which will include an object per
> prioclass/priolevel combination. Each of these objects will either have a
> "clat_ns" object or a "lat_ns" object, depending on which latency type was
> being tracked.
> 
> This JSON structure should make it easy if the per priority stats were ever
> extended to be able to track multiple latency types at the same time, as
> each prioclass/priolevel object will then simply contain (e.g.) both a
> "clat_ns" and a "lat_ns" object.
> 
> Convert the JSON output to this new per priority granularity format,
> and convert the tests to work with the new JSON output.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c                   |  44 +++++++++------
>  t/latency_percentiles.py | 118 +++++++++++++++++++--------------------
>  2 files changed, 87 insertions(+), 75 deletions(-)
> 
> diff --git a/stat.c b/stat.c
> index 096457a2..3d30eda4 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -1493,25 +1493,37 @@ static void add_ddir_status_json(struct thread_stat *ts,
>  	if (!ddir_rw(ddir))
>  		return;
>  
> -	/* Only print PRIO latencies if some high priority samples were gathered */
> -	if (ts->clat_high_prio_stat[ddir].samples > 0) {
> -		const char *high, *low;
> +	/* Only include per prio stats if there are >= 2 prios with samples */
> +	if (get_nr_prios_with_samples(ts, ddir) >= 2) {
> +		struct json_array *array = json_create_array();
> +		const char *obj_name;
> +		int i;
>  
> -		if (ts->lat_percentiles) {
> -			high = "lat_high_prio";
> -			low = "lat_low_prio";
> -		} else {
> -			high = "clat_high_prio";
> -			low = "clat_low_prio";
> -		}
> +		if (ts->lat_percentiles)
> +			obj_name = "lat_ns";
> +		else
> +			obj_name = "clat_ns";
>  
> -		tmp_object = add_ddir_lat_json(ts, ts->clat_percentiles | ts->lat_percentiles,
> -				&ts->clat_high_prio_stat[ddir], ts->io_u_plat_high_prio[ddir]);
> -		json_object_add_value_object(dir_object, high, tmp_object);
> +		json_object_add_value_array(dir_object, "prios", array);
>  
> -		tmp_object = add_ddir_lat_json(ts, ts->clat_percentiles | ts->lat_percentiles,
> -				&ts->clat_low_prio_stat[ddir], ts->io_u_plat_low_prio[ddir]);
> -		json_object_add_value_object(dir_object, low, tmp_object);
> +		for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
> +			if (ts->clat_prio[ddir][i].clat_stat.samples > 0) {
> +				struct json_object *obj = json_create_object();
> +				unsigned long long class, level;
> +
> +				class = ts->clat_prio[ddir][i].ioprio >> 13;
> +				json_object_add_value_int(obj, "prioclass", class);
> +				level = ts->clat_prio[ddir][i].ioprio & 7;
> +				json_object_add_value_int(obj, "prio", level);
> +
> +				tmp_object = add_ddir_lat_json(ts,
> +							       ts->clat_percentiles | ts->lat_percentiles,
> +							       &ts->clat_prio[ddir][i].clat_stat,
> +							       ts->clat_prio[ddir][i].io_u_plat);
> +				json_object_add_value_object(obj, obj_name, tmp_object);
> +				json_array_add_value_object(array, obj);
> +			}
> +		}
>  	}
>  
>  	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
> diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
> index cc437426..62c4cc91 100755
> --- a/t/latency_percentiles.py
> +++ b/t/latency_percentiles.py
> @@ -80,6 +80,7 @@ import time
>  import argparse
>  import platform
>  import subprocess
> +from collections import Counter
>  from pathlib import Path
>  
>  
> @@ -363,20 +364,19 @@ class FioLatTest():
>  
>      def check_nocmdprio_lat(self, job):
>          """
> -        Make sure no high/low priority latencies appear.
> +        Make sure no per priority latencies appear.
>  
>          job         JSON object to check
>          """
>  
>          for ddir in ['read', 'write', 'trim']:
>              if ddir in job:
> -                if 'lat_high_prio' in job[ddir] or 'lat_low_prio' in job[ddir] or \
> -                    'clat_high_prio' in job[ddir] or 'clat_low_prio' in job[ddir]:
> -                    print("Unexpected high/low priority latencies found in %s output" % ddir)
> +                if 'prios' in job[ddir]:
> +                    print("Unexpected per priority latencies found in %s output" % ddir)
>                      return False
>  
>          if self.debug:
> -            print("No high/low priority latencies found")
> +            print("No per priority latencies found")
>  
>          return True
>  
> @@ -497,7 +497,7 @@ class FioLatTest():
>          return retval
>  
>      def check_prio_latencies(self, jsondata, clat=True, plus=False):
> -        """Check consistency of high/low priority latencies.
> +        """Check consistency of per priority latencies.
>  
>          clat                True if we should check clat data; other check lat data
>          plus                True if we have json+ format data where additional checks can
> @@ -506,78 +506,78 @@ class FioLatTest():
>          """
>  
>          if clat:
> -            high = 'clat_high_prio'
> -            low = 'clat_low_prio'
> -            combined = 'clat_ns'
> +            obj = combined = 'clat_ns'
>          else:
> -            high = 'lat_high_prio'
> -            low = 'lat_low_prio'
> -            combined = 'lat_ns'
> +            obj = combined = 'lat_ns'
>  
> -        if not high in jsondata or not low in jsondata or not combined in jsondata:
> -            print("Error identifying high/low priority latencies")
> +        if not 'prios' in jsondata or not combined in jsondata:
> +            print("Error identifying per priority latencies")
>              return False
>  
> -        if jsondata[high]['N'] + jsondata[low]['N'] != jsondata[combined]['N']:
> -            print("High %d + low %d != combined sample size %d" % \
> -                    (jsondata[high]['N'], jsondata[low]['N'], jsondata[combined]['N']))
> +        sum_sample_size = sum([x[obj]['N'] for x in jsondata['prios']])
> +        if sum_sample_size != jsondata[combined]['N']:
> +            print("Per prio sample size sum %d != combined sample size %d" %
> +                  (sum_sample_size, jsondata[combined]['N']))
>              return False
>          elif self.debug:
> -            print("High %d + low %d == combined sample size %d" % \
> -                    (jsondata[high]['N'], jsondata[low]['N'], jsondata[combined]['N']))
> +            print("Per prio sample size sum %d == combined sample size %d" %
> +                  (sum_sample_size, jsondata[combined]['N']))
>  
> -        if min(jsondata[high]['min'], jsondata[low]['min']) != jsondata[combined]['min']:
> -            print("Min of high %d, low %d min latencies does not match min %d from combined data" % \
> -                    (jsondata[high]['min'], jsondata[low]['min'], jsondata[combined]['min']))
> +        min_val = min([x[obj]['min'] for x in jsondata['prios']])
> +        if min_val != jsondata[combined]['min']:
> +            print("Min per prio min latency %d does not match min %d from combined data" %
> +                  (min_val, jsondata[combined]['min']))
>              return False
>          elif self.debug:
> -            print("Min of high %d, low %d min latencies matches min %d from combined data" % \
> -                    (jsondata[high]['min'], jsondata[low]['min'], jsondata[combined]['min']))
> +            print("Min per prio min latency %d matches min %d from combined data" %
> +                  (min_val, jsondata[combined]['min']))
>  
> -        if max(jsondata[high]['max'], jsondata[low]['max']) != jsondata[combined]['max']:
> -            print("Max of high %d, low %d max latencies does not match max %d from combined data" % \
> -                    (jsondata[high]['max'], jsondata[low]['max'], jsondata[combined]['max']))
> +        max_val = max([x[obj]['max'] for x in jsondata['prios']])
> +        if max_val != jsondata[combined]['max']:
> +            print("Max per prio max latency %d does not match max %d from combined data" %
> +                  (max_val, jsondata[combined]['max']))
>              return False
>          elif self.debug:
> -            print("Max of high %d, low %d max latencies matches max %d from combined data" % \
> -                    (jsondata[high]['max'], jsondata[low]['max'], jsondata[combined]['max']))
> +            print("Max per prio max latency %d matches max %d from combined data" %
> +                  (max_val, jsondata[combined]['max']))
>  
> -        weighted_avg = (jsondata[high]['mean'] * jsondata[high]['N'] + \
> -                        jsondata[low]['mean'] * jsondata[low]['N']) / jsondata[combined]['N']
> +        weighted_vals = [x[obj]['mean'] * x[obj]['N'] for x in jsondata['prios']]
> +        weighted_avg = sum(weighted_vals) / jsondata[combined]['N']
>          delta = abs(weighted_avg - jsondata[combined]['mean'])
>          if (delta / jsondata[combined]['mean']) > 0.0001:
> -            print("Difference between weighted average %f of high, low means "
> +            print("Difference between merged per prio weighted average %f mean "
>                    "and actual mean %f exceeds 0.01%%" % (weighted_avg, jsondata[combined]['mean']))
>              return False
>          elif self.debug:
> -            print("Weighted average %f of high, low means matches actual mean %f" % \
> -                    (weighted_avg, jsondata[combined]['mean']))
> +            print("Merged per prio weighted average %f mean matches actual mean %f" %
> +                  (weighted_avg, jsondata[combined]['mean']))
>  
>          if plus:
> -            if not self.check_jsonplus(jsondata[high]):
> -                return False
> -            if not self.check_jsonplus(jsondata[low]):
> -                return False
> +            for prio in jsondata['prios']:
> +                if not self.check_jsonplus(prio[obj]):
> +                    return False
>  
> -            bins = {**jsondata[high]['bins'], **jsondata[low]['bins']}
> -            for duration in bins.keys():
> -                if duration in jsondata[high]['bins'] and duration in jsondata[low]['bins']:
> -                    bins[duration] = jsondata[high]['bins'][duration] + \
> -                            jsondata[low]['bins'][duration]
> +            counter = Counter()
> +            for prio in jsondata['prios']:
> +                counter.update(prio[obj]['bins'])
> +
> +            bins = dict(counter)
>  
>              if len(bins) != len(jsondata[combined]['bins']):
> -                print("Number of combined high/low bins does not match number of overall bins")
> +                print("Number of merged bins %d does not match number of overall bins %d" %
> +                      (len(bins), len(jsondata[combined]['bins'])))
>                  return False
>              elif self.debug:
> -                print("Number of bins from merged high/low data matches number of overall bins")
> +                print("Number of merged bins %d matches number of overall bins %d" %
> +                      (len(bins), len(jsondata[combined]['bins'])))
>  
>              for duration in bins.keys():
>                  if bins[duration] != jsondata[combined]['bins'][duration]:
> -                    print("Merged high/low count does not match overall count for duration %d" \
> -                            % duration)
> +                    print("Merged per prio count does not match overall count for duration %d" %
> +                          duration)
>                      return False
>  
> -        print("Merged high/low priority latency data match combined latency data")
> +        print("Merged per priority latency data match combined latency data")
>          return True
>  
>      def check(self):
> @@ -602,7 +602,7 @@ class Test001(FioLatTest):
>              print("Unexpected trim data found in output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['read'], 0, slat=False)
> @@ -626,7 +626,7 @@ class Test002(FioLatTest):
>              print("Unexpected trim data found in output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['write'], 1, slat=False, clat=False)
> @@ -650,7 +650,7 @@ class Test003(FioLatTest):
>              print("Unexpected write data found in output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['trim'], 2, slat=False, tlat=False)
> @@ -674,7 +674,7 @@ class Test004(FioLatTest):
>              print("Unexpected trim data found in output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['read'], 0, plus=True)
> @@ -698,7 +698,7 @@ class Test005(FioLatTest):
>              print("Unexpected trim data found in output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['write'], 1, slat=False, plus=True)
> @@ -722,7 +722,7 @@ class Test006(FioLatTest):
>              print("Unexpected trim data found in output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['read'], 0, slat=False, tlat=False, plus=True)
> @@ -743,7 +743,7 @@ class Test007(FioLatTest):
>              print("Unexpected trim data found in output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['read'], 0, clat=False, tlat=False, plus=True)
> @@ -765,7 +765,7 @@ class Test008(FioLatTest):
>              print("Unexpected data direction found in fio output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['mixed'], 0, plus=True, unified=True)
> @@ -792,7 +792,7 @@ class Test009(FioLatTest):
>              print("Error checking fsync latency data")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['write'], 1, slat=False, plus=True)
> @@ -813,7 +813,7 @@ class Test010(FioLatTest):
>              print("Unexpected trim data found in output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['read'], 0, plus=True)
> @@ -839,7 +839,7 @@ class Test011(FioLatTest):
>              print("Unexpected trim data found in output")
>              retval = False
>          if not self.check_nocmdprio_lat(job):
> -            print("Unexpected high/low priority latencies found")
> +            print("Unexpected per priority latencies found")
>              retval = False
>  
>          retval &= self.check_latencies(job['read'], 0, slat=False, clat=False, plus=True)

Looks OK to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research
