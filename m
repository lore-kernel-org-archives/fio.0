Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750753AbdALRMz (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 12 Jan 2017 12:12:55 -0500
Subject: Re: [PATCH] Support zlib in the Windows build (enables latency
 histogram logging)
References: <0416e3e3-c7da-637b-5c90-e0fc155e65cc@bluestop.org>
 <20170112040402.GD27546@kernel.dk>
 <da4edfed-d87f-7251-77cd-e6bd11d804fa@cran.org.uk>
From: Jens Axboe <axboe@fb.com>
Message-ID: <53f869cb-4540-321c-7383-adee5dead0f7@fb.com>
Date: Thu, 12 Jan 2017 10:12:48 -0700
MIME-Version: 1.0
In-Reply-To: <da4edfed-d87f-7251-77cd-e6bd11d804fa@cran.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rebecca Cran <rebecca@bluestop.org>
Cc: fio@vger.kernel.org

On 01/12/2017 10:01 AM, Rebecca Cran wrote:
> On 1/11/2017 9:04 PM, Jens Axboe wrote:
>> On Mon, Jan 09 2017, Rebecca Cran wrote:
>>> Add support for building with zlib in the Windows build: this enables the
>>> latency histogram logging feature.
>> Thanks Rebecca, applied.
> 
> I don't see the changeset in the log: do you still need to push it?

I did, pushed now.

-- 
Jens Axboe

