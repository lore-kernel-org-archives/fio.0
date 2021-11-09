Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E98C433F5
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2096F61184
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 06:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240519AbhKIGMY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 01:12:24 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:46668 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238713AbhKIGMX (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 01:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636438176; x=1667974176;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3q5QlzXtaf434WYqUYc/HIKfFnrVwdAqJHFpb+tgcMo=;
  b=D8g2K24qjmOlrfTtvl6MEPSRss43gmLcwer40nY54Fs+6XMFY6+fSyrm
   51kWyZvTrYenk7egREvaBf2yhAFvxk7EJYq3emvtzjvmndhPK5okotHi8
   C/+DJ+gKQu9VByZUsZ2+UEZHSfLMwBucioSzJ9hubModIzwobwbWtX9w5
   IcD/LO7jENFTe21tSKDo5CZb/UOMG2wooiY+z+fSc9tyQ24wQLN0W0vAp
   LMYuvJvhEMM0AUJLV9WgY/j80sIpx2SOxouhSsd4kmKofwvshNlGkd5rP
   q4G1Ys3aBKhSQ2vg06heaN6x6f1qkEWQMDJmzw7ViRab10d6M3x4/1VNM
   A==;
X-IronPort-AV: E=Sophos;i="5.87,219,1631548800"; 
   d="scan'208";a="189890776"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 14:09:36 +0800
IronPort-SDR: oC2OZzuglK97ibPncNx7XQ3NMsvuJhWW21rVSxIMD7vr7ICCTzFMYNI36frqpAPCmz5ah5KQ/N
 NyPTtXPnHN4Sun3HLBCWx7wX1vebtnpU2g5xIf1eBdjs0kuVJWitFxaeWwLZMTaVbks3xBXVL9
 GQyo0hjW6q7bQ6BT6Ps7FGFenu/PBn/ZVoLhNHNaEbygmlCesxXuEar/Gwc5OeYsAn5Z5eA9uw
 dM/0f1R3hLP3FbXLI4OIFaqfWhNvoD/lIyGoBDkB2l66UJy2aaNmqZ1z6JI2pN7lYt3L8V4IQa
 L4Wy2pp+XpQtVgvEIVaBOzH+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 21:44:50 -0800
IronPort-SDR: 7bzhQ4GP8L1ZR8EzwWt2pN/wxzhNhY10QmTTljb6xIIbdDfY+7UYEzBLGXnyB++BpSdk3cFjYM
 0gWTITKxrLhscbNIqvfLNANlFlG+LLOWqO1Z5nVtXZv27FAum9yXDchaXSSDLUpsyoqsGjfCzW
 wf2bu2JQQTEhMZSD9qTGQnOu4QrOsCB3WtaDz+xuZgEhxQXq4q/pWD1aymkJooFp/L/GyI755c
 Jouo/dWuikMGjPMvpW1hPzV/NKfqGJGJdH1BePg8fJbhrm3ZdmVRrcXyX6B8FOAi9TIgztMDn/
 eto=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 22:09:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HpHcy0W65z1RtVn
        for <fio@vger.kernel.org>; Mon,  8 Nov 2021 22:09:38 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636438177; x=1639030178; bh=3q5QlzXtaf434WYqUYc/HIKfFnrVwdAqJHF
        pb+tgcMo=; b=CgPkrIZsjY9Wn3CI0WMn/zcxVXflx897/OVCHA5Kn3HQi8mtnCE
        cm1C2OsCy2kjHF7vCtwBBBHdlmdGFLg7h9wIgRubGcyeAHfmJy/4MEh0RmJmJ9Zp
        7cVfM67nmR0sWbbqZOwKSxI3Jpqc5d0s6lDjWIR4ITirMQnMmOK+zv2DP/GgAvPv
        qxjiG9xT0r3zWOyf2uZ7V9ycDUHqWi8XwY3y0bc6VBhm5CIR7Gqir6H+hcli8Hqt
        zrdMyB5gUq0OKCPr5ITuiZILN8DzVYf22rQODFPBPKZcSrj6DbGYzF1NiM5Z+nmk
        WVtSriLVHla2hQsNGRnYOPreg2an8hlfopQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id t2w07VTx8mUV for <fio@vger.kernel.org>;
        Mon,  8 Nov 2021 22:09:37 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HpHcx1LBXz1RtVl;
        Mon,  8 Nov 2021 22:09:36 -0800 (PST)
Message-ID: <72a96273-5ad1-9ea0-7292-0c44c0473708@opensource.wdc.com>
Date:   Tue, 9 Nov 2021 15:09:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 1/8] docs: update cmdprio_percentage documentation
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-2-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211109002655.117274-2-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/09 9:28, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Commit 1437d6357429 ("libaio,io_uring: relax cmdprio_percentage
> constraints") relaxed the cmdprio_percentage constraints such that
> cmdprio_percentage and prioclass/prio could be used together.
> 
> However, it forgot to remove the mention of this constraint from
> the docs. Update the docs to reflect the new behavior.
> 
> Fixes: 1437d6357429 ("libaio,io_uring: relax cmdprio_percentage constraints")
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  HOWTO | 5 ++---
>  fio.1 | 3 +--
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/HOWTO b/HOWTO
> index 297a0485..196bca6c 100644
> --- a/HOWTO
> +++ b/HOWTO
> @@ -2167,9 +2167,8 @@ with the caveat that when used on the command line, they must come after the
>  
>      Set the percentage of I/O that will be issued with the highest priority.
>      Default: 0. A single value applies to reads and writes. Comma-separated
> -    values may be specified for reads and writes. This option cannot be used
> -    with the :option:`prio` or :option:`prioclass` options. For this option
> -    to be effective, NCQ priority must be supported and enabled, and `direct=1'
> +    values may be specified for reads and writes. For this option to be
> +    effective, NCQ priority must be supported and enabled, and `direct=1'
>      option must be used. fio must also be run as the root user.
>  
>  .. option:: cmdprio_class=int[,int] : [io_uring] [libaio]
> diff --git a/fio.1 b/fio.1
> index 78988c9e..e3c3feae 100644
> --- a/fio.1
> +++ b/fio.1
> @@ -1965,8 +1965,7 @@ with the caveat that when used on the command line, they must come after the
>  .BI (io_uring,libaio)cmdprio_percentage \fR=\fPint[,int]
>  Set the percentage of I/O that will be issued with the highest priority.
>  Default: 0. A single value applies to reads and writes. Comma-separated
> -values may be specified for reads and writes. This option cannot be used
> -with the `prio` or `prioclass` options. For this option to be effective,
> +values may be specified for reads and writes. For this option to be effective,
>  NCQ priority must be supported and enabled, and `direct=1' option must be
>  used. fio must also be run as the root user.
>  .TP
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
