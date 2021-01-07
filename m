Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr150134.outbound.protection.outlook.com ([40.107.15.134]:47878
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727451AbhAGXH7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Jan 2021 18:07:59 -0500
From: Erwan Velu <e.velu@criteo.com>
Subject: Adding a new cpu mode for the cpu engine
Message-ID: <3c818fe5-5d53-43d5-c949-89268172d266@criteo.com>
Date: Fri, 8 Jan 2021 00:07:03 +0100
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hey list,
I've been sending a pull request to improve the cpu engine 
:https://github.com/axboe/fio/pull/1161 
<https://github.com/axboe/fio/pull/1161>

fio is featuring a cpu engine which makes noop to load the cpu cores.
This makes the core busy but doesn't really consume energy and doesn't 
generate heat.

When benchmarking systems, it could be useful putting the processor 
under a realistic load to see how the whole system behave.
The idea is to get a more realistic cpu workload generator so IO 
benchmarks can be done under a defined cpu load.

This commit adds cpumode option into the cpuio engine.
By default, cpumode=noop to keep the current behavior.


If cpumode is set to qsort, fio will use a qsort algorithm instead of 
the noop instructions to load the processor.

This mode will consume more cpu power and will be useful to increase the 
pressure on the thermal and electrical components.

The expected cpu load is selected as per noop via the cpuload option.
qsort() consumes a lot of energy so the duration of every loop will vary 
over time as the power management & cpu clock changes.

To ensure a proper calibration, the thinktime is adjusted after every 
qsort() computation to be as precise as possible.


To give an order of magnitude, on an AMD 7502P (TDP=180W) :
cpuload=30, numjobs=64: packagewatt = 134W
cpuload=50, numjobs=64: packagewatt = 167W

cpuload=70, numjobs=64: packagewatt = 180W


The example file is updated to reflect this new capabilities.


The qsort code is coming from stress-qsort.c from stress-ng tool.
This software is also GPLv2 but author was informed and agreed with this 
usage


Erwan,

