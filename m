Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47795 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3JaQ7J (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 31 Oct 2013 12:59:09 -0400
Date: Thu, 31 Oct 2013 10:59:04 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Add json output for client/server mode.
Message-ID: <20131031165904.GJ29372@kernel.dk>
References: <1383141780-20242-1-git-send-email-castor.fu@egocast.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383141780-20242-1-git-send-email-castor.fu@egocast.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: castor.fu@egocast.org
Cc: fio@vger.kernel.org, Castor Fu <castor@alumni.caltech.edu>

On Wed, Oct 30 2013, castor.fu@egocast.org wrote:
> From: Castor Fu <castor@alumni.caltech.edu>
> 
> In client/server mode, this adds support for json mode.  Each job's
> details are gradually accumulated and upon completion the client
> dumps the full json tree.  The tree is annotated with the server
> host and port.  Also tweak configure script to allow explicitly
> disabling libnuma.

Thanks, this is good stuff! I have applied it, but split it into two
patches. You really shouldn't bundle unrelated changes together.


-- 
Jens Axboe

