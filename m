Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39839 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0GNWIX (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Jul 2010 18:08:23 -0400
Message-ID: <4C3E354E.3040600@fusionio.com>
Date: Wed, 14 Jul 2010 16:08:14 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Patch to re-use already filled up pattern in io buffers
References: <AANLkTinGG7P6hY4ltETjYGkQVV51VfiiqBPRzM0SSzhu@mail.gmail.com>	<4C3D5A43.6020005@fusionio.com>	<4C3D5CBF.3070108@fusionio.com> <AANLkTilg01hs2RgmLRSSbKcAlJPcr6YL2kyG-AQU8rqk@mail.gmail.com>
In-Reply-To: <AANLkTilg01hs2RgmLRSSbKcAlJPcr6YL2kyG-AQU8rqk@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/14/2010 12:10 PM, Radha Ramachandran wrote:
> Hi Jens,
> As I was verifying the latest code from head, I realized that we
> actually did not need the IO_U_F_FILLED flag, we can just
> use(overload) the buf_filled_len to check if the buffer is actually
> filled (as this is reset to 0 on a read). This also gave me slight
> performance bump. Attached is the patch for it.

Good point, there's no need for that flag/field at all. Will
apply your patch, thanks.

-- 
Jens Axboe

