Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55595
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481Ab2LRI3I (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 18 Dec 2012 03:29:08 -0500
Message-ID: <50D02951.4030608@kernel.dk>
Date: Tue, 18 Dec 2012 09:29:05 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Latency spikes with 'thread' option
References: <80B89753B40C5141A3E2D53FE7A2A8A930030D7E@NTXBOIMBX02.micron.com> <50C9D5CA.9000904@kernel.dk> <80B89753B40C5141A3E2D53FE7A2A8A930031AC5@NTXBOIMBX02.micron.com> <50D01990.7080102@kernel.dk>
In-Reply-To: <50D01990.7080102@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Mike Berhan (mberhan)" <mberhan@micron.com>

On 2012-12-18 08:21, Jens Axboe wrote:
> Good analysis and I believe you are correct. It's not safely shared and
> should be thread local. A quick test here with the below seems to
> indicate that that is indeed the issue, I don't see any time weirdness
> with that applied.

Bah, so that didn't work on all the supported platforms (notably OSX
does not have support for __thread). I've committed a patch that should
work across platforms, please give the current fio git a try (5d879392
or newer).

-- 
Jens Axboe

