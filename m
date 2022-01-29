Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE578C433F5
	for <fio@archiver.kernel.org>; Sat, 29 Jan 2022 00:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344659AbiA2AQn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Jan 2022 19:16:43 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25240 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbiA2AQm (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Jan 2022 19:16:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643415402; x=1674951402;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XQk/3We/6Bn/q7hgx8Ua+1dVnFSEVpZytQ8DNPip/y4=;
  b=Dr213xxPYKPPPY54XcTge/RomFoetUBAN2aDQsftOrAl7id9ppc3ixtK
   QJkjTcD3A/UKW06hVFae21D2XUqRuacljR9dKoAZgHz9aN8WJQsHyvrMs
   PYne4DAFRFaNj9W4s3/2tI+alTiiQI5FHoiMtFOgG2X9t1tO4LdAIjFpK
   x6g4p6qiiL1Sgw25WcU51ZHKKN5G1TWUA8vsjiYOkIN1FzjgNJ9aQIFhV
   4qqb2Ga5Oqq3AN26wOai56SIyrZwvM63EunRTT+U6XY+9jAkOHxIjblGl
   00BDyVMMT7+63o7E5fko6jPbRxXuGEhfhGP8NWmjntB9E7IUv+DWxxFhQ
   w==;
X-IronPort-AV: E=Sophos;i="5.88,325,1635177600"; 
   d="scan'208";a="190622756"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jan 2022 08:16:37 +0800
IronPort-SDR: 4nD5WcRBada2BgpZxDQFVoaWsjDBfLohgsPGwWCMfxFVwq22b2ab3aqN6E6784v/OzlsG2mBet
 XcLYHvqUbrDe6PPiD9jjOlm8uYNHBsYGNsmDJOYI55W39Amu4VTxwcy33yY5bF7iFcmq15QQ+D
 f7Jtb4BcJWdU5xRUVMp2zXZ6sIcVEN0u/6AFdWoHxasydHA7XD7PxEJduw7mT2j3yr5j12jAay
 ndWBr43mzhp2Tj0lzUwiRR/i7FRT7bQWvBreuCOLDXLu2F/vcG2H+N1aY7B5Ohh7LcfHXuKdDE
 HQsvKKoIEWvT/D9mZh38mE/O
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 15:49:53 -0800
IronPort-SDR: uAng+K5JATJ4QfcUoA9RZgISDitinxjwEAWFrR7zsAJXTvDvatqAnVDs9715uahYB/jE9HW30a
 oqMoXGNd7qw2DuYfJTSI7BWOGJBqw0nMQrrM1ncshQcopc/1GxH+1BlMCj9kbj0tOzhRzU0wgS
 t9KgIbc7rNq+7c2XPLSBn4QoADxnLl8ZDbQnEq+MvnUdaaWwXTmy2foC6sdzIDaJZVcmaPeq23
 1d9sCHikaiwrHOcAqi2gedSQlN97mlxnOgwJAVW88UQ0MY+HAgYlHibH1kPaT4kh0XTyHz+j4M
 0yk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 16:16:37 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JlvyF28XGz1SHwl
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 16:16:37 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643415396; x=1646007397; bh=XQk/3We/6Bn/q7hgx8Ua+1dVnFSEVpZytQ8
        DNPip/y4=; b=OI/PDV0p7UWRwqeNv5bzXZK+CNMUeljmUthB/UAZbJ8mya4fkOm
        j9ctbOkHjq0uEl8c1zIVS1M5hRhVvGjpnabTMu4PSl6pWQ6MPSqf6cGhIMH5jCbK
        rG7zkVC9oI1J6QityQQspAP162wJknyGpvTfpk1anQdxk/IPfHp4W8j4gyrsCbKH
        +0+YNpcAVzUeEGeXzJKTZD5GmyzZSDDQrvp44zPOdc1qjlejVOmU9TyPPx79Xjse
        E1k94sxScTuTpbQQanrXHTXxfL7njl+zhLAVI3BZJ7WCdgq23MG2BDUEIwDrkJf6
        ++u6hGu3m3eptf5V+pLZ3q2heAUHZQDmZZg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id IMsMailrDmsH for <fio@vger.kernel.org>;
        Fri, 28 Jan 2022 16:16:36 -0800 (PST)
Received: from [10.225.163.60] (unknown [10.225.163.60])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JlvyD35WNz1RvlN;
        Fri, 28 Jan 2022 16:16:36 -0800 (PST)
Message-ID: <7a3e701e-e3ab-4dc5-2326-387d80c38061@opensource.wdc.com>
Date:   Sat, 29 Jan 2022 09:16:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: A fio job that just waits?
Content-Language: en-US
To:     Nick Neumann <nick@pcpartpicker.com>
Cc:     fio@vger.kernel.org
References: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
 <83721719-aeb7-2a64-2cd2-ccc9b5b2113e@opensource.wdc.com>
 <CADqNVToqmzWAkkxJxe4r9M05H6ZcYRffG5pvdiHUuERMS8ojkw@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CADqNVToqmzWAkkxJxe4r9M05H6ZcYRffG5pvdiHUuERMS8ojkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 1/29/22 02:02, Nick Neumann wrote:
> On Wed, Jan 26, 2022 at 5:41 PM Damien Le Moal
> <damien.lemoal@opensource.wdc.com> wrote:
>> The job that needs to be started after a delay should have both wait_for and
>> startdelay options. That should work.
> 
> So that's what I expected and hoped. But it doesn't seem to work that
> way. For example, I tried this:
> 
> time sudo fio --ioengine=libaio --direct=1 --filename=/dev/nvme1n1
> --rw=write --iodepth=16 --bs=128k --name=job1 --size=15GB
> --runtime=10s --time_based --name=job2 -size=15GB --runtime=10s
> --time_based --wait_for=job1 --startdelay=5s
> 
> The first job runs for 10 seconds writing. The second job does the
> same but both waiting for job1 to complete, and with a startdelay of
> 5s. So I would expect the total command to take about 25 seconds = 10s
> job 1 + 5s startdelay for job2 + 10s job2 . But instead the startdelay
> appears to begin counting when fio begins, not when job2 becomes
> eligible to run due to job1 completion. The output for the runtime of
> the command above is 20.760s, with the second job starting immediately
> when job1 completes.

OK. There may be a bug then, startdelay is not accounting for the fact
that the wait_for option is being used. Can you try the stonewall option
instead of wait_for ?


-- 
Damien Le Moal
Western Digital Research
