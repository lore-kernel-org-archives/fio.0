Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH] zbd: Improve read randomness
References: <20180828053428.10143-1-damien.lemoal@wdc.com>
 <20180828053428.10143-2-damien.lemoal@wdc.com>
 <03ebc07e-092e-00ee-1b87-a5a693e4de5b@acm.org>
 <d39cb5bb4395c0426c9d29cd1c4bd8105c2df396.camel@wdc.com>
 <d0e73f47-25ec-3743-0fe3-b59a7548d885@acm.org>
 <1fd2131f9a792c717434c23fa9a034e30f80dc3b.camel@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <6f7edddf-dca2-1ca2-a533-adc1dc6e4942@acm.org>
Date: Wed, 29 Aug 2018 08:42:41 -0700
MIME-Version: 1.0
In-Reply-To: <1fd2131f9a792c717434c23fa9a034e30f80dc3b.camel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 08/28/18 20:56, Damien Le Moal wrote:
> On Tue, 2018-08-28 at 20:23 -0700, Bart Van Assche wrote:
>> On 08/28/18 17:57, Damien Le Moal wrote:

>>> If yes, then range < 0 is not possible, but range == 0 is definitely still
>>> possible and so the +1 is needed.
>>
>> Have you considered to leave out the "+ 1" and to handle range == 0
>> separately?
> 
> Sure I can do that. But again what about zbd_find_zone() ? Shouldn't it be
> changed to look for a zone with at least io_u->buflen bytes rather than only
> min_bs ? Otherwise, range can be negative and the test "if (io_u->offset +
> io_u->buflen > zb->wp)" at the end of the DDIR_READ case could terminate reads
> with eof prematuraly.

I think that it's better to shrink a read request than to modify
zbd_find_zone(). I think that making zbd_find_zone() look for a zone
that is large enough would confuse random reads if the random map is
enabled because the random generator would repeatedly propose to submit
I/O to the remainder of a zone if the random map is almost full.

>>> Looking at get_next_buflen(), io_u->buflen can be larger than min_bs. So
>>> either we need to modify zbd_find_zone() to return a zone with at least
>>> io_u->buflen bytes in it, or we need to handle the range < 0 case...
>>
>> The range < 0 case is already handled by the following code at the end
>> of the DDIR_WRITE case:
> 
> That is fine, but that is for the DDIR_WRITE case. There is no such code in
> the DDIR_READ case. Reads I/Os buflen are not modified based on the zone wp
> position... Do you think it is better to add a similar I/O size reduction code
> for reads or change zbd_find_zone() as suggested above ? I think the latter is
> better to ensure consistent sizes for reads.

Modifying the DDIR_READ case such that read requests for a zone with
less data than io_u->buflen are shrunk sounds fine to me.

Bart.

