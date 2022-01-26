Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C73C433EF
	for <fio@archiver.kernel.org>; Wed, 26 Jan 2022 23:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiAZXln (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Jan 2022 18:41:43 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:20571 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiAZXlm (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Jan 2022 18:41:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643240503; x=1674776503;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=BhtJUJi30NwylHHKV0Q+R3B+Nbvw32gCSHTmqJqHXRA=;
  b=eypvt44e3Oskf0WlCxIEZiVJfG+heKacpoLcTBxwFOxRVnJ/8hd93Za1
   IbGol6g78Ud4SWkDsvIVWTvOV5V1eVyl7RwhayrpHVBwY31lBFr77mR4Z
   +/qJwgpgM7YfZD4Zu/C6kyALJbRFndT5Ayy29kLflDmWJDHIzXybEQCf3
   ESlQkpLUGwXjKRDUOrhlmmow0LY0hI8bsfOdYpwpdI9SWrdaSddaSsmMh
   ijg2TvWj8Us4wc8siNkYrFb2x5EXIR20jm0IW0oTEGEaMRWgp+DlTVUC5
   glUMcD80AAn7gY0xSCIWT50pwp5zVI4dMWV51Q71m4Vt9sqmr4RwHqNnJ
   A==;
X-IronPort-AV: E=Sophos;i="5.88,319,1635177600"; 
   d="scan'208";a="192465705"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2022 07:41:42 +0800
IronPort-SDR: SaadIfjAU8Ddles5gC+DZNpii0WibU34mX/9+z0Tw2KjUfTXIWmYRbugT0DOr6LjGeiBqWphp6
 rQEUnO3KhyZsEYtRKZx9jfO2D46kD9OjhPmtoX283FFAUSvEgItsYQH/9qHluzDDvKjS3DyitK
 CjBV+u/YU2CaaDFTwgJibG7dvcK1UMMaq3xPHM8qUOyiaW8CV309fHbbX9gk2FCalTSFZyNPH9
 P+C3NPJQmbcqmbWizS3uGbdK4W2IAYyhtpdBvZJm+SKFJfnTPae5dFbI+Z9nQsjIzWtmQEYRDh
 k3//WqYkCVYidMGNcgMMOe9g
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 15:15:01 -0800
IronPort-SDR: pgP9Nruggt8UagsPlDcgpr34y91pI1isso593T3mXTvvrbzDkZ58Eo1dx2pTeTHujYi6cwH44L
 UuniGV7xr3Kh37dBsOnDgvFVMDL3pJP9tqb4Rhlp6/7aJeWuDfAZm8vqnL4Yc1Fw74dRzfR5iE
 SsqmmiXO8UeSesRErcRD+ZXdmwvT5w87wqd+YJPHzrAxOZShr3a/zNTubkOnt3IXDPmvdrmBsw
 6va3gnc0Gs1W/s/KgrcNj0rM/eU3VlGnuvc3/Ql3GNPXp/GuBLHYjoEisP7X4lxvhfCcoXQzdP
 Ozo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 15:41:43 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JkgGt1DD6z1Rwrw
        for <fio@vger.kernel.org>; Wed, 26 Jan 2022 15:41:42 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643240501; x=1645832502; bh=BhtJUJi30NwylHHKV0Q+R3B+Nbvw32gCSHT
        mqJqHXRA=; b=nkMP0UC6rHwSTTncvNII8DEarorQYD025zXoagFl5J6+DgXrrtL
        6WM/TMhBtEv8MNmOuIbzSOTM4347JwVHPu6W6VDDHTVeC0AbSr6/6AXOGh78Ci8c
        YK6dnwa8n7iKV9lUM83WpuLn/vR5Cm4aRamsl42Sf8/0C3gcFnvVM2ccY6QQZWbz
        2RTo6OT7oXNPGDwbISIulHS+DKhK3Kv4tAkD6XMHzMTO5xIgwPb+5TV50h4Y4Xg4
        pMvL3B7RMoFllwdJet6B6CuxoWwx5KOtfqz4ahfSGWffVW0k0pcH97jQv+lvzAut
        sWOFF+qcQpzxmaCyv2G4gbWPR1/AdzKt67Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9ExymwrTxtng for <fio@vger.kernel.org>;
        Wed, 26 Jan 2022 15:41:41 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JkgGs3V0Dz1RvlN;
        Wed, 26 Jan 2022 15:41:41 -0800 (PST)
Message-ID: <83721719-aeb7-2a64-2cd2-ccc9b5b2113e@opensource.wdc.com>
Date:   Thu, 27 Jan 2022 08:41:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: A fio job that just waits?
Content-Language: en-US
To:     Nick Neumann <nick@pcpartpicker.com>, fio@vger.kernel.org
References: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2022/01/27 8:08, Nick Neumann wrote:
> Is there a clean way to create a fio job that just waits for a fixed
> time period? I'm fairly new to fio, and want a delay between two
> consecutive jobs. I use "wait_for" to serialize as needed, and
> expected "startdelay" to allow me to put the desired delay between the
> two. But it looks like the startdelay for a job begins when fio starts
> and not when the job referenced in a "wait_for" finishes.

The job that needs to be started after a delay should have both wait_for and
startdelay options. That should work.

> 
> I can play games with a job with a very low bandwidth limit (e.g.
> 1B/s) and "runtime" and "time_based", but it feels hacky.
> 
> Am I thinking about how to get a delay between two jobs wrong? Is
> there a better way? I realize I could just run fio multiple times with
> command line delays between the runs, but I'd like the results of the
> runs to share the same time basis and output/log files.
> 
> Thanks,
> Nick


-- 
Damien Le Moal
Western Digital Research
