Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57475 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750830AbdESOX7 (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 19 May 2017 10:23:59 -0400
Subject: Re: [PATCH] stat: Re-add output of basic bw information if bw_log is
 not written
References: <20170519140927.GA27177@suselix.suse.de>
From: Jens Axboe <axboe@fb.com>
Message-ID: <248f7465-5f41-a6ea-6d1e-782c0d66d60b@fb.com>
Date: Fri, 19 May 2017 08:23:49 -0600
MIME-Version: 1.0
In-Reply-To: <20170519140927.GA27177@suselix.suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andreas Herrmann <aherrmann@suse.com>
Cc: fio@vger.kernel.org

On 05/19/2017 08:09 AM, Andreas Herrmann wrote:
> 
> Starting with 9e4438f ("stat: don't trust per_unit_log() if log is
> NULL") fio no longer provides basic bw information (e.g. min, max,
> p_agg, mean, stdev) when write_bw_log is not used. Thus you have to
> write a bw_log to obtain these values. (But in this case you can
> compute those values yourself.) I think this doesn't make sense.  Not
> writing entire bw log shouldn't prevent general sampling and
> calculation of bw stats.
> 
> This patch reactivates sampling for bw and iops to be able to
> calculate basic stats for both independend of writing of entire
> {bw,iops}_logs.
> 
> Also check for log that is really of interest in __add_samples() it
> doesn't make sense to check for bw_log if iops information needs to be
> written.

Thanks, good catch, can't believe I missed that. I have committed it.

-- 
Jens Axboe

