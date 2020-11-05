Return-Path: <rebecca@bsdio.com>
References: <20201103024741.1958-1-rebecca@bsdio.com>
 <09fc6846-16dc-a240-0c79-9bb10aa39aa1@kernel.dk>
 <CALjAwxj3vvUq9K_GWS1Ky1j9HO6tZtt=sFwnBusYNiqfoDe9Og@mail.gmail.com>
 <753057c7-5694-358b-499d-9dc9dac8e0fe@bsdio.com>
 <CALjAwxiGAxjSr8_j8Wo0Hy_LQOwbp7sanx4r-jCnSC06_Fp5SA@mail.gmail.com>
From: Rebecca Cran <rebecca@bsdio.com>
Message-ID: <3b0fa669-0aa3-d6c2-2e37-d19b9eabd8f8@bsdio.com>
Date: Thu, 5 Nov 2020 16:18:38 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxiGAxjSr8_j8Wo0Hy_LQOwbp7sanx4r-jCnSC06_Fp5SA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [PATCH] Windows: update dobuild.cmd to run the configure/make
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 11/5/20 3:29 PM, Sitsofe Wheeler wrote:

> The original script be renamed to dopkg.cmd while updating the CI
> scripts to call that and fixing up the documentation.
> A new script called dobuildandpkg.cmd (or similar) be introduced that
> does the lot. Perhaps there should be some documentation updates for
> it too.
>
> Thoughts?

That makes a lot of sense. dobuild.cmd was really only written for my 
use in building the installers, and as a result was poorly thought out.

I'll submit a patch to rename it and make improvements.


-- 
Rebecca Cran




