Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <CAGSn662aMTA5RZAdnE7C0caFtGSMfDMHXD1qV8drPnyZryJ3gQ@mail.gmail.com>
 <CAGSn662K7z5QD44VSoxDiw2ow7mnga1+V5-A3P+u8BQzO=qtUg@mail.gmail.com> <c792a656-1930-4cad-a40d-8e58b8ee94bc@kernel.dk>
In-Reply-To: <c792a656-1930-4cad-a40d-8e58b8ee94bc@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 18 Sep 2019 12:28:25 +0100
Message-ID: <CALjAwxjLwiT0xS0EmtJGpr8yLRmd+rAp_=Ks6KPxcXAii6iR8g@mail.gmail.com>
Subject: Re: FIO generated workload file export
Content-Type: text/plain; charset="UTF-8"
To: Mohiuddin Qader <mabdu002@ucr.edu>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Wed, 18 Sep 2019 at 01:35, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/17/19 3:27 PM, Mohiuddin Qader wrote:
> > Hi folks,
> > I have a question on FIO tool. I wanted to use the generated workload from FIO in some other programs. Is there any way to export the generated workload to file in some format (preferably in: fd, offset, value).
>
> See write_iolog=

Yup. There's a whole part of the documentation that describes an easy
to create trace file format -
https://fio.readthedocs.io/en/latest/fio_man.html#trace-file-format-v2
and you can also read the information in the I/O replay section
(https://fio.readthedocs.io/en/latest/fio_man.html#i-o-replay ) which
talks about log playback.

-- 
Sitsofe | http://sucs.org/~sits/

