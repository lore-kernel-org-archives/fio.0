Return-Path: <fio-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:15269 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752689AbdIGT7D (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Sep 2017 15:59:03 -0400
From: Dave Jiang <dave.jiang@intel.com>
Subject: fio and total latency percentile
Message-ID: <53cbc635-d9a3-6ef3-3634-309db0fe03d5@intel.com>
Date: Thu, 7 Sep 2017 12:59:01 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>

Jens,
fio can display completion latency percentages via the percentile_list
parameter. I can get p90 and p99 numbers for clat via
percentile_list=90:99. Is there a way to get the overall latency for
percentile? I'm interested in the total latency measurements for p90 and
p99 while doing some measurements on the persistent memory block driver
and playing around using DMA engines for transfer.

-- 

Dave Jiang
Software Engineer, Data Center Group
Intel Corp.
dave.jiang@intel.com
