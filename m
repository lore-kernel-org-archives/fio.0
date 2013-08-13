Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55898 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab3HMOnN (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 13 Aug 2013 10:43:13 -0400
Date: Tue, 13 Aug 2013 08:43:11 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Why not abort when posix_fallocate() failed?
Message-ID: <20130813144311.GI25668@kernel.dk>
References: <CA+8ZFnhapBuTo0U9Loyg=zrGHxf2GGJN2=LTu2Sw0oJWKHNicA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8ZFnhapBuTo0U9Loyg=zrGHxf2GGJN2=LTu2Sw0oJWKHNicA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "xan.peng" <xanpeng@gmail.com>
Cc: fio@vger.kernel.org

On Mon, Aug 12 2013, xan.peng wrote:
> Hi all,
> 
> I'm recently reading fio source code and running it for test purpose.
> A case bothered me which is fio keep going after posix_fallocate()
> failed, I'm wondering why, shouldn't it abort immediately?

Fio treats it as advisory, like fadvise. Back in the day, fallocate
would often not be available. So it would be hard to treat it as a full
error.

-- 
Jens Axboe

