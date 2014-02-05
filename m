Return-Path: <axboe@kernel.dk>
Date: Wed, 5 Feb 2014 12:35:51 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix verify_backlog start verification before finish
 writing
Message-ID: <20140205193551.GJ27534@kernel.dk>
References: <1391624895-9543-1-git-send-email-puthik@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391624895-9543-1-git-send-email-puthik@chromium.org>
To: Puthikorn Voravootivat <puthik@chromium.org>
Cc: FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Grant Grundler <grundler@chromium.org>
List-ID: <fio@vger.kernel.org>

On Wed, Feb 05 2014, Puthikorn Voravootivat wrote:
> Due to recent fix for checking rand_seed in verify phase. In write phase,
> the IO transaction will be logged before completing the actual data write.
> If verify_backlog is enabled, verification may start before all data has
> been written. This patch disable that fix if the verify_backlog is enabled.

Thanks, this looks good!

-- 
Jens Axboe


