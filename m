Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60056
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab3BRIEV (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Feb 2013 03:04:21 -0500
Date: Mon, 18 Feb 2013 09:02:54 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] configure: missing Android config options
Message-ID: <20130218080254.GA6003@kernel.dk>
References: <5121AB54.5090507@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5121AB54.5090507@cse.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <aaronc@cse.unsw.edu.au>
Cc: fio@vger.kernel.org

On Mon, Feb 18 2013, Aaron Carroll wrote:
> We need this for the run-time endianness check to pass.  Add supported
> clock monotonic while we're at it.

Thanks Aaron, applied.

-- 
Jens Axboe

