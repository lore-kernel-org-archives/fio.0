Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41450 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3FYIB4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 25 Jun 2013 04:01:56 -0400
Date: Tue, 25 Jun 2013 10:01:52 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: The problem of blocks overwriting by multiple writers for raw
 devices
Message-ID: <20130625080152.GB13354@kernel.dk>
References: <EEF9E3C12F20174DA289A981D6CCA6C832466199B3@MX44A.corp.emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EEF9E3C12F20174DA289A981D6CCA6C832466199B3@MX44A.corp.emc.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Jun 21 2013, Ruvinsky, Konstantin wrote:
> Hi Jens,
> 
> Question/suggestion (I am almost sure that it was already discussed
> here, but maybe ...):
> 
> Why not to divide a raw device size for multithreaded write by number
> of threads and let every thread to write on a separate chunk (as you
> do for FS - every thread writes to a separate file)? This will solves
> the problem of blocks overwriting by multiple writers.

You can do that manually, using zones for instance. Fio tries not to
guess what you are trying to do. It'll just do what you ask it to.

-- 
Jens Axboe

