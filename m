Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37636 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbaA1WDv (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Jan 2014 17:03:51 -0500
Date: Tue, 28 Jan 2014 15:03:49 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fio: consolidate rand_seed to uint64_t
Message-ID: <20140128220349.GD25989@kernel.dk>
References: <1390942940-6886-1-git-send-email-grundler@chromium.org>
 <20140128213014.GC31710@kernel.dk>
 <CANEJEGvZ3xnkg+D8RwVcvHfTKtVCcm_YP_geskOZTC0UNBnGOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGvZ3xnkg+D8RwVcvHfTKtVCcm_YP_geskOZTC0UNBnGOA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@chromium.org>
Cc: FIO List <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>, Gwendal Grignou <gwendal@chromium.org>

On Tue, Jan 28 2014, Grant Grundler wrote:
> On Tue, Jan 28, 2014 at 1:30 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > On Tue, Jan 28 2014, Grant Grundler wrote:
> >> csscope showed rand_seed was defined 4 times - each a different type.
> >> While they are used differently, the places where they overlap
> >> should reference the same type. This patch makes three of them the same
> >> as suggested by Jens Axboe.
> >
> > Time for public shaming, as you did not even compile this patch!
> 
> No, I didn't. :)  I told you I didn't test it.

When you said no testing, I'm assuming no runtime testing. I figure a
compile would at least be in the cards :-)

> > I'll let you figure out the issue :-)
> 
> Oh man...harsh master :P
> 
> -       o->rand_seed = le32_to_cpu(top->rand_seed);
> +       o->rand_seed = le64_to_cpu(top->rand_seed);
> 
> I saw this when reviewing the code but didn't realize "top" was the
> packed version that got changed.

Yeah, and vice versa for top -> o.

> Resending V2
> 
> Compiled and lightly tested on x86, not ARM where I'm doing most of my
> testing these days. :)

It should work fine, as long as the cconv.c issue is sorted out.

-- 
Jens Axboe

