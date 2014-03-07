Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaCGIbz (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 7 Mar 2014 03:31:55 -0500
Date: Fri, 7 Mar 2014 09:31:35 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH 0/2] Two small ./configure fixes
Message-ID: <20140307083135.GB17270@stefanha-thinkpad.redhat.com>
References: <1394127719-3105-1-git-send-email-stefanha@redhat.com>
 <20140306181450.GA23848@sucs.org>
 <5318E68A.1000904@fb.com>
 <0dee324adeb2479d96ebb8c90a6654ee@DM2PR04MB478.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dee324adeb2479d96ebb8c90a6654ee@DM2PR04MB478.namprd04.prod.outlook.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <BCran@fusionio.com>
Cc: Jens Axboe <axboe@fb.com>, Sitsofe Wheeler <sitsofe@yahoo.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Mar 06, 2014 at 09:22:30PM +0000, Bruce Cran wrote:
> The Windows build of fio assumes only a minimal set of POSIX headers is available, so trying to build using Cygwin's GCC and its full set is probably not going to work. Why do you not want to use MinGW GCC?

I want to cross-compile using mingw, just wasn't aware of winpthreads.
Not sure if anyone actually wants to use Cygwin :-).

Stefan
