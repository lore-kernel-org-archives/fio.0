Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A64FC433EF
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 00:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbiDGBBn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiDGBBm (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Apr 2022 21:01:42 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23875F4C6
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 17:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649293183; x=1680829183;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=N6B4g3lzfGL7V88coMKqTc6rZ3X0TPNc+SuFFfuinUg=;
  b=JRb15hfbWJ/AqwepIyumArRvtmxhcHJC+CS62tUGLPF1Fq0yRrOv3niG
   9vTYZZOydSJhOpSlrA9V96F6h8MlIBasM9AsgwyxPrvqUsCqx2RgSIOyX
   eNkik+RhK+9cazNYFl+edObdnpc9lTtxRQKVT+BFh00twVeSpnebvOHU4
   6eikk6xzqjoiAzu6nv0y86D+IDtl7ETRRKNpkN8i27shChntZXQdh8yJZ
   K6hz6jhSOCpgXeexLAhpOU+Q2JcLwX2HnoZ27SgdGHNLdP9kkR4dJdatJ
   NkNIbIWdyiC4P4HzEFBMbEMJCI6zN0GldfhVoCJ4FjnS2iAwgS27JdwXa
   g==;
X-IronPort-AV: E=Sophos;i="5.90,241,1643644800"; 
   d="scan'208";a="301461663"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Apr 2022 08:59:40 +0800
IronPort-SDR: vJvHHdTcQtotX8qmiMC/bgTkBEIkyKRUjRhKSuFiLC07a/fKAKnLTNyyRC2+5sTs2A6HTg2DMs
 aRWMFu0sTcAwVFgnbirZIImv2Vl+npcBVM3YvredUEk6jYbTK6mAfJUMhw20Ucq17yl0hbtY2g
 pBbhtIB6uo3YWmcaBFsWN858x9oBY4EbNS9NY79nCYKXN6wvxgS9pl37LN4rRYA/V+wnvgBM4t
 RaG9h5ua0pLT2FZMW4WTQCyt5mfI/UDXAKVBQwKm9qGRqkGiqtBfMFHCf7Wb4hjSnNtsl11gko
 m7thXDe81MpaV3CeR2pE5JeM
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 17:30:21 -0700
IronPort-SDR: 8KxNANs8/M7ZWYnm4FUzG6YB1ndKvIfZJrzbc51mTjn6Xr6uuDo95pZEn3WC3XJQ9aMgVxTWrE
 JgjmJBjdCR6vbW023WhpuYFv6yBfYVZTK08vpddv0ny/YbV4gsRhUWJrjtEuSLhcRb83IluHCP
 +xNP6ADgTUqnOpIKb5zL11iD75ckTLSSQiuncjUp7PY/6Yg54/4+pwG7J2gYw+q1AHmi86rfuT
 LrYG5oTGbA4rum/HiliIaIs22a9br+6cLFBZ79/5r/D20KEbTz7SEeWzlT0PkHGS6ZAjtRhv8I
 Tlg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 17:59:41 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KYjhX2FQyz1SVnx
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 17:59:40 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649293179; x=1651885180; bh=N6B4g3lzfGL7V88coMKqTc6rZ3X0TPNc+Su
        FFfuinUg=; b=FWylGa65VWjTikoy0f8+0xCARXNMBFhJuudXFkFmEJapIFh+gWM
        ydPRG8+Q1juc5QCA4x3dq5u9mI/krzVldUTRTFIC7+1trbCF2a7nvvivuzJ6vEy2
        Q+pe2k4oLh683PsFdJOCXy6zwmu3E3RsfFrzemVHwkAh85pIVmUUhoUdLUvL8gUN
        aGJATm6F2iyCxP/1/7iTbsoSVhujW6nydUwf5p056p2LVcnjC9bmja8JSRXN+KEo
        5SHmUlFaVPwzL8n3ByJ4Iu9+Fuz+/NebtnkMqZMXQfWp4Uu1zMujatOcIWIjmJ8d
        T1w0fZ/VZwn/Fiqz8t+uVqNwMHena65ludw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EEghSLu1In6I for <fio@vger.kernel.org>;
        Wed,  6 Apr 2022 17:59:39 -0700 (PDT)
Received: from [10.225.163.4] (css-nuc-sbp2.ad.shared [10.225.163.4])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KYjhW2yNqz1Rvlx;
        Wed,  6 Apr 2022 17:59:39 -0700 (PDT)
Message-ID: <0bc4cff5-bc05-a72d-72d1-088df260c761@opensource.wdc.com>
Date:   Thu, 7 Apr 2022 09:59:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 0/3] iolog: add version 3 with timestamp support
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Mohamad Gebai <mogeb@fb.com>,
        fio@vger.kernel.org
References: <20220406170530.2198263-1-mogeb@fb.com>
 <fb36eee8-923a-f8a1-0a1d-6f4f19bb2772@kernel.dk>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <fb36eee8-923a-f8a1-0a1d-6f4f19bb2772@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/7/22 08:50, Jens Axboe wrote:
> On 4/6/22 11:05 AM, Mohamad Gebai wrote:
>> This set of patches introduces version 3 of the iolog replay. This
>> version adds support for timestamps on both iolog_read and iolog_write.
>> The 'wait' action is no longer supported with version 3, as the same
>> behavior can be achieved with timestamps, and it keeps the iolog file
>> easier to follow. This could also allow to potentially deprecate the
>> 'wait' action eventially.
> 
> Not sure if it's just for me, but patch 1 isn't there. I do however see
> it on the mailing list, so maybe it is just me?

I did receive it from the list... Junk folder ?
vger seems to have bad days recently. Lots of weird behavior.



-- 
Damien Le Moal
Western Digital Research
