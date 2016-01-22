Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:13607 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbcAVWCG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 Jan 2016 17:02:06 -0500
Subject: Re: Windows Make Broken
References: <BN3PR0401MB14571048CD0CFE7699E18400F7C30@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <56A1536A.6060308@cran.org.uk> <56A1AD7C.3060802@kernel.dk>
 <56A271EF.6040401@cran.org.uk> <56A279E4.8090209@kernel.dk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <56A2A6DB.2090802@cran.org.uk>
Date: Fri, 22 Jan 2016 15:02:03 -0700
MIME-Version: 1.0
In-Reply-To: <56A279E4.8090209@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 1/22/16 11:50 AM, Jens Axboe wrote:

> - I think we should just use OS_MSG_DONTWAIT in the server.c code, then
> it'd work fine. That's an oversight on my behalf.
>
> - On the strcasestr, since you have STRCASESTR on Windows, don't you
> just need to add   output_sym "CONFIG_STRCASESTR" to configure for windows?
>

I tried defining CONFIG_STRCASESTR but it didn't work - so I think 
strcasestr.o is being linked in twice?

-- 
Bruce
