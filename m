Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:57429 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754209AbdFWRnf (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 23 Jun 2017 13:43:35 -0400
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH v3 0/4] stat: Modify info for bw and add iops stats
Date: Fri, 23 Jun 2017 19:42:56 +0200
Message-Id: <20170623174300.7937-1-aherrmann@suse.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

Hi,

this is a resubmission of patches 1 and 2 to add iops statistics and
number of samples for iops and bw stats to normal and json output
formats. Patches are rebased on fio-2.21-26-gcf6b7fb4.

I'd like to see similar information added to terse format. Thus I've
added patches 3 and 4. First to merge terse functions (reducing code
size) and then to add a new terse format 5 where iops stats and number
of samples for bw and iops are displayed.


Regards,

Andreas
