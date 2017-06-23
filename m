Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58121 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752170AbdFWWbc (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 23 Jun 2017 18:31:32 -0400
Subject: Re: [PATCH v4 0/4] stat: Modify info for bw and add iops stats
References: <20170623222738.5146-1-aherrmann@suse.com>
From: Jens Axboe <axboe@fb.com>
Message-ID: <27dd749e-91e6-2cdd-0e90-c5379cdb5482@fb.com>
Date: Fri, 23 Jun 2017 16:31:23 -0600
MIME-Version: 1.0
In-Reply-To: <20170623222738.5146-1-aherrmann@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andreas Herrmann <aherrmann@suse.com>
Cc: fio@vger.kernel.org

On 06/23/2017 04:27 PM, Andreas Herrmann wrote:
> Hi,
> 
> Next try. Changes to previous version:
> 
> [PATCH 1/4] stat: Print one-line iops stat			     
>  - Added client conversion and bump server version
> [PATCH 2/4] stat: Print number of samples in bw and iops stats  
> [PATCH 3/4] stat: Merge show_thread_status_terse_* functions    
> [PATCH 4/4] stat: Add iops stat and sample number information to
>  - Added explanation of v5 terse format to man page and HOWTO
>  - Continue to report TRIM status with terse version 5

Thanks, applied!

> One oddity I've spotted is that man page states
> 
>  "text description (if provided in config - appears on newline)"
> 
> But I think that this applies only to v2 terse format.
> 
> My merge of the terse output functions tried to preserve the code as
> is so no newline for v3 and above.
> 
> If the newline is the desired behaviour I'll send a follow-on patch to
> adapt the code to the man-page (and if not vice versa).

Only for v2, so I think you're fine.

-- 
Jens Axboe

