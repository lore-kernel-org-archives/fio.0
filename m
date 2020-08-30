Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Update os/windows/dobuild.cmd to support signing
 binaries/installer
References: <20200829232550.108-1-rebecca@bsdio.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6669d450-2259-f936-842c-33ed7faf1ed6@kernel.dk>
Date: Sat, 29 Aug 2020 18:54:28 -0600
MIME-Version: 1.0
In-Reply-To: <20200829232550.108-1-rebecca@bsdio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bsdio.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/29/20 5:25 PM, Rebecca Cran wrote:
> Since organizations are increasingly requiring software to be digitally
> signed, or have heuristics that penalize unsigned software, add support
> to do build.cmd to sign both the .exe binaries and the .msi installer.

Applied, thanks.

-- 
Jens Axboe


