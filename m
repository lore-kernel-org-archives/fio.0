Return-Path: <aschade@google.com>
MIME-Version: 1.0
In-Reply-To: <56464ACC.9030605@kernel.dk>
References: <CADp+U7ibiKciX8_cpzGzob4oL-UF-H+W7kYuiujovD0ba=hM6A@mail.gmail.com>
	<56464ACC.9030605@kernel.dk>
Date: Fri, 13 Nov 2015 14:04:28 -0800
Message-ID: <CADp+U7gHq5VJgRFzGXvHTKN8Tyz9NDUZGePDWQ548ciyJmGr7A@mail.gmail.com>
Subject: Re: Running a separate fio process for each disk?
From: Allen Schade <aschade@google.com>
Content-Type: multipart/alternative; boundary=001a1142e2384db7dd0524733edd
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--001a1142e2384db7dd0524733edd
Content-Type: text/plain; charset=UTF-8

I'm actually launching a completely separate instance of fio for each disk.
I want to say its because when I ran them under the same fio process I had
issues with the json files merging the data in an unexpected way.

Version is 2.2.6

--001a1142e2384db7dd0524733edd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I&#39;m actually launching a completely separate instance =
of fio for each disk. I want to say its because when I ran them under the s=
ame fio process I had issues with the json files merging the data in an une=
xpected way.<div><br></div><div>Version is 2.2.6</div></div>

--001a1142e2384db7dd0524733edd--

