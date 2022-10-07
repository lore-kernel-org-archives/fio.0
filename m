Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F59C433F5
	for <fio@archiver.kernel.org>; Fri,  7 Oct 2022 22:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiJGWpI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 7 Oct 2022 18:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJGWpH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Oct 2022 18:45:07 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533BC4C03B
        for <fio@vger.kernel.org>; Fri,  7 Oct 2022 15:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665182706; x=1696718706;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GoXfNtyfguezA6bhAp0eMmQbyeapqUI+JBkfNgxIwbc=;
  b=hw1hqFLoBw6HTdhM1JgwOZR0ZGrku5SQl9JtP0mgfMgMBvTpWCphNPR1
   lvwUkRO/JB84xbdyoqzvv7U2f1e7RzOUGzjAuP/YRPn9Kws/g3D2TTPgs
   KT0mUVTbdLnzSFe0Jmnn00kdjWsh+MNpzA7vZH+Ro9MaxrTp+jVIvyo/O
   eH/uvr5ZGNRwhlE13cHwKMyVD6YZA66F9J4DFFJnsySpLf5olNImK9KGm
   HvxB0A16m73ZvLVEj8hPvVe9qVGAZ17innoY7qjN3NJ8YIxBocMgq0B1a
   CuwDnw2oFLu+5+vfOwmgBDS9DtvwabKXiXKxoO1CcSIqYV5hTxulpTB8T
   w==;
X-IronPort-AV: E=Sophos;i="5.95,168,1661788800"; 
   d="scan'208";a="325376255"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2022 06:45:05 +0800
IronPort-SDR: fXagAkGXWUXKGMX4jwRpBHRyQSXM0bHJkhUKgQrFAXO4zjreF8YRfAtoocNztvy6j+KfzYd+dP
 iHGPtK4Enfw5jERoLYOadcbvYzUh2GX8+ln+ncnR8tWqyMmutX4Kk6a6V/JgzYtAYfb7U02hYv
 baXfmapIDeu6PAzx4eVIGhEwVyVBrWOSWPoWkF4wcvNOx2qjnr4LDYwdxB9iCZVwXeZENm3sQc
 EGBFvuUKwOiTMlbxUqok/R5Sa2STbeG4T+zmQFym6VD+JCmGAoyWpUE2hd23itrlqhaoWppXtT
 Vxlvvd/u/40ozKZ8ubvRuyUa
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2022 15:04:49 -0700
IronPort-SDR: qdVLcgzlTlluZHuPFUszhOzAbQ33fuLmuS5JEM+sn9m4ZQ/dsPdBbwqEcuStk8Rekc7GP08FAR
 FT4l65/YNZpYjTtg7uN7XuIW9QeooOKSlw3XJGR3DrVlOiJUYnKSM07rzvFoCMSdRBz95G1Use
 at5hwEIx/7v+KGGerIuYLrR9ALOq8idLPZCHkkAEpJd681lkJlapURpdEacOu9vls0qbWHQadC
 tpA1BEWlW4yvFksOlc3d1kvsY4ycsV/+r8dcz5ZiEmhVtOCf6lXkvQAUQGaWVJC2knaMx8CNTy
 Esc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2022 15:45:06 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mkk0K0dqlz1RvTp
        for <fio@vger.kernel.org>; Fri,  7 Oct 2022 15:45:05 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1665182704; x=1667774705; bh=GoXfNtyfguezA6bhAp0eMmQbyeapqUI+JBk
        fNgxIwbc=; b=lc96JJQLJdQw+/hNY2H81PFeA6pis+Q1KxBHq95BI4u1AdN9xHN
        3t10Qmg7P1YMBXi8fOVF8Fay2O7yuUqN14loKYeXJ4kLl1t8qa4DQAwjsAvbrGCx
        PFdNQO/Asv/NrX0QinMzsgm7MYW1AIqHslLwXYEXiMA19FCvQrV9+7NzLutJfX00
        QGLLiyy4Tcs5c20Xs4EcViXSieg1ZUEskkoMNuWbtIAEpk0F0gn3tkFoUnMDhBUh
        kmmsJN5q0nl7fKHkjHMI31quZOrmC5HV3ZnVPgDoLc11P0E6RkL/FLlbQbycAYL4
        ykAHLXFt487t8gIvMVxF3PPp62pgwxvqn3A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8vNwK2nSf-jg for <fio@vger.kernel.org>;
        Fri,  7 Oct 2022 15:45:04 -0700 (PDT)
Received: from [10.225.163.106] (unknown [10.225.163.106])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mkk0J1lQdz1RvLy;
        Fri,  7 Oct 2022 15:45:03 -0700 (PDT)
Message-ID: <aeb87504-4427-0ecd-2527-35ed0f881418@opensource.wdc.com>
Date:   Sat, 8 Oct 2022 07:45:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] examples: uring-cmd-zoned: expand the reasoning behind
 QD1
Content-Language: en-US
To:     Pankaj Raghav <p.raghav@samsung.com>, fio@vger.kernel.org
Cc:     gost.dev@samsung.com
References: <CGME20221007120530eucas1p16e2b45344e7148a39789645352a5aba8@eucas1p1.samsung.com>
 <20221007120528.58106-1-p.raghav@samsung.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221007120528.58106-1-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/7/22 21:05, Pankaj Raghav wrote:
> Expand the reasoning behind using QD1 for zoned devices with io_uring_cmd
> engine.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  examples/uring-cmd-zoned.fio | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/examples/uring-cmd-zoned.fio b/examples/uring-cmd-zoned.fio
> index 58e8f79e..89be61be 100644
> --- a/examples/uring-cmd-zoned.fio
> +++ b/examples/uring-cmd-zoned.fio
> @@ -1,7 +1,11 @@
>  # io_uring_cmd I/O engine for nvme-ns generic zoned character device
>  #
> -# NOTE: with write workload iodepth must be set to 1 as there is no IO
> -# scheduler.
> +# NOTE:
> +# Regular writes against a zone should be limited to QD1, as the device can
> +# reorder the requests.
> +#
> +# As the passthrough path do not use an IO scheduler (such as mq-deadline),
> +# the queue depth should be limited to 1 to avoid zone invalid writes.

Since all the writes issued by fio are "valid" in the first place, I would
have phrased this: "...to avoid reordering of sequential write commands in
the IO stack."

>  
>  [global]
>  filename=/dev/ng0n1

-- 
Damien Le Moal
Western Digital Research

