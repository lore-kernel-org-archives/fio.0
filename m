Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2E6ECAAD5
	for <fio@archiver.kernel.org>; Sat, 10 Sep 2022 08:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiIJIhS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 10 Sep 2022 04:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIJIhQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Sep 2022 04:37:16 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2047E6C774
        for <fio@vger.kernel.org>; Sat, 10 Sep 2022 01:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1662799036; x=1694335036;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=iD95TB+zhQgdGrF951CXT93txAZqJxxZwCTHGQzPzqc=;
  b=FsprGXMyI6aaT3jD4OJnXLOJetGjqyI3UXXTwY7dGwLgkRf93Thp+G4Z
   I6h/fz5iobrR0DE4MOD4U1Q9YJtbjaJlL2Soj7MpmCuUxwF+yUe14icqF
   7VVqIiuJiN48+Au3dH6GfukzdJjdHQfxkvAv2Wapj1aMB3onmGKrUmumK
   ckdOCVIayu9x1fF3eN/xZ/58j56UfM662yiBDCK/Hyqh8EK2v+nH4rnA7
   8IYOfbfIrFy4vqF+9cExpkc5OfSi+vbghZaTSc3vMoC9lV6OJJbMW4nV4
   q0IQXMUKm/kfxfujXNk/pv2hAVjgcL9p+Rl3avVvPzxe8tHxTuvbL29yW
   A==;
X-IronPort-AV: E=Sophos;i="5.93,305,1654531200"; 
   d="scan'208";a="323107620"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2022 16:37:15 +0800
IronPort-SDR: CAxu28VoWljftaDZ+Gj9XhVTBjBDljAFtJXagnMfk2GJRtb9z8Dy3VR0e2uQbkJdAQGm/or0MU
 wHvZgK6YSINX37m8P4FNKIuqz6aeQGHO5zzCDPTX2rXIAWpOrHxM+k816t7bCtalez3j9OPm9H
 Kf61aRSUVlgj3QmC28A5EXDg7FNZ/rKE1tdDV0n0gZk+xTWsyFLsdhZs6dDZuHWJn/CRfZMDlU
 EIpjw9DHki2FD3N5n3or4WnaxwBsjTTrbTKTIfHf7SZElwIuKB7WZlEl5oQdwbRyXoKBcEDy9b
 0/GHqBYnnszdFFusLOXhCq0N
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Sep 2022 00:57:33 -0700
IronPort-SDR: pexTXGk3NbdQf0Md8ACLZamg7gLiVw7P9flgP/5/svkGau1q5qkEmgXIvQwGD0ScFNadd4XfLD
 8retEiVDPRgPIzBOZkeCsxx24qjYVBWRms6kDHeVvJ1qqXvBuoGPwU5ZpIvltIeFp3+UsNEXWS
 oIFfDLWAFKUkYS+2Lfi/5RYdt/8EQ5KvpBQkpsKY5AKfSP14oKWgm+9VzTmyLgwilU++jBLv+t
 /M4dO5ucjyp9N/QxmiYLiYHwRMZjU4AlxMTvsIP03PIuN3FmJa42LELRAIIT75pcWGahjH9pob
 WaQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Sep 2022 01:37:15 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MPmSW0FBSz1RvTp
        for <fio@vger.kernel.org>; Sat, 10 Sep 2022 01:37:15 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:content-language:references:to:from
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1662799034; x=1665391035; bh=iD95TB+zhQgdGrF951CXT93txAZqJxxZwCT
        HGQzPzqc=; b=YIP4xSjxoYP8d9YdDZbt94CRA4/W8bRa8imMIU9Rwyk+pkSddQG
        RzQl06DIDBtspzv3jHm2HWQFYgFk7hgOxqOhcRNvtfCQPTMXPa7xsdjBfhmxX3y6
        JY/ZwnMGmb5qVTHZgohjEFsav4yzeG6QDaBGFe+ZsxDXOCPhqzSUIxvLZCv6Ir+J
        clA9L4KwNdDOaAkA2kBEfwfUM++RFE9+p0LXDdnkdR8gf8Awz56CLfAGvRyclQ12
        WueuAwxplraFdtZANanNRODhWE3c5JTp/qA0TdFMjmbJZpBQlOdSFJj8rogWWSUk
        wQnfSzxpzZDSkX5QEnj0Y+JxrOA8kTYrTug==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KtdQ8xhGXAlI for <fio@vger.kernel.org>;
        Sat, 10 Sep 2022 01:37:14 -0700 (PDT)
Received: from [10.225.1.43] (unknown [10.225.1.43])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MPmSV0r4lz1RvLy;
        Sat, 10 Sep 2022 01:37:13 -0700 (PDT)
Message-ID: <e0b4c77c-a87c-1524-3fb9-4076f77b72d1@opensource.wdc.com>
Date:   Sat, 10 Sep 2022 17:37:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: Best practices for handling drive failures during a run?
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Nick Neumann <nick@pcpartpicker.com>
Cc:     fio@vger.kernel.org
References: <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
 <a48796d8-5d66-a39c-caf0-9b83a47664ab@opensource.wdc.com>
 <CADqNVTqQLuC6fXsBg6AnCgFWaNiDX=vjOhHvAskm_EP_vD-Q_Q@mail.gmail.com>
 <022e132e-f051-28af-f85c-c2700b9ba992@opensource.wdc.com>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <022e132e-f051-28af-f85c-c2700b9ba992@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2022/09/10 17:27, Damien Le Moal wrote:
> On 2022/09/09 1:24, Nick Neumann wrote:
>> On Wed, Sep 7, 2022 at 4:01 PM Damien Le Moal
>> <damien.lemoal@opensource.wdc.com> wrote:
>>
>>> Unless you are using continue_on_error=io (or "all"), fio will stop if it
>>> sees an IO error, or at least the job that gets the IO error will stop.
>>> The IO error will come from the kernel when your drive stops responding
>>> (IO timeout and is failed and the drive is reset in that case).
>>
>> Thanks for this info.
>>
>>> Which behavior ? That fio stops ? You can try continue_on_error=none and
>>> fio will not stop until it reaches the time or size limit, even if some
>>> IOs fail.
>>
>> I would like fio to fail and exit when the I/O error happens. I was
>> wondering about a way to setup a scenario where an artificial IO error
>> will occur to make sure it does, if that makes sense.
> 
> You can use write-long, to "destroy" sectors: you will get errors when
> attempting to read the affected sectors. But that is a really big hammer. A

Note: write long is for ATA drives only. That does not apply to nvme.

> simpler solution is to use dm-flakey to create "soft" IO errors.

And Vincent also pointed out null_blk error injection. dm-flakey can go on top
of any block device.

> 
>>
>>> The default IO timeout for the kernel is 30s. If your drive stops
>>> responding for more than that, IOs will be aborted and failed (the user
>>> sees an error) and drive reset.
>>
>> Hmm. I had 65 seconds between any I/O; it sounds like that would've
>> been enough to fail things, but fio returned immediately after that 65
>> second delayed I/O, and with no error.
> 
> The IO was likely retried.
> 
>>
>> I also found the drive timeout error in syslog:
>> Sep  7 12:37:43 localhost kernel: [ 4354.600211] nvme nvme0: I/O 870
>> QID 4 timeout, aborting
>> Sep  7 12:37:43 localhost kernel: [ 4354.615429] nvme nvme0: Abort status: 0x0
>> Sep  7 12:38:15 localhost kernel: [ 4386.600297] nvme nvme0: I/O 870
>> QID 4 timeout, reset controller
>> Sep  7 12:38:17 localhost kernel: [ 4388.050831] nvme nvme0: 7/0/0
>> default/read/poll queues
>> Sep  7 12:38:18 localhost kernel: [ 4389.437287]  nvme0n1: AHDI p1 p2 p4
>> Sep  7 12:38:18 localhost kernel: [ 4389.437347] nvme0n1: p2 start
>> 2240010287 is beyond EOD, truncated
>> Sep  7 12:38:18 localhost kernel: [ 4389.437350] nvme0n1: p4 start
>> 2472081425 is beyond EOD, truncated
>>
>> Combining the fio and syslog, the chain of events appears to be:
>> 4332 seconds - drive IO stops
>> 4353 seconds - syslog entry for timeout/abort
>> 4386 seconds - syslog entry for timeout/reset
>> 4387 seconds - read completes and fio exits without error
>>
>> Thanks,
>> Nick
> 

-- 
Damien Le Moal
Western Digital Research

