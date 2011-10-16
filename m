Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:49647
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab1JPQbA (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 16 Oct 2011 12:31:00 -0400
Message-ID: <4E9B06C2.7050005@kernel.dk>
Date: Sun, 16 Oct 2011 18:30:58 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: engines like rdma engine that require additional dependencies
References: <201110151144.06000.Martin@lichtvoll.de>
In-Reply-To: <201110151144.06000.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org

On 2011-10-15 11:44, Martin Steigerwald wrote:
> Hi Jens!
> 
> I discussed with my package sponsor about whether to build rdma engine for 
> fio 1.59 debian package or not. We decided to do it and see how it builds 
> on all architectures.
> 
> But on installing fio now also two additional libs get installed and one of 
> them creates a user named "rdma".
> 
> I wonder whether it would be feasible or good to have engines that require 
> external dependencies as modules that could be packaged separately.
> 
> Might not matter much as long as its only the rdma engine tough.
> 
> What do you think?

It should be fairly easy to do that, fio already supports loading
external engines via dlopen(). So if engine/rdma.c is built as a
dynamically loadable object, then it could be packaged as
fio-engine-rdma or something like that.

-- 
Jens Axboe

