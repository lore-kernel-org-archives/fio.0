Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF3DC43217
	for <fio@archiver.kernel.org>; Mon, 28 Nov 2022 23:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbiK1XOX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 28 Nov 2022 18:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiK1XOW (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 28 Nov 2022 18:14:22 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8F22EF7A
        for <fio@vger.kernel.org>; Mon, 28 Nov 2022 15:14:17 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id z1so8533690qkl.9
        for <fio@vger.kernel.org>; Mon, 28 Nov 2022 15:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8xvhvqk2Z+Hh/m25omwfEDN4zJ2x2NbwwJ1H8Syy8hc=;
        b=j5BQGKmrSVWrqvRkuuGRq2Q/svk+bLFxDvGotrr0Nw+XvSg/Ri9Q/DDiWAGyI5pAIa
         yR5tgIDzPP5yodLXQNphZnlyJzfE1m2hxNQ8Gn7yONgFMrsMEe/Mv7rm1np4M5L3VPV/
         S/hExpsZxQDcbH7Y9oPwmDy1Jy9vWlxQbI1kiC35EsxypvyoDqIXB71yh0H542BqZ74+
         hAiU19PDL9ZgMvrCjjnMsvUjFYF2ky2sZ/J71z34rFl75Yl8EI2slbiMg5At0laHDB4o
         I4Q9pvkkY7aLTSqk6i6IFPrfIWhTEukvLfGqjLIe3YD38Wj4nXPDZRBWXqJNdqoqYOY7
         pqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8xvhvqk2Z+Hh/m25omwfEDN4zJ2x2NbwwJ1H8Syy8hc=;
        b=yT5V7pWdhKdSEHWArG2U/CNL9M4Y+lxLrlHzUqr17P/IiZw8bUaOcAp7TTwY+hGscg
         ti0BoJDWiiUZXnvT7u/RMpTyfkCv2GD+fcKMYU/ASDv3y8op9zkz+xlJVE88X9fHrke8
         LIoX/tW9ViyP4eicpblVJ2s3FQQa1Fnw/SMVauVUpSv55f3Zea7E4Qts3i+BqohmKkkD
         VEZYjjpfmMmEyiWLN62b3CYH7ji+Nhk/sq+2T4zn7uwm8iuNrTOV3HOc2LHiRfSsQKPh
         LXY9kOZ8wSH2MmCx5ICrHFFgqlWyrIJMr5NWsY1CCMURBOv2jQLXyesndOfpf1xDSRDL
         oOOg==
X-Gm-Message-State: ANoB5pmRabGZmdKP79phN0VDfRbNjnje1alKRE1BcEi4zZsy6rCP/r3p
        AfitALYfriI1EgmSWJh3zio=
X-Google-Smtp-Source: AA0mqf4dB2fn/dXXhUufLB6yo9EBZ4EyfkLsXw5awRRw5UvyelqRmv0qtKYN3+Fe+JRgU3kh71744w==
X-Received: by 2002:a05:620a:66e:b0:6cb:c12c:9759 with SMTP id a14-20020a05620a066e00b006cbc12c9759mr33490441qkh.214.1669677256169;
        Mon, 28 Nov 2022 15:14:16 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id ay7-20020a05620a178700b006fb0e638f12sm9356156qkb.4.2022.11.28.15.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 15:14:15 -0800 (PST)
Message-ID: <d5a22217-235e-5686-6348-55f7687820e3@gmail.com>
Date:   Mon, 28 Nov 2022 18:14:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: Bssplit verify problem
Content-Language: en-US
To:     =?UTF-8?B?5piO56m65oG2?= <artlers@gmail.com>, fio@vger.kernel.org
References: <CAHDEAQNY9H5YZeQTBL+kU87qTtBxeEW2A15NdRvVNch9sDK7Jg@mail.gmail.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAHDEAQNY9H5YZeQTBL+kU87qTtBxeEW2A15NdRvVNch9sDK7Jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 11/12/22 01:33, 明空恶 wrote:
 > Hi,
 >
 > I use fio 3.19 to test NvmeSSD，cmd string is：
 > 
--------------------------------------------------------------------------------
 > fio --filename=/dev/nvme0n1 --rw=randwrite --offset=0 --size=10%
 > --bs=128k --iodepth=64 --numjobs=1 --ioengine=libaio
 > --name=randwrite_data --allow_file_create=0 --thread --direct=1
 > --group_reporting=1 --verify_dump=1 --verify_backlog=1 --randrepeat=0
 > --do_verify=1 --verify=pattern --verify_pattern=0x51d4b0e0
 > --bssplit=512:4k:16k:32k:64k:128k:1024k
 > 
--------------------------------------------------------------------------------
 >
<snip>

I ran your job (dropping --bs=128k because you have --bssplit) using the 
current tip of fio (3.33-33-g01fd) and saw no errors.

Vincent
