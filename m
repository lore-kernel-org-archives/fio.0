Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:50798 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1BKJ1G (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Feb 2011 04:27:06 -0500
Message-ID: <4D550132.4000101@fusionio.com>
Date: Fri, 11 Feb 2011 10:28:18 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: SPC-1 profile
References: <3DEFDA95-E1BA-4C79-BE8E-9AF8EC84603E@bjorgeengen.net>	<4D54FEC7.9030602@fusionio.com> <AANLkTimSwmNYraRqZ5oWEPBLV4N5LaqFL8YnY6Fri2K_@mail.gmail.com>
In-Reply-To: <AANLkTimSwmNYraRqZ5oWEPBLV4N5LaqFL8YnY6Fri2K_@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: DongJin Lee <dongjin.lee@auckland.ac.nz>
Cc: =?ISO-8859-1?Q?Jarle_Bj=F8rgeengen?= <jarle@bjorgeengen.net>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-02-11 10:23, DongJin Lee wrote:
> 
> Still alive, I haven't got around to merge to the latest fio version.
> But the main functions are still the same, -- mainly on write/read and
> rand read/write.  Do you need the test config file? it works but
> really lacking the integration with fio's option.  Oh Jens, thanks
> again for keeping the branch there!

That was fast :-)

I would really appreciate an update. If it works, lets fold it into the
mainline branch. Then we can work on integrating well with the fio
options afterwards.

Note I'll be gone in a few hours and all of next week (skiing), so you
have plenty of time!

-- 
Jens Axboe

