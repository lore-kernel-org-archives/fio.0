Return-Path: <bruce@cran.org.uk>
Subject: Re: "disable_bw" option in HOWTO should be "disable_bw_measurement"
References: <3dcd7620-5355-680d-ae2e-c20f7a50045e@cran.org.uk>
 <03444854-ebc8-3aaa-0956-1212fcb9812f@kernel.dk>
 <d0d2fb07-e16a-5599-f69a-32df45e39248@cran.org.uk>
 <b13495f7-d30b-0443-4bef-909517f87352@kernel.dk>
From: Bruce Cran <bruce@cran.org.uk>
Message-ID: <992b9380-91a6-d88e-6fda-53f93427c7f2@cran.org.uk>
Date: Wed, 12 Oct 2016 10:23:59 -0600
MIME-Version: 1.0
In-Reply-To: <b13495f7-d30b-0443-4bef-909517f87352@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/12/16 10:03 AM, Jens Axboe wrote:

> axboe@x1:/home/axboe/git/fio $ ./fio --name=null --ioengine=null --bs=4k
> --rw=read --size=1g --disable_bw=1
> null: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=null, iodepth=1
> fio-2.14-27-gafd2c
> Starting 1 process
> [...]
>
> Works for me...

Hmm, sorry - adding "disable_bw=1" in a job file also works for me now.

-- 
Bruce

