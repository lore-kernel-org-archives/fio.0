Return-Path: <axboe@kernel.dk>
Message-ID: <544A7557.4090502@kernel.dk>
Date: Fri, 24 Oct 2014 09:50:47 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio hangs with --status-interval
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com> <53BEF29E.3040500@kernel.dk> <CAE56cDv7UmeGN=1rwyhbv7v5LfUkv+ueOoi+6KhnaXZYNx_7Fg@mail.gmail.com> <53BFCF22.8020407@kernel.dk> <CAE56cDtO9v3h2TkiyXQQ8dakmPiE+e-+wSazAc=XESOWA954Tg@mail.gmail.com> <53C0F4EC.9010107@kernel.dk> <CAFTzLMPFs0E4XphF5o155GiFaae0gGqJySswXpKUPPokPWoebw@mail.gmail.com> <53CCCA96.7010703@kernel.dk> <CAFTzLMP5GRx6R2HCykKN4pjkPLwHGafMc2HNh4gUONRRjBgYFg@mail.gmail.com> <53D20AA8.6020700@kernel.dk> <53D20DB8.10100@kernel.dk> <CAFTzLMPE+h_v8ydUP+iuCwJErQLuU=ZNcuKKcuxuZztandp+mQ@mail.gmail.com> <53D61053.9030902@kernel.dk> <CAFTzLMMP1tWNQ0tHj62enk-emhtX9sHv5wq+UCJpXO71RhB_NQ@mail.gmail.com> <53D6A95B.8020307@kernel.dk> <CAE56cDvVtc3kqw-BiEBwM2a34WB-csYMfR6TKjCtS9D=AUnJcw@mail.gmail.com> <54492656.5050805@kernel.dk> <CAE56cDtNaV6OodpXHmSJsYYj0U7CaQdW+ZBxhv-XPiNAwbU+2A@mail.gmail.com> <5449E0EF.7040402@kernel.dk> <CAE56cDv+C8Bg4QZHg_88G-wzhFJkZk1AYG69f2Fjsvsf6MLDWA@mail.gmail.com>
In-Reply-To: <CAE56cDv+C8Bg4QZHg_88G-wzhFJkZk1AYG69f2Fjsvsf6MLDWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Michael Mattsson <michael.mattsson@gmail.com>
Cc: Vasily Tarasov <tarasov@vasily.name>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-10-24 09:33, Michael Mattsson wrote:
> Hey,
> This seems to be fixed now. I successfully finished 1500+ runs over
> night in my rig without issues (it would have a hanging fio thread
> about every other or second or so between eight clients).

Goodie, I thought that it might.

-- 
Jens Axboe


