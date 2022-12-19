Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D05C4332F
	for <fio@archiver.kernel.org>; Mon, 19 Dec 2022 18:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiLSSJF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 19 Dec 2022 13:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiLSSJE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Dec 2022 13:09:04 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E08613CDE
        for <fio@vger.kernel.org>; Mon, 19 Dec 2022 10:09:01 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-40b40ff39f1so137739627b3.10
        for <fio@vger.kernel.org>; Mon, 19 Dec 2022 10:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7RgP1CwMw9xTYGT8jPQrA6YL6cjpKjAIQCoPLz0XGRg=;
        b=MvoACw9I+iitVl9acTtm80QeBZ248HGZNvfRII0Yk02gahZOvk3AcnDGielr+d6Eg7
         +uAtPfvyLVjx7dEtv7BEfENeuDtpdiU2t38u/5DDmVWOhQ9gV0P/JT3VJWy3XnqWyVCc
         4muylCaLvUUZkWx758n/sn1SZpy/BQVV2mcFBuwoQAumMwxDdgH/S0W2zOyQlYp8S1Dx
         UCJTc1KEc3TTdZLjJCU3xD4WtrnT54g9IkPoxk05m67EBFJbh2m1oCZ94SOFcEBrdfuU
         zzCwF1Q12zbDp8vhWXJpPiVKwa0bWs8iiuSIIr7kfLsUnhihpNTaZFQ2ebFUohFJZq9F
         awQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7RgP1CwMw9xTYGT8jPQrA6YL6cjpKjAIQCoPLz0XGRg=;
        b=poytHfEUN2VU+T4rI2/bdFXaN5z27UEaN+j3VG9Zep3gBFYwIJ2WAqEV2QPvouDIsh
         RJMot/0fyv/MsoAuKQcSJBbCRH/IDn/sEbLxUVX1lFXodsQyc4SQjZ972FfR27oPBgJN
         tuCNdOXwK7vZ5KzBWBxVFBWdrYTDDuojj+bdb0aX6oB6V5TbD8r4qC0VKIA56MBwskbq
         WC/hGKKmK5+vECozSBbt2P6BikxLB2MrftSZAfsAmvcNANTqyPWw4OZmihkWl253sFwY
         0e7D77EUOqVtwOMx09239NU3OucMgzU33hbtRc2QZEWgMBiZROnkyledy0BuDd5Ip19d
         Hiow==
X-Gm-Message-State: ANoB5pltuSZgDeXtPLZhaHnPReE0K4SoDVmQ5Kcbx59soiiIdn/OKXT1
        p6qOrGW9cr0fwErmzWnXeaae9Hq3y/I=
X-Google-Smtp-Source: AA0mqf5/R/mo9M3U/mkWaBPRq1n1zhno46ertB++dwURfdb8M0nAf25qv52794Toat+FBCh0mPL9JQ==
X-Received: by 2002:a05:7500:374b:b0:ea:a909:862 with SMTP id gx11-20020a057500374b00b000eaa9090862mr3576013gab.39.1671473340399;
        Mon, 19 Dec 2022 10:09:00 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id s21-20020a05620a0bd500b006ee8874f5fasm3299634qki.53.2022.12.19.10.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 10:08:59 -0800 (PST)
Message-ID: <6e314a31-a9e1-0cd0-8e0f-7821149184dd@gmail.com>
Date:   Mon, 19 Dec 2022 13:08:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] fio: Append "filecreate/filestat/filedelete" to
 'readwrite=' field
To:     "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
        fio <fio@vger.kernel.org>
Cc:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>
References: <HK0PR04MB238880EA157D090AF252654DFD179@HK0PR04MB2388.apcprd04.prod.outlook.com>
 <HK0PR04MB2388BE724C7A93EDC8FAEDC4FD179@HK0PR04MB2388.apcprd04.prod.outlook.com>
 <HK0PR04MB2388DB3551D724BB15BEA2B9FDE59@HK0PR04MB2388.apcprd04.prod.outlook.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <HK0PR04MB2388DB3551D724BB15BEA2B9FDE59@HK0PR04MB2388.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/19/22 00:50, Friendy.Su@sony.com wrote:
> How about Patch v2?
> 
> I plan to create more patches to correct IOPS, BW fields in log. With several steps of "not-big" modification, makes FIO fit for file operation measurement.
> 

As I wrote earlier, I am opposed to such large changes for a fairly 
narrow use case. There is always a risk of regressions with changes like 
these and in the absence of thorough automated testing for the code that 
is modified I am not willing to take these changes.

Consider adding something like Section 1.25 to 
https://fio.readthedocs.io/en/latest/ which would be a full description 
of the file operation ioengines listing their idiosyncrasies along with 
fully fleshed out examples.

Vincent
