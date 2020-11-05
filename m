Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20201103024741.1958-1-rebecca@bsdio.com> <09fc6846-16dc-a240-0c79-9bb10aa39aa1@kernel.dk>
In-Reply-To: <09fc6846-16dc-a240-0c79-9bb10aa39aa1@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 5 Nov 2020 05:51:05 +0000
Message-ID: <CALjAwxj3vvUq9K_GWS1Ky1j9HO6tZtt=sFwnBusYNiqfoDe9Og@mail.gmail.com>
Subject: Re: [PATCH] Windows: update dobuild.cmd to run the configure/make
Content-Type: text/plain; charset="UTF-8"
To: Rebecca Cran <rebecca@bsdio.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Wed, 4 Nov 2020 at 23:47, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/2/20 7:47 PM, Rebecca Cran wrote:
> > Add a new shell script, _domake.sh which runs under Cygwin. This
> > is invoked via dobuild.cmd to run the configure and make steps of
> > the build. In this way, a single command, run from a Developer Command
> > Prompt, can be used to go from a clean workspace to a final installer
> > binary.
>
> Applied, thanks.

Has this one broken CI -
https://ci.appveyor.com/project/axboe/fio/builds/36143673/job/4omj3bylpdxyhga5
?

-- 
Sitsofe | http://sucs.org/~sits/

