Return-Path: <fio-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:52677 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaCFSOw (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 6 Mar 2014 13:14:52 -0500
Date: Thu, 6 Mar 2014 18:14:51 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH 0/2] Two small ./configure fixes
Message-ID: <20140306181450.GA23848@sucs.org>
References: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: fio@vger.kernel.org, axboe@fb.com

On Thu, Mar 06, 2014 at 06:41:57PM +0100, Stefan Hajnoczi wrote:
> My hopes of cross-compiling fio for Windows were dashed when I realized
> pthreads is needed (I guess only Cygwin supports it, not mingw).

I think mingw supports pthreads using winpthreads (see
http://thread.gmane.org/gmane.comp.storage.fio/97/focus=149 ). Does fio
even compile with pure cygwin gcc (rather than mingw)? I think I had a
brief try and it complained about conflicting headers...

-- 
Sitsofe | http://sucs.org/~sits/
