Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36313 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdAWNRz (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 08:17:55 -0500
Received: by mail-wm0-f44.google.com with SMTP id c85so132057986wmi.1
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 05:17:55 -0800 (PST)
Received: from [192.168.1.211] (ppp-212-114-239-131.dynamic.mnet-online.de. [212.114.239.131])
        by smtp.googlemail.com with ESMTPSA id x69sm7168650wma.15.2017.01.23.05.17.53
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Jan 2017 05:17:53 -0800 (PST)
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Subject: hitting 2048 threads/jobs limit
Message-ID: <71c37fa9-61da-c3dc-fdc1-67d254845b46@gmail.com>
Date: Mon, 23 Jan 2017 14:17:53 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

is there a way to increase the 2048 threads/jobs limit in FIO?

I am hitting a wall trying to saturate a storage on random 8kB reads .. 
can't get over 5 mio IOPS.

Please see the top most / right most IOPS value 4.597.700 in here:

https://github.com/oberstet/scratchbox/raw/master/cruncher/sql19/Performance%20Results%20-%20NVMe%20Scaling%20with%20IO%20Concurrency.pdf

The box has still more CPU cycles avail .. and the IOPS over IO 
concurrency seems to indicate there is more room ..

Cheers,
/Tobias

PS: thanks for an _awesome_ tool!
