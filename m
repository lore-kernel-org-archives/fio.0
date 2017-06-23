Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44704 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754854AbdFWT4s (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 23 Jun 2017 15:56:48 -0400
Subject: Re: [PATCH v3 0/4] stat: Modify info for bw and add iops stats
References: <20170623174300.7937-1-aherrmann@suse.com>
 <febe06de-7c82-698f-15df-d1282011ec49@fb.com>
 <20170623194508.GA3090@suselix.suse.de>
From: Jens Axboe <axboe@fb.com>
Message-ID: <329f0df2-4991-07bf-9fa7-9281c2674b24@fb.com>
Date: Fri, 23 Jun 2017 13:56:36 -0600
MIME-Version: 1.0
In-Reply-To: <20170623194508.GA3090@suselix.suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andreas Herrmann <aherrmann@suse.com>
Cc: fio@vger.kernel.org

On 06/23/2017 01:45 PM, Andreas Herrmann wrote:
> On Fri, Jun 23, 2017 at 12:15:34PM -0600, Jens Axboe wrote:
>> On 06/23/2017 11:42 AM, Andreas Herrmann wrote:
>>> Hi,
>>>
>>> this is a resubmission of patches 1 and 2 to add iops statistics and
>>> number of samples for iops and bw stats to normal and json output
>>> formats. Patches are rebased on fio-2.21-26-gcf6b7fb4.
>>>
>>> I'd like to see similar information added to terse format. Thus I've
>>> added patches 3 and 4. First to merge terse functions (reducing code
>>> size) and then to add a new terse format 5 where iops stats and number
>>> of samples for bw and iops are displayed.
>>
>> Looks good, I like it. Patch #4 needs an explanation of version 5
>> of the terse format, though. Care to add that?
> 
> You mean for the commit message or for the man-page or both? For the
> latter I think the differences between the different terse versions
> should be described. (Maybe I missed it but I think that is not in the
> man-page).

The HOWTO and man page seem to have up to version 3, but doesn't
include information that v4 is just v3 + a trim section.

-- 
Jens Axboe

