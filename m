Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH] zbd: Improve read randomness
References: <20180828053428.10143-1-damien.lemoal@wdc.com>
 <20180828053428.10143-2-damien.lemoal@wdc.com>
 <03ebc07e-092e-00ee-1b87-a5a693e4de5b@acm.org>
 <d39cb5bb4395c0426c9d29cd1c4bd8105c2df396.camel@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <d0e73f47-25ec-3743-0fe3-b59a7548d885@acm.org>
Date: Tue, 28 Aug 2018 20:23:12 -0700
MIME-Version: 1.0
In-Reply-To: <d39cb5bb4395c0426c9d29cd1c4bd8105c2df396.camel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 08/28/18 17:57, Damien Le Moal wrote:
> Thinking more about this, since zbd_find_zone() only guarantees that the zone
> returned has min_bs data in it, range can in fact still be <= 0 if
> io_u->buflen is larger than min_bs. Is it assumed here that min_bs and
> io_u->buflen are always equal ?

There is no such assumption. io_u->buflen can be larger than min_bs.
E.g. test11 in test-zbd-support triggers that case because it uses the
bsrange option.

> If yes, then range < 0 is not possible, but range == 0 is definitely still
> possible and so the +1 is needed.

Have you considered to leave out the "+ 1" and to handle range == 0
separately?

> Looking at get_next_buflen(), io_u->buflen can be larger than min_bs. So
> either we need to modify zbd_find_zone() to return a zone with at least
> io_u->buflen bytes in it, or we need to handle the range < 0 case...

The range < 0 case is already handled by the following code at the end
of the DDIR_WRITE case:

	/*
	 * Make sure that the buflen is a multiple of the minimal
	 * block size. Give up if shrinking would make the request too
	 * small.
	 */
	new_len = min((unsigned long long)io_u->buflen,
		      ((zb + 1)->start << 9) - io_u->offset);
	new_len = new_len / min_bs * min_bs;
	if (new_len == io_u->buflen)
		goto accept;
	if (new_len >= min_bs) {
		io_u->buflen = new_len;
		dprint(FD_IO, "Changed length from %u into %llu\n",
		       orig_len, io_u->buflen);
		goto accept;
	}
	log_err("Zone remainder %lld smaller than minimum block size %d\n",
		(((zb + 1)->start << 9) - io_u->offset),
		min_bs);
	goto eof;

Bart.

