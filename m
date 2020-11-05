Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20201103024741.1958-1-rebecca@bsdio.com> <09fc6846-16dc-a240-0c79-9bb10aa39aa1@kernel.dk>
 <CALjAwxj3vvUq9K_GWS1Ky1j9HO6tZtt=sFwnBusYNiqfoDe9Og@mail.gmail.com> <753057c7-5694-358b-499d-9dc9dac8e0fe@bsdio.com>
In-Reply-To: <753057c7-5694-358b-499d-9dc9dac8e0fe@bsdio.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 5 Nov 2020 22:29:27 +0000
Message-ID: <CALjAwxiGAxjSr8_j8Wo0Hy_LQOwbp7sanx4r-jCnSC06_Fp5SA@mail.gmail.com>
Subject: Re: [PATCH] Windows: update dobuild.cmd to run the configure/make
Content-Type: text/plain; charset="UTF-8"
To: Rebecca Cran <rebecca@bsdio.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Thu, 5 Nov 2020 at 17:59, Rebecca Cran <rebecca@bsdio.com> wrote:
>
> On 11/4/20 10:51 PM, Sitsofe Wheeler wrote:
>
> > Has this one broken CI -
> > https://ci.appveyor.com/project/axboe/fio/builds/36143673/job/4omj3bylpdxyhga5
> > ?
>
> It does seem like it. I'll look into it.

I think the main issue is that the CI was using dobuild.cmd to just do
the packaging bits. Now it does (as its name originally suggested) and
it actually does a build AND does packaging. CI really needs packaging
to be seperate because it wants to control what's passed to configure.
I wonder if this change could be reverted and:

The original script be renamed to dopkg.cmd while updating the CI
scripts to call that and fixing up the documentation.
A new script called dobuildandpkg.cmd (or similar) be introduced that
does the lot. Perhaps there should be some documentation updates for
it too.

Thoughts?


--
Sitsofe | http://sucs.org/~sits/

