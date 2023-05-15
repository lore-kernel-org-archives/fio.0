Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554FFC77B75
	for <fio@archiver.kernel.org>; Mon, 15 May 2023 12:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241970AbjEOMt6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 May 2023 08:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241439AbjEOMt5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 May 2023 08:49:57 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C748A6
        for <fio@vger.kernel.org>; Mon, 15 May 2023 05:49:57 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f52d303bcdso9368911cf.0
        for <fio@vger.kernel.org>; Mon, 15 May 2023 05:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684154996; x=1686746996;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iN0tKMkXrKxNk+ShdguMlHv/G20NMbbkQbmsGf6aUss=;
        b=WtK23k3Ieq52pMmLfPLIMmQn9ANyEvbSpGC6xA2uzy/8Gesxo8NoPZcIsd7iHRkp8J
         64bVaNxAzsSVGJfWQnM7hGcdU70/4nuwqt2DiEFh0QDVBc9shjriDvrfsM33QcLH0FST
         Jt0uRf8NWjsUcpsU1XZNgNfoermLH5uyaRADl8NQqquyvIcR0r3RnIpG4kOq8gN972IA
         3F2V9lUFm1gQ+/8Mi9NhUQR8rzO1lVdekaiYZkEpl3wLRDojFC9Hi7sL0Csm6uP5Pmvt
         e01VLVCAMXZCfqVAUPnnd1YXrsMB0Z4+LF3iUdyKnfQ3wWEPaE6rEKwwlSVfK/pMI9Zw
         CFMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684154996; x=1686746996;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iN0tKMkXrKxNk+ShdguMlHv/G20NMbbkQbmsGf6aUss=;
        b=ShYNSD//8LWuwsuZqd7sTRwXFCYzG/7T5sF3mwR0ZiOmuphRLx66AXIL2lV2Qs7kbJ
         TMFZvI4VsgCnLmC7IIrol2tKev3Xms+VwhypxA9A6ZWxdxYTNnBokSW22Yq+Z8+HXVHU
         DFmUP6C+peNhZnXEm2pHOcqxaNgIVENEZ4al66gLoMgvNE5ezea4ydH6YBGPwtHLxEwh
         IT0bySUXqKEvGCo85jNAmHBWkGNmLSxpU61uKKrokjteAJH5LNNDgc+DFvAAZmefE+vx
         byTyzziKfDKN2rMoz2xtj5LJKgkfQiz4viTrhX7N3jLuRrNK2kM+m0ON8tWe0S+iD9KY
         iEag==
X-Gm-Message-State: AC+VfDzHhBFQUKp8IzJkE3wQM+Gvm2cJgjRqrb7Ge0RV5UzK73lUUk86
        NAMxSHLK1ax8U6tvdcBOqA8=
X-Google-Smtp-Source: ACHHUZ4JYR+D9l8jOF4vVqZQNK9OB2cQQb9dD/agxscQSZYj2q50GAElFOaO5MMCW5eoHsmA78TmyA==
X-Received: by 2002:ac8:7c4d:0:b0:3f2:384:9292 with SMTP id o13-20020ac87c4d000000b003f203849292mr51349502qtv.34.1684154995959;
        Mon, 15 May 2023 05:49:55 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id t1-20020a05620a034100b0075954005b46sm333296qkm.48.2023.05.15.05.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 05:49:55 -0700 (PDT)
Message-ID: <b2cb9f09-0475-6722-ea89-6b7fa12a4bf2@gmail.com>
Date:   Mon, 15 May 2023 08:49:54 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 0/2] io_uring_cmd cleanup and fixes
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, joshi.k@samsung.com
References: <CGME20230515054350epcas5p4643d68a6f79cae867b88be678154329b@epcas5p4.samsung.com>
 <20230515110340.21984-1-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230515110340.21984-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 5/15/23 07:03, Ankit Kumar wrote:
> The NVM command set specification 1.0c supports 64 LBA formats.
> The first patch adds support for that.
> 
> The io_uring_cmd ioengine assumes that logical block size is always
> power of 2. But with namespace formats where metadata is transferred
> at the end of logical block i.e. an extended logical block this is
> not true.
> This second patch adds the support for extended logical block sizes.
> This however doesn't include support for protection info and metadata
> transferred as separate buffer, we return error for those.
> 
> Changes from v1:
> * Split the original patch into 2 as suggested by Vincent and Jens
> * Address all review comments from Vincent
> 
> Ankit Kumar (2):
>    engines/nvme: support for 64 LBA formats
>    engines/io_uring: io_uring_cmd engine fixes
> 
>   engines/io_uring.c | 30 ++++++++++++++++++---
>   engines/nvme.c     | 66 ++++++++++++++++++++++++++++++++++++++--------
>   engines/nvme.h     |  6 ++---
>   3 files changed, 84 insertions(+), 18 deletions(-)
> 

Applied with a change to the title of the second patch's commit message. 
Thanks.

Vincent
