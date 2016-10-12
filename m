Return-Path: <axboe@kernel.dk>
Subject: Re: "disable_bw" option in HOWTO should be "disable_bw_measurement"
References: <3dcd7620-5355-680d-ae2e-c20f7a50045e@cran.org.uk>
 <03444854-ebc8-3aaa-0956-1212fcb9812f@kernel.dk>
 <d0d2fb07-e16a-5599-f69a-32df45e39248@cran.org.uk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b13495f7-d30b-0443-4bef-909517f87352@kernel.dk>
Date: Wed, 12 Oct 2016 10:03:56 -0600
MIME-Version: 1.0
In-Reply-To: <d0d2fb07-e16a-5599-f69a-32df45e39248@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/12/2016 10:00 AM, Bruce Cran wrote:
> On 10/12/16 9:00 AM, Jens Axboe wrote:
>
>> I added that as an alias, to keep it inline with the slat/clat
>> equivalents.
>
> It doesn't seem to be working - when I added "disable_bw=1" fio told me
> it was an unknown option.

Are you on the right build?

axboe@x1:/home/axboe/git/fio $ ./fio --name=null --ioengine=null --bs=4k 
--rw=read --size=1g --disable_bw
./fio: option '--disable_bw' requires an argument
./fio: unrecognized option '--disable_bw'
Did you mean disable_bw?

axboe@x1:/home/axboe/git/fio $ ./fio --name=null --ioengine=null --bs=4k 
--rw=read --size=1g --disable_bw=1
null: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=null, iodepth=1
fio-2.14-27-gafd2c
Starting 1 process
[...]

Works for me...

-- 
Jens Axboe


