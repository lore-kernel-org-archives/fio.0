Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274DCC7EE23
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 19:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbjFHTKS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 15:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjFHTKR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 15:10:17 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8A32D4B
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 12:10:13 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-33db1ad228aso451675ab.1
        for <fio@vger.kernel.org>; Thu, 08 Jun 2023 12:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686251413; x=1688843413;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+FAXLHcGbhcUBG90bhwgeomTCKxiFYFbgaIsVxE1RZw=;
        b=3TO9punOCw4b2EV6ICrjHWJUze4Ie4VPvOa45vl9R//tzHhEgsgEcPDDxZmNslxzAC
         pUEGbsZhmckF2PODsW+T0cePeWTX34coG4kc6NC2uTktCKdvKZU480n3UPZ9woqYCY02
         4IpEt1xv2aCGboFb2vmZuZ/SQ37QGQC5c+R9fPpn2UzeqausyQcnPrt0o70PzW9c+I7b
         ntoiFLzQfz6a1I/JjAQ1pLxWuZoh3ymnltluVS5NiL0/MaMtUWfRMPQ4uKERLQLnMrA2
         RpHW55iUKLSi+QJxXoY0gaMB36RP386OHRGCtVc93adEQ+h31K2Vt0/MoL+TkEWXCMBo
         3DMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686251413; x=1688843413;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+FAXLHcGbhcUBG90bhwgeomTCKxiFYFbgaIsVxE1RZw=;
        b=CffWUS8yPu/7Y06F5qOrvUywCSY//3rKTBFWYUQPxdj6DgjmSGTDOGUyF5LYIhlcDo
         XClgOWi8KhgOaJL34ynvM0hXo6eqXiGmSWORLOjYcPZhpKRy8cUjzsuSY0Z+a+NNk99h
         NdobQ+T4jYZkVXfdLTTSLXyB9+lgGTAr/voKK1yEDJherQYYv3ui19umFYQ/r56BIG+k
         ZKXebzjqIkPbssX/C8UoLdK2xuLasYGx/jSZJBkBnc2N+Y+p470qhel4ldLBUzVvA8oO
         KKmzQHeI35Jz03LNEJyf8WF+eydwzf49In1+FcfeuJccGuriJwHA5r+uFr1sz4z+aP/k
         DzDw==
X-Gm-Message-State: AC+VfDwf6465WJuWboAEio803r3P+xyX8b779eWATARuVDs0aWVFF2G1
        0F/je+e7kgejOOyXjD0tMsMIew==
X-Google-Smtp-Source: ACHHUZ58vQr5MjZVT24b4uQ0hLo9fQkCcOdqWgSfMrvCZQeH6ERL6HMXInCJKmK3ZtCRmrCxkvPdrQ==
X-Received: by 2002:a92:d8c1:0:b0:33b:e24b:ca46 with SMTP id l1-20020a92d8c1000000b0033be24bca46mr3304724ilo.3.1686251412962;
        Thu, 08 Jun 2023 12:10:12 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n17-20020a92d9d1000000b00325e56c1cdcsm580723ilq.49.2023.06.08.12.10.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 12:10:12 -0700 (PDT)
Message-ID: <c89d540c-cfb6-2830-6e3f-d16d2d577bd1@kernel.dk>
Date:   Thu, 8 Jun 2023 13:10:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 0/7] zbd: clean up code and fix bugs for open zones
 accounting
Content-Language: en-US
To:     Vincent Fu <vincentfu@gmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
 <be2ca491-c88d-0db9-f7d4-ecf71d485845@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <be2ca491-c88d-0db9-f7d4-ecf71d485845@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 6/8/23 12:45 PM, Vincent Fu wrote:
> On 6/8/23 03:06, Shin'ichiro Kawasaki wrote:
>> Fio with zonemode=zbd does accounting of 'open zones'. However, the meaning of
>> 'open zone' is confusing because its definition is similar but different
>> between fio and zoned block devices. The first patch in this series avoids the
>> confusion by renaming the word 'open zone' to 'write zone'.
>>
>> Also, recently three bugs were found related to the open zones accounting.
>> Following three patches fix the bugs. The last three patches improve test cases
>> corresponding to the fixes.
>>
>> Changes from v1:
>> * Reflected review comments on the 4th patch
>> * Added Reviewed-by tags
>>
>> Shin'ichiro Kawasaki (7):
>>    zbd: rename 'open zones' to 'write zones'
>>    zbd: do not reset extra zones in open conditions
>>    zbd: fix write zone accounting of almost full zones
>>    zbd: fix write zone accounting of trim workload
>>    t/zbd: reset zones before tests with max_open_zones option
>>    t/zbd: test write zone accounting of almost full zones
>>    t/zbd: test write zone accounting of trim workload
>>
>>   engines/io_uring.c     |   2 +-
>>   fio.h                  |   2 +-
>>   io_u.c                 |   2 +-
>>   io_u.h                 |   2 +-
>>   options.c              |   4 +-
>>   t/zbd/test-zbd-support |  64 ++++++++-
>>   zbd.c                  | 292 ++++++++++++++++++++++++-----------------
>>   zbd.h                  |  25 ++--
>>   zbd_types.h            |   2 +-
>>   9 files changed, 248 insertions(+), 147 deletions(-)
>>
> 
> Applied. Thanks.
> 
> Vincent

Vincent gets these too, but pasting it here for Shin'ichiro:

Please find the latest report on new defect(s) introduced to axboe/fio found with Coverity Scan.

1 new defect(s) introduced to axboe/fio found with Coverity Scan.
1 defect(s), reported by Coverity Scan earlier, were marked fixed in the recent build analyzed by Coverity Scan.

New defect(s) Reported-by: Coverity Scan
Showing 1 of 1 defect(s)


** CID 462265:    (ATOMICITY)
/zbd.c: 1554 in zbd_convert_to_write_zone()
/zbd.c: 1554 in zbd_convert_to_write_zone()


________________________________________________________________________________________________________
*** CID 462265:    (ATOMICITY)
/zbd.c: 1554 in zbd_convert_to_write_zone()
1548     		       "%s(%s): wait zone write and retry write target zone selection\n",
1549     		       __func__, f->file_name);
1550     		pthread_mutex_unlock(&zbdi->mutex);
1551     		zone_unlock(z);
1552     		io_u_quiesce(td);
1553     		zone_lock(td, f, z);
>>>     CID 462265:    (ATOMICITY)
>>>     Using an unreliable value of "in_flight" inside the second locked section. If the data that "in_flight" depends on was changed by another thread, this use might be incorrect.
1554     		should_retry = in_flight;
1555     		goto retry;
1556     	}
1557     
1558     	pthread_mutex_unlock(&zbdi->mutex);
1559     
/zbd.c: 1554 in zbd_convert_to_write_zone()
1548     		       "%s(%s): wait zone write and retry write target zone selection\n",
1549     		       __func__, f->file_name);
1550     		pthread_mutex_unlock(&zbdi->mutex);
1551     		zone_unlock(z);
1552     		io_u_quiesce(td);
1553     		zone_lock(td, f, z);
>>>     CID 462265:    (ATOMICITY)
>>>     Using an unreliable value of "in_flight" inside the second locked section. If the data that "in_flight" depends on was changed by another thread, this use might be incorrect.
1554     		should_retry = in_flight;
1555     		goto retry;
1556     	}
1557     
1558     	pthread_mutex_unlock(&zbdi->mutex);
1559     

-- 
Jens Axboe


