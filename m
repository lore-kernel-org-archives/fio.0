Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:60471 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbcAVWVz (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 Jan 2016 17:21:55 -0500
Subject: Re: Windows Make Broken
References: <BN3PR0401MB14571048CD0CFE7699E18400F7C30@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <56A1536A.6060308@cran.org.uk> <56A1AD7C.3060802@kernel.dk>
 <56A271EF.6040401@cran.org.uk> <56A279E4.8090209@kernel.dk>
 <56A2A6DB.2090802@cran.org.uk> <56A2A940.9000105@kernel.dk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <56A2AB81.60107@cran.org.uk>
Date: Fri, 22 Jan 2016 15:21:53 -0700
MIME-Version: 1.0
In-Reply-To: <56A2A940.9000105@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 1/22/16 3:12 PM, Jens Axboe wrote:

> I think you earlier added it in the cygwin section. We need to kill that
> one, not the generic one, since that would fail on systems not providing
> strcasestr().
>
> http://git.kernel.dk/cgit/fio/commit/?id=ada83043abcb94dde7c603ce60ae8de9693a022f

There's one other fix in my patch that would be good to be committed: 
Cygwin doesn't define rand_r since it's not in C99 
(https://cygwin.com/ml/cygwin/2009-05/msg00432.html). I've instead 
changed os-windows.h to avoid the compiler warnings.

-- 
Bruce
