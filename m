Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:51146 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1HONRF (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Aug 2011 09:17:05 -0400
Message-ID: <4E491C4C.2070409@fusionio.com>
Date: Mon, 15 Aug 2011 15:17:00 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio memory allocation problems
References: <4E453BE0.5060708@cesnet.cz> <4E48D901.6030603@fusionio.com> <4E48DF73.10700@cesnet.cz>
In-Reply-To: <4E48DF73.10700@cesnet.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jiri Horky <jiri.horky@cesnet.cz>
Cc: fio@vger.kernel.org, 'Jan Furman' <Jan.Furman@cesnet.cz>, =?UTF-8?B?UGV0ZXIgVmVyxI1pbcOhaw==?= <peter.vercimak@cesnet.cz>

On 2011-08-15 10:57, Jiri Horky wrote:
> Hi Jens,
> 
> the patch is attached. It resolves the issue but I would not bet it
> works in all scenarios.

I think it's OK. Just to be on the safe side, I ran it through my stest
app that I had saved from when I did smalloc, and it passes. I think the
+1 dates back to when the pools had a header.

-- 
Jens Axboe

