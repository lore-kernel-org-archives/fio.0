Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50101 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab3GVS3R (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Jul 2013 14:29:17 -0400
Date: Mon, 22 Jul 2013 12:29:15 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [Pull Request] Fixing coherency in fio2gnuplot
Message-ID: <20130722182915.GA32755@kernel.dk>
References: <51ED6FFC.2070309@enovance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ED6FFC.2070309@enovance.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: fio@vger.kernel.org

On Mon, Jul 22 2013, Erwan Velu wrote:
> Hello,
> Sorry to make many pull request in a row but I just discover a serious
> problem when plotting multiple traces at the same time. It was in fact
> shortening the plots & rendering to the smallest trace file.
> 
> This bug is pretty boring and this patch series does fix it.
> The branch is on top the current master, shall be easy to merge ;o)

No worries, pulled both of them. Thanks!

-- 
Jens Axboe

