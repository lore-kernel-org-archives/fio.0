Return-Path: <axboe@kernel.dk>
Message-ID: <54492656.5050805@kernel.dk>
Date: Thu, 23 Oct 2014 10:01:26 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio hangs with --status-interval
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com> <53BE5286.2060203@kernel.dk> <CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com> <53BEF29E.3040500@kernel.dk> <CAE56cDv7UmeGN=1rwyhbv7v5LfUkv+ueOoi+6KhnaXZYNx_7Fg@mail.gmail.com> <53BFCF22.8020407@kernel.dk> <CAE56cDtO9v3h2TkiyXQQ8dakmPiE+e-+wSazAc=XESOWA954Tg@mail.gmail.com> <53C0F4EC.9010107@kernel.dk> <CAFTzLMPFs0E4XphF5o155GiFaae0gGqJySswXpKUPPokPWoebw@mail.gmail.com> <53CCCA96.7010703@kernel.dk> <CAFTzLMP5GRx6R2HCykKN4pjkPLwHGafMc2HNh4gUONRRjBgYFg@mail.gmail.com> <53D20AA8.6020700@kernel.dk> <53D20DB8.10100@kernel.dk> <CAFTzLMPE+h_v8ydUP+iuCwJErQLuU=ZNcuKKcuxuZztandp+mQ@mail.gmail.com> <53D61053.9030902@kernel.dk> <CAFTzLMMP1tWNQ0tHj62enk-emhtX9sHv5wq+UCJpXO71RhB_NQ@mail.gmail.com> <53D6A95B.8020307@kernel.dk> <CAE56cDvVtc3kqw-BiEBwM2a34WB-csYMfR6TKjCtS9D=AUnJcw@mail.gmail.com>
In-Reply-To: <CAE56cDvVtc3kqw-BiEBwM2a34WB-csYMfR6TKjCtS9D=AUnJcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Michael Mattsson <michael.mattsson@gmail.com>
Cc: Vasily Tarasov <tarasov@vasily.name>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/23/2014 09:57 AM, Michael Mattsson wrote:
> Hey,
> Have there been any work on this? This is still an issue for me on fio
> 2.1.13. It happens less frequently but I've had two hangs in a sample
> of ~40 runs.

Try current -git and see if it works better. If not, lets get some new
traces and we'll get this fixed up.

-- 
Jens Axboe


