Return-Path: <axboe@kernel.dk>
Subject: Re: Pending 3.20 release
References: <7da03194-c1b4-34cc-cf36-a7b53914d778@kernel.dk>
 <20200521172819.GA19385@avx2>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7593a791-1b5f-87a5-6d3d-a42a2770f59f@kernel.dk>
Date: Thu, 21 May 2020 11:43:41 -0600
MIME-Version: 1.0
In-Reply-To: <20200521172819.GA19385@avx2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>

On 5/21/20 11:28 AM, Alexey Dobriyan wrote:
> On Thu, May 21, 2020 at 08:40:09AM -0600, Jens Axboe wrote:
>> Hi,
>>
>> CC'ing a few folks here that have had (or have) pending patches
>> that aren't yet in the repo. I'm planning on releasing 3.20 in
>> the not-so-distant future, but I wanted to check in and see if
>> everybody is happy with where we are at for their favorite features
>> or bug fixes.
>>
>> Let me know if you have pending items that should go into 3.20,
>> or if you're happy with the current state.
> 
> I'll rebase and resend everything except ZBD verification.
> 
> bugfix			fio: parse "io_size=1%"
> 			zbd: consolidate zone mutex initialisation
> 			zbd: make zbd_info->mutex non-recursive
> quite important feature	zbd: introduce per job maximum open zones limit
> more assert()		zbd: don't lock zones outside working area
> 			zbd: bump ZBD_MAX_OPEN_ZONES
> 			verify: decouple seed generation from buffer fill

Great thanks, your series is the only one I'm aware of that is pending,
so was hoping you'd pipe up.

-- 
Jens Axboe


