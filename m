Return-Path: <dave@twin.jikos.cz>
Date: Mon, 9 Sep 2013 15:06:30 +0200
From: David Sterba <dave@jikos.cz>
Subject: Re: fio --showcmd fails if directory= does not exist
Message-ID: <20130909130630.GD9122@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20130906123812.GB9122@twin.jikos.cz>
 <5229FC39.50905@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5229FC39.50905@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: dave@jikos.cz, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Fri, Sep 06, 2013 at 10:00:57AM -0600, Jens Axboe wrote:
> That's definitely a bug, the callbacks should not verify anything if we
> are only in dump or parse only mode. I've committed a fix.

Thanks, I've verified that all my .fio scripts are converted fine.

david

