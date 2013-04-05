Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41363 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3DEIlF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Apr 2013 04:41:05 -0400
Date: Fri, 5 Apr 2013 10:40:56 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: How to re-use default sequential filenames?
Message-ID: <20130405084056.GM9683@kernel.dk>
References: <515DAA33.4000009@warnerbros.com>
 <20130404181946.GD9683@kernel.dk>
 <20130404184104.GE9683@kernel.dk>
 <CAHBo9gmJHgZAjQ=rjeNpzrV7boLS6+2VcxtZRnkad7y_hwp=Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHBo9gmJHgZAjQ=rjeNpzrV7boLS6+2VcxtZRnkad7y_hwp=Dw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michal =?utf-8?B?xaBtdWNy?= <msmucr@gmail.com>
Cc: Alan Hagge <Alan.Hagge@warnerbros.com>, fio@vger.kernel.org

On Fri, Apr 05 2013, Michal Šmucr wrote:
> Hello to all,
> this is actually great thread. I discovered wonderful fio before two
> days during seeking for tool, which allows me to simulate typical
> workload with DPX files playback and recording (one file per frame).
> I'm playing with it today and slowly getting into options. By
> coincidence, i subscribed to this list to ask almost same question as
> Alan and found this first thread.. :-)
> Reusing of generated frames (file sequences) between write and read
> jobs is also important for me and is exactly thing, what i thought
> about. I will try to test patch by Jens.
> 
> One small thing, sorry for slight derail of thread topic, which come
> to my mind was option for kind of automatic set of blocksize during
> read to match length of each pre-generated file within sequence, which
> fio got from directory using opendir directive. Idea behind this come
> from common behaviour of VFX applications, which issue read io for
> whole frame size. So application use stat() output to get actual file
> size before reading of each frame. If I have same filesize per frame
> it is easy to adjust blocksize before benchmark, but if i want to test
> read performance of sequence with compressed frames or simulate
> mixture of different resolutions, this will be handy.

It would not be a problem making the block size decision probed or
dynamic. But it's not clear to me from the above what you would base it
on. The file size? Or st_blksize?

> Thank you and especially Jens for creation of fio (first day with it
> is mindblowing :)

You're welcome, glad you like it :-). Fio grows with great suggestions
from people actually using it, which this thread is a good example of.

-- 
Jens Axboe

