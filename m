Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140128172609.GL20264@kernel.dk>
References: <CAOpYm_W685AkEuFnNZX-m0Jfq+B+crzQv5oEF_Hbvq3XbABhaQ@mail.gmail.com>
	<20140127192215.GF2782@kernel.dk>
	<CAOpYm_WNfhkyFRofHg6aUfm_nxL7oX8gCc++wNFMproqP1rVeA@mail.gmail.com>
	<20140127224603.GM2782@kernel.dk>
	<20140127230339.GN2782@kernel.dk>
	<CANEJEGspxdmAAhRCS7hiQeeFAOmSg9+ZwnZ_wcROji-9zE9tAg@mail.gmail.com>
	<20140127233116.GO2782@kernel.dk>
	<CANEJEGsfPUTzV4iwkYCDY1xwagW8uW+nimBzLOLDt2uzZHPGYg@mail.gmail.com>
	<20140128172609.GL20264@kernel.dk>
Date: Mon, 3 Feb 2014 14:05:23 -0800
Message-ID: <CANEJEGv19PwUxqZ4A8MbSkMT2-Hyy_SrMkumVAQkxmsfQs0Jpg@mail.gmail.com>
Subject: Re: A bug in combining fsrange and verify
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, Wallence Lu <wallencelu@gmail.com>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Jan 28, 2014 at 9:26 AM, Jens Axboe <axboe@kernel.dk> wrote:
...
> But another bug has been uncovered. If you run this:
>
> [global]
> filename=fio.ver
> loops=10
> verify=crc32
>
> [random-rw]
> size=31457280
> rw=randrw
>
> fio will complain about unmatched seeds in later iterations...

Puthikorn just posted a patch that fixes 4 issues that he's found so
far which can cause this symptom.  Let's continue the conversation on
that thread.

cheers,
grant

ps. I've already teased him about the C++ style comment in his patch. :)

