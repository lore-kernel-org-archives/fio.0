Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57934
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162584Ab3DETbv (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 5 Apr 2013 15:31:51 -0400
Date: Fri, 5 Apr 2013 21:31:34 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: How to re-use default sequential filenames?
Message-ID: <20130405193134.GC12244@kernel.dk>
References: <515DAA33.4000009@warnerbros.com>
 <20130404181946.GD9683@kernel.dk>
 <20130404184104.GE9683@kernel.dk>
 <CAHBo9gmJHgZAjQ=rjeNpzrV7boLS6+2VcxtZRnkad7y_hwp=Dw@mail.gmail.com>
 <20130405084056.GM9683@kernel.dk>
 <CAHBo9gn-vMzsKGtZYOHB979_EJ9PbnF3=eK9MPOrnsciNDJtrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHBo9gn-vMzsKGtZYOHB979_EJ9PbnF3=eK9MPOrnsciNDJtrg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michal =?utf-8?B?xaBtdWNy?= <msmucr@gmail.com>
Cc: Alan Hagge <Alan.Hagge@warnerbros.com>, fio@vger.kernel.org

On Fri, Apr 05 2013, Michal Šmucr wrote:
> 2013/4/5 Jens Axboe <axboe@kernel.dk>:
> > It would not be a problem making the block size decision probed or
> > dynamic. But it's not clear to me from the above what you would base it
> > on. The file size? Or st_blksize?
> 
> I'm sorry Jens, i wasn't much clear regarding this. I meant file size - st_size.

OK, so how would you size the block size based on the file size? That's
the part that isn't quite clear to me. There could be a number of valid
options in that area, and things like buffered/unbuffered IO might
influence that as well. In other words, it would involve some
heuristics, which I'm never that crazy about adding.

But tell me what you are proposing in detail, and we can take it from
there :-)

-- 
Jens Axboe

