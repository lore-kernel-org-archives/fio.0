Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CC3C6FA82
	for <fio@archiver.kernel.org>; Sat, 10 Sep 2022 08:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIJI2C (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 10 Sep 2022 04:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIJI2B (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 10 Sep 2022 04:28:01 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0A88E461
        for <fio@vger.kernel.org>; Sat, 10 Sep 2022 01:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1662798479; x=1694334479;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j1fYJ1u2xK8HmzOx+0xPv0Da0KhWb3RqS+knl0TyBE4=;
  b=nG1KD0yZ0puGVPgxN1kNbQn6KOx3ZC6NtHw/WGx6FRuWhJwG3/bz/K1i
   O4nEv2j4Lji3siZTbg2VAlKuIyHi6bsslJRcWzBorz2BZXw6NUs5a+RtR
   pyBEaGbmHX4DkrYm4nxIJ372vMvUwWf6Ha2xM38OjzKosMeUd5Q5y8Lh+
   5O09ETH198aaBM4NE0SsJRiOdeksFddr+ijaKvTWqI0Ne2IZ3Q4j6qYf6
   FJ5DVXgIMK6NrA7cd90Z/c99NgsfbEJWfP496JL++607WzwCoOFyw5G2w
   6IGq9pGIzoKHwv9JKUWOI1nI+bnkQSc+lzVqMaxRn57JZ5R0xjUQ0pPx4
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,305,1654531200"; 
   d="scan'208";a="209412953"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2022 16:27:59 +0800
IronPort-SDR: +Y3J+PN46zx3UKxQzZ61dttUavEZOUZyOhu5nxUe4yH5sqwE2f7IEnEGQdBrQ+5mX2Cn7AUKed
 yZJUsxecrPEmkXxLKUSYg6h2iHjoSWp5CW7G1s2sx7d+djXztaknv0DI1Oqo6b4JtBjntkHnz2
 TZID/NSzh383yz6ETlxvzRTFsp9wPwffqfOmKkelOd1uor0u0HO6O286bSbHYhPltfr1279ZO+
 YIgxBscOI5lW5EDTAk59kh8/COgtvcbPw7FVejLB1FPBkxlY1+L9BKTBCpQxVciFBTkLrJB683
 7QJWbDf0bMHcJ3MOugqvYzyG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Sep 2022 00:42:51 -0700
IronPort-SDR: rlPrmu4JviFveVsanGwG1hMKgyvX+qMXnHxdN9VQCzWvWvpZErQIH2zPLX7uADDc1aUOvp8sC0
 X9OlrBOPvke4cNtMLXp8ZhVI9W48IV5QzRH9BszN7+QUd9tsyvKG6xReVYlU0zGwbdW/MffJo+
 fSPoC9GoKOdBtFP8pfvuHgH5OMdO30u4ebP17gw+2LedPGurj2MWSObwDLfyKqbr7vm8aKfnMA
 jaT+IjlR4ORkWUBUXfvTl1BKZZe8iXKEV/gISdGsNp6EfwwK4kcDpxIOgTgxuYqXnMyAkTmy5y
 nhI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Sep 2022 01:27:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MPmFp6mHwz1RvTp
        for <fio@vger.kernel.org>; Sat, 10 Sep 2022 01:27:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1662798478; x=1665390479; bh=j1fYJ1u2xK8HmzOx+0xPv0Da0KhWb3RqS+k
        nl0TyBE4=; b=ddQe8/FSD9JDV8nYCyWxCsU2QAberz1XjCEY+kxf0l7NhXuxsXB
        0ZGvtKTNUGRf9YKzx4aSs0dRkTtr+fyNYbS81YXxYrkeWBWodILnwo2RiodpkrIu
        neMmrEa7si/ItqOQKvS8uxRhVVrmj1cYczhCaDbSEFG5xhdsngNfsy9PG9HdFHpX
        FhA8is6GVf2tZfyxDuq672W9Iujnlsyq23MKHjsCx2t1k3xFyhWJBl6FoVIxeA+g
        mehDDXOkuonRHeE4K5VvAQZpoVVZuMrXwsh1Js3pGNtorvGXcLALX1cHuhJjOFBn
        bjEZMLClvyeNG/w3cKSAUFq6ReWOYbCRQ2Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AiWUgohoaEgj for <fio@vger.kernel.org>;
        Sat, 10 Sep 2022 01:27:58 -0700 (PDT)
Received: from [10.225.1.43] (unknown [10.225.1.43])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MPmFp0CK8z1RvLy;
        Sat, 10 Sep 2022 01:27:57 -0700 (PDT)
Message-ID: <022e132e-f051-28af-f85c-c2700b9ba992@opensource.wdc.com>
Date:   Sat, 10 Sep 2022 17:27:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.1
Subject: Re: Best practices for handling drive failures during a run?
Content-Language: en-US
To:     Nick Neumann <nick@pcpartpicker.com>
Cc:     fio@vger.kernel.org
References: <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
 <a48796d8-5d66-a39c-caf0-9b83a47664ab@opensource.wdc.com>
 <CADqNVTqQLuC6fXsBg6AnCgFWaNiDX=vjOhHvAskm_EP_vD-Q_Q@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CADqNVTqQLuC6fXsBg6AnCgFWaNiDX=vjOhHvAskm_EP_vD-Q_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2022/09/09 1:24, Nick Neumann wrote:
> On Wed, Sep 7, 2022 at 4:01 PM Damien Le Moal
> <damien.lemoal@opensource.wdc.com> wrote:
> 
>> Unless you are using continue_on_error=io (or "all"), fio will stop if it
>> sees an IO error, or at least the job that gets the IO error will stop.
>> The IO error will come from the kernel when your drive stops responding
>> (IO timeout and is failed and the drive is reset in that case).
> 
> Thanks for this info.
> 
>> Which behavior ? That fio stops ? You can try continue_on_error=none and
>> fio will not stop until it reaches the time or size limit, even if some
>> IOs fail.
> 
> I would like fio to fail and exit when the I/O error happens. I was
> wondering about a way to setup a scenario where an artificial IO error
> will occur to make sure it does, if that makes sense.

You can use write-long, to "destroy" sectors: you will get errors when
attempting to read the affected sectors. But that is a really big hammer. A
simpler solution is to use dm-flakey to create "soft" IO errors.

> 
>> The default IO timeout for the kernel is 30s. If your drive stops
>> responding for more than that, IOs will be aborted and failed (the user
>> sees an error) and drive reset.
> 
> Hmm. I had 65 seconds between any I/O; it sounds like that would've
> been enough to fail things, but fio returned immediately after that 65
> second delayed I/O, and with no error.

The IO was likely retried.

> 
> I also found the drive timeout error in syslog:
> Sep  7 12:37:43 localhost kernel: [ 4354.600211] nvme nvme0: I/O 870
> QID 4 timeout, aborting
> Sep  7 12:37:43 localhost kernel: [ 4354.615429] nvme nvme0: Abort status: 0x0
> Sep  7 12:38:15 localhost kernel: [ 4386.600297] nvme nvme0: I/O 870
> QID 4 timeout, reset controller
> Sep  7 12:38:17 localhost kernel: [ 4388.050831] nvme nvme0: 7/0/0
> default/read/poll queues
> Sep  7 12:38:18 localhost kernel: [ 4389.437287]  nvme0n1: AHDI p1 p2 p4
> Sep  7 12:38:18 localhost kernel: [ 4389.437347] nvme0n1: p2 start
> 2240010287 is beyond EOD, truncated
> Sep  7 12:38:18 localhost kernel: [ 4389.437350] nvme0n1: p4 start
> 2472081425 is beyond EOD, truncated
> 
> Combining the fio and syslog, the chain of events appears to be:
> 4332 seconds - drive IO stops
> 4353 seconds - syslog entry for timeout/abort
> 4386 seconds - syslog entry for timeout/reset
> 4387 seconds - read completes and fio exits without error
> 
> Thanks,
> Nick

-- 
Damien Le Moal
Western Digital Research

