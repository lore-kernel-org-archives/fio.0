Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59560 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3AYVWZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 25 Jan 2013 16:22:25 -0500
Date: Fri, 25 Jan 2013 14:22:15 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: fio is being killed by the oom-killer after fio verify runs for
 some time ~13 hours
Message-ID: <20130125212215.GA15635@kernel.dk>
References: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
 <20130111091010.GA32674@kernel.dk>
 <50F12401.8090606@kernel.dk>
 <CABYizFLj4LSJApybuRfUfCiuqhVNac0T733BcMnpUOAivWhi7A@mail.gmail.com>
 <20130118204040.GT3571@kernel.dk>
 <20130121212925.GA1300@kernel.dk>
 <20130123182100.GC30268@kernel.dk>
 <CABYizF+3JhYd8zRwjq5JNSq5KVPbOs=FjY-4J-1hPK5hCFEEpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABYizF+3JhYd8zRwjq5JNSq5KVPbOs=FjY-4J-1hPK5hCFEEpA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: brian arb <brianjamesarb@gmail.com>
Cc: fio@vger.kernel.org

On Fri, Jan 25 2013, brian arb wrote:
> Hi Jen,
> It appears every thing ran as expected.

Great! I take it that means it:

1) Ran to completion
2) Completed the verify successfully

Correct?

BTW, fio also supports a json output format. It's more robust than the
csv format, so both easier to parse by a computer reliably, and readable
by humans as well.

-- 
Jens Axboe

