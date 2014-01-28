Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140128221748.GE25989@kernel.dk>
References: <1390942940-6886-1-git-send-email-grundler@chromium.org>
	<20140128213014.GC31710@kernel.dk>
	<CANEJEGvZ3xnkg+D8RwVcvHfTKtVCcm_YP_geskOZTC0UNBnGOA@mail.gmail.com>
	<20140128220349.GD25989@kernel.dk>
	<CANEJEGurTpsgV5gUv1758dvE7UtP2zqNP6aLe4S69Ezo4i5yVA@mail.gmail.com>
	<20140128221748.GE25989@kernel.dk>
Date: Tue, 28 Jan 2014 14:23:10 -0800
Message-ID: <CANEJEGsANrvTBF1pqEXQzoWj3HdqmdcygFG=Sh4H+ZUK0NsWmQ@mail.gmail.com>
Subject: Re: [PATCH] fio: consolidate rand_seed to uint64_t
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, FIO List <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

On Tue, Jan 28, 2014 at 2:17 PM, Jens Axboe <axboe@kernel.dk> wrote:
...
> It's because the parser is using non uintxx_t types, so you can't really
> please it here. There's __cpu_to_le64() to avoid this crap. But ideally,
> the parser just needs changing so that anything that is now unsigned int
> is uint32_t and unsigned long long needs to be uint64_t.

Got it.

> If you look at your committed patch, I made those changes for you.

Thanks! LGTM.

cheers
grant

