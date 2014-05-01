Return-Path: <axboe@kernel.dk>
Message-ID: <536282D2.5030508@kernel.dk>
Date: Thu, 01 May 2014 11:22:26 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] Replace CONFIG_CPU_COUNT with plain CPU_COUNT
References: <1398946024-13566-1-git-send-email-daniel.gollub@gmail.com>
In-Reply-To: <1398946024-13566-1-git-send-email-daniel.gollub@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Daniel Gollub <daniel.gollub@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/01/2014 06:07 AM, Daniel Gollub wrote:
> Fixes double-declartion issue of CPU_COUNT when fio.h is included by
> third-party projects.
> 
> Checking for a define of CPU_COUNT seems to be a common approach
> to deal with different versions of sched.h]

Thanks Daniel, applied all 5 of your patches.

-- 
Jens Axboe


