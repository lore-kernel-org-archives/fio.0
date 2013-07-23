Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58671 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3GWC4t (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Jul 2013 22:56:49 -0400
Date: Mon, 22 Jul 2013 20:56:47 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [Pull Request] Various fixes reported by Clang
Message-ID: <20130723025647.GA29296@kernel.dk>
References: <51EDAAA7.4070103@enovance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EDAAA7.4070103@enovance.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: fio@vger.kernel.org

On Mon, Jul 22 2013, Erwan Velu wrote:
> Hey,
> 
> I had the curiosity to check how fio was considered by clang.
> The "--analyze" option of clang is something levering interesting bugs.
> 
> In fact, there is many false positive but some were real.
> I've been pushing a branch featuring the associated fixes. That's almost
> nothing but I cannot close my eyes on it ;o)

Thanks, all three look good. Thanks for wading through the false
positives to find the gold :-)

-- 
Jens Axboe

