Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5951EC433F5
	for <fio@archiver.kernel.org>; Fri,  3 Dec 2021 00:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbhLCA5I (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:57:08 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:52779 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbhLCA5G (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Dec 2021 19:57:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638492823; x=1670028823;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PVsvWxVIgOVyoE8FFC4KUHG62AQdRyUDxfu1OHbtxvk=;
  b=nTXxKI7XOGODT9iTGfWx5QyMiMJVOatMadiyq6vpFy+FufmkxfvpdOjG
   JOqUrzQva7tLsVRgQ2jmh/7kiJmFf9qvLw6MUZPx5/SOhsIyjDQIFrvvS
   vVmZclbs6mvUuHgWp1ohWLBNb0hgncFVoICVu18+Yp0WUGn6j0fcL0JE0
   Rg+aTU5nYag80c7w5T6gWM9JofXxHe1GS517yn/0Mgp2EMoFvrV+utvDU
   Vr/v2SdNbYeN0/z1EV0ccnmyZ7jGYUvuDJBfLnHvHLi+aeOsENmRr2GQb
   e7LwvDbJ4kSYWFwj15OTt+BqaLXklZly2Kyf6CxwS2LGENMiwkob1uyFR
   g==;
X-IronPort-AV: E=Sophos;i="5.87,283,1631548800"; 
   d="scan'208";a="299175503"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2021 08:53:42 +0800
IronPort-SDR: fwM8eRTrcoDvPRrTHrUUQAmNw+kpHQp5DJmEFy5zCFLCUzdFiXwvA4IQeRBZ8e+QRaqIVrYmwf
 CSL9rMXdFFcQprDv4nInRffCz8EzvN48UsLwMF82zFkcwkyv1f8kDmymQKKsdW3H34YfytEdLU
 UwhH3+TIoMxGDBpjcMQAYuRH9JVHFVMBWJXM8DcVZ0OlBUR4juo0YC3ScIg1jA9JUYS7Q6AYgy
 RTjS7b9lPWwdTknxWRvJ1otUNEXv0NVAXiG1Cf1bQbSsoskX9KdwdIxGJb6uuWCfPG3uBPHMS2
 mHDJgACaSuRzQyINoMY3b6wa
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 16:26:52 -0800
IronPort-SDR: VZfjpGXtDJPDSkMVhNNIXhVG8DF+oGy7Aa9e+Y1z7BPzNyxum6VP3zU3CjPQdDmsHzrHdT9+vl
 G4qMkcBlRy+ifcmtcxwgEOMeE5iMS32ArUSINU241mTQCtW3TVuOxeizDsX0FklIO6YdSGjyhS
 EuS/roC/SlROu+j6l7gAKUAOExNlWnFNdA2/ePgqKNNX6YLamgfXITKpTeCwW5hCKzsMokhlmF
 tW4SMrSK0RPZWjAQdRsae2Tzld80mDn2SMFkbBNefBDLlJiZBx7M4NEDJp6Hs1nLVEK8eqU2XJ
 Zfo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 16:53:43 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J4vTL1yZgz1Rwnx
        for <fio@vger.kernel.org>; Thu,  2 Dec 2021 16:53:42 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1638492821; x=1641084822; bh=PVsvWxVIgOVyoE8FFC4KUHG62AQdRyUDxfu
        1OHbtxvk=; b=beQsZE1gEh7TberJ3geAOzp4lFkD3o2EJiPAE3zr9fdYUmqwmZ3
        Sjufl3nVB7LDmceWZ3/kiHYryZa07+/h+B/nfb1bqA9kw2NdrHBMl7oMEo0hjFcA
        STu7fipLUQHumyjtv7GZFiaHvsHn6KnCKg3XXhesYAfI01MBQqa/M6nGmymaaMWA
        vJUyzGaA+WdHB8Zkz1W3eQUQeRXLuI9OzJehbwlRl53OflCIZIy4GZzotiFsVsno
        uAg8974sGeSohhTf/uJEYGhJPgJCEwiUG0kpMdvrwuGqTBxq5kBpkXMpeuZEgLSa
        Z6lp7Zxoh2+xc/1pT0Vmf91R2u1ukMaVKHQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id i0zIgptXQWde for <fio@vger.kernel.org>;
        Thu,  2 Dec 2021 16:53:41 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J4vTJ3fFKz1RtVG;
        Thu,  2 Dec 2021 16:53:40 -0800 (PST)
Message-ID: <81c52512-cd9d-9edd-62a2-5781c31d5a7f@opensource.wdc.com>
Date:   Fri, 3 Dec 2021 09:53:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] filesetup: create zbd_info before jumping to done label
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Shane Moore <Shane.Moore@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
References: <20211202094153.8381-1-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211202094153.8381-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/12/02 18:42, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> For a thread that has zonemode == ZONE_MODE_ZBD set, the zbd code requires
> that each file (for that thread) has a valid f->zbd_info pointer.
> 
> This intent was further clarified by commit 5ddf46d0b2df ("zbd: change some
> f->zbd_info conditionals to asserts").
> 
> The zbd info pointer is set by zbd_init_files(), either by creating a new
> zbd_info struct, or by increasing the refcount of an existing zbd_info.
> 
> A zbd_info struct contains the in memory state of the zones, including e.g.
> each zone's wp and zone capacity.
> 
> Normally, zbd_init_files() is always called, even for read only workloads.
> However, in the case where a read iolog was supplied, setup_files()
> currently jumps to the done label before zbd_init_files() has been called.
> 
> Even for a read only workload, zbd_adjust_block() will do things as
> checking if the read I/O is below the wp (unless td->o.read_beyond_wp is
> enabled). In order to be able to do this comparison, we need a valid
> zbd_info.
> 
> There is no reason why the zbd code should treat a read only workload
> different from a read iolog workload. (E.g. the wp for the zones might
> have changed since the read iolog was recorded.)
> 
> If the user for some reason wants to disregard the wp check during a read
> iolog workload, the td->o.read_beyond_wp option can be used, just like in
> the regular read only workload case.
> 
> Move the read iolog check and the matching "goto done" after the call to
> zbd_init_files(). This way, we treat a read iolog workload simlar to a
> regular read only workload, while avoiding an assertion failure in
> zbd_setup_files() (which is called after the done label).
> 
> Reported-by: Shane Moore <shane.moore@wdc.com>
> Suggested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> Tested-by: Shane Moore <shane.moore@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  filesetup.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/filesetup.c b/filesetup.c
> index 228e4fff..fb556d84 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -1119,9 +1119,6 @@ int setup_files(struct thread_data *td)
>  	if (err)
>  		goto err_out;
>  
> -	if (o->read_iolog_file)
> -		goto done;
> -
>  	if (td->o.zone_mode == ZONE_MODE_ZBD) {
>  		err = zbd_init_files(td);
>  		if (err)
> @@ -1129,6 +1126,9 @@ int setup_files(struct thread_data *td)
>  	}
>  	zbd_recalc_options_with_zone_granularity(td);
>  
> +	if (o->read_iolog_file)
> +		goto done;
> +
>  	/*
>  	 * check sizes. if the files/devices do not exist and the size
>  	 * isn't passed to fio, abort.
> 

Looks OK to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
