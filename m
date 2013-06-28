Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52272 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3F1OI7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 28 Jun 2013 10:08:59 -0400
Date: Fri, 28 Jun 2013 16:08:56 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Make threads access the same files?
Message-ID: <20130628140856.GO24293@kernel.dk>
References: <CAJLXCZTeqg6DTeRcMK0asRoZ7EShD8Od+Y05R-Tgi7OEcS2Fuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJLXCZTeqg6DTeRcMK0asRoZ7EShD8Od+Y05R-Tgi7OEcS2Fuw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrew Davidoff <davidoff@qedmf.net>
Cc: fio@vger.kernel.org

On Thu, Jun 27 2013, Andrew Davidoff wrote:
> Hi,
> 
> If I understand fio's threaded operation, mrfiles are generated for
> each thread (jobs=N), and each thread operates on its own files. Is
> there a way to tell fio to spawn multiple threads, but for each to
> access a single set of files?
> 
> So:
> 
> nrfiles=2048
> jobs=12
> 
> Would produce 12 threads working against the same 2048 files.

See the 'filename_format' option.

-- 
Jens Axboe

