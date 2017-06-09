Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:43422 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdFIPtn (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 9 Jun 2017 11:49:43 -0400
Date: Fri, 9 Jun 2017 17:49:21 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 0/2] stat: Modify info for bw and iops stats in normal output
Message-ID: <20170609154716.GA11503@suselix.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

Hi,

I'd like to add basic IOPS statistics to fio's output. Sampling is
done already but the final calculation and printing is missing.

Also I think it's usefull to know how many samples were collected and
used to do the calculations. At least it helped me to understand that
log_avg_msec parameter only has impact to metrics for which a log is
written (e.g. using write_bw_log, write_lat_log etc.). For the rest
the default sampling time is 500 msec, I think.

To make this information available in general, other output formats
(at least the terse format) should also be adapted. But before doing
that I'd like to know whether adding such info is accepted or
rejected.


Thanks,

Andreas
