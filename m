Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C04EB64DD
	for <fio@archiver.kernel.org>; Thu, 20 Jul 2023 14:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjGTOuT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Jul 2023 10:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjGTOuO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Jul 2023 10:50:14 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E6D26B0
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 07:50:10 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-765ae938b1bso82286285a.0
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 07:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689864609; x=1690469409;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SCxkIA6RMc0NgbP7AIqO5NVagoc8offtDAkpuHGZPBA=;
        b=Z3GkTD9Yk2TKsgmRn/RCutpUp3wdZetJZ31f0Hy2YSbNbWCV+8d2juwU6Zix5qhS2r
         GRndVPzc0MGA+EvbZowPRXO2f6vCIGcI2GSuPLBCEBvwH7cBpvjhWVxi3YTop8vqTV9E
         J9gdktEWG4NqpV7/PLWp+tYLl1vRcRyY08MiDnJtF1OCs9qPNhmNz1RBwAZXXpA7vPeO
         utFoqF1ER05C9qxfbK1hWe+GglY8TKVng0afcdDtwNorJVStBPYRBKUJu4YqY4oOtU20
         3ZxOE4ltG0WHOm34gAw6jr+m+TuhRR0yPzPvolQ30H69YshPJ2N9dchxoRIR2XoPkT4X
         DRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689864609; x=1690469409;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SCxkIA6RMc0NgbP7AIqO5NVagoc8offtDAkpuHGZPBA=;
        b=OC+3uEwnHTSZV72iQzH7hCIeZ7UTEb/zlijeMk5ZmAra751JYcJ9RKut8e0ZEuQrZ1
         vEXNcDfqqTYZoIDkMvDNeIagCkQwlIeihnSWh7wodRTtcVRlxG/N9wBXDS2xXhxz/ab6
         7kqz7cN927E1hx7uK0T7gJmg/jirrFTdOXCmacdht/FPeU3NmL5ubRMJxHJ3k1l6goMY
         7G9Ml5i2aG1dbR1jkYqqpcFjfksxwkU2BG5JgQ+/UNg095qtmcWwArEJvM3kLxjDYeGz
         t0SoEGs4pAnk9AjejYxx8yRKAzmGXfc702n7POihYkzO6qAyDfDx4Hatm/kmM2zKLEQj
         kz/A==
X-Gm-Message-State: ABy/qLZWsVPij/HU4NhZOeXqEDO+eGXmeRmB7iYjaBPHx48tHAaUmY0Y
        GMAvbtJKmSmlWGSRjGSmgXI=
X-Google-Smtp-Source: APBJJlEhpDIyw18CosmYwlJlRYPgYjB+BPEB0epetJoWkiWt/IfK3POJ0CE1lZMlAA6ZZLVuLBNNag==
X-Received: by 2002:a05:620a:444e:b0:767:e01a:14cd with SMTP id w14-20020a05620a444e00b00767e01a14cdmr3934712qkp.3.1689864609365;
        Thu, 20 Jul 2023 07:50:09 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id o7-20020a05620a15c700b00767cd2dbd82sm326485qkm.15.2023.07.20.07.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 07:50:08 -0700 (PDT)
Message-ID: <85f9a8f9-c5b2-9289-da9a-8b606204fd5f@gmail.com>
Date:   Thu, 20 Jul 2023 10:50:08 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 00/13] zbd: improve max_active_zones limit handling
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230719105756.553146-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/19/23 06:57, Shin'ichiro Kawasaki wrote:
> Current fio implementation for zonemode=zbd has two problems for zoned
> block devices with max_active_zones. The first problem is max_active_zones
> limit error. When some of write target zones are in closed condition at fio
> start, writes to other zones causes the max_active_zones limit error. The
> second problem is a confusing error message. When number of active zones goes
> beyond the max_active_zones limit, fio prints unrelated error message and
> confuses users [1].
> 
> This series addresses the two problems. The first patch is a preparation to get
> the max_active_zones value from devices. The next two patches fix the two
> problems. The forth patch modifies man document of max_open_zones option to
> match with the fixes. Other nine patches improve test scripts for the fixes. Add
> test cases and test conditions to confirm the fixes. Also fix test script bugs
> found during this work.
> 
> [1] https://lore.kernel.org/fio/ZHShQdVGkyRfd6v0@x1-carbon/T/#m4ec7ff1575981e92517c0ea7f699e7df9aba087c
> 
> Changes from v1:
> * Reflected comments on the list and added Reviewed-by tags
> 
> Dmitry Fomichev (2):
>    t/zbd: fix null_blk configuration in run-tests-against-nullb
>    t/zbd: add max_active configs to run-tests-against-nullb
> 
> Shin'ichiro Kawasaki (11):
>    zbd: get max_active_zones limit value from zoned devices
>    zbd: write to closed zones on the devices with max_active_zones limit
>    zbd: print max_active_zones limit error message
>    docs: modify max_open_zones option description
>    t/zbd: add close_zone helper function
>    t/zbd: add max_active_zone variable
>    t/zbd: add test case to check zones in closed condition
>    t/zbd: add test case to check max_active_zones limit error message
>    t/zbd: get max_open_zones from sysfs
>    t/zbd: fix fio failure check and SG node failure in test case 31
>    t/zbd: add missing prep_write for test cases with write workloads
> 
>   HOWTO.rst                     |  44 +++++---
>   fio.1                         |  36 ++++--
>   io_u.c                        |   2 +
>   ioengines.h                   |   4 +-
>   oslib/blkzoned.h              |   9 ++
>   oslib/linux-blkzoned.c        |  23 ++++
>   t/zbd/functions               |  33 +++++-
>   t/zbd/run-tests-against-nullb | 203 ++++++++++++++++++++++++++++++++--
>   t/zbd/test-zbd-support        |  91 ++++++++++++++-
>   zbd.c                         |  47 +++++++-
>   zbd.h                         |   5 +
>   11 files changed, 457 insertions(+), 40 deletions(-)
> 

Applied. Thanks.

Vincent
