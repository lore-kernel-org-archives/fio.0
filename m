Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:36874 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab1ESH7E (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 May 2011 03:59:04 -0400
Message-ID: <4DD4CDC3.3000909@fusionio.com>
Date: Thu, 19 May 2011 09:58:59 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio accessing boot drive
References: <BANLkTinaacqHwb+UfoBbhC2V4EO9z6ZTpg@mail.gmail.com>	<BANLkTinVT0yeg36ONDvckhm2N0DtWqFUog@mail.gmail.com> <BANLkTikGATQye=CWDXmvMz_6Tn9rvd1HEQ@mail.gmail.com>
In-Reply-To: <BANLkTikGATQye=CWDXmvMz_6Tn9rvd1HEQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vikram Seth <seth.vik@gmail.com>
Cc: Josh Aune <luken@omner.org>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-05-19 03:50, Vikram Seth wrote:
> Hi Josh,
> 
> Thanks for the response.
> 
> Do you mean use 'norandommap' option ?
> If I disable random map then won't I lose coverage on random i/o testing?

You will. With the random map turned out, you are guarenteed to hit
every block and only once. Without it, you are at the mercy of the
random number generator. But it is of high quality, so coverage will
still be excellent and it'll likely be faster (and retain randomness at
the end of the run, the random map tends to give up at the very end).

Unless you are absolutely needing the coverage guarentee, I would just
turn it off if it's a problem. Alternatively, make /tmp a tmpfs or
similar so updates to the maps don't end up touching disk.

-- 
Jens Axboe

