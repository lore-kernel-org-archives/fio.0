Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Windows: update dobuild.cmd to run the configure/make
References: <20201103024741.1958-1-rebecca@bsdio.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <09fc6846-16dc-a240-0c79-9bb10aa39aa1@kernel.dk>
Date: Wed, 4 Nov 2020 16:43:24 -0700
MIME-Version: 1.0
In-Reply-To: <20201103024741.1958-1-rebecca@bsdio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bsdio.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/2/20 7:47 PM, Rebecca Cran wrote:
> Add a new shell script, _domake.sh which runs under Cygwin. This
> is invoked via dobuild.cmd to run the configure and make steps of
> the build. In this way, a single command, run from a Developer Command
> Prompt, can be used to go from a clean workspace to a final installer
> binary.

Applied, thanks.

-- 
Jens Axboe


