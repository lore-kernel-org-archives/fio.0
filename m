Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42455 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab3H3QLi (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Aug 2013 12:11:38 -0400
Message-ID: <5220C427.9030806@kernel.dk>
Date: Fri, 30 Aug 2013 10:11:19 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Running Fio under AIX 7
References: <795872394.588090.1377863589568.JavaMail.root@thomas-krenn.com>
In-Reply-To: <795872394.588090.1377863589568.JavaMail.root@thomas-krenn.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org

On 08/30/2013 05:53 AM, Georg Schönberger wrote:
> Hi fio users,
> 
> I am trying to run Fio under AIX 7 - according to the documentation there shouldn't be any problem with it.
> For now I am getting the following error, do you have any idea what's the problem here (filesystem jfs/jfs2)?

Odd, so it's posix_fadvise() getting EINVAL. Most likely reason for that
is that fio is not picking up the right values for it.

It finds them here, on this platform:

AIX aixbuild 3 5 00C1DC964C00

Does it need some other magic on AIX 7 to find them? You can bypass the
error by setting invalidate_cache=0, but it would be great if you could
dig around a bit in /usr/include and see what is up. Alternatively, if I
can log into the machine, I can definitely fix it up.

-- 
Jens Axboe

