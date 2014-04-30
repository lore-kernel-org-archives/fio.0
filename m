Return-Path: <axboe@kernel.dk>
Message-ID: <53610813.4060601@kernel.dk>
Date: Wed, 30 Apr 2014 08:26:27 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix gfio build due to disk_stat struct seperation
References: <1398839273-21596-1-git-send-email-d.gollub@telekom.de>
In-Reply-To: <1398839273-21596-1-git-send-email-d.gollub@telekom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Daniel Gollub <d.gollub@telekom.de>, fio@vger.kernel.org
Cc: Daniel Gollub <daniel.gollub@t-online.de>
List-ID: <fio@vger.kernel.org>

On 04/30/2014 12:27 AM, Daniel Gollub wrote:
> Signed-off-by: Daniel Gollub <d.gollub@telekom.de>
> Cc: Daniel Gollub <daniel.gollub@t-online.de>

Thanks, looks like I neglected to test gfio after making that change.
Applied.

-- 
Jens Axboe


