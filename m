Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48047 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3CVNQP (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 22 Mar 2013 09:16:15 -0400
Date: Fri, 22 Mar 2013 07:15:29 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] mutex: fix the expression for checking the mutext magic.
Message-ID: <20130322131529.GA25978@kernel.dk>
References: <514BF694.2090004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514BF694.2090004@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Mar 22 2013, majianpeng wrote:
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>

Hah, that might work a little better! Thanks, I'll have to play the
jet lag card on that change. That, and copy-pasting.

-- 
Jens Axboe

