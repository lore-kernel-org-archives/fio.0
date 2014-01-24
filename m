Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140124211957.GB9593@kernel.dk>
References: <1379451974-16100-1-git-send-email-jcasse@chromium.org>
	<CANEJEGt0OQCGi_7u68+m-7Rth2ykbaYJt+K17krd_YQCf=f96Q@mail.gmail.com>
	<20140124185855.GF7483@kernel.dk>
	<CANEJEGtcapSorcgMYRXiPBpA8sxK+u3VSL8ySyywfJQ29_KABw@mail.gmail.com>
	<20140124200732.GI7483@kernel.dk>
	<CANEJEGu5w_Lvcbnw0t_mdzqeqVugOX_bFuu521hOK9fw4r+QUA@mail.gmail.com>
	<20140124211957.GB9593@kernel.dk>
Date: Fri, 24 Jan 2014 14:56:48 -0800
Message-ID: <CANEJEGvKyMMRSoxiJZAHPkGsf-SF8oEhmW6atoaBG-FVozSEtQ@mail.gmail.com>
Subject: Re: [PATCH] Adds check for numberio during verify phase.
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Jan 24, 2014 at 1:19 PM, Jens Axboe <axboe@kernel.dk> wrote:
...
> Why not just use an environment variable, like you do for other things?
> Then just have:
>
> verify_only=${VERIFY_ONLY}
>
> and you could easily reuse the same job file.

Good idea! That would work.  We'll do that next time we update fio if
there is no verify_only option.

thanks!
grant

