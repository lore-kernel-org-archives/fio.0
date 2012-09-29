Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45959 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2I2G1B (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 29 Sep 2012 02:27:01 -0400
Message-ID: <50669495.1080801@kernel.dk>
Date: Sat, 29 Sep 2012 08:26:29 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Should group_reporting be clumping together different groups?
References: <CAFFT=U=WusZz8z+J93NvS8QEe=4NuDtiHHJ6_KJQ=gLAggdouA@mail.gmail.com>
In-Reply-To: <CAFFT=U=WusZz8z+J93NvS8QEe=4NuDtiHHJ6_KJQ=gLAggdouA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Akash Verma <akashv@google.com>
Cc: fio <fio@vger.kernel.org>

On 2012-09-29 04:11, Akash Verma wrote:
> Let's say I use FIO with the following job file:
> 
> 
> [group_1]
> rw=randwrite
> size=1024k
> ioengine=libaio
> time_based=1
> runtime=10
> direct=1
> do_verify=0
> numjobs=2
> group_reporting=1
> 
> [group_2]
> rw=randread
> size=1024k
> ioengine=libaio
> time_based=1
> runtime=10
> direct=1
> numjobs=2
> group_reporting=1
> 
> 
> I get a single report, named after group_1 but actually including
> results for group_2 as well. Since I'm using group_reporting with
> numjobs, shouldn't I be getting two reports, one for group_1 and one
> for group_2?
> 
> I am able to get the desired functionality using:
> new_group=1
> under group_2, causing FIO to specifically treat that group as
> separate for reporting purposes. However the current behavior still
> doesn't conform with the description given for both group_reporting
> and new_group.

Hmm, I think it's perfectly aligned with what is described. The
documentation states that jobs are part of the same group, except if:

- They are separated by a stone wall, which implies starting a new
  group.

- or the new_group primitive is used explicitly.

-- 
Jens Axboe

