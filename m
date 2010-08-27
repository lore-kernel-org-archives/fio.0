Return-Path: <ctuffli@gmail.com>
MIME-Version: 1.0
From: Chuck Tuffli <ctuffli@gmail.com>
Date: Fri, 27 Aug 2010 15:37:21 -0600
Subject: Re: using ioengine=sg
Message-ID: <AANLkTi=JxBLiV4L1B_RHW9yK1jna_JHu7iton+0h-P_d@mail.gmail.com>
References: <AANLkTimTvSmj-1L80KAyVf7uv9d+vDENsMj-_bFDqRBR@mail.gmail.com>
	<4C776359.70403@fusionio.com>
	<AANLkTikN0M5eVXOAi9APqeS2Q7tiuYPacMsWiO0FnAWC@mail.gmail.com>
	<4C77EE22.6020009@fusionio.com>
In-Reply-To: <4C77EE22.6020009@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Aug 27, 2010 at 9:56 AM, Jens Axboe <jaxboe@fusionio.com>
...
> Works for me, exact same job file. Can you do an sg_inq /dev/sg2?

Ugh, inquiries failed to that device but not others. Something went
wrong with the LLDD, but a reboot cleared everything up. BTW, the
patch really helped with the performance I'm seeing. Thanks again!

---chuck

