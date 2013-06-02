Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42955 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab3FBMUu (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 2 Jun 2013 08:20:50 -0400
Date: Sun, 2 Jun 2013 14:20:07 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Question on --buffer_compress_percentage
Message-ID: <20130602122007.GQ26106@kernel.dk>
References: <CAF+0mvnU7GMsKrbArcECaD5Z0YtLxA6GtghQjOJtOxZHb=cxjQ@mail.gmail.com>
 <20130527082147.GC29680@kernel.dk>
 <CAF+0mv=Lw7GF6PyYBw9LGAf5LGmM85WZVrWv3Ba=6O2bQ6zU3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+0mv=Lw7GF6PyYBw9LGAf5LGmM85WZVrWv3Ba=6O2bQ6zU3Q@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org

On Sat, Jun 01 2013, Matthew Eaton wrote:
> Hi Jens,
> 
> Thank you for your explanation.  I have another question in regards to
> buffer_compress_percentage if you don't mind.
> 
> If I were to call fio with "--refill_buffers
> --buffer_compress_percentage=0", would this be the same as setting
> only "--refill_buffers"?

Yes, those would be equivalant as the default is to use fully randomized
data contents.

> Also, if I were to call fio with "--refill_buffers
> --buffer_compress_percentage=100", would this be the same as setting
> "--zero_buffers"?

Yes.

-- 
Jens Axboe

