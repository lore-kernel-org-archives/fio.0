Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA68C433F5
	for <fio@archiver.kernel.org>; Tue, 18 Jan 2022 23:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245680AbiARXXy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jan 2022 18:23:54 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:7294 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbiARXXx (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jan 2022 18:23:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642548233; x=1674084233;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=316BW4Ncvbdr2BRReiFYO4+foe20K98SnVFP0ykQnuk=;
  b=MgKCYcmB/yUP478cY3Ie+fF9SEHsmZoL8wnCqera67lsgh2Co4SYkPJh
   OKd8StBJSJFSx2o+1Ct4ZkfNSctkkaJSdu9l1dkiX3xRVs/MMabNXuEu2
   ZPJDquFZqS1r9ubfkB76WVSbZemVPqUPHXMCIMk774ZVGO32kRHq/X/uI
   FNBQ2i/n7D0OxbUo3lm+P/GbF7+XGHkDd4p/LLjqujf1K/MQ2Mc9Kqlvb
   tx5np3YOftJTzsQua33nHW2t8hQ7CMC8hL94uR+uPk9/WZzj7GjqdP8es
   jhRD7bdfeqak4AEJ0E6A7lEdJv14g//TfLVzxg3JgTyPwdDayWOov5ukM
   g==;
X-IronPort-AV: E=Sophos;i="5.88,298,1635177600"; 
   d="scan'208";a="195588717"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2022 07:23:52 +0800
IronPort-SDR: z/hZb6cJvjicELMKY8k/WeDXN2+CYD8srRYwUDLDx2ydNnAUq/AoiwlqzN1YZAMr52s5X/v/LY
 hoOalUUBQRm+qzNMP1iM3+5wblyZuHoUiOfXZm9XGgxdQxl5K5SWupDKSsOOGAW6bTLV6vgCWk
 KBEgOtDc456ACnKMwsf8Ebz4yeSqcYEXiCq41+g3W2NywSoSj/55Uu+Lg39EfrVYN44B4DtPhP
 6PbcLxrUlgKr+dGqwmyl0y37Wwer69Q8Zi/T1KLNdv5iFyGIX5p4OoXdV9aAVZUz77VF3d+I9P
 miRxDCm2t5F/KpWu4TuJDo7G
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 14:56:07 -0800
IronPort-SDR: yIdpBGluEnhbJ4+1LNugg9U01Q+AYruPrOc8M58fpc5CHcCPfFL8EOcO9gSDR6F6IMJ39HMNBv
 XVrnrO8VT2CjhQkdYwVDOQfNHGjTn8S6YPfU6TjvWUghN0BjdMIvP/pJqKGLMvXGTo46T28iuU
 DFN9zsnWZ7fdr6hud3gRgnLeOiqVkKHGrureMxGpC/eyKHuXbcQ36Em5+UF3yn8ae9J4oPg4iW
 m/AfYCjzbWjWAUmcRgJ82iaVyKgnCgU4i8DnrTUBVxCBkTFXb7g+Gc9YJ8hHUDorUvPbUW7wpN
 /Yk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 15:23:53 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JdlG10Hggz1SVnx
        for <fio@vger.kernel.org>; Tue, 18 Jan 2022 15:23:53 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1642548232; x=1645140233; bh=316BW4Ncvbdr2BRReiFYO4+foe20K98SnVF
        P0ykQnuk=; b=jHLV9rEb/PXu8TwhF0tbWy1gdC9SRFThIkJmCbK2lnFO4SZ5OJg
        XRo6x3xmElU0lGaufGZKy4rY8vp0YUOb9P1F+ndYDJIIXLsP2dz3KSHk1hjOCq5R
        ZvWDgSTHNLl77eQGoeAOCWlHbcRceOwBUCiLrSCrnd7xaAiLUdRkFlnlgy/LMtgj
        57LyJK8aQqW7QU++fOZwjeTZKmfRMqyT7unsNgExGPXcmQn5DdawP1QiDWGPVl4b
        l9S6HCfpvOyfrIPRi+ibbcDQLQff4Rrwxf89lcdnInKo59rNvRDJ+UTH+wGkC2NY
        izYgD1g4RzF0DggW6Dc3r8cP/C86ZyR6D3w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id weQB6qZ09_wS for <fio@vger.kernel.org>;
        Tue, 18 Jan 2022 15:23:52 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JdlFz6vL5z1Rwrw;
        Tue, 18 Jan 2022 15:23:51 -0800 (PST)
Message-ID: <3422d44d-15e4-1e23-d2e9-70477039ca3a@opensource.wdc.com>
Date:   Wed, 19 Jan 2022 08:23:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: re; How do <>rw and <>rd_wr disk tests work?
Content-Language: en-US
To:     "Gibson, Thomas" <thomas.gibson@hpe.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <SJ0PR84MB1434C484CDB0DE5E4A19554BF4589@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <SJ0PR84MB1434C484CDB0DE5E4A19554BF4589@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2022/01/19 6:10, Gibson, Thomas wrote:
> Ok, so I've gotten info, from sitsofe@gmail.com, on the fio test data between
>       seqrd, seqwr, randrd, randwr.
> and
>       seqrw, seqrd_seqwr
>       randrw, randrd_randwr, randrd_seqwr.
> 
> That person that reviewed my test data, id'd that cpu usage was not an issue.  So, I'm now looking at my buffer cache size and what unneeded processes the server is running that I can turn off.  
> 
> I'm trying to determine what things on the server will affect the testing beyond what I'm currently addressing.  It was also suggested that I add "iostat -xzh 1" to see what disk utilization is like.
> 
> I know this is a biggy, does anyone know where I can find a copy of JEDEC JESD218?

These documents are for purchase or free to access for JDEC members. Either
purchase it or get access to it if HPE is a JEDEC member (likely it is).

> 
> But I'm still left with a basic question, are there any kind of documents that describe how the tests operate internally?  By understanding how the testing operates I might be able to identify what could explain the results I'm getting.

What test ? Can you share the fio script/command line you are running and what
your performance issues are ?
There are many ways to do IOs to storage. Without details on what exactly you
are running, it is impossible to comment on performance.

> 
> Tom Gibson
> hw/sw engineer
> hpe/aruba
> 
> 
> 
> 


-- 
Damien Le Moal
Western Digital Research
