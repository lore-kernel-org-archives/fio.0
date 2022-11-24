Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2763BC43219
	for <fio@archiver.kernel.org>; Thu, 24 Nov 2022 10:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiKXK4O (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 24 Nov 2022 05:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiKXK4L (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 24 Nov 2022 05:56:11 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4177B179A9D
        for <fio@vger.kernel.org>; Thu, 24 Nov 2022 02:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669287369; x=1700823369;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=P2jAH/zVwhFp/SK6LpWGFUyl/EIy+1IDsiSKmz8lAuQ=;
  b=iyKdfHUpqBzAFmH3UuOKYvOgrxCHN8VjD7bBUuvOWYh0xdOXv0bYJfLb
   NdmAbSVtT+5/v9ZTQ4OAUJ3DuDXscatz7a+MOYnQ9VuY4/QcIy1UCRDpv
   wwpaWteaSg3LMAHi7YVPYBdGdZv4IGwY0R4rB2YfLtCfXPI1mRhXG+z0O
   6IRpPDxCfXh9O2jtpSWm/kD5B6AVF4E/NCumBGJR8zT2f904qdGfzzFi5
   /i5eX8VxPrj7abJ6mkTQLzsvWFuS0eVLF0etpOqxMJYdUs/IqSjA9878G
   jxrWDrMPgNk9xrSraYH2y7XoClLM7GN5mYnPKeCBmw/P9r5WVAEj89VJm
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,190,1665417600"; 
   d="scan'208";a="321428969"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Nov 2022 18:56:08 +0800
IronPort-SDR: kQWCfzUL/1ZGPCTu+qsnR7PRhovvmOJkYaOpYknevosbQAIHtoGqIpzsUlJurjwJnnXDBY26oc
 iJ04n1oZaCExLF2jrDe8nW0seftBZMPvhffug0FHFb1QYdSr9yZyxHnDZpxRFa8nDxLFGBHp+Q
 5ZLLLqbflmX9HOFTt/fpFR5VtdWGQOAI9PcyZ2Y6TrZHEPeUFE5G3A1nY57R8HfywAh8ADeCja
 XtRhoqlwnbREjBocett2n35T+VgT6JRvTiofGFCIaBKpi0EUtK7c01Z65UuYm72+QK83wP0Ziy
 TKM=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Nov 2022 02:09:10 -0800
IronPort-SDR: IBkcKyv+ESS6iy16Z3Xa29cB+z7g1Iyzy2RqpjE78NnwlI/hWP2mNqwAK05uZDdFfIJ391XngG
 8eZsa7yQQV6mX8O3pa4+7t54bRnZa+UFpgIFtDxSICb8fFv6RTP8r4OWQU+IgUKvRV8mjaym4K
 ngQfJIIZMB6yXpGgNb3aggC9P2ulFf9nBzC83z7XjZV60jbrSZiGj6rSbtGCmGM1k74ulIvHqO
 QvnS/0UmfsVfSMid/1tEvsl867jOm7ElAPOPlPnBlLmboGIcTAwA3XLhgATxT2L0QUxvU9ptb/
 xcQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Nov 2022 02:56:09 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NHw0825f2z1RvTp
        for <fio@vger.kernel.org>; Thu, 24 Nov 2022 02:56:08 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1669287365; x=1671879366; bh=P2jAH/zVwhFp/SK6LpWGFUyl/EIy+1IDsiS
        Kmz8lAuQ=; b=tDziam3slHW1w1BFRfaLAiQw4N4RenGyfKHeQA9npir85cqdLlJ
        qlXOT0g4weV0kEqY2YmfGqZpCv8fANkKFLooGplLL9zZ5ani7lS5c3QH8PaIGLvk
        wV3xGRIWjtDmlUSm7qA/8MBMXrke9dsKvz2e38f2JWvwqb+1FGsEG28NDVrseWZE
        B/jO4PU4B/R5x2wuDcihsnlrhzPXTfTewCH9fyIidBOBzFSrZB2JirQxbzNS1XIJ
        TC23LVSoB6nP6v1iZND1uJHLfkCc3gVd2yowH6h4+dZHMF2ajqsOnBVfZzG8c0Ot
        j59F/0ZZXGWGAGt31wlAKv1/UlaRa+S3zQg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id laK3vCpiwQry for <fio@vger.kernel.org>;
        Thu, 24 Nov 2022 02:56:05 -0800 (PST)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NHw046n0Vz1RvLy;
        Thu, 24 Nov 2022 02:56:04 -0800 (PST)
Message-ID: <a6e67f8d-97e7-4551-b9ea-52609c6daad0@opensource.wdc.com>
Date:   Thu, 24 Nov 2022 19:56:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: fio bug (?)
Content-Language: en-US
To:     Mateusz Masiarz <matimasiarz@gmail.com>, fio@vger.kernel.org
References: <CAON0+B8Tq+yH+Uqoxi6QbO82mEqipc2sz1rBtnAEurc6cuxkLg@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CAON0+B8Tq+yH+Uqoxi6QbO82mEqipc2sz1rBtnAEurc6cuxkLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/24/22 05:38, Mateusz Masiarz wrote:
> Hello, I'm trying to benchmark pendrives with fio. I'm running:
> fio --name=test --ioengine=posixaio --direct=1 --rw=randwrite --bs=4k
> --size=4g --numjobs=1 --iodepth=1 --runtime=60 --group_reporting
> --time_based

Try ioengine=psync and you can drop iodepth=1 as it is useless. That is
equivalent to aio with iodepth=1.
You can also try ioengine=libaio (with iodepth >= 1) on Linux.

> the io file creates normally, but then the job starts. Firstly, the
> write speed is not shown. Secondly, after the job runs for one minute,
> the completion percentage drops to 50 and the eta shows a few thousand
> days and the job doesn't end. After about 5 minutes of running the job
> ends, but write speed is supposedly only a few bytes per second, which
> (I think) is wrong, because crystaldisk mark shows around a few
> megabytes per second with a similar random write test. I'm running
> fio-3.33 and I tested this on MacBook M1, raspberry pi, some old
> kubuntu system and on Windows, and every result was similar.
> By the way, is it normal for "Laying down IO file" to take a while?

-- 
Damien Le Moal
Western Digital Research

