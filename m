Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Allow sequential read to start anywhere in a zone (option
 offset), and have a span smaller than a zone (option size).
References: <20200515162213.1035-1-plabat@micron.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <587d8563-a96e-12a9-42af-27fe0d452cb1@kernel.dk>
Date: Mon, 18 May 2020 16:56:57 -0600
MIME-Version: 1.0
In-Reply-To: <20200515162213.1035-1-plabat@micron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: plabat@micron.com, damien.lemoal@wdc.com
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/15/20 10:22 AM, plabat@micron.com wrote:
> From: Pierre Labat <plabat@micron.com>
> 
> Allow sequential read to start anywhere in a zone (option
> offset), and have a span smaller than a zone (option size).
> 
> A use case is a Key Value Store reading a set of keys or values
> starting somewhere in a zone.

Applied, but I modified your commit message a bit. Don't make the title
that long, and especially don't duplicate the title again just below it.
The first paragraph and your title are identical.

-- 
Jens Axboe


