Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84041C4332F
	for <fio@archiver.kernel.org>; Tue, 29 Nov 2022 17:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiK2RmE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 29 Nov 2022 12:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiK2RmD (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 29 Nov 2022 12:42:03 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC044A9FA
        for <fio@vger.kernel.org>; Tue, 29 Nov 2022 09:42:01 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id x18so10342428qki.4
        for <fio@vger.kernel.org>; Tue, 29 Nov 2022 09:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CWq0gdYBuD3LG8CM2aYV5fBGOgBHT0ri4XEtmIj63rk=;
        b=LlBOWOUgeQEeyTcKQgPnjMTnQ+dVM4otRYY16NJzX+mB6GZFEhdH0MrepZpAjyeRcD
         BY+lr2wSqL4hISXS2uVn1LhuGQpMXNkPRM/WhAXoM1dEWYAjWo/BRzSVRBojMGWRV8jI
         72YeyWALJWjjPt2GeoFVGuQ07e4w3hQKweYtV/gOdsdSwJGi5Pr4GNBc31T2Zeusj2ha
         gM0C7J9tFGP397qKs51u9Zk22KVsbZqv9gAGgKdxaJ4VX582k6z9R6jny25unSyAHaiy
         H7zEDUsuXOjiLKE8jCbClJzqEpxdeYDoMJyd6ckyRf4Suqmpx1wjkP3Q8hS7T+pLvHC5
         ni7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CWq0gdYBuD3LG8CM2aYV5fBGOgBHT0ri4XEtmIj63rk=;
        b=xLdCzDRScVKZtM4yJCZGsEJpbPCQEIQ2lWczpYqbF4jGz0Ma6LswMfegQh13gVEBSO
         6bN6Fl/MhvcdkEL55nd15rm36MRBwomm17jALJ9oRB1VjKikMMe2swILg+8lvy7YV2Gu
         zb5TuJN58g+CXOxV2Kl4AvxFrDzXG2SXHnJj++mw5N6uQcvzMXZ8nImynE7lRuvFnZTC
         W4MuqBdNyo3RquizycSj/aT/HdUCm/OEaRFb+qzrdAmrzte4B6uEuXBxNzcm29+HGU5j
         hsWPjte++uj09s+XQTCgX3PUzcQOaSpBJzxrFglK3qgNiVAAmuMzKx76Mdo+9Q+XnoVu
         vI/A==
X-Gm-Message-State: ANoB5plEiIP1WHeDN8TdXm/rBlkFJrMBeydmjZbEIQIVP7ZkLFkcjg7F
        BD87jZga2g5pOLByMIee8v8=
X-Google-Smtp-Source: AA0mqf4Re/qawdVma+qPE5MnRBE8TpYMNqRQWrhikvanbPmazeHBz4XRwBEmkaF9JFXOFBkbPvpJ5A==
X-Received: by 2002:a37:8a45:0:b0:6f9:fd7a:f300 with SMTP id m66-20020a378a45000000b006f9fd7af300mr35393908qkd.257.1669743720787;
        Tue, 29 Nov 2022 09:42:00 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bj12-20020a05620a190c00b006cfc1d827cbsm11037618qkb.9.2022.11.29.09.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 09:42:00 -0800 (PST)
Message-ID: <9efdea12-679d-d8f8-b240-c21100adbc10@gmail.com>
Date:   Tue, 29 Nov 2022 12:41:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1] fio: Append "filecreate/filestat/filedelete" to
 'readwrite='
Content-Language: en-US
To:     "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
        fio <fio@vger.kernel.org>
Cc:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>,
        "Kento.A.Kobayashi@sony.com" <Kento.A.Kobayashi@sony.com>
References: <HK0PR04MB23884FFF415F7EFCB424CABEFD049@HK0PR04MB2388.apcprd04.prod.outlook.com>
 <7c4b684c-03e8-9f33-3809-443ac7678a07@gmail.com>
 <HK0PR04MB23882A7010C577D1EA34FB57FD0A9@HK0PR04MB2388.apcprd04.prod.outlook.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <HK0PR04MB23882A7010C577D1EA34FB57FD0A9@HK0PR04MB2388.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/21/22 05:36, Friendy.Su@sony.com wrote:
>> I think having this option will be confusing and lead to users trying to
>> run a job with --ioengine=psync --rw=filecreate.
> 
>> However, I understand the confusion that arises when the file operation
>> ioengines are used. Might there be some other way to help? Perhaps the
>> ioengine could emit some sort of message? Or the documentation for the
>> file operation ioengines could be enhanced?
> 
> I created this patch because somebody sent me email to ask why rw string shows 'read' when he measured by filecreate engine. And more, users felt strange what does IOPS/BW for file operation mean?
> I think we can do option check at beginning. '--ioengine=filecreate' and '--rw=filecreate' must be paired. If not paired, emit error message and exit. How do you think?
> 
> Though FIO is designed for IO measurement originally, file operation performance is also regularly evaluated for file system. It is helpful if expand FIO to adapt to file operation benchmark.
> 
> Friendy
> 

I think the better solution is to augment the documentation with a 
detailed discussion of the file operation ioengines because they work so 
differently from other fio ioengines.

Because of how unusual these ioengines are, there are many ways the 
ioengines can be misused and their results misinterpreted. Making a 
change like this reduces the possible confusion by only a small amount. 
Having a detailed guide to these ioengines in the documentation will 
more comprehensively reduce confusion and misuse of these ioengines.

Vincent


