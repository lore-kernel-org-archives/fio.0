Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47860 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS65 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Jan 2014 13:58:57 -0500
Date: Fri, 24 Jan 2014 10:58:55 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Adds check for numberio during verify phase.
Message-ID: <20140124185855.GF7483@kernel.dk>
References: <1379451974-16100-1-git-send-email-jcasse@chromium.org>
 <CANEJEGt0OQCGi_7u68+m-7Rth2ykbaYJt+K17krd_YQCf=f96Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGt0OQCGi_7u68+m-7Rth2ykbaYJt+K17krd_YQCf=f96Q@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@chromium.org>
Cc: Juan Casse <jcasse@chromium.org>, FIO_list <fio@vger.kernel.org>

On Fri, Jan 24 2014, Grant Grundler wrote:
> Jens, Ping?
> You think you can still integrate the three patches from Juan?

I think that would be manageable. But really a new feature (or feature
modification) like this should be accompanies by a job file example for
it. Care to provide one?

-- 
Jens Axboe

