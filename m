Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962E9C433EF
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 08:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349314AbhKYI6C (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 03:58:02 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:65076 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349094AbhKYI4B (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 03:56:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637830370; x=1669366370;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B08MSoo1rjzm1VDBHfz4nWwjbtWvQqGCor1xL2DPwwo=;
  b=KbkgM9yNm1JKewy636Aj22mRrymXkyV9OHUxqU1BH0+1pqD/IYqeAiNw
   d1bKuYOPYC3OuRgPlYrFbd/A6CaE7FryAUga5cs9y/2OwHEa/C8yAduQ8
   HWh+0zcZuHqnuV8MP3eftws7DF2GBB40uy2v0qudkuPZEe2v5d6DnN61s
   A2ojTIUumiCiCHj6hDE3OMacauq0avFlUB2FzVdZqTI29gvyRNTaAEmrT
   E8ZcY5Y+yNKotIQU0ncC3YBDHCfDQZNM/oJNmYbdOqp/tVsp+GolvStZW
   NnNLpdzcNr96DUB0O6PynG/E2EVZmM2F8w8GAyKzo+82sihBl5+dA5R6z
   g==;
X-IronPort-AV: E=Sophos;i="5.87,262,1631548800"; 
   d="scan'208";a="186616885"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 16:52:50 +0800
IronPort-SDR: QskF9Z8gYtjypsWd1NZBbiOPo8TgaMchy7mlk3CSCOuEHWTi2toVowrCUAp48wPi///DpM0njM
 ie3h/xpuCd+gzLM2Nr2bbAzhVy0sfDW8rBRZhUll0J+AsQmz3zbPEMjpWrg2jDpVgl4K4ssPvm
 SmJBDf6nBTfrKh0NgntWismIfUWU5zBLHAGvgwuNQiDWC7sH72GVJwPOwJITd60q51+R/GiV/G
 ZcH7ZAw7oO0H6X4KfrdG9KQ8BPwRvV4AYC90ahCyKnMmq+fBI9AhBFLYvMAOHWYEhjD5uzDN9S
 COBzvyoEadPqpLTdUhIVNyew
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 00:26:10 -0800
IronPort-SDR: nEuFuLcUYn+MStPNhQ+sEZNSbwN7tz3H+keAoG+z2So9cmcSqH65bCpoA0frwdcAxDOh3gQ6tY
 ssh+oeSy2h7jSjvfVH1gKsCBy/eXXEVr64HBio0FVUa9WzBPlRj58dX6komF812C3GFsRDhGsA
 N/SbapMFbmSHWVcMVGXXXpOcH5qVWOjTwhn4Yh091KROBifuYEbMGyfX/8UVlY5KR2o/Ipwhv2
 OJnFzYx/aNNObOpldoC7PCiQO6P/8+CVr6P663nRn/Z7GkvsNfgdnjgPODGrSU/Vvr6sSVOXwS
 nZE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 00:52:51 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J0BTt4gSjz1RtVn
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 00:52:50 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637830370; x=1640422371; bh=B08MSoo1rjzm1VDBHfz4nWwjbtWvQqGCor1
        xL2DPwwo=; b=cwdYtfH/fx1gy2PKM7V49SBBI4s2lL/XZcvBRN37Qwj9DuC7kWn
        uwYFvXW1QWffQM1f9AUnKUtUkXjCDBkWfXknHQ6DNa/fjK8d1EARzNTSDR3syfPg
        3ByddXwWw06oUNY9n/fg5qi41jEp9ntI47s2p3HXkWbBMr+q7xEGsTIU+3lhvILX
        yD8duyyYyAy8Mx5zvLQq9SBeJfNDobCBwNXU86UpsEFynjF8SQQOvpMKfeI3Boe7
        psFdJ1XyR5YHoJbbCezoFVT14rsI/Ll4U7aYs9SO0ioBj3K6fWynZxIN8Wz238fL
        tZAGp6OrrEXc+eQ7dlYah0Ry8V7oj3id2uA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gr5kI49gL1IP for <fio@vger.kernel.org>;
        Thu, 25 Nov 2021 00:52:50 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J0BTs5L5sz1RtVl;
        Thu, 25 Nov 2021 00:52:49 -0800 (PST)
Message-ID: <7dadbe1c-8f2c-5ffa-ef5a-c2f108f3b06f@opensource.wdc.com>
Date:   Thu, 25 Nov 2021 17:52:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 1/6] docs: document quirky implementation of per
 priority stats reporting
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
 <20211123142708.48867-2-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211123142708.48867-2-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/23 23:27, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Commit 56440e63ac17 ("fio: report percentiles for slat, clat, lat") changed
> many things. One of the changes, from the commit message:
> "- for the new cmdprio_percentage latencies, if lat_percentiles=1,
> *total* latency percentiles will be tracked. Otherwise, *completion*
> latency percentiles will be tracked."
> 
> In other words, the commit changed the per prio stats from always tracking
> (and reporting) clat latency, to instead either track (and report) clat or
> lat latency.
> 
> Considering that a certain latency type reports two things:
> 1) min/max/avg latency for the the specific latency type
> 2) latency percentiles for the specific latency type
> 
> If disable_clat/disable_lat is used, neither 1) nor 2) will be reported.
> If clat_percentiles/lat_percentiles is false, 2) will not be reported.
> 
> Therefore it is unintuitive that setting lat_percentiles=1, an option
> usually used to enable/disable percentile reporting, also affects which
> type of latency that will be tracked (and reported) for per prio stats.
> 
> The fact that the variables are named e.g. clat_prio_stat, regardless of
> the type of latency being tracked does not help.
> 
> Anyway, let's document the way that the current implementation works,
> so that a user can know how per priority stats are handled, without having
> to read the source, since the commit that introduced this behavior forgot
> to update the documentation.
> 
> Fixes: 56440e63ac17 ("fio: report percentiles for slat, clat, lat")
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  HOWTO | 6 +++++-
>  fio.1 | 5 ++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/HOWTO b/HOWTO
> index a3b3acfe..8c9e4135 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -2169,7 +2169,11 @@ with the caveat that when used on the command line, they must come after the
>      Default: 0. A single value applies to reads and writes. Comma-separated
>      values may be specified for reads and writes. For this option to be
>      effective, NCQ priority must be supported and enabled, and `direct=1'
> -    option must be used. fio must also be run as the root user.
> +    option must be used. fio must also be run as the root user. Unlike
> +    slat/clat/lat stats, which can be tracked and reported independently, per
> +    priority stats only track and report a single type of latency. By default,
> +    completion latency (clat) will be reported, if :option:`lat_percentiles` is
> +    set, total latency (lat) will be reported.
>  
>  .. option:: cmdprio_class=int[,int] : [io_uring] [libaio]
>  
> diff --git a/fio.1 b/fio.1
> index a6469541..a3ebb67d 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -1967,7 +1967,10 @@ Set the percentage of I/O that will be issued with the highest priority.
>  Default: 0. A single value applies to reads and writes. Comma-separated
>  values may be specified for reads and writes. For this option to be effective,
>  NCQ priority must be supported and enabled, and `direct=1' option must be
> -used. fio must also be run as the root user.
> +used. fio must also be run as the root user. Unlike slat/clat/lat stats, which
> +can be tracked and reported independently, per priority stats only track and
> +report a single type of latency. By default, completion latency (clat) will be
> +reported, if \fBlat_percentiles\fR is set, total latency (lat) will be reported.
>  .TP
>  .BI (io_uring,libaio)cmdprio_class \fR=\fPint[,int]
>  Set the I/O priority class to use for I/Os that must be issued with a
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
