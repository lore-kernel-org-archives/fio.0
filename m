Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37085 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaA1VaP (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Jan 2014 16:30:15 -0500
Date: Tue, 28 Jan 2014 14:30:14 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fio: consolidate rand_seed to uint64_t
Message-ID: <20140128213014.GC31710@kernel.dk>
References: <1390942940-6886-1-git-send-email-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390942940-6886-1-git-send-email-grundler@chromium.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@chromium.org>
Cc: FIO List <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>, Gwendal Grignou <gwendal@chromium.org>

On Tue, Jan 28 2014, Grant Grundler wrote:
> csscope showed rand_seed was defined 4 times - each a different type.
> While they are used differently, the places where they overlap
> should reference the same type. This patch makes three of them the same
> as suggested by Jens Axboe.

Time for public shaming, as you did not even compile this patch! I'll
let you figure out the issue :-)

-- 
Jens Axboe

