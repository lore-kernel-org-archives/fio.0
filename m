Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADFAC4332F
	for <fio@archiver.kernel.org>; Thu, 15 Dec 2022 05:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLOFjO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 15 Dec 2022 00:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiLOFjL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Dec 2022 00:39:11 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDFF3135E
        for <fio@vger.kernel.org>; Wed, 14 Dec 2022 21:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1671082750; x=1702618750;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Mz27ld6HlByWXis2JFmc9ITRIiECyHJQ9JwGKEqMDrc=;
  b=CgkQhsWMl74sHTizkdPu6gr4pYKAQ6cxsFW7t+BrTS6pff14hg8VdiVF
   9ma776NYbpBPziLNZRFDdoKs16fzgtrEel+iF4JgPNKjOLpzqsRCkaKTf
   +miUNIcZEimAH7VM6bI1GZwDO8HVN21KMyB52+FFNbqvgxtTYiHUx4KNc
   JH7qjPpQr7z4PaW5jgRzg1VyrXHxbXqQjdfYnLDNSJ7VFstuB1DsyeKZG
   r/iHGqKXKGRMvjycAHFQlrNF/vZZIIxvbcu4XbXMwJoq9UjGRZfLtHLSv
   O1GvaLTdrLj67IkJVa+VLQ7KOg7k/37Uw00IJuc+QWgZ8Hzi7S/pAxUbE
   g==;
X-IronPort-AV: E=Sophos;i="5.96,246,1665417600"; 
   d="scan'208";a="218694683"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Dec 2022 13:39:09 +0800
IronPort-SDR: sBq9VNs8lbagPcEdPbbRPeK0SLpbujkFWCVw3qsOA/h63LHlwl/Df/AkAgpwoKyaULKJOZ8z01
 O0PFZ2EqkjTMnhqoh6vUtT8SL8NmwcRRSh7bSaUmsUr4HDlKNLS2rtjkgKYD+X7uQ4NBKII/tM
 iHO9w6p1kAEA1lKKRnLcu2a5q5yKd5uBsn3AXmheRfe4q6UZfP6Er8mnAuQPAZy5K+5e3qEHs+
 i5fXnMd3Oa9uSgfVegVuokIm/Es7y266v7gNsmjha8nHsbeJwmrs87+18iha+uvA2UL5hjBx8F
 c4I=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Dec 2022 20:57:31 -0800
IronPort-SDR: jH5op1w0mL76uV6kxB8pF2i6PZS7tbCUMK1TcwongHtc9FhXzVombJLhy1dFlxjbbD7OeJoQH2
 /410NXw0E8/S9Zx8560XHZUr9C0B5eBsc8E0Zlpe0pA7BM34JJdPiIcRTnCcl/ZinFSdCPm3HQ
 8zzPVRF1XFGm7X3Z0JBhQ24m9lpa1MJd/3BM0C/hsVcnEfqspYaOyY5Dp10L6QnbEI5ZoKTKws
 2yoni6QG/kz+PG6o4TR0702Qvf7jeh7OOGlH3bivuv93haMUPvreKcuWHr5cAvrWubAbl52yAY
 lW8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Dec 2022 21:39:10 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NXgyj4HXkz1RwqL
        for <fio@vger.kernel.org>; Wed, 14 Dec 2022 21:39:09 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1671082748; x=1673674749; bh=Mz27ld6HlByWXis2JFmc9ITRIiECyHJQ9Jw
        GKEqMDrc=; b=KTrEAZWRCGEkCvj4uUuuvStJOCkoDH+xB2bYivTo9/gjJjsQ2Iu
        wIfm6kggro3SVfufAbY/IGCqSS8rGsVnprhb5q9ROcUeACANq/50mm8OyAXPuEFb
        SofokPfCn0F9bl2NoI4yil768XaXSXXXgiMR7PvBEnl0TkFIqYZBgiOcpkPC48c8
        nbk29aji6puFftpidcE7dO+aFVOkc0Cf+UW1lpDELsZWs34oIj3tKjGWmtCTXWxK
        ijf3/OdS9OLVURAxLpLk9a4iTh5xUhq3/RN65EfNSX9p2DUrTqJWvqp2i80t0q72
        5V/pF756IxvOYWOk0YarkRMomKQ9YR7mldg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id S0NzWDOhMVZ1 for <fio@vger.kernel.org>;
        Wed, 14 Dec 2022 21:39:08 -0800 (PST)
Received: from [10.225.163.96] (unknown [10.225.163.96])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NXgyg5Yk5z1RvLy;
        Wed, 14 Dec 2022 21:39:07 -0800 (PST)
Message-ID: <1b9fb701-7145-e6cb-c96c-ca5e46f4d213@opensource.wdc.com>
Date:   Thu, 15 Dec 2022 14:39:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 2/4] HOWTO/man: improve descriptions of max open zones
 options
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20221215015606.2767187-1-shinichiro.kawasaki@wdc.com>
 <20221215015606.2767187-3-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221215015606.2767187-3-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/15/22 10:56, Shin'ichiro Kawasaki wrote:
> The options max_open_zones and job_max_open_zones control the number of
> open zones for zonemode=zbd. However, descriptions in HOWTO and man
> about these options are not clear enough since it is not well described
> what an open zone is. Improve the description by adding explanation of
> the open zone state. Also explain the default values for these options.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  HOWTO.rst | 27 ++++++++++++++++++++-------
>  fio.1     | 23 +++++++++++++++++------
>  2 files changed, 37 insertions(+), 13 deletions(-)
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 5a5263c3..ad43d162 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -1052,16 +1052,29 @@ Target file/device
>  
>  .. option:: max_open_zones=int
>  
> -	When running a random write test across an entire drive many more
> -	zones will be open than in a typical application workload. Hence this
> -	command line option that allows one to limit the number of open zones. The
> -	number of open zones is defined as the number of zones to which write
> -	commands are issued.
> +	A zone of a zoned block device is in the open state when it is partially
> +	written (i.e. not all sectors of the zone have been written). Zoned
> +	block devices may have limitation on the total number of zones that can

may have limitation -> may have a limit on (my bad)

> +	be simultaneously in the open state, that is, the number of zones that
> +	can be written to simultaneously. The :option:`max_open_zones` parameter
> +	limits the number of zones to which write commands are issued by all fio
> +	jobs, that is, limits the number of zones that will be in the open
> +	state. This parameter is relevant only if the :option:`zonemode` =zbd is
> +	used. The default value is always equal to maximum number of open zones
> +	of the target zoned block device and a value higher than this limit
> +	cannot be specified by users unless the option
> +	:option:`ignore_zone_limits` is specified. When
> +	:option:`ignore_zone_limits` is specified or the target device has no
> +	limit on the number of zones that can be in an open state,
> +	:option:`max_open_zones` can specify 0 to disable any limit on the
> +	number of zones that can be simultaneously written to by all jobs.
>  
>  .. option:: job_max_open_zones=int
>  
> -	Limit on the number of simultaneously opened zones per single
> -	thread/process.
> +	In the same manner as :option:`max_open_zones`, limit the number of open
> +	zones per fio job, that is, the number of zones that a single job can
> +	simultaneously write to. A value of zero indicates no limit.
> +	Default: zero.
>  
>  .. option:: ignore_zone_limits=bool
>  
> diff --git a/fio.1 b/fio.1
> index a0d765e5..d6ad0e27 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -828,14 +828,25 @@ numbers fio only reads beyond the write pointer if explicitly told to do
>  so. Default: false.
>  .TP
>  .BI max_open_zones \fR=\fPint
> -When running a random write test across an entire drive many more zones will be
> -open than in a typical application workload. Hence this command line option
> -that allows one to limit the number of open zones. The number of open zones is
> -defined as the number of zones to which write commands are issued by all
> -threads/processes.
> +A zone of a zoned block device is in the open state when it is partially written
> +(i.e. not all sectors of the zone have been written). Zoned block devices may
> +have limitation on the total number of zones that can be simultaneously in the
> +open state, that is, the number of zones that can be written to simultaneously.
> +The \fBmax_open_zones\fR parameter limits the number of zones to which write
> +commands are issued by all fio jobs, that is, limits the number of zones that
> +will be in the open state. This parameter is relevant only if the
> +\fBzonemode=zbd\fR is used. The default value is always equal to maximum number
> +of open zones of the target zoned block device and a value higher than this
> +limit cannot be specified by users unless the option \fBignore_zone_limits\fR is
> +specified. When \fBignore_zone_limits\fR is specified or the target device has
> +no limit on the number of zones that can be in an open state,
> +\fBmax_open_zones\fR can specify 0 to disable any limit on the number of zones
> +that can be simultaneously written to by all jobs.
>  .TP
>  .BI job_max_open_zones \fR=\fPint
> -Limit on the number of simultaneously opened zones per single thread/process.
> +In the same manner as \fBmax_open_zones\fR, limit the number of open zones per
> +fio job, that is, the number of zones that a single job can simultaneously write
> +to. A value of zero indicates no limit. Default: zero.
>  .TP
>  .BI ignore_zone_limits \fR=\fPbool
>  If this option is used, fio will ignore the maximum number of open zones limit

-- 
Damien Le Moal
Western Digital Research

