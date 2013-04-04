Return-Path: <msmucr@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130404184104.GE9683@kernel.dk>
References: <515DAA33.4000009@warnerbros.com>
	<20130404181946.GD9683@kernel.dk>
	<20130404184104.GE9683@kernel.dk>
Date: Fri, 5 Apr 2013 01:59:38 +0200
Message-ID: <CAHBo9gmJHgZAjQ=rjeNpzrV7boLS6+2VcxtZRnkad7y_hwp=Dw@mail.gmail.com>
Subject: Re: How to re-use default sequential filenames?
From: =?UTF-8?Q?Michal_=C5=A0mucr?= <msmucr@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Alan Hagge <Alan.Hagge@warnerbros.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hello to all,
this is actually great thread. I discovered wonderful fio before two
days during seeking for tool, which allows me to simulate typical
workload with DPX files playback and recording (one file per frame).
I'm playing with it today and slowly getting into options. By
coincidence, i subscribed to this list to ask almost same question as
Alan and found this first thread.. :-)
Reusing of generated frames (file sequences) between write and read
jobs is also important for me and is exactly thing, what i thought
about. I will try to test patch by Jens.

One small thing, sorry for slight derail of thread topic, which come
to my mind was option for kind of automatic set of blocksize during
read to match length of each pre-generated file within sequence, which
fio got from directory using opendir directive. Idea behind this come
from common behaviour of VFX applications, which issue read io for
whole frame size. So application use stat() output to get actual file
size before reading of each frame. If I have same filesize per frame
it is easy to adjust blocksize before benchmark, but if i want to test
read performance of sequence with compressed frames or simulate
mixture of different resolutions, this will be handy.

Thank you and especially Jens for creation of fio (first day with it
is mindblowing :)

Michal Smucr

