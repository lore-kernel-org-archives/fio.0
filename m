Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42672
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762630Ab3DHLSB (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 8 Apr 2013 07:18:01 -0400
Date: Mon, 8 Apr 2013 13:17:45 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: How to re-use default sequential filenames?
Message-ID: <20130408111745.GC12244@kernel.dk>
References: <515DAA33.4000009@warnerbros.com>
 <20130404181946.GD9683@kernel.dk>
 <20130404184104.GE9683@kernel.dk>
 <20130405083902.GL9683@kernel.dk>
 <CAHBo9gn2t6khrMGBsL4omOmiFoGZzfRCOmS9KfLRmRjPa4F-3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHBo9gn2t6khrMGBsL4omOmiFoGZzfRCOmS9KfLRmRjPa4F-3w@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michal =?utf-8?B?xaBtdWNy?= <msmucr@gmail.com>
Cc: Alan Hagge <Alan.Hagge@warnerbros.com>, fio@vger.kernel.org

On Mon, Apr 08 2013, Michal Šmucr wrote:
> 2013/4/5 Jens Axboe <axboe@kernel.dk>:
> > and then 'write' and 'read' job would be sharing those files. Let me
> > know if it works for you.
> 
> Thank you for patch Jens.
> Re-using files working for me and i also like that string format
> specification. Compiled with last git and tested on Mac OS X and
> Centos 5.
> I played with fio and sequence tests, it already helps me to get
> figures much closer to real world utilization. I always struggled with
> generic synthetic benchmarks as it usually don't work with sequences.
> So i can roughly set IO sizes, modes, but for example can't simulate
> performance differences caused by different file allocation between
> one huge file (with few extents due to filesystem internal
> optimization) and thousands of files.
> Great!

Thanks for testing and confirming that it both works and that the
semantics make sense. I tagged 2.0.15 this morning and kept a few
pending features/fixes in a 'next' branch, all have been pulled into the
master branch. So the filename_format option is now in current -git,
though it did not make 2.0.15 final.

> P.S.: Here is what i tried as single thread HD video job. (and as
> example where application read whole frame at once, so bs is
> uncommonly equal filesize).
> 
> [global]
> ioengine=sync
> buffered=0
> filesize=8305664
> bs=8305664
> nrfiles=3000
> openfiles=1
> filename_format=HD_sequence_test.$filenum.dpx
> file_service_type=sequential
> directory=/mnt/test/io
> 
> [2min-sequence-write]
> rw=write
> 
> [2min-sequence-read]
> stonewall
> rw=read

Looks sane!

-- 
Jens Axboe

