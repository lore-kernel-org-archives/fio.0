Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51676 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaAXXRH (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Jan 2014 18:17:07 -0500
Date: Fri, 24 Jan 2014 15:17:05 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Adds check for numberio during verify phase.
Message-ID: <20140124231705.GG9593@kernel.dk>
References: <1379451974-16100-1-git-send-email-jcasse@chromium.org>
 <CANEJEGt0OQCGi_7u68+m-7Rth2ykbaYJt+K17krd_YQCf=f96Q@mail.gmail.com>
 <20140124185855.GF7483@kernel.dk>
 <CANEJEGtcapSorcgMYRXiPBpA8sxK+u3VSL8ySyywfJQ29_KABw@mail.gmail.com>
 <20140124200732.GI7483@kernel.dk>
 <CANEJEGu5w_Lvcbnw0t_mdzqeqVugOX_bFuu521hOK9fw4r+QUA@mail.gmail.com>
 <20140124211957.GB9593@kernel.dk>
 <CANEJEGvKyMMRSoxiJZAHPkGsf-SF8oEhmW6atoaBG-FVozSEtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGvKyMMRSoxiJZAHPkGsf-SF8oEhmW6atoaBG-FVozSEtQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@chromium.org>
Cc: FIO_list <fio@vger.kernel.org>

On Fri, Jan 24 2014, Grant Grundler wrote:
> On Fri, Jan 24, 2014 at 1:19 PM, Jens Axboe <axboe@kernel.dk> wrote:
> ...
> > Why not just use an environment variable, like you do for other things?
> > Then just have:
> >
> > verify_only=${VERIFY_ONLY}
> >
> > and you could easily reuse the same job file.
> 
> Good idea! That would work.  We'll do that next time we update fio if
> there is no verify_only option.

Good, so we're all happy! I'm not adding the command line option if I
can avoid it, it seems redundant and I prefer to keep those options if
they have implicit global scope. The ones that exist and could be
options, I've retained them only to avoid unecessarily breaking peoples
setups.

-- 
Jens Axboe

