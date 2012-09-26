Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2IZKny (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 26 Sep 2012 06:43:54 -0400
Message-ID: <5062DC48.2000704@kernel.dk>
Date: Wed, 26 Sep 2012 12:43:20 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] netbsd: fix gettid
References: <1348650803-92011-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1348650803-92011-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: fio@vger.kernel.org

On 09/26/2012 11:13 AM, Roger Pau Monne wrote:
> Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>

Thanks Roger. I'm assuming you are using fio on NetBSD so I can consider
this tested? It's applied.

-- 
Jens Axboe

