Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42639 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2IYKMT (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 25 Sep 2012 06:12:19 -0400
Message-ID: <50618361.8020602@kernel.dk>
Date: Tue, 25 Sep 2012 12:11:45 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] backend: fix data direction flow check
References: <1348567224-22570-1-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1348567224-22570-1-git-send-email-dmonakhov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: fio@vger.kernel.org

On 09/25/2012 12:00 PM, Dmitry Monakhov wrote:
> This patch fix regression caused SIGSEGV in case of writeonly 
> or readonly mode.

Bah, how embarassing. Thanks!

-- 
Jens Axboe

