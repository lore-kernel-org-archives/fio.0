Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:59626
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab1JEIvD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Oct 2011 04:51:03 -0400
Message-ID: <4E8C1A77.6080606@kernel.dk>
Date: Wed, 05 Oct 2011 10:51:03 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio version to package?
References: <201110051049.42373.ms@teamix.de>
In-Reply-To: <201110051049.42373.ms@teamix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org

On 2011-10-05 10:49, Martin Steigerwald wrote:
> Hi Jens!
> 
> I looked upgrading my fio debian package from 1.57 to a newer version.
> 
> Whats the right version to use?
> 
> I see 1.59 and 1.99 both dated 5 Oct 2011. Which one is the latest stable 
> version?

1.59 is the latest stable version. 1.99 is a tagged snapshot of the
client-server branch, which has the network functionality. It'll be 2.0
eventually.

So for now go with 1.59.

-- 
Jens Axboe

