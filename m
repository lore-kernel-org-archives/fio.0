Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41468 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754564AbdFWSPv (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 23 Jun 2017 14:15:51 -0400
Subject: Re: [PATCH v3 0/4] stat: Modify info for bw and add iops stats
References: <20170623174300.7937-1-aherrmann@suse.com>
From: Jens Axboe <axboe@fb.com>
Message-ID: <febe06de-7c82-698f-15df-d1282011ec49@fb.com>
Date: Fri, 23 Jun 2017 12:15:34 -0600
MIME-Version: 1.0
In-Reply-To: <20170623174300.7937-1-aherrmann@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andreas Herrmann <aherrmann@suse.com>
Cc: fio@vger.kernel.org

On 06/23/2017 11:42 AM, Andreas Herrmann wrote:
> Hi,
> 
> this is a resubmission of patches 1 and 2 to add iops statistics and
> number of samples for iops and bw stats to normal and json output
> formats. Patches are rebased on fio-2.21-26-gcf6b7fb4.
> 
> I'd like to see similar information added to terse format. Thus I've
> added patches 3 and 4. First to merge terse functions (reducing code
> size) and then to add a new terse format 5 where iops stats and number
> of samples for bw and iops are displayed.

Looks good, I like it. Patch #4 needs an explanation of version 5
of the terse format, though. Care to add that?

-- 
Jens Axboe

