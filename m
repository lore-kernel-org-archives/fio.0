Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:46053 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3GYS1i (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Jul 2013 14:27:38 -0400
Date: Thu, 25 Jul 2013 12:27:34 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Helping to model this workload
Message-ID: <20130725182734.GH29296@kernel.dk>
References: <20130725164518.GG29296@kernel.dk>
 <CE16CF2A.12CB3%Antonio.Jose.Rodrigues.Neto@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE16CF2A.12CB3%Antonio.Jose.Rodrigues.Neto@netapp.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Jul 25 2013, Neto, Antonio Jose Rodrigues wrote:
> 
> On 7/25/13 12:45 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
> 
> >On Tue, Jul 23 2013, Neto, Antonio Jose Rodrigues wrote:
> >> Hi All
> >> 
> >> This is neto from Brazil
> >> 
> >> How are you?
> >> 
> >> I need to model the following workload:
> >> 
> >> Sequential Read % 35.0
> >> Sequential Write % 5.0
> >> Random Read % 50.0
> >> Random Write % 10.0
> >> Random Read Working Set(GB) 1000.0
> >> Random Write Working Set(GB) 1000.0
> >> Sequential Read Size(KB) 64KB
> >> Sequential Write Size(KB) 64KB
> >> Random Read Size(KB) 8KB
> >> Random Write Size(KB) 8KB
> >
> >So that's 85% reads and 15% writes, first part:
> >
> >rw=randrw
> >rwmixread=85
> >
> >and then you have 50/85 reads random and 35/85 reads sequential. That's
> >roughly 59% reads random. On the writes, you have 10/15 random and 5/15
> >sequential. That's roughly 67% writes random:
> >
> >percentage_random=59,67
> >
> >The latter I just added support for, before it only support a single
> >setting for reads and writes.
> >
> >Fio does not support splitting block sizes on a random/sequential basis.
> >You will have to improvise there.
> >
> >-- 
> >Jens Axboe
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe fio" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Hi Jens
> 
> This is neto from Brazil
> 
> How are you?
> 
> Thank you very much.
> 
> So basically the option right now is to use either 8KB or 64KB right?
> 
> Something like:
> 
> [workload]
> bs=8k
> ioengine=libaio
> iodepth=2
> numjobs=64
> direct=1
> runtime=2400
> size=2000g
> filename=\\.\PhysicalDrive9
> filename=\\.\PhysicalDrive10
> rw=randrw
> rwmixread=85
> percentage_random=59,67
> 
> thread
> unified_rw_reporting=1
> group_reporting=1
> 
> 
> Would be nice to have something like:
> 
> block_mixed=8192,65536 (random, sequential)

That would certainly easily be feasible. But since that would override
any other blocksize setting, might be cleaner to just have a boolean
saying whether to interpret these fields as "read,write" or
"sequential,random" instead.

BTW, if you use filename= twice like you do above, only the last one
will be effective.

-- 
Jens Axboe

