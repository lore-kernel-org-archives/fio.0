Return-Path: <axboe@kernel.dk>
Message-ID: <531515D1.40904@kernel.dk>
Date: Mon, 03 Mar 2014 15:52:49 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix verify_only option not working properly
References: <1393889612-14391-1-git-send-email-puthik@chromium.org>
In-Reply-To: <1393889612-14391-1-git-send-email-puthik@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Puthikorn Voravootivat <puthik@chromium.org>
Cc: FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Grant Grundler <grundler@chromium.org>
List-ID: <fio@vger.kernel.org>

On 2014-03-03 15:33, Puthikorn Voravootivat wrote:
> In commit c4b6117, we changed the place to call log_io_piece but
> the new place won't be reached when using verify_only option so
> that when we run with the verify_only option, fio won't verify
> anything at all.
>
> This patch fix that by also call the log_io_piece in the do_dry_run
> function for the verify_only code path.

Thanks applied, and with that patch, I've tagged 2.1.6 just now.

-- 
Jens Axboe


