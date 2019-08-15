Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH fio] nbd: Update for libnbd 0.9.8.
References: <20190815153040.4511-1-rjones@redhat.com>
 <3df9429c-caf0-6913-5fdf-a5aae85b9765@kernel.dk>
 <20190815165735.GI3888@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2da31297-2a7e-7a5b-6267-b2a555c90597@kernel.dk>
Date: Thu, 15 Aug 2019 11:02:57 -0600
MIME-Version: 1.0
In-Reply-To: <20190815165735.GI3888@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: fio@vger.kernel.org, eblake@redhat.com
List-ID: <fio@vger.kernel.org>

On 8/15/19 10:57 AM, Richard W.M. Jones wrote:
> On Thu, Aug 15, 2019 at 10:42:17AM -0600, Jens Axboe wrote:
>> On 8/15/19 9:30 AM, Richard W.M. Jones wrote:
>>> As the libnbd API isn't permanently stable until we reach the 1.0
>>> release (expected soon), some code changes are needed to cope with API
>>> changes between 0.9.6 and 0.9.8.  In this case we made changes to
>>> completion handlers after feedback from reviewers.  This fix for fio
>>> incorporates all the changes needed and bumps the minimum version to
>>> libnbd >= 0.9.8.
>>
>> Applied, thanks.
> 
> Thanks - we're really hoping this will be the last time (forever)
> that the API changes.  Fingers crossed ...

If the versioning proximity to 1.0 is worth anything, hopefully it'll
be pretty close to (if not at) stability :-)

-- 
Jens Axboe


