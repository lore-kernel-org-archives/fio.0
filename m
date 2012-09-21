Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54020 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2IUL0E (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 21 Sep 2012 07:26:04 -0400
Message-ID: <505C4EB1.4090800@kernel.dk>
Date: Fri, 21 Sep 2012 13:25:37 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] core: Actually EIO is a fatal error
References: <1348225456-21811-1-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1348225456-21811-1-git-send-email-dmonakhov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: fio@vger.kernel.org

On 09/21/2012 01:04 PM, Dmitry Monakhov wrote:
> As soon as i understand this is just a mistype.

It's not a typo. By that logic, EILSEQ is fatal too, since it is a
verification failure of read data (so might as well have been an EIO).
Fatal, in this context, means errors that fio can recover from and
continue doing work.


-- 
Jens Axboe

