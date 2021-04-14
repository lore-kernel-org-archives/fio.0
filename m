Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbhDNNjP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Apr 2021 09:39:15 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B7FC061574
        for <fio@vger.kernel.org>; Wed, 14 Apr 2021 06:38:53 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id 18so2009267qtz.6
        for <fio@vger.kernel.org>; Wed, 14 Apr 2021 06:38:53 -0700 (PDT)
Received: from Steves-iMac.local (cpe-172-74-104-12.nc.res.rr.com. [172.74.104.12])
        by smtp.googlemail.com with ESMTPSA id p10sm8522392qtl.17.2021.04.14.06.38.52
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 06:38:52 -0700 (PDT)
From: Steve King <stkissteve@gmail.com>
Subject: [QUESTION] Incorrect arguments for FIO job?
Message-ID: <68973b2a-c2a6-e1c0-5990-eb2599a585f1@gmail.com>
Date: Wed, 14 Apr 2021 09:38:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi folks - could use some help as I'm not a fio expert....

Short version is an external team is presenting results to me that I 
don't entirely believe. The resulting IOPS & Throughput for 'random 
read' and 'random write' are exactly the same, which makes no logical 
sense.  I'm concerned they have a problem with the arguments used in 
FIO; especially as I notice a typo.

Here is what's being run:
fio --randrepeat=1 --ioengine=libaio --direct=1 --sync=1 
  --name=fio-test --filename=random_50read_50write-.fio  --overwrite=1 
--iodepth=64 --size=1GB --readrite=randrw --rwmixread=50 --rwmixwrite=50 
--bs=16k --runtime=60 --time_based --ramp_time=15  --percentage_random=50

Note typo "readRite...."   But a lot of these arguments seem 
redundant.   Thanks!

