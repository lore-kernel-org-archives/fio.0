Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79578C54EE9
	for <fio@archiver.kernel.org>; Wed,  7 Sep 2022 21:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiIGVBN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Sep 2022 17:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiIGVBM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Sep 2022 17:01:12 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCC37A75F
        for <fio@vger.kernel.org>; Wed,  7 Sep 2022 14:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1662584471; x=1694120471;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=sJhpUS/a42Ea85dXyYCHYtCciqaJwHF8/7w+JLAGxOQ=;
  b=H1YkReWyefkjmLrRbTeQTjDE+Ig2784T50xfBbzqH0bh8gcZtiuINWui
   Nuk/nEmKUL2eyEI75ARyS8b0KOkFNOqeS3DpY0qyXmGE8hln5+uuH485x
   a25ZxjtfiyFCM6A0f6mraVBLscbxbJa9KU5pEkU/tyucdOn/Q5qm3GsmQ
   IAygaashw9cxnT46J+UEUkTKy6PTvNeUo7KCqCW+8qAIylePRUqTqpqvd
   MdGDBsNvK2vLl4xjMOf+/SfBctXElIY1XIiNpBLQwiOCDwXWagJhGTE6J
   7MqRdZmDwbrcyFESmZ4gMakfRC5f4jCtO1s52G9CPcCgbkpy60/rk9/Vf
   A==;
X-IronPort-AV: E=Sophos;i="5.93,297,1654531200"; 
   d="scan'208";a="210772855"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Sep 2022 05:01:10 +0800
IronPort-SDR: oay/LT/+E2rdAAJfPy/LM0rAVvx+37om+GFw8SGqR603LqbCxnKaKR+nZcxV9F4dz3ygJwL/HQ
 COrUQTJdz20xytVx1peclV/N0LbccSwT/7CVrQPVxXim+NVyaqCeFAF9/BiINqxI19HrLVdXxQ
 6dgfl+7UBgQyhIp1egxbLCdZG9nevltIGIXj7Pnl7HSQ2SSTkSzFeXaUTR2G4iHFHUyN7adeKs
 TWBnsQItNCLqA4sSwTVb8xmCGWNOFClrkCikAP4gJ2IwrKcpEcYU2FgWza8TCd0RWPZM7frKnH
 H2d89J2VTNhTV/cQJFr5d7lD
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2022 13:21:31 -0700
IronPort-SDR: N79Z1Cr76gBBGdhWQKGiXM/tLH3xJ7I/E8s8aZivmM/uHRicXB7iIVcV+rxUhpS4ySMQ20Yux4
 H799mFML32cC7Ug1Q9ODfyxlxchOgrYo+2elSjThqU57eotjTGr8kzdGwc3oVpV9QgiLPuMt/z
 0esk4MsA3/vo9xTgW6u6VuGRoT+anodscwjPmwws+idaEpiurra0B037m9BWTXnADyhS21SzhZ
 8zvU8K39No9zd5NJq7s4d/ijNHzfV2LnqJYCqq5lAqDU3LYexT1o1jx+qb8OY9DLop38LockTu
 7Y4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2022 14:01:12 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MNF6G3h24z1RvTr
        for <fio@vger.kernel.org>; Wed,  7 Sep 2022 14:01:10 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1662584470; x=1665176471; bh=sJhpUS/a42Ea85dXyYCHYtCciqaJwHF8/7w
        +JLAGxOQ=; b=fAcoDLDagiJVvtWXg6kslmZ23BLCc1/XSBK8kq3ROsxTZ4flXrs
        +Qjtiawk3yeLHuO93A3NkSwww3pharxfhjoOtAYUjlMcgtkEB3ndMNbAy+SGCYRt
        9u4jlZtiQRE4qAz+/BsUXlEK7nMYx48s3Il+zXYrKkkzdtgMS+RdSr+7Vx4dSTDa
        uumOK0Iz4un+kthta4hzyZHHfZ0LMSom/p+/OWySQG8r0kVbddw0nGtzVBvVrLmr
        4I7BAWGJ1Jy5bukSPTgiNWz+YGzwD6gaNdzieJsg5TNB2d2b4ldXCF80k5FbQsxO
        meK+z9FcMxy3wKVAooqDA85BeOIW6LyV1Eg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ImqdbU-knTBX for <fio@vger.kernel.org>;
        Wed,  7 Sep 2022 14:01:10 -0700 (PDT)
Received: from [10.225.163.64] (unknown [10.225.163.64])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MNF6F5CmBz1RvLy;
        Wed,  7 Sep 2022 14:01:09 -0700 (PDT)
Message-ID: <a48796d8-5d66-a39c-caf0-9b83a47664ab@opensource.wdc.com>
Date:   Thu, 8 Sep 2022 06:01:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: Best practices for handling drive failures during a run?
Content-Language: en-US
To:     Nick Neumann <nick@pcpartpicker.com>, fio@vger.kernel.org
References: <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/8/22 00:58, Nick Neumann wrote:
> I was wondering if there were any recommendations/suggestions on
> handling drive failures during a fio run. I hit one yesterday with a
> 60 second mixed use test on an SSD. 51 seconds in, the drive basically
> stopped responding. (A separate program that periodically calls
> smartctl to get drive state also showed something was up, as data like
> temperature was missing.)
> 
> At 107 seconds, a read completed, and fio exited.
> 
> It made me wonder what would have happened if the test was not time
> limited - e.g., a full drive write. Would it have just hung, waiting
> forever? Or would the OS eventually get back to fio and tell it the
> submitted operations have failed and fio would exit?

Unless you are using continue_on_error=io (or "all"), fio will stop if it
sees an IO error, or at least the job that gets the IO error will stop.
The IO error will come from the kernel when your drive stops responding
(IO timeout and is failed and the drive is reset in that case).

> 
> Any ideas on ways to test the behavior, or areas of the code to look at?

Which behavior ? That fio stops ? You can try continue_on_error=none and
fio will not stop until it reaches the time or size limit, even if some
IOs fail.

> 
> I'm basically looking for input on how to make sure fio does not hang
> in such situations. And even better would be if I could get fio to
> return an error if it does happen - I could see the controls for
> reporting error being configurable - e.g., if an operation doesn't
> return for N seconds, stop the job and return an error. I'm happy to
> work on implementing stuff to help with this, and wanted to see where
> things currently are at and what others thought about the general
> issue.

The default IO timeout for the kernel is 30s. If your drive stops
responding for more than that, IOs will be aborted and failed (the user
sees an error) and drive reset.

> 
> Thanks,
> Nick

-- 
Damien Le Moal
Western Digital Research

