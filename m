Return-Path: <axboe@kernel.dk>
Subject: Re: io_uring engine -- sqthread_poll option can't work as implemented
References: <x49r254apvv.fsf@segfault.boston.devel.redhat.com>
 <6adaa1ad-93b6-48b1-6fe0-7a0cceab9eda@kernel.dk>
 <x498sr5txag.fsf@segfault.boston.devel.redhat.com>
 <0f8ba952-418c-d63d-6b3e-021cae4cfecc@kernel.dk>
 <0edfb602-184c-f33b-485e-221be543b069@kernel.dk>
 <7a3c83bd-4bbe-72ca-b690-5b247e8b9fd0@kernel.dk>
 <x49h85qu6av.fsf@segfault.boston.devel.redhat.com>
 <75a6f63a-2515-32e1-07b8-5c84eed0c662@kernel.dk>
 <x49d0geu3jk.fsf@segfault.boston.devel.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b2225e27-ef5d-3bdf-0147-ddaf8e6a1221@kernel.dk>
Date: Thu, 5 Sep 2019 10:11:39 -0600
MIME-Version: 1.0
In-Reply-To: <x49d0geu3jk.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 9/5/19 10:10 AM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> I did make make sqthread_poll == true set registerfiles as well, and added
>> the man page bits for the option. If you have further updates, please do
>> send them. Also interested in how the testing went ;-)
> 
> OK, I had a look and the patch looks good to me.  It tested out fine as
> well with the attached jobfile, run against both a block device and file
> system.

My lucky punch of the day. Thanks for testing, Jeff!

-- 
Jens Axboe


