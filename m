Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37734 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab2DSHrD (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Apr 2012 03:47:03 -0400
Message-ID: <4F8FC2E5.1000207@kernel.dk>
Date: Thu, 19 Apr 2012 09:46:45 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Issue with verify and Mix read/writes
References: <CAN8qX8busH4Nu=0BuAYxeMOJSp+PC_z5JK3LPLaGAzb3Wy_Oug@mail.gmail.com>
In-Reply-To: <CAN8qX8busH4Nu=0BuAYxeMOJSp+PC_z5JK3LPLaGAzb3Wy_Oug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Suresh Dhanarajan <sureshdrajan@gmail.com>
Cc: fio@vger.kernel.org

On 04/19/2012 12:14 AM, Suresh Dhanarajan wrote:
> Hi Jens,
> 
> I am using the verify option with mix read and write case.
> When verify option is I am seeing that the results are not reflecting
> the actual percentage given in the jobfile.
> When i don't use verify option the results are exactly as per the
> percentage given in the jobfile.
> 
> Please fin the result for various cases with and without verify option,
> 
> withverify sequential :-
> Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
> 2988;2436;594;1256
> 10240;6565;1603;1597
> ===================
> wthoutverify sequential :-
> Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
> 3124;2460;600;1300
> 7116;5605;1368;1300
> ===================
> 
> random with verify
> Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
> 3088;431;105;7322
> 10240;1363;332;7693
> ===============
> 
> random without verify
> Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
> 3076;430;105;7311
> 7164;1003;244;7311
> 
> I used 70% read and 30% write option.
> Is it that when verify is used the mix percentage wont be honored?
> I had mentioned size has 10mb but when verify is used even that is not
> getting honored.
> Is there a way to make this case to honor the percentage set in the job file?

The reads that are done to verify a written block are not accounted in
the read/write mix ratio. So that is why you see more reads than you
asked for.

-- 
Jens Axboe

